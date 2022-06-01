import 'package:flutter/material.dart';

class SignaturePainter extends CustomPainter {
  SignaturePainter(this.points);

  final List<Offset> points;

  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  bool shouldRepaint(SignaturePainter other) => other.points != points;
}

class Signature extends StatefulWidget {
  SignatureState createState() => SignatureState();
}

class SignatureState extends State<Signature> {
  List<Offset> _points = <Offset>[];

  Widget build(BuildContext context) {
    return SafeArea(child: Column(
      children: [
        Expanded(
          // height: 550,
          child: GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              setState(() {
                RenderBox referenceBox =
                context.findRenderObject() as RenderBox;
                Offset localPosition =
                referenceBox.globalToLocal(details.globalPosition);
                print('$localPosition');
                _points = List.from(_points)..add(localPosition);
              });
            },
            onPanEnd: (DragEndDetails details) => _points.add(Offset.infinite),
            child: CustomPaint(
                painter: SignaturePainter(_points), size: Size.infinite),
          ),
        ),
        Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _points = <Offset>[];
                  });
                },
                child: Text('clear')),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _points.removeLast();
                    while(_points.last !=Offset.infinite) {
                      _points.removeLast();
                    }
                  });
                },
                child: Text('back')),
          ],
        )
      ],
    ));
  }
}
