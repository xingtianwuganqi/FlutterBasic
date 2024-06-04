
import 'package:flutter/rendering.dart';

extension ColorExt on Color {
  /*
  hex 16进制颜色 返回 Color
  * */
  static Color colorHex(String hex) {
    if (hex.contains("#")) {
      hex = hex.replaceFirst("#", "");
    }
    var colorInt = int.parse(hex,radix: 16);
    return Color(colorInt | 0xFF000000);
  }
}

extension StringExt on String {
  Color get hexColor {
    var hexColorString = this;
    if (hexColorString.contains("#")) {
      hexColorString = hexColorString.replaceFirst("#", "");
    }
    return ColorExt.colorHex(hexColorString);
  }
}
