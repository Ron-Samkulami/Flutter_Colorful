
import 'package:flutter/material.dart';
import 'package:flutter_app/basic/app_theme.dart';

//双层按钮
class RaisingButton extends StatefulWidget {
  const RaisingButton({
    Key? key,
    this.size,
    this.color,
    required this.onPressed,
    this.onLongPress,
    this.child,
  }) : super(
    key: key,
  );

  final Size? size;
  final Color? color;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget? child;
  @override
  _RaisingButtonState createState() => _RaisingButtonState();
}

class _RaisingButtonState extends State<RaisingButton> {
  @override
  Widget build(BuildContext context) {
    double outerWidth = ((widget.size?.width != null) ? widget.size?.width : 50)!;
    double outerHeight =
    ((widget.size?.height != null) ? widget.size?.height : 50)!;
    return GestureDetector(
      onTap: widget.onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipOval(
            child: Container(
              width: outerWidth,
              height: outerHeight,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: widget.color != null
                      ? [widget.color!, widget.color!.withOpacity(0.2)]
                      : [AppTheme.blueGreen2, AppTheme.glacier1],
                  center: Alignment.bottomRight,
                  radius: 1,
                ),
              ),
            ),
          ),
          ClipOval(
            child: Container(
                width: outerWidth * 0.8,
                height: outerHeight * 0.8,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: widget.color != null
                        ? [widget.color!.withOpacity(0.2), widget.color!]
                        : [AppTheme.glacier1, AppTheme.blueGreen2],
                    center: Alignment.bottomRight,
                    radius: 2,
                  ),
                )),
          ),
          ClipOval(
            child: Container(
              width: outerWidth * 0.8,
              height: outerHeight * 0.8,
              child: Center(
                child: widget.child,
              ),),
          ),
        ],
      ),
    );
  }
}