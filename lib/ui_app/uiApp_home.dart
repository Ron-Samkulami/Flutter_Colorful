import 'package:flutter/material.dart';
import 'package:flutter_app/basic/app_theme.dart';
import 'package:flutter_app/ui_app/tabPage/mine_page.dart';
import 'package:flutter_app/ui_app/tabPage/first_page.dart';
import 'package:flutter_app/ui_app/tabPage/second_page.dart';
import 'package:flutter_app/ui_app/tabPage/third_page.dart';

import 'package:flutter_app/ui_app/uiView/animation/mySlideTransition.dart';

import '../select_app.dart';

//主页
class UIAPPHomePage extends StatefulWidget {
  UIAPPHomePage({Key? key}) : super(key: key);

  @override
  _UIAPPHomePageState createState() => _UIAPPHomePageState();
}

//主页的状态
class _UIAPPHomePageState extends State<UIAPPHomePage>
    with TickerProviderStateMixin {
  late PageController _pageController;

  int _tabIndex = 0;
  List _tabBody = [
    FirstPage(),
    SecondPage(),
    null,
    ThirdPage(),
    MinePage(),
  ];

  int selectedIndex = 0;
  bool ltr = true;

  @override
  void initState() {
    _pageController = new PageController(initialPage: _tabIndex);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawerView(),

      /// FutureBuilder + 自定义页面切换动画
      // body: FutureBuilder<bool>(
      //   future: getData(),
      //   builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(
      //         child: Text("Loading Data"),
      //       );
      //     } else if (!snapshot.hasData) {
      //       return const SizedBox();
      //     } else {
      //       return AnimatedSwitcher(///使用切换动画
      //         duration: const Duration(milliseconds: 600),
      //         ///默认为渐隐渐显动画，可以指定为其他动画
      //         transitionBuilder: (Widget child, Animation<double> animation) {
      //           //自定义平移效果
      //           return SlideTransitionX(
      //             child: child,
      //             direction: ltr ? AxisDirection.left : AxisDirection.right,
      //             position: animation,
      //           );
      //         },
      //         child: tabBody,
      //       );
      //     }
      //   },
      // ),

      body: PageView.builder(
        onPageChanged: onPageChange,
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return _tabBody[index];
        },
        itemCount: _tabBody.length,
      ),

      //悬浮按钮
      floatingActionButton: FloatingActionButton(
        foregroundColor: AppTheme.glacier[500],
        backgroundColor: AppTheme.creamYellow,
        elevation: 5,
        heroTag: 'add',
        onPressed: showAddPage,
        child: Icon(Icons.add),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppTheme.nearlyWhite,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined), label: 'message'),
          BottomNavigationBarItem(
              icon: SizedBox(
                height: 30,
              ),
              label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.games_outlined),
            label: 'game',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_outline_outlined), label: 'mine')
        ],
        // selectedLabelStyle: TextStyle(
        //     color: AppTheme.nearlyWhite, fontSize: AppTheme.title.fontSize),
        // unselectedLabelStyle: TextStyle(
        //     color: AppTheme.glacier[400], fontSize: AppTheme.title.fontSize),
        // showSelectedLabels: true,
        // showUnselectedLabels: false,
        selectedIconTheme: IconThemeData(color: AppTheme.glacier),
        unselectedIconTheme: IconThemeData(color: AppTheme.glacier[700]),
        // selectedItemColor: AppTheme.glacier,
        unselectedItemColor: AppTheme.glacier[700],
        currentIndex: _tabIndex,
        fixedColor: AppTheme.glacier,
        iconSize: 26.0,
        onTap: onItemTapped,
      ),
    );
  }

  ///-------------------------------- 方法 -----------------------------
  ///
  /// 获取数据
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 100));
    return true;
  }

  onPageChange(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  onItemTapped(int index) {
    if (index == 2) {
      showAddPage();
    } else {
      _pageController.jumpToPage(index);
      onPageChange(index);
    }
  }

  showAddPage() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return Hero(
            tag: 'add',
            child: SelectAppPage(),
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  Widget buildDrawerView() {
    return Container(
      width: 300,
      child: ColoredBox(
        color: AppTheme.nearlyWhite,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  //背景径向渐变
                  colors: [AppTheme.glacier1, AppTheme.glacier[800]!],
                  center: Alignment.bottomRight,
                  radius: 2,
                ),
                // color: AppTheme.glacierGrayBlue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Drawer Header',
                    style: TextStyle(
                      color: AppTheme.deepPlumPink,
                      fontSize: 24,
                      shadows: [
                        Shadow(
                            color: AppTheme.darkBlueGreen,
                            blurRadius: 1,
                            offset: Offset(1.5, 1.5))
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        child: Hero(
                          /// Hero 路由切换动画，需要tag 作为标识才能生效
                          tag: "avatar",
                          child: CircleAvatar(
                            radius: 35.0,
                            backgroundColor: AppTheme.glacier[500],
                            child: const Text(
                              'RS',
                              textScaleFactor: 2,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, PageRouteBuilder(pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return FadeTransition(
                              opacity: animation,
                              child: Scaffold(
                                body: Center(
                                  child: Hero(
                                    tag: "avatar",
                                    child: Container(
                                      // color: Colors.red,
                                      width: 300,
                                      height: 500,
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,

                                        ///fitBox用于约束子类的
                                        child: GestureDetector(
                                          child: CircleAvatar(
                                            radius: 200.0,
                                            backgroundColor:
                                            AppTheme.glacier[500],
                                            child: Text(
                                              'RS',
                                              textScaleFactor: 3,
                                            ),
                                          ),
                                          onTap: () =>
                                              Navigator.of(context).pop(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }));
                        },
                      ),
                      Spacer(),
                      SizedBox(
                        width: 100,
                        height: 30,
                        child: OutlinedButton.icon(
                            style: ButtonStyle(
                                alignment: Alignment.centerLeft,
                                backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.focused) &&
                                      !states.contains(MaterialState.pressed)) {
                                    return AppTheme.glacierGrayBlue;
                                  } else if (states
                                      .contains(MaterialState.pressed)) {
                                    return AppTheme.pinkWhite;
                                  }
                                  return AppTheme.pinkWhite;
                                }),
                                overlayColor:
                                MaterialStateProperty.resolveWith((states) {
                                  return AppTheme.glacier[400];
                                })),
                            onPressed: () {},
                            icon: Icon(Icons.edit),
                            label: Text("Edit")),
                      )
                    ],
                  )
                ]
                    .map((e) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: e,
                ))
                    .toList(),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
            ListTile(
              leading: Icon(Icons.more),
              title: Text('More App'),
              onTap: () => Navigator.pushNamed(context, "new_page"),
            ),
            Chip(
              avatar: CircleAvatar(
                backgroundColor: AppTheme.glacier[300],
                child: const Text('RS'),
              ),
              label: const Text('Ron Samkulami'),
            ),
          ],
        ),
      ),
    );
  }
}
