import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'filetools.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage>
    with AutomaticKeepAliveClientMixin {
  _IndexPageState() {
    print('_IndexPageState 被实例化');
  }

  bool showStatistics = false;

  Stream<FileSystemEntity> _fileEntities;
  List<Uri> _fileUris;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: <Widget>[],
    );
  }

  onButtonPresed() async {
    _fileEntities = await FileTools.getFiles();
    final uris = _fileEntities.map((event) => event.uri);
    _fileUris = await uris.toList();
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}

class FolderStatusCard extends StatefulWidget {
  FolderStatusCard({Key key}) : super(key: key);

  @override
  _FolderStatusCardState createState() => _FolderStatusCardState();
}

class _FolderStatusCardState extends State<FolderStatusCard> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
