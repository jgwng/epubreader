import 'package:epubreader/helper/app_theme_helper.dart';
import 'package:epubreader/resources/routes.dart';
import 'package:epubreader/resources/size.dart';
import 'package:epubreader/viewModel/home_page_controller.dart';
import 'package:epubreader/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomePageController controller;

  @override
  void initState(){
    super.initState();
    controller = Get.put<HomePageController>(HomePageController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody()
    );
  }


  Widget buildBody(){
    return Obx((){
      if(controller.isLoading.value == true){
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Center(
            child: CircularProgressIndicator(
              color: AppThemeHelper.pointColor,
            ),
          ),
        );
      }

      double percentage = controller.novelRead.value.percentage ?? 0;
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            coverImage(),
            SizedBox(
              height: 8.s,
            ),
            Text(
                controller.novelRead.value.bookTitle ?? '',
              style: TextStyle(
                fontSize: 20.fs,
                color: Theme.of(context).colorScheme.surfaceDim
              ),
            ),
            SizedBox(
              height: 8.s,
            ),
            Text(
              controller.novelRead.value.bookAuthor ?? '',
              style: TextStyle(
                  fontSize: 20.fs,
                  color: Theme.of(context).colorScheme.surfaceDim
              ),
            ),
            SizedBox(
              height: 8.s,
            ),
            Text(
              '현재 읽음 정도 : ${(percentage * 100).toStringAsFixed(2)}%',
              style: TextStyle(
                  fontSize: 20.fs,
                  color: Theme.of(context).colorScheme.surfaceDim
              ),
            ),
            SizedBox(
              height: 20.s,
            ),
            CustomButton(
              onPressed: controller.onTapViewerPage,
              buttonText: '${percentage > 0 ? '이어' : '새로' } 읽기',
            )
          ],
        ),
      );
    });
  }

  Widget coverImage(){
    if(controller.epubBook.CoverImage == null){
      return SizedBox(
        width: 200.s,
        height: 200.s,
        child: Placeholder(),
      );
    }
    return SizedBox(
      width: 200.s,
      height: 200.s,
      child: Image.memory(controller.epubBook.CoverImage!.getBytes()),
    );
  }
}
