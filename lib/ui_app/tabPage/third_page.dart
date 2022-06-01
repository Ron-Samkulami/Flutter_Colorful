import 'package:flutter/material.dart';

import '../uiView/customPaint/rs_signature.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({
    Key? key,
  }) : super(key: key);

  bool reloadData() {
    print('ThirdPage reloadData');
    return true;
  }

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Paint'),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "chess_game_Page"),
              child: Text('Chess Game')),
          ElevatedButton(onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Signature Pad'),
                  ),
                  body: Signature(),
                );
              })
            );
          }, child: Text('Signature Pad')),
        ],
      ),
    );
  }
}
