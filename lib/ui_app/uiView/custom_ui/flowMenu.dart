
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/basic/app_theme.dart';

enum ExpandOrientation { left, up, right, down }

List<IconData> menuItems = <IconData>[
  Icons.home,
  Icons.add_a_photo,
  Icons.video_call,
  Icons.settings,
  Icons.keyboard_arrow_right,
];

class FlowMenu extends StatefulWidget {
  const FlowMenu({
    Key? key,
    required this.expandOrientation,
  }) : super(key: key);

  final ExpandOrientation expandOrientation;

  @override
  _FlowMenuState createState() => _FlowMenuState();
}


class _FlowMenuState extends State<FlowMenu> with SingleTickerProviderStateMixin {
  //成员变量
  late AnimationController menuAnimation;
  late IconData lastTapped;

  //成员方法
  void _updateMenu(IconData icon) {
    if(icon != Icons.keyboard_arrow_right) {
      setState(() => lastTapped = icon);
    }
  }

  //初始化状态
  @override
  void initState() {
    super.initState();
    lastTapped = Icons.home;
    menuAnimation = AnimationController(vsync: this, duration: const Duration(milliseconds: 200),);
  }

  //Item构建方法
  Widget flowMenuItem(IconData icon) {
    final double buttonDiameter =  min(75, MediaQuery.of(context).size.width / menuItems.length);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      child: RawMaterialButton(
        fillColor: lastTapped == icon ? AppTheme.blueGreen : AppTheme.glacier[400],
        splashColor: Colors.pink[100],
        shape:CircleBorder(),
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(30.0),
        // ),
        constraints: BoxConstraints.tight(Size(buttonDiameter - 10, buttonDiameter - 10)),
        onPressed: () {
          _updateMenu(icon);
          //控制动画的status，reverse或forward，达到列表展开或收起的目的
          menuAnimation.status == AnimationStatus.completed ? menuAnimation.reverse() : menuAnimation.forward();
        },
        child: Icon(
          icon,
          color: Colors.white,
          size: 45.0,
        ),
      ),
    );
  }

  //build方法
  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: FlowMenuDelegate(menuAnimation: menuAnimation, expandOrientation: widget.expandOrientation),
      children: menuItems.map<Widget>((IconData icon) => flowMenuItem(icon)).toList(),
    );
  }

}



class FlowMenuDelegate extends FlowDelegate {
  FlowMenuDelegate({
    required this.menuAnimation,
    required this.expandOrientation,
  }) : super(repaint: menuAnimation);

  final Animation<double> menuAnimation;
  final ExpandOrientation expandOrientation;

  @override
  bool shouldRepaint(covariant FlowMenuDelegate oldDelegate) {
    return menuAnimation != oldDelegate.menuAnimation;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    double dx = 0.0;
    for (int i = 0; i < context.childCount; i++) {
      dx = context.getChildSize(i)!.width * i;
      switch(this.expandOrientation) {
        case ExpandOrientation.left: {
          context.paintChild(
            i,
            transform: Matrix4.translationValues(-dx * menuAnimation.value, 0, 0,),
          );
        }
        break;
        case ExpandOrientation.up: {
          context.paintChild(
            i,
            transform: Matrix4.translationValues(0, -dx * menuAnimation.value, 0,),
          );

        }
        break;
        case ExpandOrientation.right: {
          context.paintChild(
            i,
            transform: Matrix4.translationValues(dx * menuAnimation.value, 0, 0,),
          );
        }
        break;
        case ExpandOrientation.down: {
          context.paintChild(
            i,
            transform: Matrix4.translationValues(0, dx * menuAnimation.value, 0,),
          );
        }
        break;
      }

    }
  }
}