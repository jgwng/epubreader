import 'package:epubreader/helper/app_theme_helper.dart';
import 'package:epubreader/helper/novel_option_db_helper.dart';
import 'package:epubreader/helper/novel_read_book_db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

//앱 시작하기전 초기 세팅 해주는 함수
Future<void> initAppSetting() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    NovelOptionDBHelper().initDB(),
    NovelReadBookDbHelper().initDB(),
    GetStorage.init()
  ]);

  AppThemeHelper().init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
}
