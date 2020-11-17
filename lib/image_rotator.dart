import 'dart:async';

import 'package:flutter/services.dart';

enum ImageFormat { jpeg, png }

class ImageRotator {
  static const MethodChannel _channel = const MethodChannel('io.siteplan.image_rotator');

  static Future<void> rotate(String imagePath, String targetPath, double angle, {ImageFormat format = ImageFormat.png}) async {
    await _channel.invokeMethod('rotate',{
			'imagePath': imagePath,
			'targetPath': targetPath,
			'angle': angle,
			'format': format.index,
		});
  }
}
