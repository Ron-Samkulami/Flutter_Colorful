import 'package:flutter/material.dart';
import '../../../basic/app_theme.dart';
import 'com_buildSliverList.dart';

class NestedScrollViewPage extends StatefulWidget {
  @override
  _NestedScrollViewPageState createState() => _NestedScrollViewPageState();
}

class _NestedScrollViewPageState extends State<NestedScrollViewPage> {
  // DateTime? _lastPressedAt; //上次点击时间

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          // WillPopScope(
          //拦截返回按钮，会屏蔽侧滑返回手势
          // onWillPop: () async {
          // if (_lastPressedAt == null ||
          //     DateTime.now().difference(_lastPressedAt!) >
          //         Duration(seconds: 1)) {
          //   //两次点击间隔超过1秒则重新计时
          //   _lastPressedAt = DateTime.now();
          //   return false;
          // }
          //   return true;
          // },
          // child:
          NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            // 实现 snap 效果
            SliverOverlapAbsorber(
              ///包装在 SliverOverlapAbsorber 中，解决snap 遮挡内容的问题
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                floating: true,
                snap: true, //floating为true时才有效，捏合或轻划时出现
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                    "assets/images/feedbackImage.png",
                    fit: BoxFit.cover,
                  ),
                ),
                forceElevated: innerBoxIsScrolled,
              ),
            ),
          ];
        },
        body: Builder(builder: (BuildContext context) {
          return RepaintBoundary(
            child: CustomScrollView(
              slivers: <Widget>[
                rsColorDisplay(10),
              ],
            ),
          );
        }),
      ),
      // ),
    );
  }
}

// 构建列表项
Widget rsLiverList() {
  final count = 256 * 256 * 256;
  return SliverFixedExtentList(
    itemExtent: 1,
    delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        //创建列表项
        return Container(
          alignment: Alignment.center,
          color: Color.fromARGB(
              255, (index ~/ 256) ~/ 256, index ~/ 256, index % 256),
          child: Text(
            '${(index ~/ 256) ~/ 256},${index ~/ 256},${index % 256}',
            style: TextStyle(color: AppTheme.nearlyWhite),
          ),
        );
      },
      childCount: count,
    ),
  );
}

// 构建列表项
Widget rsColorDisplay(int colorGrains) {
  const maxColorValue = 256;
  assert(colorGrains < maxColorValue && colorGrains >= 0);
  var pixelSize = (colorGrains < maxColorValue && colorGrains >= 0) ? colorGrains : 8;
  var xPixelsCount = maxColorValue ~/ pixelSize;
  final count = xPixelsCount * xPixelsCount * xPixelsCount;

  return SliverGrid(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        print('${(index ~/ (xPixelsCount * xPixelsCount)) * pixelSize},'
            '${((index % (xPixelsCount * xPixelsCount)) ~/ xPixelsCount) * pixelSize},'
            '${((index % (xPixelsCount * xPixelsCount)) % xPixelsCount) * pixelSize}');
        return ColoredBox(
            color: Color.fromARGB(
                255,
                (index ~/ (xPixelsCount * xPixelsCount)) * pixelSize,
                ((index % (xPixelsCount * xPixelsCount)) ~/ xPixelsCount) * pixelSize,
                ((index % (xPixelsCount * xPixelsCount)) % xPixelsCount) * pixelSize));
      }, childCount: count),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: xPixelsCount, childAspectRatio: 1));
}

