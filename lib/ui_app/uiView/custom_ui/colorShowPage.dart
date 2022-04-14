import 'package:flutter/material.dart';
import 'package:flutter_app/basic/app_theme.dart';

class ColorShowPage extends StatefulWidget {
  ColorShowPage({Key? key, required this.rsColor}) : super(key: key);

  RSColor rsColor;

  @override
  _ColorShowPageState createState() => _ColorShowPageState();
}

class _ColorShowPageState extends State<ColorShowPage> {
  @override
  Widget build(BuildContext context) {
    var colorValueStr = ColorDescription.hexColorValue(widget.rsColor.color);
    var colorNameStr = widget.rsColor.colorName;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context, "A return result"),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: Text('Bolor Page'),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: ColoredBox(
                    color: widget.rsColor.color,
                  ),
                ),
              ),
              Text(
                "$colorNameStr : $colorValueStr",
                // textScaleFactor: 1.2,
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, "A return result"),
                child: Text("Backward"),
              )
            ],
          ),
        ));
  }
}
