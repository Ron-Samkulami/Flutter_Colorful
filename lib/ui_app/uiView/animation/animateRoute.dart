import 'package:flutter/material.dart';
import 'package:flutter_app/basic/app_theme.dart';


class StaggerRoute extends StatefulWidget {
  @override
  _StaggerRouteState createState() => _StaggerRouteState();
}

class _StaggerRouteState extends State<StaggerRoute>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  _playAnimation() async {
    try {
      //先正向执行动画
      await _controller.forward().orCancel;
      //再反向执行动画
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          Container(
            width: 80.0,
            height: 120.0,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              border: Border.all(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            //调用我们定义的交错动画Widget
            child: StaggerAnimation(controller: _controller),
          ),

          Padding(
            padding: EdgeInsets.only(top: 5),
            child: SizedBox(
              width: 50,
              height: 20,
              child: ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.resolveWith((states) {
                    if(states.contains(MaterialState.pressed) || states.contains(MaterialState.disabled)) {return 0;}
                    return 5;
                  }),
                  backgroundColor: MaterialStateProperty.resolveWith((states) => AppTheme.deepPlumPink)
                ),
                onPressed: () => _playAnimation(),
                child: Text("Fire",textScaleFactor: 0.5,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/// --------------- 动画 ---------------
class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({
    Key? key,
    required this.controller,
  }) : super(key: key) {
    //高度动画
    height = Tween<double>(
      begin: .0,
      end: 80.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.0, 0.6, //间隔，前60%的动画时间
          curve: Curves.fastLinearToSlowEaseIn,
        ),
      ),
    );

    color = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.0, 0.6, //间隔，前60%的动画时间
          curve: Curves.ease,
        ),
      ),
    );

    padding = Tween<EdgeInsets>(
      begin: const EdgeInsets.only(left: 10.0),
      end: const EdgeInsets.only(left: 50.0),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.6, 1.0, //间隔，后40%的动画时间
          curve: Curves.ease,
        ),
      ),
    );
  }

  late final Animation<double> controller;
  late final Animation<double> height;
  late final Animation<EdgeInsets> padding;
  late final Animation<Color?> color;

  Widget _buildAnimation(BuildContext context, child) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: padding.value,
      child: Container(
        color: color.value,
        width: 20.0,
        height: height.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}