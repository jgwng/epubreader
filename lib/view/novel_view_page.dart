
import 'package:epubreader/enum/enums.dart';
import 'package:epubreader/helper/app_theme_helper.dart';
import 'package:epubreader/resources/size.dart';
import 'package:epubreader/viewModel/novel_view_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class NovelViewPage extends StatefulWidget {
  const NovelViewPage({super.key});

  @override
  State<NovelViewPage> createState() => _NovelViewPageState();
}

class _NovelViewPageState extends State<NovelViewPage> {
  late NovelViewerController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put<NovelViewerController>(NovelViewerController());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result){
          if(didPop){
            return;
          }
        },
        child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              novelViewArea(),
              novelViewerMenu(),
              novelViewerLoading()
            ],
          ),
        ),
    ));
  }

  Widget novelViewerLoading(){
    return Obx((){
      if(controller.isLoading.value){
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Center(
            child: CircularProgressIndicator(
              color: AppThemeHelper.pointColor,
            ),
          ),
        );
      }
      return const SizedBox();
    });
  }

  Widget novelViewArea(){
    return InAppWebView(
      initialFile: "assets/index.html",
      onWebViewCreated: controller.onWebViewCreated,
      onLoadStop: controller.onWebViewLoadStop,
      initialSettings: InAppWebViewSettings(
          isInspectable: kDebugMode,
          javaScriptEnabled: true,
          mediaPlaybackRequiresUserGesture: false,
          transparentBackground: true,
          supportZoom: false,
          allowsInlineMediaPlayback: true,
          disableLongPressContextMenuOnLinks: false,
          iframeAllowFullscreen: true,
          allowsLinkPreview: false,
          verticalScrollBarEnabled: false,
          // disableVerticalScroll: true,
          selectionGranularity: SelectionGranularity.CHARACTER),
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}.toSet(),
    );
  }

  Widget novelViewerNavigateTouchArea(){
    return Obx((){
      if(controller.viewerOption.value.pageNavigation == Navigation.scroll){
        return  const SizedBox();
      }
      return Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: controller.onTapPrevPage,
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                ),
              ),
            ),
            Expanded(
              key: GlobalKey(),
              child: InkWell(
                onTap: controller.onTapShowSetting,
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: controller.onTapNextPage,
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
  Widget novelViewerMenu(){
    return Obx(() {
      if (controller.showBar.isTrue) {
        return PointerInterceptor(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                novelViewerMenuTopBar(),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      controller.showBar.value = false;
                    },
                    child:  Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                novelViewerMenuBottomBar(),
              ],
            ),
          ),
        );
      }
      return const SizedBox();
    });
  }

  Widget novelViewerMenuTopBar(){
    return  Container(
      height: 60.s,
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.only(left: 16.s,right: 20.s),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: controller.onExitPage,
            child: SizedBox(
              width: 40.s,
              height: 40.s,
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: 24.s,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: AppThemeHelper.toggleMode,
                child: ValueListenableBuilder(
                    valueListenable: AppThemeHelper.themeMode,
                    builder: (_,value,__){
                      return Icon(
                        AppThemeHelper.isDark ? Icons.dark_mode : Icons.light_mode,
                        size: 24.s,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      );
                    }),
              ),
              SizedBox(width: 8.s,),
              InkWell(
                onTap: controller.onTapSettingBottomSheet,
                child: Icon(
                  Icons.settings_rounded,
                  size: 24.s,
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget novelViewerMenuBottomBar(){
    return Container(
      height: 60.s,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16.s),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Obx(() {
        return Row(
          children: [
            Expanded(
              child: Slider(
                activeColor: Theme.of(context).colorScheme.surfaceDim,
                inactiveColor: Theme.of(context).colorScheme.secondary,
                thumbColor: AppThemeHelper.pointColor,
                min: 0,
                max: controller.totalPage.value.toDouble(),
                value: controller.currentPage.value.toDouble(),
                divisions: (controller.totalPage.value - 1) <= 0
                    ? 1
                    : (controller.totalPage.value - 1),
                // 페이지 수만큼 분할
                label: '${controller.currentPage.value}',
                onChanged: controller.onTapScrollPage,
              ),
            ),
            SizedBox(
              width: 80.s,
              child: Text(
                '${controller.currentPage.value}/${controller.totalPage.value}',
                style: TextStyle(
                    fontSize: 16.fs,
                    color: Theme.of(context).colorScheme.surfaceDim),
              ),
            )
          ],
        );
      }),
    );
  }
}



