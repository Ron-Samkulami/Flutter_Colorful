import 'package:flutter/material.dart';

import '../../../basic/app_theme.dart';


// 构建列表项
Widget buildSliverList(itemCount) {
  return SliverFixedExtentList(
    itemExtent: 50.0,
    delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
        //创建列表项
        return Container(
          alignment: Alignment.center,
          color: AppTheme.deepPlumPink.withOpacity(((index + 1) / itemCount)),
          child: Text('list item $index'),
        );
      },
      childCount: itemCount,
    ),
  );
}

/// ----------------------- buildTwoSliverList -------------------
Widget buildTwoSliverList() {
  // SliverFixedExtentList 是一个 Sliver，它可以生成高度相同的列表项。
  // 再次提醒，如果列表项高度相同，我们应该优先使用SliverFixedExtentList
  // 和 SliverPrototypeExtentList，如果不同，使用 SliverList.
  var fixedExtentlistView = SliverFixedExtentList(
    itemExtent: 56, //列表项高度固定
    delegate: SliverChildBuilderDelegate(
          (_, index) => ListTile(title: Text('$index')),
      childCount: 10,
    ),
  );

  var listViewDivider = SliverFixedExtentList(
    itemExtent: 2, //列表项高度固定
    delegate: SliverChildBuilderDelegate(
          (_, index) => ListTile(tileColor: AppTheme.glacier),
      childCount: 1,
    ),
  );

  var sliverListView = SliverList(
    delegate: SliverChildBuilderDelegate(
          (_, index) => ListTile(
        tileColor: AppTheme.lightPlumPink,
        title: Text("$index"),
      ),
      childCount: 10,
    ),
  );

  // 使用
  return CustomScrollView(
    slivers: [
      fixedExtentlistView,
      listViewDivider,
      sliverListView,
    ],
  );
}