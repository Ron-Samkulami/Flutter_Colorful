import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_app/basic/app_theme.dart';
import 'package:flutter_app/ui_app/eventBus.dart';


int rowCount = 15;
int columnCount = 15;
Map positions = <Offset, Color>{};
List placedPositions = <Offset>[];
bool someBodyWin = false;
class MyChessboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    print('MyChessboardPainter paint');
    var rect = Offset.zero & size;
    //画棋盘
    drawChessboard(canvas, rect);
  }

  // 返回false, 后面介绍
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 画棋盘
void drawChessboard(Canvas canvas, Rect rect) {
  //棋盘背景
  var paint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill //填充
    // ..color = AppTheme.lightPlumPink;
    ..color = Color(0xFFDCC48C);
  canvas.drawRect(rect, paint);

  //画棋盘网格
  paint
    ..style = PaintingStyle.stroke //线
    ..color = Colors.black38
    ..strokeWidth = 1.0;

  //画横线
  for (int i = 0; i <= rowCount; ++i) {
    double dy = rect.top + rect.height / rowCount * i;
    canvas.drawLine(Offset(rect.left, dy), Offset(rect.right, dy), paint);
  }

  for (int i = 0; i <= columnCount; ++i) {
    double dx = rect.left + rect.width / columnCount * i;
    canvas.drawLine(Offset(dx, rect.top), Offset(dx, rect.bottom), paint);
  }
}

/// 在指定位置画棋子
class ChessPiecesPainter extends CustomPainter {
  const ChessPiecesPainter({
    required this.drawPosition,
    this.isBlack = true,
  });

  final Offset drawPosition;
  final bool isBlack;

  @override
  void paint(Canvas canvas, Size size) {
    // print('ChessPiecesPainter paint');
    var rect = Offset.zero & size;
    double eWidth = rect.width / columnCount;
    double eHeight = rect.height / rowCount;
    //画棋子
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = isBlack ? Colors.black : Colors.white;

    Offset position = Offset(
        (((drawPosition.dx + eWidth / 2) ~/ eWidth) * eWidth),
        (((drawPosition.dy + eHeight / 2) ~/ eHeight) * eHeight));

    if (positions.containsKey(position) == false) {

      //绘制棋子
      canvas.drawCircle(
        position,
        min(eWidth / 2, eHeight / 2) - 2,
        paint,
      );

      //记录当前位置被占用
      positions[position] = paint.color;

      //计算是否5连子
      someBodyWin = judgeIsWin(rect, position, paint.color);

      print('判断完成$someBodyWin');
      if (someBodyWin) {
        //通知
        bus.emit('somebodyWin',paint.color);
      }


    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

/// 判断指定位置是否能放置棋子
bool canPlaceChess(Size size, Offset drawPosition) {
  var rect = Offset.zero & size;
  double eWidth = rect.width / columnCount;
  double eHeight = rect.height / rowCount;
  Offset position = Offset(
      (((drawPosition.dx + eWidth / 2) ~/ eWidth) * eWidth),
      (((drawPosition.dy + eHeight / 2) ~/ eHeight) * eHeight));
  if (positions.containsKey(position) == false && someBodyWin == false) {
    return true;
  }
  return false;
}

/// 清空指定位置的棋子记录
void rollBackAStep(Size size, Offset drawPosition) {
  var rect = Offset.zero & size;
  double eWidth = rect.width / columnCount;
  double eHeight = rect.height / rowCount;
  Offset position = Offset(
      (((drawPosition.dx + eWidth / 2) ~/ eWidth) * eWidth),
      (((drawPosition.dy + eHeight / 2) ~/ eHeight) * eHeight));
  positions.remove(position);

  if (someBodyWin) {
    someBodyWin = false;
  }
}

void reStart() {
  positions = <Offset, Color>{};
  someBodyWin = false;
}

///判断输赢
bool judgeIsWin(Rect rect, Offset position, Color color) {
  double eWidth = rect.width / columnCount;
  double eHeight = rect.height / rowCount;

  //横线
  double testX = position.dx;
  int countX = 1;
  while (testX < rect.width) {
    testX += eWidth;
    if (positions[Offset(testX, position.dy)] == color) {
      countX += 1;
    } else {
      break;
    }
  }
  testX = position.dx;
  while (testX > 0) {
    testX -= eWidth;
    if (positions[Offset(testX, position.dy)] == color) {
      countX += 1;
    } else {
      break;
    }
  }

  if (countX == 5) {
    return true;
  }

  //纵线
  double testY = position.dy;
  int countY = 1;
  while (testY < rect.height) {
    testY += eHeight;
    if (positions[Offset(position.dx, testY)] == color) {
      countY += 1;
    } else {
      break;
    }
  }
  testY = position.dy;
  while (testY > 0) {
    testY -= eHeight;
    if (positions[Offset(position.dx, testY)] == color) {
      countY += 1;
    } else {
      break;
    }
  }

  if (countY == 5) {
    return true;
  }

  //斜线
  double testXYX1 = position.dx;
  double testXYY1 = position.dy;
  int countXY1 = 1;
  while (testXYX1 < rect.width && testXYY1 < rect.height) {
    testXYX1 += eWidth;
    testXYY1 += eHeight;
    if (positions[Offset(testXYX1, testXYY1)] == color) {
      countXY1 += 1;
    } else {
      break;
    }
  }
  testXYX1 = position.dx;
  testXYY1 = position.dy;
  while (testXYX1 > 0 && testXYY1 > 0) {
    testXYX1 -= eWidth;
    testXYY1 -= eHeight;
    if (positions[Offset(testXYX1, testXYY1)] == color) {
      countXY1 += 1;
    } else {
      break;
    }
  }

  if (countXY1 == 5) {
    return true;
  }

  //斜线
  double testXYX2 = position.dx;
  double testXYY2 = position.dy;
  int countXY2 = 1;
  while (testXYX2 > 0 && testXYY2 < rect.height) {
    testXYX2 -= eWidth;
    testXYY2 += eHeight;
    if (positions[Offset(testXYX2, testXYY2)] == color) {
      countXY2 += 1;
    } else {
      break;
    }
  }
  testXYX2 = position.dx;
  testXYY2 = position.dy;
  while (testXYX2 < rect.width && testXYY2 > 0) {
    testXYX2 += eWidth;
    testXYY2 -= eHeight;
    if (positions[Offset(testXYX2, testXYY2)] == color) {
      countXY2 += 1;
    } else {
      break;
    }
  }

  if (countXY2 == 5) {
    return true;
  }

  return false;

}
