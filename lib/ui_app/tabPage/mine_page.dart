import 'package:flutter/material.dart';
import 'package:flutter_app/basic/app_theme.dart';
import 'package:flutter_app/basic/macro.dart';

import 'package:flutter_app/fitness_app/home_drawer.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/ui_app/uiView/custom_tool/layoutBuilderRoute.dart';
import 'package:flutter_app/ui_app/uiView/listView/list_view_main.dart';

import 'package:flutter_app/ui_app/uiView/custom_ui/colorShowPage.dart';
import 'package:flutter_app/ui_app/uiView/custom_ui/RS_customScrollView.dart';
import 'package:flutter_app/ui_app/uiView/custom_ui/customSliver.dart';
import 'package:flutter_app/ui_app/uiView/custom_ui/nested_scrollView.dart';

import '../../basic/circular_color_picker.dart';
import '../../basic/rectangle_color_picker.dart';

class MinePage extends StatefulWidget {
  const MinePage({
    Key? key,
  }) : super(key: key);

  bool reloadData() {
    print('MinePage reloadData');
    return true;
  }

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.forward_outlined),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: Text(S.of(context).Flutter_Demo),
        actions: <Widget>[
          Hero(
              tag: "ColorShowPage",
              child: IconButton(
                  icon: Icon(Icons.color_lens),
                  onPressed: () {
                    Navigator.push(context, PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                      return FadeTransition(
                        opacity: animation,

                        ///Hero 不能作为另一个 Hero 的子组件，
                        ///如果RSCustomScrollView页面中有其它Hero动画组件，如floatingActionButton，会出问题
                        child: Hero(
                          tag: "ColorShowPage",
                          child: ColorShowPage(rsColor: RSColor.creamYellow),
                        ),
                      );
                    }));
                  })),
          popMenu(),
        ],
      ),

      //右侧抽屉页
      endDrawer: Drawer(
        child: HomeDrawer(
          screenIndex: DrawerIndex.HOME,
          iconAnimationController: AnimationController(
              vsync: this, duration: const Duration(milliseconds: 1000)),
        ),
      ),

      body: Column(
        children: [
          Center(
            child: Text(S.of(context).change_language),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    S.load(Locale.fromSubtags(languageCode: 'zh'));
                    setState(() {});
                  },
                  child: Text('切换到中文')),
              ElevatedButton(
                  onPressed: () {
                    S.load(Locale.fromSubtags(languageCode: 'en'));
                    setState(() {});
                  },
                  child: Text('Switch to English'))
            ],
          ),
          RectangleColorPicker(
              // initialColor: Colors.green,
              colorWidth: 300,
              colorHeight: 150,
              onTapUpListener: (_color) {
                print('矩形取色-点选-$_color');
              },
              colorListener: (_color) {
                print('矩形取色-拖动-$_color');
              }),
          CircularColorPicker(
            onColorChange: (Color value) { print('圆形取色-拖动-$value');},
            onColorChangeEnd: (Color value) {print('圆形取色-结束-$value');},
          )
        ],
      ),
    );
  }

  ///-------------------------------- Widget -----------------------------

  ///右上角弹出菜单
  Widget popMenu() {
    return PopupMenuButton<popMenuItem>(
      icon: Icon(Icons.list_outlined),
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
            Navigator.push(
                context,
                PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 600),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return FadeTransition(
                        opacity: animation,
                        child: InfiniteListView(),
                      );
                    }));
          } else if (result == popMenuItem.item2) {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (context) {
                  return CustomSliverPage();
                },
                // fullscreenDialog: true,
              ),
            );
          } else if (result == popMenuItem.item3) {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (context) {
                  return NestedScrollViewPage();
                },
              ),
            );
          } else {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (context) {
                  return RSCustomScrollView();
                },
              ),
            );
          }
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<popMenuItem>>[
        const PopupMenuItem<popMenuItem>(
          value: popMenuItem.item1,
          child: Text('InfiniteListView'),
          // onTap: () => print("item上的点击事件");,  //const修饰时，不能写onTap，onTap内无法完成跳转
        ),
        const PopupMenuItem<popMenuItem>(
          value: popMenuItem.item2,
          child: Text('CustomSliverPage'),
        ),
        const PopupMenuItem<popMenuItem>(
          value: popMenuItem.item3,
          child: Text('NestedScrollViewPage'),
        ),
        const PopupMenuItem<popMenuItem>(
          value: popMenuItem.item4,
          child: Text('RSCustomScrollView'),
        ),
      ],
    );
  }

  ///-------------------------------- 方法 -------------------
////跳转到一个页
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
