import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_app/basic/app_theme.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/select_app.dart';

import 'package:flutter_app/ui_app/uiApp_home.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    //处理错误上报
    // reportError(details);
  };
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) {
    runZoned(() {
      //init third party sdk

      //run app
      runApp(MyApp());
    });

  });
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
      restorationScopeId: 'Colorfool',
      debugShowCheckedModeBanner: false,
      // title: S.of(context).Flutter_Demo, //会报错
      onGenerateTitle: (context){
        return S.of(context).Flutter_Demo;
      },
      theme: ThemeData(
        primarySwatch: AppTheme.glacier,
        textTheme: AppTheme.textTheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      // locale: const Locale('en', 'US'), //手动指定locale
      localeListResolutionCallback: (List<Locale>? locales, Iterable<Locale> supportedLocales){
        //可以判断当前q
        locales?.forEach((element) => print('$element'));
        print('supportedLocales List as Follow \r');
        supportedLocales.forEach((element) => print('$element'));
      },

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
      // home: SelectAppPage(),
      home: UIAPPHomePage(),
    );

  }
}




