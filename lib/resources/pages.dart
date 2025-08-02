import 'package:epubreader/resources/routes.dart';
import 'package:epubreader/view/home_page.dart';
import 'package:epubreader/view/novel_view_page.dart';
import 'package:get/get.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: Routes.home,
      page: ()=> HomePage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.viewer,
      page: ()=> NovelViewPage(),
      transition: Transition.cupertino,
    ),
  ];

}