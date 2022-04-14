import 'package:flutter/material.dart';
import 'package:flutter_app/basic/app_theme.dart';

class RSCustomScrollView extends StatefulWidget {
  RSCustomScrollView({Key? key}) : super(key: key);

  @override
  _RSCustomScrollViewState createState() => _RSCustomScrollViewState();
}

class _RSCustomScrollViewState extends State<RSCustomScrollView> {
  @override
  Widget build(BuildContext context) {
    var itemCount = 10;
    return Material(
      child: CustomScrollView(
        slivers: <Widget>[

          // AppBar，包含一个导航栏.
          SliverAppBar(
            // pinned: true, // 滑动到顶端时会固定住
            // floating: true,// pinned为true时生效，当floating为true时，下拉马上就出现appBar

            expandedHeight: 250.0,
            title: Text("title"),
            backgroundColor: AppTheme.glacierBlue,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('FlexibleSpaceBar'),
              // background: Image.asset(
              //   "./imgs/sea.png",
              //   fit: BoxFit.cover,
              // ),
              background: ColoredBox(color: AppTheme.lightPlumPink,),
            ),

            bottom: PreferredSize(
              preferredSize: Size(300, 40),
              child: Text("bottom"),
            ),
          ),

          ///  SliverToBoxAdapter可以将renderBox适配为Sliver
          SliverToBoxAdapter(
            child: SizedBox(
              height: 300,
              child: PageView(
                children: [
                  Container(
                    child: ColoredBox(color: AppTheme.creamYellow, child: Center(child: Text("1"),),),
                  ),
                  Container(
                    child: ColoredBox(color: AppTheme.creamGreen1, child: Center(child: Text("2"),),),
                  )
                ],
              ),
            ),
          ),
          
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverGrid(
              //Grid
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, //Grid按两列显示
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 4.0,
              ),
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  //创建子widget
                  return Container(
                    alignment: Alignment.center,
                    // color: Colors.cyan[100 * (index % 9)],
                    color: AppTheme.glacier.withOpacity(((index+1) / itemCount)),
                    child: Text('grid item $index'),
                  );
                },
                childCount: itemCount,
              ),
            ),
          ),

          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                //创建列表项
                return Container(
                  alignment: Alignment.center,
                  color: AppTheme.deepPlumPink.withOpacity(((index+1) / itemCount)),
                  child: Text('list item $index'),
                );
              },
              childCount: itemCount,
            ),
          ),
        ],
      ),
    );
  }
}
