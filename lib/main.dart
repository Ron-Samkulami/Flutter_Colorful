import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_app/basic/app_theme.dart';
import 'package:flutter_app/select_app.dart';

import'package:flutter/rendering.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //可视化调试
    // debugPaintSizeEnabled = true;//显示边框
    // debugPaintBaselinesEnabled = true;//显示基线
    // debugPaintPointersEnabled = true;//显示触摸点
    // debugRepaintRainbowEnabled = true;//发生重绘时显示彩虹边框
    // debugPaintLayerBordersEnabled = true;//显示图层边界

    //性能调试
    //显示布局和重绘堆栈
    // debugPrintMarkNeedsLayoutStacks = true;
    // debugPrintMarkNeedsPaintStacks = true;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
      !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: AppTheme.glacier,
        textTheme: AppTheme.textTheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      //路由管理
      //方式1
      routes: {
        "new_page":(context) => SelectAppPage(),
      },
      //方式2
      // onGenerateRoute: (RouteSettings settings) {
      //   return MaterialPageRoute(builder: (context){
      //     String? routeName = settings.name;
      //     print("$routeName");
      //     //判断名称，按需路由，也可以在之前加权限判断
      //     return SizedBox();
      //   });
      // },
      //
      home: SelectAppPage(),
    );
  }
}




