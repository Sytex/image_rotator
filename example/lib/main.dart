import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:image_rotator/image_rotator.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
	var _rotatedImagePath = '';

  @override
  void initState() {
    super.initState();
  }

	Future<bool> _requestPermissions() async {
		if(Platform.isIOS) return true;
		final permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
		return permissions[PermissionGroup.storage] == PermissionStatus.granted;
	}

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> rotate(double angle) async {
    var hasPermissions = await _requestPermissions();

		if(!hasPermissions) return;
		
		var directory;
		if(Platform.isAndroid) {
			directory = await getExternalStorageDirectory();
		} else {
			directory = await getApplicationDocumentsDirectory();
		}

		var dirPath = '${directory.path}/IMAGE_ROTATOR';
    String rotatedImagePath = '$dirPath/demo.jpg';
		await Directory(dirPath).create(recursive: true);

		try {
			var image = await ImagePicker.pickImage(source: ImageSource.gallery);
			await ImageRotator.rotate(image.path, rotatedImagePath, angle, format: ImageFormat.jpeg);
			_rotatedImagePath = rotatedImagePath;
    } catch(error) {
      rotatedImagePath = 'Failed to rotate image.';
    }

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Stack(
					children: <Widget>[
						Center(
							child: Row(
								mainAxisAlignment: MainAxisAlignment.center,
								children: <Widget>[
									RaisedButton(
										child: Text('-90'),
										onPressed: () {
											rotate(-90);
										},
									),
									RaisedButton(
										child: Text('90'),
										onPressed: () {
											rotate(90);
										},
									),
								],
							),
						),
						_rotatedImagePath.isNotEmpty
						? Container(
							color: Colors.black,
							height: 200,
							width: double.infinity,
							child: Image.file(
								File(_rotatedImagePath),
								/* fit: BoxFit.cover , */
							),
						) : Container(),
					],
				)
      ),
    );
  }
}
