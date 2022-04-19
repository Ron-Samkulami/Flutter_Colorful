import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/basic/app_theme.dart';
import 'package:flutter_app/ui_app/uiView/custom_ui/customSliver.dart';
import 'com_buildSliverList.dart';

class NestedScrollViewPage extends StatefulWidget {
  @override
  _NestedScrollViewPageState createState() => _NestedScrollViewPageState();
}

class _NestedScrollViewPageState extends State<NestedScrollViewPage> {
  DateTime? _lastPressedAt; //上次点击时间

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // child: NestedScrollView(
      //   headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
      //     return <Widget>[
      //       SliverAppBar(
      //         title: const Text("嵌套ListView"),
      //         pinned: true,
      //         forceElevated: innerBoxIsScrolled,
      //       ),
      //       buildSliverList(2),
      //
      //     ];
      //   },
      //   body: ListView.builder(
      //     padding: const EdgeInsets.all(8),
      //     physics: const ClampingScrollPhysics(), //重要
      //     itemCount: 30,
      //     itemBuilder: (BuildContext context, int index) {
      //       return SizedBox(
      //         height: 50,
      //         child: Center(child: Text("Item $index"),),
      //       );
      //     },
      //   ),
      // ),

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
              // SliverAppBar(
              //   floating: true,
              //   snap: true, //floating为true时才有效，捏合或轻划时出现
              //   expandedHeight: 200,
              //   forceElevated: innerBoxIsScrolled,
              //   flexibleSpace: FlexibleSpaceBar(
              //     background: Image.asset(
              //       "./imgs/sea.png",
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
              SliverOverlapAbsorber(
                ///包装在 SliverOverlapAbsorber 中，解决snap 遮挡内容的问题
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  floating: true,
                  snap: true, //floating为true时才有效，捏合或轻划时出现
                  expandedHeight: 200,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset(
                      "./imgs/sea.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  forceElevated: innerBoxIsScrolled,
                ),
              ),
            ];
          },
          body: Builder(builder: (BuildContext context) {
            return CustomScrollView(
              slivers: <Widget>[buildSliverList(100)],
            );
          }),
        ),
      // ),
    );
  }
}

// 构建列表项
// Widget buildSliverList(itemCount) {
//   return SliverFixedExtentList(
//     itemExtent: 50.0,
//     delegate: SliverChildBuilderDelegate(
//           (BuildContext context, int index) {
//         //创建列表项
//         return Container(
//           alignment: Alignment.center,
//           color: AppTheme.deepPlumPink.withOpacity(((index + 1) / itemCount)),
//           child: Text('list item $index'),
//         );
//       },
//       childCount: itemCount,
//     ),
//   );
// }
