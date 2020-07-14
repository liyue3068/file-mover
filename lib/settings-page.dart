import 'dart:io';

import 'package:file_mover/filetools.dart';
import 'package:file_mover/state/settings-state.dart';
import 'package:file_mover/tools.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // SettingsState settingsState;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SettingItem(
          '需要传输的文件所在路径',
          Consumer<SettingsState>(
            builder: (context, value, child) {
              int maxLengthToShow =
                  value.paths.length > 5 ? 5 : value.paths.length;
              return Column(
                children: <Widget>[
                  Column(
                    children: value.paths
                        .take(maxLengthToShow)
                        .map((e) => Text(e,
                            style: TextStyle(color: RandomColor.GlabalColor)))
                        .toList()
                          ..insert(maxLengthToShow, Text('...')),
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.stretch,
              );
            },
          ),
          Icons.folder_open,
          onTap: () async {
            await showDialog(
              context: context,
              builder: (context) => Consumer<SettingsState>(
                builder: (context, value, child) => SimpleDialog(
                  title: Text('管理路径'),
                  children: value.paths
                      .asMap()
                      .keys
                      .map((idx) => Row(
                            key: UniqueKey(),
                            children: <Widget>[
                              Expanded(child: Text(value.paths[idx])),
                              IconButton(
                                icon: Icon(Icons.remove_circle),
                                color: Colors.redAccent,
                                onPressed: () async {
                                  value.deletePath(idx);
                                  setState(() {});
                                },
                              ),
                            ],
                          ))
                      .toList()
                        ..add(
                          Row(
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () async {
                                  var addedPath = await FilesystemPicker.open(
                                    title: '请选择文件夹',
                                    context: context,
                                    rootDirectory: Directory('/mnt/sdcard/'),
                                    pickText: '确定',
                                    fsType: FilesystemType.folder,
                                  );
                                  value.addPath(addedPath);
                                },
                                child: Text('添加路径'),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class SettingItem extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData iconData;
  final void Function() onTap;

  SettingItem(this.title, this.child, this.iconData, {this.onTap, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Icon(
                  iconData,
                  size: 38,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 3, 0, 3)),
            child,
            Divider(),
          ],
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
        ),
      ),
      onTap: onTap,
    );
  }
}
