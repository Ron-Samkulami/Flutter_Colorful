
import 'package:flutter/material.dart';
import 'package:flutter_app/ui_app/uiView/custom_ui/flowMenu.dart';

import 'package:flutter_app/basic/app_theme.dart';

class UiUnitRoute extends StatefulWidget {

  @override
  _UiUnitRouteState createState() => _UiUnitRouteState();
}

class _UiUnitRouteState extends State<UiUnitRoute> {
  String btnText = "Normal";
  String str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  bool _switchSelected = true; //维护单选开关状态
  bool _checkboxSelected = false; //维护复选框状态
  Icon btnIcon = Icon(Icons.check_box_outline_blank_outlined);

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

