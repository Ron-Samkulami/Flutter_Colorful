import 'package:flutter/material.dart';
import 'package:flutter_app/basic/app_theme.dart';
import 'package:flutter_app/ui_app/uiView/custom_tool/keep_alive_wrapper.dart';

class FirstPage extends StatefulWidget {
  // const FirstPage({Key? key}) :super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return TabViewRoute1();
  }
}

/// Page
///
class Page extends StatefulWidget {
  const Page({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  _PageState createState() => _PageState();
}

/// 混入AutomaticKeepAliveClientMixin  wantKeepAlive返回true缓存所有子元素，不销毁
/// 这部分逻辑封装为 KeepAliveWrapper
class _PageState extends State<Page> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context); //混入AutomaticKeepAliveClientMixin时，必须调用
    print("build ${widget.text}");
    return Center(child: Text("${widget.text}", textScaleFactor: 5));
  }

  @override
  bool get wantKeepAlive => true;
}


/// TabView
///
class TabViewRoute1 extends StatefulWidget {
  @override
  _TabViewRoute1State createState() => _TabViewRoute1State();
}

class _TabViewRoute1State extends State<TabViewRoute1>
    with SingleTickerProviderStateMixin {
  // late TabController _tabController;
  List tabs = ["新闻", "历史", "图片"];
  List<Widget> childPage = List<Widget>.generate(5, (index) => Page(text: '$index'));

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    //使用DefaultTabController 时，不需要指定 TabController
    return DefaultTabController(
        // initialIndex: 2,
        length: tabs.length,
        child: Column(
          children: [
            Container(
              color: AppTheme.lightPlumPink,
              child: TabBar(
                  // controller: _tabController,
                  tabs: tabs.map((e) => Tab(child: Text(e,style: TextStyle(
                    color: AppTheme.glacier,
                  ),),)).toList(),
                ),
            ),

            Expanded(child: TabBarView(
              //构建
              // controller: _tabController,
              children: [
                KeepAliveWrapper(
                  child: Container(
                    alignment: Alignment.center,
                    child: PageView (
                      // scrollDirection: Axis.vertical, // 滑动方向为垂直方向
                      children: childPage,
                      // allowImplicitScrolling: true, //true时缓存，但是只能缓存前后两个页面
                    ),
                  ),
                ),
                KeepAliveWrapper(
                  child: buildTwoSliverList(),
                ),
                buildTwoSliverList(),
              ],
            ))
          ],
        )
    );
  }

  @override
  void dispose() {
    // 释放资源
    // _tabController.dispose();
    super.dispose();
  }
}


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
    delegate: SliverChildBuilderDelegate((_, index) => ListTile(tileColor: AppTheme.glacier),
      childCount: 1,
    ),
  );

  var sliverListView = SliverList(
    delegate: SliverChildBuilderDelegate(
        (_, index)  => ListTile(tileColor: AppTheme.lightPlumPink,title: Text("$index"),),
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