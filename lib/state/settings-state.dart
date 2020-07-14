import 'dart:convert';
import 'dart:io';
import 'package:file_mover/models/global-settings.dart';

import 'package:file_mover/filetools.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class SettingsState extends ChangeNotifier {
  /**
   * 路径
   */
  List<String> paths = [];
  File _settingsFile;
  GlobalSettings _globalSettings;

  void Load() async {
    if (await FileTools.isGranted) {
      var folder = await getApplicationSupportDirectory();
      var settingsFilePath = folder.path + 'settings.json';
      _settingsFile = File(settingsFilePath);

      if (!await _settingsFile.exists()) {
        await _settingsFile.create();
        _globalSettings = GlobalSettings(paths = List<String>());
        var temp_json = jsonEncode(_globalSettings.toJson());
        await _settingsFile.writeAsString(temp_json, mode: FileMode.write);
      } else {
        var jsonStr = await _settingsFile.readAsString();
        var jsonObj = json.decode(jsonStr);
        _globalSettings = GlobalSettings.fromJson(jsonObj);
        this.paths = _globalSettings.paths;
      }
    }
    this.notifyListeners();
  }

  Future<void> addPath(String path) async {
    this._globalSettings.paths.add(path);
    await this.savePath();
    this.notifyListeners();
  }

  Future<void> deletePath(int index) async {
    this._globalSettings.paths.removeAt(index);
    await this.savePath();
    this.notifyListeners();
  }

  Future<void> savePath() async {
    var jsonObj = this._globalSettings.toJson();
    var jsonStr = jsonEncode(jsonObj);
    await this._settingsFile.writeAsString(jsonStr);
  }
}
