import 'package:flutter/material.dart';

import 'package:flutter_app/basic/app_theme.dart';
import 'package:flutter_app/basic/macro.dart';
import 'package:flutter_app/fitness_app/home_drawer.dart';

import 'package:flutter_app/ui_app/uiView/custom_tool/layoutBuilderRoute.dart';

import 'package:flutter_app/ui_app/uiView/listView/list_view_main.dart';
import 'package:flutter_app/ui_app/tabPage/first_page.dart';
import 'package:flutter_app/ui_app/tabPage/second_page.dart';


import 'package:flutter_app/ui_app/uiView/custom_ui/colorShowPage.dart';
import 'package:flutter_app/ui_app/uiView/custom_ui/RS_customScrollView.dart';
import 'package:flutter_app/ui_app/uiView/custom_ui/customSliver.dart';
import 'package:flutter_app/ui_app/uiView/custom_ui/nested_scrollView.dart';

//主页
class UIAPPHomePage extends StatefulWidget {
  UIAPPHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _UIAPPHomePageState createState() => _UIAPPHomePageState();
}

//主页的状态
class _UIAPPHomePageState extends State<UIAPPHomePage>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  Widget tabBody = Container(
    color: AppTheme.nearlyWhite,
  );

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    tabBody = FirstPage();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), //这里的widget代表状态所属的类
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: pushToAPage),
          popMenu(),
        ],
      ),

      //左侧抽屉页
      drawer: Drawer(
        // backgroundColor: AppTheme.creamGreen2,
        child: MediaQuery.removePadding(
          context: context,
          // removeTop: true,
          child: drawerView(),
        ),
      ),

      body: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("Loading Data"),
            );
          } else if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return tabBody;
          }
        },
      ),

      //右侧抽屉页
      endDrawer: Drawer(
        child: HomeDrawer(
          screenIndex: DrawerIndex.HOME,
          iconAnimationController: AnimationController(
              vsync: this, duration: const Duration(milliseconds: 1000)),
        ),
      ),

      //悬浮按钮
      floatingActionButton: FloatingActionButton(
        foregroundColor: AppTheme.glacier[400],
        backgroundColor: AppTheme.deepPlumPink,
        onPressed: () {},
        child: Icon(Icons.add),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        color: AppTheme.glacier,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  tabBody = FirstPage();
                });
              },
              icon: Icon(Icons.home_outlined),
              color: AppTheme.glacier[400],
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  // tabBody = SizedBox(child: Expanded(flex: 1,child: Container(color: AppTheme.deepPlumPink,),),);
                  tabBody = SecondPage();
                });
              },
              icon: Icon(Icons.message_outlined),
              color: AppTheme.glacier[400],
            ),
            SizedBox(),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.business_outlined),
              color: AppTheme.glacier[400],
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.people_outline_outlined),
              color: AppTheme.glacier[400],
            ),
          ],
        ),
      ),
    );
  }

  ///-------------------------------- Widget -----------------------------
  ///自定义抽屉
  Widget drawerView() {
    return ListView(
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
                  CircleAvatar(
                    radius: 35.0,
                    backgroundColor: AppTheme.glacier[500],
                    child: const Text(
                      'RS',
                      textScaleFactor: 2,
                    ),
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
    );
  }

  ///右上角弹出菜单
  Widget popMenu() {
    return PopupMenuButton<popMenuItem>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          width: 2,
          color: Colors.white,
          style: BorderStyle.none,
        ),
      ),
      offset: Offset(0.0, 5.0),
      color: Colors.white,
      onSelected: (popMenuItem result) {
        setState(() {
          if (result == popMenuItem.item1) {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (context) {
                  return LayoutBuilderRoute();
                },
                // fullscreenDialog: true,
              ),
            );
          } else if (result == popMenuItem.item2) {
            Navigator.of(context).push(
              new MaterialPageRoute(builder: (context) {
                return InfiniteListView();
              }),
            );
          } else {}
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<popMenuItem>>[
        const PopupMenuItem<popMenuItem>(
          value: popMenuItem.item1,
          child: Text('Layout Page'),
          // onTap: () => print("item上的点击事件");,  //const修饰时，不能写onTap，onTap内无法完成跳转
        ),
        const PopupMenuItem<popMenuItem>(
          value: popMenuItem.item2,
          child: Text('ListView Page'),
        ),
        const PopupMenuItem<popMenuItem>(
          value: popMenuItem.item3,
          child: Text('TODO'),
        ),
      ],
    );
  }

  ///-------------------------------- 方法 -----------------------------
  ///
  ///   /// 获取数据
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 500));
    return true;
  }

  ///跳转到一个页
  void pushToAPage() async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ColorShowPage(rsColor: RSColor.creamYellow);
          // return RSCustomScrollView();
          // return NestedScrollViewPage();
        },

      ),
    );
    print("路由返回值：$result");
  }
}
