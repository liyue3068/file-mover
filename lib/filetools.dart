import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class FileTools {
  static bool _isGranted = false;
  static Directory root = Directory('/mnt/sdcard/');

  static Future<Stream<FileSystemEntity>> getFiles() async {
    var status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      final targetDirectory = Directory.fromUri(Uri.parse(
          'content://com.android.externalstorage.documents/document/primary%3ADCIM%2FCamera'));
      return targetDirectory.list();
    }
  }

  static Future<Directory> SelectFolder(BuildContext context) async {
    var __isGranted = await isGranted;
    if (!__isGranted) {
      throw Exception('权限不足');
    }
    return showDialog<Directory>(
      context: context,
      builder: (context) {
        return Text('23333');
      },
    );
  }

  static Future<bool> get isGranted async {
    if (!_isGranted) {
      var status = await Permission.storage.request();
      if (status == PermissionStatus.granted) {
        _isGranted = true;
      }
    }
    return Future.value(_isGranted);
  }
}
