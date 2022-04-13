import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_app/ui_app/uiView/listView/animatedList.dart';
import 'package:flutter_app/ui_app/uiView/listView/load_data_list.dart';

class InfiniteListView extends StatefulWidget {
  @override
  _InfiniteListViewState createState() => _InfiniteListViewState();
}

class _InfiniteListViewState extends State<InfiniteListView> {
  double currentOffset = 0.0;
  double topBarOpacity = 1.0;
  double showTopTopBtnOffset = 100.0;
  bool showToTopBtn = false;
  final ScrollController _scrollController = ScrollController();
  String _progress = "0%"; //滑动百分比进度

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      // print(_scrollController.offset - currentOffset);
      // print(_scrollController.positions.elementAt(0).pixels); //ScrollPosition是真正保存元素滚动位置的
      //是否显示导航栏
      if (_scrollController.offset > currentOffset) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      } else {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      }

      if (_scrollController.offset >= 0) {
        currentOffset = _scrollController.offset;
      }

      //显示回到顶部按钮
      if (currentOffset < showTopTopBtnOffset && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (currentOffset >= showTopTopBtnOffset &&
          showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    return Scaffold(
      appBar: AppBar(
        title: Text("InfiniteList"),
        toolbarOpacity: topBarOpacity,
        bottomOpacity: topBarOpacity,
        toolbarHeight: topBarOpacity == 0 ? 0.0 : 56,
      ),

      // body: AnimatedListRoute(),

      // body: LoadDataListRoute(scrollController: _scrollController,),
      body: Scrollbar(
        // thickness: 3,
        // isAlwaysShown: true,
        controller: _scrollController,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            //显示进度
            double progress = notification.metrics.pixels /
                notification.metrics.maxScrollExtent;
            if (notification.metrics.atEdge == false) {
              setState(() {
                //进度最小为0%，最大为100%
                _progress = "${min(max((progress * 100).toInt(), 0), 100)}%";
              });
            }
            return false; //true会使得ScrollBar失效
          },
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              LoadDataListRoute(
                scrollController: _scrollController,
              ),
              Positioned(
                bottom: 20,
                child: CircleAvatar(
                  radius: 30.0,
                  child: Text(_progress),
                  backgroundColor: Colors.black54,
                ),
              )
            ],
          ),
        ),
      ),

      floatingActionButton: !showToTopBtn
          ? null
          : FloatingActionButton(
              child: Icon(Icons.arrow_upward),
              onPressed: () {
                //返回到顶部时执行动画
                _scrollController.animateTo(
                  .0,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.ease,
                );
              }),
    );
  }
}
