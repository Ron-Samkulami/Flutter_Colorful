import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui' as ui;

/// 学知乎大佬思路，
/// 模仿NetworkImage制作一个自定义ImageProvider
class LoadImage extends ImageProvider<LoadImage> {
  const LoadImage(this.image, {this.scale = 1.0});

  final ui.Image image;
  final double scale;

  @override
  ImageStreamCompleter load(LoadImage key, decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key),
      scale: key.scale,
    );
  }

  Future<ui.Codec> _loadAsync(LoadImage key) async {
    assert(key == this);
    //image转ByteData
    final a = await image.toByteData(format: ui.ImageByteFormat.png);
    var codec = await PaintingBinding.instance!
        .instantiateImageCodec(a!.buffer.asUint8List());
    return codec;
  }

  @override
  Future<LoadImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<LoadImage>(this);
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final LoadImage typedOther = other;
    return image == typedOther.image && scale == typedOther.scale;
  }

  @override
  int get hashCode => hashValues(image.hashCode, scale);

  @override
  String toString() =>
      '$runtimeType(${describeIdentity(image)}, scale: $scale)';
}

/// ----- ImageProvider 转 ui.Image
class ImageUtils {
  static Future<ui.Image> loadImageByProvider(
    ImageProvider provider, {
    ImageConfiguration config = ImageConfiguration.empty,
  }) async {
    Completer<ui.Image> completer = Completer<ui.Image>(); //完成的回调
    ImageStreamListener listener;
    ImageStream stream = provider.resolve(config); //获取图片流

    listener = ImageStreamListener((ImageInfo frame, bool sync) {
      final ui.Image image = frame.image;
      completer.complete(image); //完成
      // stream.removeListener(listener); //移除监听
    });
    stream.addListener(listener); //添加监听
    return completer.future; //返回
  }
}

// //实际使用 ImageProvider转ui.Image
// ui.Image image = await ImageUtils.loadImageByProvider(
// CachedNetworkImageProvider(imgUrl));
