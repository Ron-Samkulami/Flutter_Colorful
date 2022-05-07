import 'package:flutter_app/fitness_app/models/tabIcon_data.dart';
import 'package:flutter_app/fitness_app/training/training_screen.dart';
import 'package:flutter/material.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'fitness_app_theme.dart';
import 'my_diary/my_diary_screen.dart';
import 'package:flutter_app/fitness_app/my_profile/my_profile.dart';

class FitnessAppHomeScreen extends StatefulWidget {
  @override
  _FitnessAppHomeScreenState createState() => _FitnessAppHomeScreenState();
}

class _FitnessAppHomeScreenState extends State<FitnessAppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  //tab数据
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  //页面内容
  Widget tabBody = Container(
    color: FitnessAppTheme.background,
  );

  @override
  void initState() {
    //默认选中第一个tab
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    /// vsync 需要传入一个TickerProvider, 一般在state中混入TickerProviderStateMixin
    animationController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    //默认显示的第一个页面
    tabBody = MyDiaryScreen(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            //snapshot是FutureBuilder提供的异步操作数据快照，可根据快照状态分情况显示
            // if(snapshot.connectionState == ConnectionState.waiting) {
            //   return Container(color: Colors.cyan,);
            // } else
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            //点击中间tab回调
          },
          changeIndex: (int index) {
            switch (index) {
              case (0):
                animationController?.reverse().then<dynamic>((data) {
                  if (!mounted) {//判断当前State是否被加载到树上，已经被dispose的Sate无法进行渲染
                    return;
                  }
                  setState(() {
                    tabBody = MyDiaryScreen(animationController: animationController);
                  });
                });
                break;
              case(1):
              case(2):
                animationController?.reverse().then<dynamic>((data) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    tabBody =
                        TrainingScreen(animationController: animationController);
                  });
                });
                break;
              case(3):
                animationController?.reverse().then<dynamic>((data) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    tabBody =
                        MyProfile(animationController: animationController);
                  });
                });
                break;
              default:

            }
            // if (index == 0 || index == 2) {
            //
            // } else if (index == 1 || index == 3) {
            //   animationController?.reverse().then<dynamic>((data) {
            //     if (!mounted) {
            //       return;
            //     }
            //     setState(() {
            //       tabBody =
            //           TrainingScreen(animationController: animationController);
            //     });
            //   });
            // }
          },
        ),
      ],
    );
  }
}
