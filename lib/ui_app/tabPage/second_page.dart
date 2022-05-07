
import 'package:flutter/material.dart';
import 'package:flutter_app/ui_app/uiView/custom_ui/ui_Unit.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key,}) :super(key: key);

  bool reloadData(){
    print('SecondPage reloadData');
    return true;
  }

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UI'),
      ),
      body: UiUnitRoute(),
    );
  }
}
