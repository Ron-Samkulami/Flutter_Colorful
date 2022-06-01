import 'package:flutter/material.dart';

class RectangleColorPicker extends StatefulWidget {
  final Color? initialColor;
  final ValueChanged<Color>? colorListener;
  final ValueChanged<Color>? onTapUpListener;
  final double? colorWidth;
  final double? colorHeight;

  const RectangleColorPicker(
      {Key? key,
        this.initialColor,
        this.colorListener,
        this.onTapUpListener,
        this.colorWidth,
        this.colorHeight,
        })
      : super(key: key);

  @override
  _RectangleColorPickerState createState() => _RectangleColorPickerState();
}

class _RectangleColorPickerState extends State<RectangleColorPicker> {
  double _top = 0.0;
  double _left = 0.0;
  double _thumbSize = 20;
  double _hue = 0.0;
  double _brightNum = 50.0;
  late double lightness;
  late double _colorWidth;
  late double _colorHeight;

  Color get _color {
    return HSLColor.fromAHSL(
      1,
      _hue,
      1,
      lightness,
    ).toColor();
    //返回HSL、AHSL格式的色调亮度字符串
  }

  @override
  void initState() {
    super.initState();
    HSLColor hslColor = HSLColor.fromColor(widget.initialColor != null ? widget.initialColor! : Colors.blue);
    _colorWidth = (widget.colorWidth != null ? widget.colorWidth : 250)!;
    _colorHeight = (widget.colorHeight != null ? widget.colorHeight : 80)!;
    _left = (_colorWidth * hslColor.hue) / 360;
    _top = (_colorHeight * (hslColor.lightness - 0.5) * 200) / 100;
    this._hue = hslColor.hue;
    this.lightness = hslColor.lightness;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onPanStart: (DragStartDetails detail) {
          var localPosition = detail.localPosition;
          buildSetState(localPosition, context);
          if(widget.colorListener != null){
            widget.colorListener!(_color);
          }

        },
        onPanDown: (DragDownDetails detail) {
          var localPosition = detail.localPosition;
          buildSetState(localPosition, context);
          if(widget.colorListener != null){
            widget.colorListener!(_color);
          }
        },
        onPanUpdate: (DragUpdateDetails detail) {
          //获取当前触摸点的局部坐标
          var localPosition = detail.localPosition;
          buildSetState(localPosition, context);
          if(widget.colorListener != null){
            widget.colorListener!(_color);
          }

        },
        onPanEnd: (DragEndDetails detail) {
          if(widget.onTapUpListener != null){
            widget.onTapUpListener!(_color);
          }
        },
        onTapUp: (TapUpDetails detail){
          if(widget.onTapUpListener != null){
            widget.onTapUpListener!(_color);
          }
        },
        child: ColorRect(
            colorHeight: _colorHeight,
            colorWidth: _colorWidth,
            top: _top,
            thumbSize: _thumbSize,
            left: _left,
            color: _color),
      ),
    );
  }

  void buildSetState(Offset localPosition, BuildContext context) {
    return setState(() {
      _left = localPosition.dx;
      _top = localPosition.dy;
      if (_left < 0) {
        _left = 0;
      } else if (0 <= _left && _left <= _colorWidth) {
        _left = _left;
        _hue = (360 * _left) / (_colorWidth);
      } else if (_left > _colorWidth) {
        _left = (_colorWidth);
        _hue = 360;
      }

      if (((5 / 360 - 5 / 360) < _left &&
          _left < (5 / 360 + 5 / 360) * _colorWidth) &&
          (_top < 5)) {
        _left = 5 / 360 * _colorWidth;
        _top = 0;
      } else if ((((5 + 350 / 6) / 360 - 5 / 360) * _colorWidth < _left &&
          _left < ((5 + 350 / 6) / 360 + 5 / 360) * _colorWidth) &&
          (_top < 5)) {
        _left = (5 + (1 * 350) / 6) / 360 * _colorWidth;
        _top = 0;
      } else if ((((5 + (2 * 350) / 6) / 360 - 5 / 360) * _colorWidth < _left &&
          _left < ((5 + (2 * 350) / 6) / 360 + 5 / 360) * _colorWidth) &&
          (_top < 5)) {
        _left = (5 + (2 * 350) / 6) / 360 * _colorWidth;
        _top = 0;
      } else if ((((5 + (3 * 350) / 6) / 360 - 5 / 360) * _colorWidth < _left &&
          _left < ((5 + (3 * 350) / 6) / 360 + 5 / 360) * _colorWidth) &&
          (_top < 5)) {
        _left = (5 + (3 * 350) / 6) / 360 * _colorWidth;
        _top = 0;
      } else if ((((5 + (4 * 350) / 6) / 360 - 5 / 360) * _colorWidth < _left &&
          _left < ((5 + (4 * 350) / 6) / 360 + 5 / 360) * _colorWidth) &&
          (_top < 5)) {
        _left = (5 + (4 * 350) / 6) / 360 * _colorWidth;
        _top = 0;
      } else if ((((5 + (5 * 350) / 6) / 360 - 5 / 360) * _colorWidth < _left &&
          _left < ((5 + (5 * 350) / 6) / 360 + 5 / 360) * _colorWidth) &&
          (_top < 5)) {
        _left = (5 + (5 * 350) / 6) / 360 * _colorWidth;
        _top = 0;
      } else if ((((5 + (6 * 350) / 6) / 360 - 5 / 360) * _colorWidth < _left &&
          _left < ((5 + (6 * 350) / 6) / 360 + 5 / 360)) &&
          (_top < 5)) {
        _left = (5 + (6 * 350) / 6) / 360 * _colorWidth;
        _top = 0;
      }

      if (_top <= 0) {
        _top = 0;
        _brightNum = 50;
        lightness = _brightNum / 100;
      } else if (0 <= _top && _top <= _colorHeight) {
        _brightNum = (100 * _top) / _colorHeight / 2 + 50;
        lightness = _brightNum / 100;
      } else if (_top > _colorHeight) {
        _top = _colorHeight;
        _brightNum = 100;
        lightness = _brightNum / 100;
      }

    });
  }
}

class ColorRect extends StatelessWidget {
  const ColorRect({
    Key? key,
    required double colorHeight,
    required double colorWidth,
    required double top,
    required double thumbSize,
    required double left,
    required Color color,
  })  : _colorHeight = colorHeight,
        _colorWidth = colorWidth,
        _top = top,
        _thumbSize = thumbSize,
        _left = left,
        _color = color,
        super(key: key);

  final double _colorHeight;
  final double _colorWidth;
  final double _top;
  final double _thumbSize;
  final double _left;
  final Color _color;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: DecoratedBox(
                  child: Container(
                    height: _colorHeight,
                    width: _colorWidth,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [
                        0,
                        5 / 360,
                        (5 + 350 / 6) / 360,
                        (5 + (2 * 350) / 6) / 360,
                        (5 + (3 * 350) / 6) / 360,
                        (5 + (4 * 350) / 6) / 360,
                        (5 + (5 * 350) / 6) / 360,
                        (5 + (6 * 350) / 6) / 360,
                        1.0
                      ],
                      colors: [
                        Color.fromARGB(255, 255, 0, 0),
                        Color.fromARGB(255, 255, 0, 0),
                        Color.fromARGB(255, 255, 255, 0),
                        Color.fromARGB(255, 0, 255, 0),
                        Color.fromARGB(255, 0, 255, 255),
                        Color.fromARGB(255, 0, 0, 255),
                        Color.fromARGB(255, 255, 0, 255),
                        Color.fromARGB(255, 255, 0, 0),
                        Color.fromARGB(255, 255, 0, 0),
                      ],
                    ),
                  )),
            ),
          ),
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: DecoratedBox(
                  child: Container(
                    height: _colorHeight,
                    width: _colorWidth,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withAlpha(0),
                        Colors.white,
                      ],
                    ),
                  )),
            ),
          ),
          Container(
              child: Thumb(
                  top: _top,
                  thumbSize: _thumbSize,
                  left: _left,
                  color: _color)),
        ],
      ),
    );
  }
}

class Thumb extends StatelessWidget {
  const Thumb({
    Key? key,
    required double top,
    required double thumbSize,
    required double left,
    required Color color,
  })  : _top = top,
        _thumbSize = thumbSize,
        _left = left,
        _color = color,
        super(key: key);

  final double _top;
  final double _thumbSize;
  final double _left;
  final Color _color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: _top - _thumbSize / 2,
        left: _left - _thumbSize / 2,
        child: GestureDetector(
            child: Container(
              child: Icon(
                Icons.circle,
                color: _color,
                size: _thumbSize,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_thumbSize / 2),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 0.1, //阴影范围
                    spreadRadius: 0.001, //阴影浓度
                    color: Colors.black, //阴影颜色
                  ),
                ],
              ),
            )));
  }
}


