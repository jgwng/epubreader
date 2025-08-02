import 'dart:ui';

import 'package:flutter/material.dart';

Color hexToColor(String hexString) {
  if(hexString.isEmpty){
    return Colors.transparent;
  }
  final buffer = StringBuffer();
  if (hexString.length == 7) buffer.write('ff'); // alpha 없으면 기본 불투명
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

extension ColorUtils on Color{
  String get colorToHex {
    final redValue = (r * 255).toInt().toRadixString(16).padLeft(2, '0');
    final greenValue =(g * 255).toInt().toRadixString(16).padLeft(2, '0');
    final blueValue = (b * 255).toInt().toRadixString(16).padLeft(2, '0');
    return '#$redValue$greenValue$blueValue';
  }
}