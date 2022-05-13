import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:color_thief_dart/color_thief_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/basic/app_theme.dart';
import 'package:flutter_app/rs_widgets/rs_image_picker.dart';
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
              padding: EdgeInsets.all(8),
              child: SizedBox(
                width: 150,
                height: 30,
                child: ColoredBox(
                  color: widget.rsColor.color,
                ),
              ),
            ),
            Text(
              "$colorNameStr : $colorValueStr",
            ),

            /// 图片框
            Container(
              height: 250,
              alignment: Alignment.center,
              margin: EdgeInsets.all(20),
              child: _image,
            ),


            /// 提色器
            Container(
              height: 50,
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.none,
                child: FutureBuilder<List<int>?>(
                  // initialData: ,
                  future: getImageColorString(_image),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (snapshot.hasData){
                        String _imageColor = "";
                        List<int> colorList = snapshot.data;
                        colorList.forEach((element) { _imageColor += '$element-';});
                        colorList.forEach(print);

                        return Column(
                          children: [
                            SizedBox(
                              width: 80,
                              height: 35,
                              child: ColoredBox(
                                color: Color.fromARGB(255, colorList[0],
                                    colorList[1], colorList[2]),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                  "当前颜色：${_imageColor.substring(0, _imageColor.length - 1)}"),
                            )
                          ],
                        );
                      } else {
                        return Text("空白图片");
                      }
                    } else {
                      return CircularProgressIndicator();
                      return Text("正在加载颜色");
                    }
                  },
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () => showImagePicker(),
                    child: Text("Pick Image"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: Text("print color"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showImagePicker();
      //   },
      //   child: Center(
      //     child: Text("Add"),
      //   ),
      // ),
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

@pragma('get')
  /// 从图片解析颜色
/// Future<List<int>?> 返回类型可以省略?
Future<List<int>?> getImageColorString(Image image) async {
    ui.Image uiImage = await ImageUtils.loadImageByProvider(image.image);
    return getColorFromImage(uiImage);
  }
}
