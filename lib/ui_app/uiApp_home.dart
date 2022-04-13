
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

import 'package:flutter_app/basic/app_theme.dart';
import 'package:flutter_app/basic/macro.dart';
import 'package:flutter_app/fitness_app/home_drawer.dart';
import 'package:flutter_app/ui_app/uiView/flowMenu.dart';
import 'package:flutter_app/ui_app/uiView/layoutBuilderRoute.dart';

import '../webSocket_app/webSocket.dart';
import 'package:flutter_app/ui_app/uiView/listView/list_view_main.dart';


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
  final TextStyle _biggerFont = new TextStyle(fontSize: 18.0);
  AnimationController? animationController;

  String btnText = "Normal";
  Icon btnIcon = Icon(Icons.check_box_outline_blank_outlined);
  bool _switchSelected = true; //维护单选开关状态
  bool _checkboxSelected = false; //维护复选框状态

  String str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  @override
  void initState() {
    // TODO: implement initState
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), //这里的widget代表状态所属的类
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _showFavoriteList),
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

      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    btnText = "UnNormal";
                    btnIcon = Icon(Icons.check_box);
                  });
                },
                child: Row(
                  children: [
                    Text("$btnText"),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: btnIcon,
                    ),
                  ],
                ),
              ),
              Switch(
                activeColor: AppTheme.blueGreen,
                value: _switchSelected, //当前状态
                onChanged: (value) {
                  //重新构建页面
                  setState(() {
                    _switchSelected = value;
                  });
                },
              ),
              Checkbox(
                value: _checkboxSelected,
                activeColor: AppTheme.blueGreen, //选中时的颜色
                onChanged: (value) {
                  setState(() {
                    _checkboxSelected = value!;
                  });
                },
              ),
              SizedBox(
                height: 5,
                width: 100,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(AppTheme.glacierBlue),
                  // value: .7,
                ),
              ),
              SizedBox(
                height: 70,
                width: 100,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(AppTheme.blueGreen),
                  value: .7,
                ),
              ),
              SizedBox(
                width: 150,
                height: 30,
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: AppTheme.glacier,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: AppTheme.glacier1,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: AppTheme.glacierBlue,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 0, left: 30),
                constraints: BoxConstraints.tightFor(width: 100.0, height: 60),
                //卡片大小
                decoration: BoxDecoration(
                  //背景装饰
                  gradient: RadialGradient(
                    //背景径向渐变
                    colors: [
                      AppTheme.blueGreen2,
                      AppTheme.glacier1,
                      AppTheme.blueGreen
                    ],
                    center: Alignment.centerRight,
                    radius: 2.2,
                  ),
                  boxShadow: [
                    //卡片阴影
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(2.0, 2.0),
                      blurRadius: 4.0,
                    )
                  ],
                ),
                transform: Matrix4.rotationZ(.2),
                //卡片倾斜变换
                alignment: Alignment.center,
                //卡片内文字居中
                child: Text(
                  //卡片文字
                  "404",
                  style:
                      TextStyle(color: AppTheme.deepPlumPink, fontSize: 30.0),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: 60,
                height: 190,
                child: ListView.separated(
                  key: PageStorageKey(13),
                  itemCount: str.length,
                  itemBuilder: (BuildContext context, int index) {
                    if(index < str.length) {
                      return Text(str[index], textScaleFactor: 1.5,);
                    }
                      return ListTile(title: Text("$index", textScaleFactor: 1.5,));
                    },
                  separatorBuilder: (BuildContext context, int index) {
                      return index%2 == 0 ? Divider(color: Colors.blue,) : Divider(color: Colors.red,);
                  },
                ),
              )
            ]
                .map((e) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: e,
                    ))
                .toList(),
          ),

          Container(
            width: 80,
            child: FlowMenu(expandOrientation: ExpandOrientation.down),
          ),

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

      //悬浮按钮
      floatingActionButton: FloatingActionButton(
        foregroundColor: AppTheme.glacier[400],
        backgroundColor: AppTheme.deepPlumPink,
        onPressed: () { },
        child: Icon(Icons.add),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        color: AppTheme.glacier,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.home_outlined), color: AppTheme.glacier[400],),
            IconButton(onPressed: (){}, icon: Icon(Icons.message_outlined), color: AppTheme.glacier[400],),
            SizedBox(),
            IconButton(onPressed: (){}, icon: Icon(Icons.business_outlined), color: AppTheme.glacier[400],),
            IconButton(onPressed: (){}, icon: Icon(Icons.people_outline_outlined), color: AppTheme.glacier[400],),
          ],
        ),
      ),
    );

  }

//-------------------------------- Widgets -----------------------------
//抽屉列表
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
          child: Text(
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
          leading: Icon(Icons.close),
          title: Text('Close'),
          onTap: () => Navigator.pop(context),
        ),
        Chip(
          avatar: CircleAvatar(
            backgroundColor: Colors.teal.shade100,
            child: const Text('RS'),
          ),
          label: const Text('Ron Samkulami'),
        ),
      ],
    );
  }

  //右上角弹出菜单
  Widget popMenu() {
    return PopupMenuButton<popMenuItem>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
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
          print(result);
          if (result == popMenuItem.item1) {
            ///跳转到
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (context) {
                  return new WebSocketPage(
                    title: 'WebSocketPage',
                    channel: new IOWebSocketChannel.connect(
                        'ws://echo.websocket.org'),
                  );
                },
                fullscreenDialog: true,
              ),
            );
          } else if (result == popMenuItem.item2) {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (context) {
                  return LayoutBuilderRoute();
                },
                // fullscreenDialog: true,
              ),
            );
          } else if (result == popMenuItem.item3) {
            Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (context) {
                    return InfiniteListView();
                  }),

            );
          } else {
            Navigator.pushNamed(context, "new_page");
          }
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<popMenuItem>>[
        const PopupMenuItem<popMenuItem>(
          value: popMenuItem.item1,
          child: Text('WebSocket Page'),
        ),
        const PopupMenuItem<popMenuItem>(
          value: popMenuItem.item2,
          child: Text('Layout Page'),
        ),
        const PopupMenuItem<popMenuItem>(
          value: popMenuItem.item3,
          child: Text('ListView Page'),
        ),
        const PopupMenuItem<popMenuItem>(
          value: popMenuItem.item4,
          child: Text('Select App '),
        ),
      ],
    );
  }

//-------------------------------- 方法 -----------------------------
  //显示收藏列表
  void _showFavoriteList() async {
    String colorStr = ColorDescription.hexColorValue(AppTheme.glacier);
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () =>
                          Navigator.pop(context, "A return result"),
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip,
                    );
                  },
                ),
                title: Text('Saved Suggestions'),
              ),
              body: Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: _showFavoriteList,
                      child: Text("Color $colorStr"),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pop(context, "A return result"),
                      child: Text("Backward"),
                    )
                  ],
                ),
              ));
        },
      ),
    );
    print("路由返回值：$result");
  }
}
