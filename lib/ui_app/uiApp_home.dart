import 'package:web_socket_channel/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../webSocket_app/webSocket.dart';
import 'package:flutter_app/basic/app_theme.dart';
import 'package:flutter_app/basic/macro.dart';
import 'package:flutter_app/ui_app/uiView/flowMenu.dart';
import 'package:flutter_app/fitness_app/home_drawer.dart';
import 'package:flutter_app/ui_app/uiView/highlight_button.dart';

//主页
class UIAPPHomePage extends StatefulWidget {
  UIAPPHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _UIAPPHomePageState createState() => _UIAPPHomePageState();
}


//主页的状态
class _UIAPPHomePageState extends State<UIAPPHomePage> with TickerProviderStateMixin {
  final TextStyle _biggerFont = new TextStyle(fontSize: 18.0);
  AnimationController? animationController;

  String BtnText = "Normal";
  bool _switchSelected = true; //维护单选开关状态
  bool _checkboxSelected = false;//维护复选框状态

  @override
  void initState() {
    // TODO: implement initState
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), //这里的widget代表状态所属的类
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _showFavoriteList),
          PopMenu(),
        ],
      ),

      //左侧抽屉页
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.glacierBlue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: AppTheme.deepPlumPink,
                  fontSize: 24,
                  shadows:[
                    Shadow(color: AppTheme.darkBlueGreen, blurRadius: 1, offset: Offset(1.5, 1.5))
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
        ),

      ),

      body: Row(
        children: [
          Container(
            constraints: BoxConstraints.tightFor(width: 80.0,),
            child: FlowMenu(),
          ),
          Column(
            children: [
              OutlinedButton(
                onPressed: (){},
                onFocusChange: (change){
                  if(change == true) {
                    setState(() {
                      BtnText = "UnNormal";
                    });
                  }

                },
                child: Text("$BtnText"),
              ),
              Switch(
                value: _switchSelected,//当前状态
                onChanged:(value){
                  //重新构建页面
                  setState(() {
                    _switchSelected=value;
                  });
                },
              ),
              Checkbox(
                value: _checkboxSelected,
                activeColor: Colors.blue, //选中时的颜色
                onChanged:(value){
                  setState(() {
                    _checkboxSelected = value!;
                  });
                } ,
              ),
              SizedBox(),
            ],
          )

        ],
      ),

      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        onPressed: () {  },
        child: Icon(
          Icons.add,
          size: (25),
        ),
      ),


    );
  }



  //右上角弹出菜单
  Widget PopMenu() {
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
          } else {
            Navigator.pushNamed(context, "new_page");
          }
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<popMenuItem>>[
        const PopupMenuItem<popMenuItem>(
          value: popMenuItem.item1,
          child: Text('PopMenu Item1'),
        ),
        const PopupMenuItem<popMenuItem>(
          value: popMenuItem.item2,
          child: Text('PopMenu Item2'),
        ),
        const PopupMenuItem<popMenuItem>(
          value: popMenuItem.item3,
          child: Text('PopMenu Item3'),
        ),
      ],
    );
  }



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
                    onPressed: () => Navigator.pop(context,"A return result"),
                    tooltip: MaterialLocalizations
                        .of(context)
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
                    child: Text("Color $colorStr"),),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context,"A return result"),
                    child: Text("Backward"),)
                ],
              ),
            )
          );
        },
      ),
    );
    print("路由返回值：$result");
  }
}


