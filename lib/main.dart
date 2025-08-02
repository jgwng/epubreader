import 'package:epubreader/helper/app_theme_helper.dart';
import 'package:epubreader/resources/routes.dart';
import 'package:epubreader/view/home_page.dart';
import 'package:epubreader/view/novel_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_epub_viewer/flutter_epub_viewer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'resources/pages.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context){
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (_, child) {
        return ValueListenableBuilder(
            valueListenable: AppThemeHelper.themeMode,
            builder: (_,value,__){
              return GetMaterialApp(
                navigatorKey: navigatorKey,
                theme: AppThemeHelper.light,
                darkTheme: AppThemeHelper.dark,
                themeMode: AppThemeHelper.currentMode,
                debugShowCheckedModeBanner: false,
                getPages: AppPages.pages,
                initialRoute: Routes.home,
                home: HomePage(),
              );
            });
      },
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final epubController = EpubController();

  var textSelectionCfi = '';

  bool isLoading = true;

  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.transparent,
              ),
              Expanded(
                child: Stack(
                  children: [
                    EpubViewer(
                      epubSource: EpubSource.fromAsset(
                          'assets/mockepub.epub'),
                      epubController: epubController,
                      displaySettings: EpubDisplaySettings(
                          flow: EpubFlow.scrolled,
                          useSnapAnimationAndroid: false,
                          snap: true,
                          theme: EpubTheme.light(),
                          allowScriptedContent: true),
                      selectionContextMenu: ContextMenu(
                        menuItems: [
                          ContextMenuItem(
                            title: "Highlight",
                            id: 1,
                            action: () async {
                              epubController.addHighlight(cfi: textSelectionCfi);
                            },
                          ),
                        ],
                        settings: ContextMenuSettings(
                            hideDefaultSystemContextMenuItems: true),
                      ),
                      onChaptersLoaded: (chapters) {
                        setState(() {
                          isLoading = false;
                        });
                      },
                      onEpubLoaded: () async {
                        print('Epub loaded');
                      },
                      onRelocated: (value) {
                        print("Reloacted to $value");
                        setState(() {
                          progress = value.progress;
                        });
                      },
                      onAnnotationClicked: (cfi) {
                        print("Annotation clicked $cfi");
                      },
                      onTextSelected: (epubTextSelection) {
                        textSelectionCfi = epubTextSelection.selectionCfi;
                        print(textSelectionCfi);
                      },
                    ),

                  ],
                ),
              ),
            ],
          )),
    );
  }
}