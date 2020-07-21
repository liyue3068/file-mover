import 'dart:io';

import 'package:file_mover/server-config.widget.dart';
import 'package:file_mover/udpClient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

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
  UdpClient udpClient = UdpClient();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: <Widget>[
        FlatButton(
          onPressed: () async {
            var currentState = StateNetworkInfo();
            await currentState.init();
            if (currentState == null) return;
            // currentState.init();
            var a = await showDialog(
              context: context,
              child: ServerConfigWidget(),
            );
            if (a != null) {
              await udpClient.init(a);
              udpClient.findServer();
            }
          },
          child: Text('连接服务器'),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: TransmissionStatusItem('/esdfsdf/sdfasdf', 12, 32),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: TransmissionStatusItem(
            '/esdfsdf/sdfasdf',
            12,
            32,
            started: true,
            progress: 0.6,
            transmitedCount: 25,
          ),
        ),
      ],
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

class TransmissionStatusList extends StatefulWidget {
  @override
  _TransmissionStatusListState createState() => _TransmissionStatusListState();
}

class _TransmissionStatusListState extends State<TransmissionStatusList> {
  List<TransmissionStatus> status;

  @override
  Widget build(BuildContext context) {}
}

class TransmissionStatusItem extends StatelessWidget {
  final String path;
  final int filesCount;
  final double totalSize;

  final bool started;
  final double progress;
  final double transmitedCount;

  TransmissionStatusItem(this.path, this.filesCount, this.totalSize,
      {this.started = false, this.progress, this.transmitedCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Text('路径:' + path),
              Text('文件数量:' + filesCount.toString()),
              Text('总大小:' + totalSize.toString()),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          flex: 1,
        ),
        Container(
          width: 100,
          height: 70,
          child: this.started
              ? Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      child: Text('已传输:' + transmitedCount.toString()),
                    ),
                    Positioned(
                      top: 24,
                      child: CircularProgressIndicator(
                        value: this.progress,
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink(),
        ),
      ],
    );
  }
}

class TransmissionStatus extends ChangeNotifier {
  String _filePath;
  String get filePath => _filePath;
  set filePath(String value) {
    _filePath = value;
    this.notifyListeners();
  }

  int _filesCount;
  int get filesCount => _filesCount;
  set filesCount(int value) {
    _filesCount = value;
    this.notifyListeners();
  }

  double _totalSize;
  double get totalSize => _totalSize;
  set totalSize(double value) {
    _totalSize = value;
    this.notifyListeners();
  }
}
