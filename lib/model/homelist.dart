
import 'package:flutter/widgets.dart';
import 'package:flutter_app/ui_app/uiApp_home.dart';
import 'package:flutter_app/webSocket_app/login_view.dart';
import 'package:flutter_app/fitness_app/fitness_app_home_screen.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  Widget? navigateScreen;
  String imagePath;

  static List<HomeList> homeList = [

    HomeList(
      imagePath: 'assets/fitness_app/fitness_app.png',
      navigateScreen: FitnessAppHomeScreen(),
    ),
    HomeList(
      imagePath: 'assets/introduction_animation/introduction_animation.png',
      navigateScreen: UIAPPHomePage(title: 'UIAPP',),
    ),
    HomeList(
      imagePath: 'assets/hotel/hotel_booking.png',
      navigateScreen: LoginPage(),
    ),
    // HomeList(
    //   imagePath: 'assets/design_course/design_course.png',
    //   navigateScreen: DesignCourseHomeScreen(),
    // ),
  ];
}
