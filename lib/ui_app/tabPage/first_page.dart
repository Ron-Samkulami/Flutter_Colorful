import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_app/basic/app_theme.dart';
import 'package:flutter_app/ui_app/uiView/custom_tool/keep_alive_wrapper.dart';
import 'package:flutter_app/ui_app/uiView/custom_ui/com_buildSliverList.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);
  bool reloadData() {
    print('FirstPage reloadData');
    return true;
  }

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: TabViewRoute1(),
    );
  }
}

/// -------------- Page --------------
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

/// -------------- TabViewPage --------------
///
class TabViewRoute1 extends StatefulWidget {
  @override
  _TabViewRoute1State createState() => _TabViewRoute1State();
}

class _TabViewRoute1State extends State<TabViewRoute1>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    //使用DefaultTabController 时，不需要指定 TabController
    return DefaultFirstPage();
    // return NestedTabBarView1();
  }

  @override
  void dispose() {
    // 释放资源
    // _tabController.dispose();
    super.dispose();
  }
}

/// -------------- DefaultFirstPage --------------
class DefaultFirstPage extends StatefulWidget {
  @override
  _DefaultFirstPageState createState() => _DefaultFirstPageState();
}

class _DefaultFirstPageState extends State<DefaultFirstPage>
    with SingleTickerProviderStateMixin {
  final _toptabs = <String>["资讯", "娱乐"];
  late List _tabs;
  late List _firstTabs = <String>["新闻", "历史", "图片"];
  late List _secondTabs = <String>["电影", "音乐"];
  List<Widget> childPage =
      List<Widget>.generate(5, (index) => Page(text: '$index'));
  late Widget _tabBody;
  late Widget _firstTabBody;
  late Widget _secondTabBody;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _toptabs.length, vsync: this);
    _tabController.addListener(() {});

    //第一Tab
    _firstTabs = <String>["新闻", "历史", "图片"];
    _firstTabBody = TabBarView(
      //构建
      // controller: _tabController,
      children: [
        KeepAliveWrapper(
          child: Container(
            alignment: Alignment.center,
            child: PageView(
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
    );

    //第二Tab
    _secondTabs = <String>["电影", "音乐"];
    _secondTabBody = TabBarView(
      //构建
      // controller: _tabController,
      children: [
        KeepAliveWrapper(
          child: Container(
            alignment: Alignment.center,
            child: PageView(
              // scrollDirection: Axis.vertical, // 滑动方向为垂直方向
              children: childPage,
              // allowImplicitScrolling: true, //true时缓存，但是只能缓存前后两个页面
            ),
          ),
        ),
        KeepAliveWrapper(
          child: buildTwoSliverList(),
        ),
      ],
    );

    //默认显示第一Tab
    _tabs = _firstTabs;
    _tabBody = _firstTabBody;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        // initialIndex: 2,
        length: _tabs.length,
        child: Column(
          children: [
            Container(
              color: AppTheme.glacier[400],
              child: TabBar(
                controller: _tabController,
                onTap: (int index) {
                  setState(() {
                    _tabs = index == 0 ? _firstTabs : _secondTabs;
                    _tabBody = index == 0 ? _firstTabBody : _secondTabBody;
                  });
                },
                tabs: getTabBarTabs(_toptabs),
              ),
            ),
            Container(
              color: AppTheme.lightPlumPink,
              child: TabBar(
                tabs: getTabBarTabs(_tabs),
              ),
            ),
            Expanded(child: _tabBody)
          ],
        ));
  }
}

List<Widget> getTabBarTabs(List list) {
  return list
      .map((e) => Tab(
            child: Text(
              e,
              style: TextStyle(
                color: AppTheme.glacier,
              ),
            ),
          ))
      .toList();
}

/// ------ 嵌套 tabView ---------
class NestedTabBarView1 extends StatelessWidget {
  const NestedTabBarView1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _tabs = <String>['猜你喜欢', '今日特价', '发现更多'];
    // 构建 tabBar
    return DefaultTabController(
      length: _tabs.length, // This is the number of tabs.
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  title: const Text('商城'),
                  floating: true,
                  snap: true,
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: _tabs.map((String name) {
              return Builder(
                builder: (BuildContext context) {
                  return CustomScrollView(
                    key: PageStorageKey<String>(name),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(8.0),
                        sliver: buildSliverList(50),
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
