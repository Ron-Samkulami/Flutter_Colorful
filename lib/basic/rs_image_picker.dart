import 'package:flutter/material.dart';
import 'package:flutter_app/basic/app_theme.dart';
import 'package:image_picker/image_picker.dart';

typedef RSImagePickerResultConsumer = Function(
  XFile? selectedFile,
);

class RSImagePickerView extends StatefulWidget {
  RSImagePickerView({Key? key, required this.consumer}) : super(key: key);

  //传入一个使用图片的方法
  final RSImagePickerResultConsumer consumer;

  @override
  _RSImagePickerViewState createState() => _RSImagePickerViewState();
}

class _RSImagePickerViewState extends State<RSImagePickerView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text("选择照片",
              textScaleFactor: 1.1,
              style: TextStyle(color: AppTheme.grey.withOpacity(0.7))),
        ),
        selectItem(false, "从相册选择"),
        selectItem(true, "拍照"),
        Center(
          child: GestureDetector(
            child: Text(
              "取消",
              textScaleFactor: 1.1,
              style: TextStyle(color: AppTheme.grayGreen),
            ),
            onTap: () => Navigator.pop(context),
          ),
        )
      ],
    );
  }

  //创建弹窗列表选项
  Widget selectItem(bool openCamera, String name) {
    return ListTile(
      leading: Icon(openCamera ? Icons.camera : Icons.image),
      title: Text(name),
      onTap: () => openPicker(openCamera),
    );
  }

  openPicker(bool openCamera) async {
    Navigator.pop(context);
    var picker = ImagePicker();
    XFile? image = await picker.pickImage(
        source: openCamera ? ImageSource.camera : ImageSource.gallery);
    widget.consumer(image);
  }
}
