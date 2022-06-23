import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_app/basic/app_theme.dart';

//双层按钮
class RSRaisingButton extends StatefulWidget {
  const RSRaisingButton({
    Key? key,
    this.radius,
    this.colors,
    required this.onPressed,
    this.onTapDown,
    this.onTapCancel,
    this.onLongPress,
    this.child,
  }) : super(
          key: key,
        );

  final double? radius;
  final List<Color>? colors;
  final VoidCallback? onPressed;
  final VoidCallback? onTapDown;
  final VoidCallback? onTapCancel;
  final VoidCallback? onLongPress;
  final Widget? child;
  @override
  _RSRaisingButtonState createState() => _RSRaisingButtonState();
}

class _RSRaisingButtonState extends State<RSRaisingButton> {
  bool showShadow = true;

  @override
  Widget build(BuildContext context) {
    double defaultRadius =
        ((widget.radius != null) ? widget.radius : 50)!;
    return GestureDetector(
      /// 通过触摸状态控制阴影显示
      onTapDown: (TapDownDetails details) {
        print('RSRaisingButton onTapDown');
        widget.onTapDown?.call();
        setState(() {
          showShadow = false;
        });
      },
      onTapUp: (TapUpDetails details) {
        print('RSRaisingButton onTapUp');
        setState(() {
          showShadow = true;
        });
      },
      onTapCancel: () {
        print('RSRaisingButton onTapCancel');
        widget.onTapCancel?.call();
        setState(() {
          showShadow = true;
        });
      },
      onTap: widget.onPressed,
      onLongPress: widget.onLongPress,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: defaultRadius,
            height: defaultRadius,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: widget.colors != null
                    ? widget.colors!
                    : [AppTheme.blueGreen2, AppTheme.glacier1],
                center: Alignment.bottomRight,
                radius: 1,
              ),
              boxShadow: showShadow
                  ? [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(4.0, 4.0),
                        blurRadius: 4.0, //8.0
                      )
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(2.0, 2.0),
                        blurRadius: 2.0, //4.0
                      )
                    ],
            ),
          ),
          ClipOval(
            child: Container(
              width: defaultRadius * 0.8,
              height: defaultRadius * 0.8,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: widget.colors != null
                      ? widget.colors!
                      : [AppTheme.blueGreen2, AppTheme.glacier1],
                  center: Alignment.topLeft,
                  radius: 1.5,
                ),
              ),
              child: Center(
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
