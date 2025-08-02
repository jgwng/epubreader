import 'package:epubreader/enum/enums.dart';
import 'package:epubreader/util/common_util.dart';
import 'package:flutter/animation.dart';

class NovelViewerOption {
  int? id;
  int? fontSize;
  int? lineHeight;
  int? horizontalPadding;
  int? verticalPadding;
  FontFamily? fontFamily;
  Navigation? pageNavigation;
  CurlAnimation? curlAnimation;
  Color? backgroundColor;
  Color? fontColor;

  NovelViewerOption({
    this.id,
    this.fontSize = 0,
    this.lineHeight = 0,
    this.horizontalPadding = 0,
    this.verticalPadding = 0,
    this.pageNavigation = Navigation.scroll,
    this.fontFamily = FontFamily.batang,
    this.curlAnimation = CurlAnimation.none,
    this.backgroundColor,
    this.fontColor,
  });

  Map<String, dynamic> toMap() {
    return {
      'fontSize': fontSize,
      'lineHeight': lineHeight,
      'horizontalPadding': horizontalPadding,
      'verticalPadding': verticalPadding,
      'pageNavigation': (pageNavigation?.value ?? '').toString(),
      'fontFamily': (fontFamily?.value ?? '').toString(),
      'curlAnimation': (curlAnimation?.value ?? '').toString(),
      'backgroundColor': (backgroundColor?.colorToHex ?? '').toString(),
      'fontColor': (fontColor?.colorToHex ?? '').toString(),
    };
  }

  factory NovelViewerOption.fromMap(Map<String, dynamic> map) {
    return NovelViewerOption(
      id: map['id'],
      fontSize: map['fontSize'],
      lineHeight: map['lineHeight'],
      horizontalPadding: map['horizontalPadding'],
      verticalPadding: map['verticalPadding'],
      backgroundColor: hexToColor(map['backgroundColor'] ?? ''),
      fontColor: hexToColor(map['fontColor'] ?? ''),
      pageNavigation: decodeNavigation(map['pageNavigation'] ?? ''),
      fontFamily: decodeFontFamily(map['fontFamily'] ?? ''),
      curlAnimation: decodeCurlAnimation(map['curlAnimation'] ?? ''),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is NovelViewerOption) {
      return fontSize == other.fontSize &&
          lineHeight == other.lineHeight &&
          horizontalPadding == other.horizontalPadding &&
          verticalPadding == other.verticalPadding;
    }
    return false;
  }
}