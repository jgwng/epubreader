import 'package:epubreader/resources/keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AppThemeHelper {
  static final AppThemeHelper instance = AppThemeHelper._internal();
  static ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);
  static bool get isDark => themeMode.value == ThemeMode.dark;
  static ThemeMode get currentMode =>  (isDark) ? ThemeMode.dark : ThemeMode.light;

  factory AppThemeHelper() => instance;
  AppThemeHelper._internal();

  static void toggleMode() async{
    switch (themeMode.value) {
      case ThemeMode.light:
        themeMode.value = ThemeMode.dark;
        await GetStorage().write(Keys.IS_DARK_MODE,true);
        break;
      case ThemeMode.dark:
        themeMode.value = ThemeMode.light;
        await GetStorage().write(Keys.IS_DARK_MODE,false);
        break;
      default:
    }
  }

  void init() {
    bool isDarkMode = GetStorage().read(Keys.IS_DARK_MODE) ?? false;
    if(isDarkMode == true){
      themeMode.value = ThemeMode.dark;
    }else{
      themeMode.value = ThemeMode.light;
    }
  }

  static const Color pointColor = Color(0xFF453798);

  static final ThemeData light = ThemeData(
    primaryColorLight: Colors.white,
    primaryColorDark: const Color(0xFF1C1C20),
    secondaryHeaderColor: const Color(0xFFEAEBED),
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent,
    focusColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }
    ),
    appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFF8F8FF)
    ),
    primarySwatch: createMaterialColor(Color(0xFF644FD4)),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.light(
        surface: Colors.white,
        secondary: Color(0xFF9FA4AA),
        onSurface: Color(0xFF131214),
        surfaceDim: Color(0xFF131214),
        surfaceBright :Color(0xFFA0A0A0),
        outline: Color.fromRGBO(0,0,0,0.15),
        tertiary: Color(0x993C3C43),
        inverseSurface:  Color(0xFF0A0A0A),
        outlineVariant: Color.fromRGBO(153, 153, 153, 1.0),
        scrim: Color(0xFF424242),
        surfaceContainer: Color(0xFF787880),
        error: Color(0xFFFF383C)
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.black),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontSize: 12, // Set your desired font size
              fontWeight: FontWeight.bold, // Set your desired font weight
              color: Colors.white, // Set your desired text color
            ),
          ),
        )),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.black,
      textTheme: ButtonTextTheme.normal,
    ),
    cupertinoOverrideTheme: CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black
    ),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: Color.fromRGBO(163, 208, 249, 1.0),
    ),
  );

  static final ThemeData dark = ThemeData(
      scaffoldBackgroundColor:  Color(0xFF0A0A0A),
      primaryColorLight: const Color(0xFF1C1C20),
      primaryColorDark: Colors.white,
      primarySwatch: createMaterialColor(Color(0xFF1C1C20)),
      pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          }
      ),
      secondaryHeaderColor: const Color.fromRGBO(40, 40, 40, 1.0),
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.white,
        textTheme: ButtonTextTheme.normal,
      ),
      appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1C1C20)
      ),
      colorScheme: ColorScheme.dark(
          surface: Color.fromRGBO(24, 24, 24,1.0),
          secondary: Color.fromRGBO(77, 77, 77, 1.0),
          onSurface: Color.fromRGBO(77, 77, 77, 1.0),
          surfaceDim: Color(0xFFF8F9FE),
          surfaceBright: Color(0xFFCCCCCC),
          outline: Color.fromRGBO(243, 245, 247, 0.3),
          tertiary: Color(0x99EBEBF5),
          surfaceContainer: Color(0xFF767680).withAlpha(88),
          outlineVariant: Color.fromRGBO(204, 204, 204, 1.0),
          scrim: Color(0xFFCCCCCC),
          inverseSurface: Color(0xFFFAFAFA),
          error: Color(0xFFFF4245)
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.white
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: Color.fromRGBO(73, 117, 159, 1.0),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.white),
            foregroundColor: WidgetStateProperty.all(Colors.black),
            textStyle: WidgetStateProperty.all(
              const TextStyle(
                fontSize: 12, // Set your desired font size
                fontWeight: FontWeight.bold, // Set your desired font weight
                color: Colors.black, // Set your desired text color
              ),
            ),
          )),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color.fromRGBO(22, 22, 22, 1.0),
        selectedItemColor: Color.fromRGBO(237, 237, 237, 1.0),
        unselectedItemColor: Color.fromRGBO(111, 111, 111, 1.0),
      ));

  static MaterialColor createMaterialColor(Color color) {
    List<double> strengths = <double>[.05];
    final Map<int, Color> swatch = {};
    final int r = color.r.toInt(), g = color.g.toInt(), b = color.b.toInt();

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.toInt32, swatch);
  }
}
extension ColorEx on Color {
  static int floatToInt8(double x) {
    return (x * 255.0).round() & 0xff;
  }
  int get toInt32 {
    return floatToInt8(a) << 24 | floatToInt8(r) << 16 | floatToInt8(g) << 8 | floatToInt8(b) << 0;
  }
}