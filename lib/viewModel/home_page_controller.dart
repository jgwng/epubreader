import 'package:epubreader/helper/novel_read_book_db_helper.dart';
import 'package:epubreader/model/novel_read.dart';
import 'package:epubreader/resources/routes.dart';
import 'package:epubx/epubx.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController{
  RxBool isLoading = true.obs;
  EpubBook  epubBook = EpubBook();
  NovelReadBookDbHelper helper = NovelReadBookDbHelper();
  Rx<NovelRead> novelRead = NovelRead().obs;
  @override
  void onReady() async{
    super.onReady();
    await fetchData();
    await fetchReadPercentage();
  }
  Future<void> fetchData() async{
    final bytes = await rootBundle.load('assets/mockepub.epub');
    final base64Str = bytes.buffer.asUint8List();
    epubBook = await EpubReader.readBook(base64Str);
    isLoading.value = false;
  }

  Future<void> fetchReadPercentage() async{
    if(epubBook.Title?.isEmpty ?? true) return;
    String title = epubBook.Title!;
    var result = await helper.fetchRead(title);
    if(result.isNotEmpty){
      novelRead.value = NovelRead.fromMap(result.first);
    }else{
      novelRead.value = NovelRead(
        bookAuthor: epubBook.Author ?? '',
        bookTitle: epubBook.Title ?? '',
        percentage: 0.0,
        cfi: ''
      );
      var id = await helper.saveNovelRead(novelRead.value);
      if(id != 0){
        novelRead.value.id = id;
      }
    }
    isLoading.value = false;
  }

  void onTapViewerPage() async{
    var result =await Get.toNamed(Routes.viewer,arguments: {
      'novelRead' : novelRead.value
    });
    if(result != null){
      novelRead.value = result;
      novelRead.refresh();
      var updateResult = await helper.updateNovelRead(result);
      print(updateResult);
    }
  }





}