import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ui_app/uiView/custom_ui/RS_customPaint.dart';
import 'package:flutter_app/ui_app/eventBus.dart';

Size chessBoardSize = Size(360,360);

class ThirdPage extends StatefulWidget {
  const ThirdPage({
    Key? key,
  }) : super(key: key);

  bool reloadData() {
    print('ThirdPage reloadData');
    return true;
  }

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> with AutomaticKeepAliveClientMixin{

  bool blackStep = true;
  var blackChessList = <RepaintBoundary>[];
  var whiteChessList = <RepaintBoundary>[];
  late Offset _currentPosition;
  String winner = '-';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    print('重新build');
    bus.on('somebodyWin', (arg) {
      //由于是在paint时发送事件总线，需要延迟setState，否则会被系统取消
      Future.delayed(Duration(milliseconds: 50),() {
        setState(() {
          winner = arg == Colors.black ? 'black' : 'white';
        });
      });
    });

    if(blackChessList.isEmpty && whiteChessList.isEmpty) {
      reStart();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('UI'),
      ),

      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              child: RepaintBoundary(
                child: CustomPaint(
                  size: chessBoardSize,
                  painter: MyChessboardPainter(),
                ),
              ),
              onLongPressDown: (LongPressDownDetails details) {
                // print('${details.localPosition}');
                if (canPlaceChess(chessBoardSize, details.localPosition)) {
                  setState(() {
                    if (blackStep) {
                      blackChessList.add(
                        RepaintBoundary(
                          child: CustomPaint(
                            size: chessBoardSize,
                            painter:
                            ChessPiecesPainter(drawPosition: details.localPosition),
                          ),
                        ),
                      );
                    } else {
                      whiteChessList.add(
                        RepaintBoundary(
                          child: CustomPaint(
                            size: chessBoardSize,
                            painter:
                            ChessPiecesPainter(drawPosition: details.localPosition, isBlack: false),
                          ),
                        ),
                      );
                    }
                    blackStep = !blackStep;
                    _currentPosition = details.localPosition;
                  });
                }

              },
            ),
            IgnorePointer(
              child: Stack(
                children: blackChessList,
              ),
            ),
            IgnorePointer(
              child: Stack(
                children: whiteChessList,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 430),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        blackChessList = <RepaintBoundary>[];
                        whiteChessList = <RepaintBoundary>[];
                        reStart();
                        winner = '-';
                      });
                    },
                    child: Text('重开'),
                  ),
                  Padding(padding: EdgeInsets.only(left: 15), child: Text('Winner:$winner'),)
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.backspace_outlined), onPressed: () {
          setState(() {
            blackStep = !blackStep;
            if (blackStep) {
              blackChessList.removeLast();
            } else {
              whiteChessList.removeLast();
            }
            rollBackAStep(chessBoardSize,_currentPosition);
            winner = '-';
          });
      },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
  


}
