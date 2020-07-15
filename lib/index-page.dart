import 'dart:io';

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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: <Widget>[
        FlatButton(
          onPressed: () async {
            var currentState = StateNetworkInfo();
            await currentState.init();

            var a = await showDialog(
              context: context,
              child: StatefulBuilder(
                builder: (context, innerSetState) {
                  print('mark');
                  return SimpleDialog(
                    title: Text('选择服务器'),
                    children: <Widget>[
                      DropdownButton(
                        items: currentState.currentNetworkInterfaces
                            .map(
                              (e) => DropdownMenuItem(
                                child: Text(e.name),
                                value: e.index,
                              ),
                            )
                            .toList(),
                        onChanged: (int value) {
                          print('onChanged:' + value.toString());
                          innerSetState(() {
                            currentState
                                .currentSelectedIndexOfNetworkInterface = value;
                          });
                        },
                        value:
                            currentState.currentSelectedIndexOfNetworkInterface,
                        underline: SizedBox.shrink(),
                      ),
                      DropdownButton(
                        items: currentState.currentIPAddressList
                            .map(
                              (e) => DropdownMenuItem(
                                child: Text(e.address),
                                value: e.address,
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          currentState.currentSelectedIpAddress = value;
                        },
                        value: currentState.currentSelectedIpAddress,
                        underline: SizedBox.shrink(),
                      ),
                    ],
                  );
                },
              ),
            );
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

class StateNetworkInfo {
  List<NetworkInterface> _currentNetworkInterfaces;
  List<NetworkInterface> get currentNetworkInterfaces =>
      _currentNetworkInterfaces;

  Future<void> init() async {
    _currentNetworkInterfaces = await NetworkInterface.list();
    currentSelectedIndexOfNetworkInterface = _currentNetworkInterfaces[0].index;
  }

  String currentSelectedIpAddress;
  // String get currentSelectedIpAddress => _currentSelectedIpAddress;
  // set currentSelectedIpAddress(String value) {
  //   _currentSelectedIpAddress = value;
  // }

  List<InternetAddress> _currentIPAddressList;
  List<InternetAddress> get currentIPAddressList => _currentIPAddressList;
  set currentIPAddressList(List<InternetAddress> value) {
    _currentIPAddressList = value;
    currentSelectedIpAddress = currentIPAddressList[0].address;
  }

  int _currentSelectedIndexOfNetworkInterface;
  int get currentSelectedIndexOfNetworkInterface =>
      _currentSelectedIndexOfNetworkInterface;
  set currentSelectedIndexOfNetworkInterface(int value) {
    _currentSelectedIndexOfNetworkInterface = value;
    currentIPAddressList = _currentNetworkInterfaces
        .singleWhere((element) => element.index == value)
        .addresses;
  }
}
