import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:color_thief_dart/color_thief_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/basic/app_theme.dart';
import 'package:flutter_app/basic/rs_image_picker.dart';
import 'package:flutter_app/basic/rs_image_utils.dart';
import 'package:image_picker/image_picker.dart';

class ColorShowPage extends StatefulWidget {
  ColorShowPage({Key? key, required this.rsColor}) : super(key: key);

  final RSColor rsColor;

  @override
  _ColorShowPageState createState() => _ColorShowPageState();
}

class _ColorShowPageState extends State<ColorShowPage> {
  late Image _image;
  late String _imageColor;

  @override
  void initState() {
    _image =
        Image.asset('assets/introduction_animation/introduction_animation.png');
    _imageColor = '255-255-255';
    super.initState();
  }

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
        title: Text('Color Page'),
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
            Container(
              height: 300,
              alignment: Alignment.center,
              margin: EdgeInsets.all(20),
              child: _image,
            ),
            Text(
              "当前图片颜色 : $_imageColor",
            ),
            ElevatedButton(
              onPressed: () => showImagePicker(),
              child: Text("Pick Image"),
            ),
            ElevatedButton(
              onPressed: () {
                getImageColorString(_image);
              },
              child: Text("print color"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showImagePicker();
        },
        child: Center(
          child: Text("Add"),
        ),
      ),
    );
  }

  /// 选取图片弹窗
  showImagePicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => Container(
              height: 200,
              padding: EdgeInsets.all(8),
              color: AppTheme.nearlyWhite,
              child: RSImagePickerView(
                consumer: (XFile? selectedFile) {
                  if (selectedFile != null) {
                    setState(() {
                      _image = Image.file(File(selectedFile.path));
                    });
                  }
                },
              ),
            ));
  }



  /// 从图片解析颜色
  Future<String> getImageColorString(Image image) async {
    String _colorStr = "";
    ui.Image uiImage = await ImageUtils.loadImageByProvider(image.image);
    getColorFromImage(uiImage).then((color) {
      print('识别到颜色值- $color');
      if (color != null) {
        for(int i = 0; i < color.length; i++) {
          _colorStr = _colorStr + '${color[i]}-';
        }
        // print('颜色值：$_colorStr');
        setState(() {
          _imageColor = _colorStr;
        });
      }
    });
    return _colorStr;
  }

}
