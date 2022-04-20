
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class LoadDataListRoute extends StatefulWidget {
  const LoadDataListRoute({Key? key, this.scrollController}) : super(key: key);

  final ScrollController? scrollController;
  @override
  _LoadDataListRouteState createState() => _LoadDataListRouteState();
}

class _LoadDataListRouteState extends State<LoadDataListRoute> {
  static const loadingTag = "##loading##"; //表尾标记
  var _words = <String>[loadingTag];

  /// 由于滑动监听中会短时间内频繁调用setState触发build方法，
  /// 而_retrieveData是有延时的异步操作，_words的数量更新不及时
  /// 这个参数用于防止短时间内触发多次_retrieveData，造成数据过多
  bool _isRoading = false;
  final globalKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    _retrieveData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.separated(
          controller: widget.scrollController,
          itemCount: _words.length,
          itemBuilder: (context, index) {
            //如果到了表尾
            if (_words[index] == loadingTag) {
              //不足100条，继续获取数据
              if (_words.length - 1 < 100) {
                if (!_isRoading) {
                  //获取数据
                  _retrieveData();
                }
                //加载时显示loading
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text("Loading Data"),
                      ),
                      SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                      )
                    ],
                  ),
                );
              } else {
                //已经加载了100条数据，不再获取数据。
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "No More Data!",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }
            }
            //显示单词列表项
            return ListTile(title: Text("$index--${_words[index]}"));
          },
          separatorBuilder: (context, index) => Divider(height: .0),
        ),
      ],
    );
  }

  void _retrieveData() {
    _isRoading = true;
    Future.delayed(Duration(milliseconds: 500)).then((e) {
      setState(() {
        _words.insertAll(_words.length-1, generateWordPairs().take(20).map((e) => e.asPascalCase).toList());
        _isRoading = false;
      });
    });
  }

// @override
// Widget build(BuildContext context) {
// return SingleChildScrollView(
//   reverse: true,
//   padding: EdgeInsets.only(top: 10),
//   child: Center(
//     child: Column(
//       children: str.split("")
//           .map((e) => Text(e, textScaleFactor: 2.0,))
//           .toList(),
//     ),
//   ),
// );
// }


}