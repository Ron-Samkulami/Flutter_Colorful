import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_app/ui_app/uiView/custom_ui/flowMenu.dart';

import 'package:flutter_app/basic/app_theme.dart';
import 'package:flutter_app/ui_app/uiView/animation/animateRoute.dart';
import 'package:flutter_app/ui_app/uiView/custom_ui/RS_rotateBox.dart';
import 'package:flutter_app/rs_widgets/left_right_box.dart';
import 'package:flutter_app/rs_widgets/rs_button.dart';

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
  double _turns = .0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 40,
                maxWidth: 80,
              ),
              child: LeftRightBox(
                children: [
                  Container(
                    width: 90,
                    height: 40,
                    child: ColoredBox(
                      color: AppTheme.glacier[600]!,
                      /// 使用builder创建局部刷新
                      child: Builder(builder: (BuildContext context) {
                        return Switch(
                          activeColor: AppTheme.glacier[300]!,
                          value: _switchSelected, //当前状态
                          onChanged: (value) {
                            _switchSelected = value;
                            (context as Element).markNeedsBuild();
                          },
                        );
                      },),
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 80,
                    child: ColoredBox(
                      color: Colors.blue,
                      child: Checkbox(
                        value: _checkboxSelected,
                        activeColor: AppTheme.blueGreen, //选中时的颜色
                        onChanged: (value) {
                          setState(() {
                            _checkboxSelected = value!;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            /// 进度条
            SizedBox(
              height: 5,
              width: 100,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(AppTheme.glacierBlue),
                // value: .7,
              ),
            ),
            /// FLex
            SizedBox(
              width: 80,
              height: 20,
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: AppTheme.lightCreamYellow,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: AppTheme.lightPlumPink,
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
            ///倾斜渐变色卡片
            Container(
              margin: EdgeInsets.only(top: 0, left: 10),
              constraints: BoxConstraints.tightFor(width: 60.0, height: 30),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppTheme.blueGreen2,
                    AppTheme.glacier1,
                    AppTheme.blueGreen
                  ],
                  center: Alignment.centerRight,
                  radius: 2.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    offset: Offset(2.0, 2.0),
                    blurRadius: 4.0,
                  )
                ],
              ),
              transform: Matrix4.rotationZ(.2),
              alignment: Alignment.center,
              child: Text(
                "404",
                style: TextStyle(color: AppTheme.deepPlumPink, fontSize: 20.0),
              ),
            ),
            ///弹窗
            ElevatedButton(
              child: Text("安卓弹窗"),
              onPressed: () async {
                bool? delete = await showDeleteConfirmDialog2();
                if (delete == null) {
                  print("取消删除");
                } else {
                  print("同时删除子目录: $delete");
                }
              },
            ),
            ///模态
            ElevatedButton(
              child: Text("Modal View"),
              onPressed: () async {
                String? type = await _showModalBottomSheet();
                print(type);
              },
            ),
            ///点击事件透传
            Container(
              color: AppTheme.deepPlumPink,
              width: 50,
              height: 50,
              child: Stack(
                children: [
                  wChild(1),
                  wChild(2),
                  IgnorePointer(child: wChild(3))
                ],
              ),
            )
          ]
              .map((e) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: e,
                  ))
              .toList(),
        ),

        Container(
          width: 80,
          child: FlowMenu(expandOrientation: ExpandOrientation.down),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppTheme.nearlyWhite,
              width: 100,
              height: 200,
              child: StaggerRoute(),
            ),
            Container(
              width: 100,
              child: Column(
                children: [
                  GestureDetector(
                    onPanUpdate: (DragUpdateDetails details) {
                      setState(() {
                        _turns += -(details.delta.dx == 0
                                ? details.delta.dy
                                : details.delta.dx) /
                            10;
                      });
                    },
                    child: RSRotateBox(
                        turns: _turns,
                        speed: 500,
                        child: const Icon(
                          Icons.refresh_outlined,
                          size: 50,
                        )),
                  ),

                  RSRaisingButton(
                    onPressed: () {},
                    child: Text('RS'),
                  ),
                  SizedBox(height: 10,),
                  RSRaisingButton(
                    onPressed: () {},
                    colors: [AppTheme.deepPlumPink, AppTheme.lightPlumPink],
                    radius: 40,
                    child: Text('RS',textScaleFactor: 0.8,),
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  /// wChild

  Widget wChild(int index) {
    return Listener(
      //behavior: HitTestBehavior.opaque, // 放开此行，点击只会输出 2
      behavior: HitTestBehavior.translucent, // 放开此行，点击会同时输出 2 和 1
      onPointerDown: (e) => print(index),
      child: SizedBox.expand(),
    );
  }

  /// StatefulBuilder
  Future<bool?> showDeleteConfirmDialog2() {
    bool _withTree = false; //记录复选框是否选中
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text("提示"),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "您确定要删除当前文件吗?",
                textScaleFactor: 1.2,
              ),
              Row(
                children: <Widget>[
                  Text(
                    "同时删除子目录？",
                    textScaleFactor: 0.9,
                  ),
                  //使用StatefulBuilder来构建StatefulWidget上下文
                  StatefulBuilder(builder: (context, _setState) {
                    return Checkbox(
                        value: _withTree,
                        onChanged: (bool? value) {
                          /// _setState方法实际就是该StatefulWidget的setState方法，
                          /// 调用后builder方法会重新被调用
                          _setState(() {
                            _withTree = !_withTree;
                          });
                        });
                  }),

                  // /// 一个更简洁据局部更新的方式
                  // Builder(builder: (BuildContext context) {
                  //   return Checkbox(
                  //       value: _withTree,
                  //       onChanged: (bool? value) {
                  //         _withTree = !_withTree;
                  //         ///这里的context只是Checkbox 范围内的context
                  //         (context as Element).markNeedsBuild();
                  //       });
                  // }),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("删除"),
              onPressed: () {
                //执行删除操作
                Navigator.of(context).pop(_withTree);
              },
            ),
          ],
        );
      },
    );
  }

  /// 底部模态列表
  // 弹出底部菜单列表模态对话框
  Future<String?> _showModalBottomSheet() {
    return showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: 30,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text("$index"),
              onTap: () => Navigator.of(context).pop("点击序号$index"),
            );
          },
        );
      },
    );
  }
}

/// StatefulBuilder
class StatefulBuilder extends StatefulWidget {
  const StatefulBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final StatefulWidgetBuilder builder;

  @override
  _StatefulBuilderState createState() => _StatefulBuilderState();
}

class _StatefulBuilderState extends State<StatefulBuilder> {
  @override
  Widget build(BuildContext context) => widget.builder(context, setState);
}
