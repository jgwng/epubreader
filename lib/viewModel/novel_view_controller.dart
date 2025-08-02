import 'dart:convert';

import 'package:epubreader/enum/enums.dart';
import 'package:epubreader/helper/novel_option_db_helper.dart';
import 'package:epubreader/model/novel_option.dart';
import 'package:epubreader/model/novel_read.dart';
import 'package:epubreader/resources/keys.dart';
import 'package:epubreader/resources/size.dart';
import 'package:epubreader/util/common_util.dart';
import 'package:epubreader/widget/option_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NovelViewerController extends GetxController {
  late InAppWebViewController webViewController;
  RxBool isLoading = true.obs;
  RxBool showBar = false.obs;
  RxInt currentPage = 0.obs;
  RxInt totalPage = 1.obs;
  NovelOptionDBHelper helper = NovelOptionDBHelper();
  Rx<NovelViewerOption> viewerOption = NovelViewerOption().obs;
  double viewerHeight = 0;
  late NovelRead read;

  @override
  void onInit(){
    super.onInit();
    double height = Get.height;
    double top = Get.mediaQuery.viewPadding.top;
    double bottom = Get.mediaQuery.viewPadding.bottom;
    viewerHeight = height - top - bottom;
    if (Get.arguments != null) {
      read  = Get.arguments['novelRead'] ?? NovelRead();
    }
  }

  @override
  void onReady() async{
    super.onReady();
    List<Map<String, dynamic>> optionList = await helper.fetchOption();
    if(optionList.isEmpty){
      NovelViewerOption defaultOption = NovelViewerOption(
        horizontalPadding: 10.s.toInt(),
        verticalPadding: 10.s.toInt(),
        lineHeight: 1,
        fontSize: 16.s.toInt(),
        fontFamily: FontFamily.batang,
        fontColor: Colors.black,
        backgroundColor: Colors.white,
        pageNavigation: Navigation.page
      );
      viewerOption.value = defaultOption;
      var result = await helper.saveOption(defaultOption);
      viewerOption.value.id = result ?? 1;
    }else{
      NovelViewerOption option = NovelViewerOption.fromMap(optionList.first);
      viewerOption.value = option;
    }
  }

  void onExitPage() async{
    await helper.saveOption(viewerOption.value);
    Get.back(result: read);
  }

  void onWebViewCreated(InAppWebViewController controller) {
    webViewController = controller;
    webViewController.addJavaScriptHandler(
      handlerName: "onTotalPages",
      callback: (args) {
        isLoading.value = false;
        totalPage.value = args[0];
      },
    );

    webViewController.addJavaScriptHandler(
      handlerName: 'onTouchEnd',
      callback: (args) {
        final y = args[0]['screenY'] as int;
        final x = args[0]['screenX'] as int;
        bool touchMenuArea = y > 60.s && y >= Get.height - 60.s;
        if(viewerOption.value.pageNavigation == Navigation.scroll){
          showBar.toggle();
        }else{
          if(0 <= x && x < Get.width/3 ){
            showBar.value = false;
            onTapPrevPage();
          }else if(x > Get.width * (2/3) && x < Get.width ){
            showBar.value = false;
            onTapNextPage();
          }else{
            showBar.toggle();
          }
        }
      },
    );

    webViewController.addJavaScriptHandler(
      handlerName: 'onSwipe',
      callback: (args) {
        final y = args[0]['screenY'] as int;
        final x = args[0]['screenX'] as int;
        if(viewerOption.value.pageNavigation == Navigation.page){
          if(0 <= x && x < Get.width/3 ){
            showBar.value = false;
            onTapPrevPage();
          }else if(x < Get.width * (2/3) && x < Get.width ){
            showBar.toggle();
          }else{
            showBar.value = false;
            onTapNextPage();
          }
        }
      },
    );

    webViewController.addJavaScriptHandler(
      handlerName: "onPageChanged",
      callback: (args) {
        final current = args[0]['current'];
        final total = args[0]['total'];
        final cfi = args[0]['currentCfi'];
        final double percent = (args[0]['percent'] as num).toDouble();
        totalPage.value = total;
        currentPage.value = current;
        read.cfi = cfi;
        read.percentage = percent;
      },
    );
  }

  void onWebViewLoadStop(controller, url) async {
    final bytes = await rootBundle.load('assets/mockepub.epub');
    final base64Str = base64Encode(bytes.buffer.asUint8List());
    String manager = 'default';
    if(viewerOption.value.pageNavigation == Navigation.scroll){
      manager = 'continuous';
    }
    double width = Get.width;
    final js = '''
      loadBook({
          base64Str: atob("$base64Str"),
          manager: "$manager",
          cfi: "${read.cfi ?? ''}",
          width: "$width",
          height: "$viewerHeight",
          fontSize: "${viewerOption.value.fontSize}",
          fontFamily: "${viewerOption.value.fontFamily?.value ?? ''}",
          lineHeight: "${viewerOption.value.lineHeight}",
          padding: "${viewerOption.value.verticalPadding}px ${viewerOption.value.horizontalPadding}px",
          fontColor: "${(viewerOption.value.fontColor ?? Colors.black).colorToHex}",
          backgroundColor: "${(viewerOption.value.backgroundColor ?? Colors.white).colorToHex}",
          pageNavigation: "${viewerOption.value.pageNavigation?.value ?? ''}"
       });                 
    ''';
    await  webViewController.evaluateJavascript(source: js);
  }

  void onTapPrevPage() {
    if (currentPage.value > 0) {
      currentPage.value -= 1;
      webViewController.evaluateJavascript(source: 'prevPage()');
    }
  }

  void onTapShowSetting() {
    showBar.toggle();
  }

  void onTapNextPage() {
    if (currentPage.value < totalPage.value) {
      currentPage.value = currentPage.value + 1;
      webViewController.evaluateJavascript(source: 'nextPage()');
    }
  }

  void onTapSettingBottomSheet() async {
    showBar.value = true;
    var result = await showNovelOptionSettingBottomSheet(
      initOption: viewerOption.value
    );
    if (result != null) {
      viewerOption.value = result;
      helper.updateOption(viewerOption.value);
      Color fontColor = result.fontColor ?? Colors.black;
      Color bgColor = result.backgroundColor ?? Colors.white;
      final fnName = (result == viewerOption.value) ? 'updateFlow' : 'updateStyle';
      String manager = 'default';
      if(result.pageNavigation == Navigation.scroll){
        manager = 'continuous';
      }
      final js = '''
        $fnName({
          pageNavigation: "${result.pageNavigation?.value ?? 'paginated'}",
          manager: "$manager",
          width: "${Get.width}",
          height: "$viewerHeight",
          fontSize: "${result.fontSize}",
          fontFamily: "${result.fontFamily}",
          lineHeight: "${result.lineHeight}",
          padding: "${result.verticalPadding}px ${result.horizontalPadding}px",
          fontColor: "${(fontColor).colorToHex}",
          backgroundColor: "${(bgColor).colorToHex}"
        });
      ''';
      webViewController.evaluateJavascript(source: js);
    }
  }

  void onTapScrollPage(double value) {
    showBar.value = true;
    final targetPage = value.round();
    currentPage.value =targetPage;
    webViewController.evaluateJavascript(
      source: 'goToPage($targetPage);',
    );
  }

  void changeStyle() {
    final js = '''
        updateStyle({
          fontSize: "${viewerOption.value.fontSize}",
          fontFamily: "${viewerOption.value.fontFamily}",
          lineHeight: "${viewerOption.value.lineHeight}",
          padding: "${viewerOption.value.horizontalPadding}px ${viewerOption.value.verticalPadding}px",
          fontColor: "${(viewerOption.value.fontColor ?? Colors.black).colorToHex}",
          backgroundColor: "${(viewerOption.value.backgroundColor ?? Colors.white).colorToHex}",
          pageNavigation: "${viewerOption.value.pageNavigation}",
       });
    ''';
    webViewController.evaluateJavascript(source: js);
  }

  void changeFontBGColor(Color fontColor, Color backgroundColor){
    final js =
      '''
         changeFontBGColor({
           fontColor: "${fontColor.colorToHex}",
           backgroundColor: "${backgroundColor.colorToHex}",
         });                 
      ''';
    webViewController.evaluateJavascript(source: js);
  }
}
