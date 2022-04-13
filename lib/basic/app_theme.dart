import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);
  static const String fontName = 'WorkSans';

//自定义颜色样式
  static const MaterialColor glacier = MaterialColor(
    _glacierPrimaryValue,
    <int, Color>{
      50: Color(0xFFFFFDE7),
      100: Color(0xFFFFF9C4),
      200: Color(0xFFFFF59D),
      300: Color(0xFFFFF176),
      400: Color(0xFFE7EEEF),
      500: Color(_glacierPrimaryValue),
      600: Color(0xFFB8DADC),
      700: Color(0xFFB8DADC),
      800: Color(0xFFAEC9CB),
      900: Color(0xFFC7D9DD),
    },
  );
  static const int _glacierPrimaryValue = 0xFF5A736D;


  static const Color _glacier = Color(0xFFE3EAF0);
  static const Color coldGray = Color(0xFFC3D6DD);
  static const Color deepCreamGreen = Color(0xFF8EB69D);
  static const Color creamGreen = Color(0xFFA7C9AF);

  static const Color coldGray1 = Color(0xFFC7D9DD);
  static const Color plumPink = Color(0xFFEAB1A2);
  static const Color creamGreen1 = Color(0xFFC7E1D4);
  static const Color deepColdGray = Color(0xFF586A78);

  static const Color darkGreen = Color(0xFF385445);
  static const Color glacier1 = Color(0xFFE7EEEF);
  static const Color lightDarkGreen = Color(0xFF698F7D);
  static const Color lightPlumPink = Color(0xFFE9DCD3);

  static const Color lightBlueGreen = Color(0xFF6998A2);
  static const Color lightCreamYellow = Color(0xFFD8D4CA);
  static const Color blueGreen = Color(0xFF468283);//莫兰迪绿（柔和）
  static const Color darkBlueGreen = Color(0xFF4D7282);

  static const Color creamGreen2 = Color(0xFFAFD1C3);
  static const Color creamGray = Color(0xFFE5E6E1);
  static const Color blueGreen2 = Color(0xFF4F989D);//莫兰迪绿（浅）
  static const Color deepPlumPink = Color(0xFFEC7C68);

  static const Color glacierBlue = Color(0xFFB8DADC);
  static const Color pinkWhite = Color(0xFFFCFAFB);
  static const Color lightPink = Color(0xFFFEDEDD);
  static const Color tealLike = Color(0xFF148395);//莫兰迪绿（深）

  static const Color almostWhite = Color(0xFFFAFAFB);
  static const Color glacierGrayBlue = Color(0xFFAEC9CB);
  static const Color creamYellow = Color(0xFFFCEED6);
  static const Color grayGreen = Color(0xFF9ABDB1);

  static const Color greenWhite = Color(0xFFF4F9F4);
  static const Color deepGreenWhite = Color(0xFFA7D7C4);
  static const Color grassGreen = Color(0xFF74B49B);
  static const Color deepGrayGreen = Color(0xFF5C8D89);

  static const Color deepGrayGreen1 = Color(0xFF5A736D);
  static const Color grayGreen2 = Color(0xFF7EA497);
  static const Color almostWhite1 = Color(0xFFF0F0F3);
  static const Color grayGreen1 = Color(0xFF8FBDB3);

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle( // h4 -> display1
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle( // h5 -> headline
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle( // h6 -> title
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle( // subtitle2 -> subtitle
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle( // body1 -> body2
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle( // body2 -> body1
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle( // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );

}


//添加颜色描述信息
class RSColor {
  final String colorName;
  final Color color;
  const RSColor(this.colorName, this.color);

  static const RSColor glacier = RSColor("glacier", AppTheme.glacier);
}



//色值字符串转化为颜色
class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

}


//获取色值描述字符串
class ColorDescription {
  static String hexColorValue(Color color) => _getHexColorValue(color.value);
  static String hexColorRedValue(Color color) => _getHexColorValue(color.red);
  static String hexColorGreenValue(Color color) => _getHexColorValue(color.green);
  static String hexColorBlueValue(Color color) => _getHexColorValue(color.blue);

  static String _getHexColorValue(int value) {
    String stringValue = value.toRadixString(16).toUpperCase();
    if (stringValue.length == 8) {
      return stringValue.replaceFirst('FF', '#');
    }
    return stringValue;
  }


}