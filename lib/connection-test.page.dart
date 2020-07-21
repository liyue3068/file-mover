import 'dart:ffi';
import 'dart:io';

import 'package:file_mover/transmission/transmission.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConnectionTestPage extends StatefulWidget {
  @override
  _ConnectionTestPageState createState() => _ConnectionTestPageState();
}

class _ConnectionTestPageState extends State<ConnectionTestPage> {
  ConnectionTestPageViewModel _connectionTestPageViewModel;
  RawDatagramSocket _clientSide;
  TransmissionService _transmissionService;
  bool _findingServer = false;

  Future<void> sendMulticast(String clientIpStr) async {
    var idx = clientIpStr.indexOf('%');
    if (idx >= 0) {
      clientIpStr = clientIpStr.substring(0, idx);
    }

    final clientAddress = InternetAddress(clientIpStr);
    if (_clientSide == null ||
        _clientSide.address.address != clientAddress.address) {
      _clientSide = await RawDatagramSocket.bind(clientAddress, 10010);
      print('重新bind RawDatagramSocket');
    }
    var remoteAddress = clientAddress.rawAddress.length == 4
        ? InternetAddress('224.168.100.2')
        : InternetAddress('FF12::1');
    var sentLength =
        _clientSide.send('Hello!!'.codeUnits, remoteAddress, 10086);
    print('remote:${remoteAddress.address} :$sentLength');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      builder: (context, snapshot) {
        return StatefulBuilder(
          builder: (context, setState) {
            findServer() async {
              setState(() {
                _findingServer = true;
              });
              var msg = await _transmissionService.findServer(
                  _connectionTestPageViewModel.currentSelectedIpAddress);
              print('Message:$msg');
              setState(() {
                _findingServer = false;
              });
            }

            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
                  children: <Widget>[
                    Text('选择Interface'),
                    DropdownButton(
                      items:
                          _connectionTestPageViewModel.currentNetworkInterfaces
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text(e.name),
                                  value: e.index,
                                ),
                              )
                              .toList(),
                      onChanged: (int value) {
                        setState(() {
                          _connectionTestPageViewModel
                              .currentSelectedIndexOfNetworkInterface = value;
                        });
                      },
                      value: _connectionTestPageViewModel
                          ._currentSelectedIndexOfNetworkInterface,
                    ),
                    Text('选择IP'),
                    DropdownButton(
                      items: _connectionTestPageViewModel.currentIPAddressList
                          .map(
                            (e) => DropdownMenuItem(
                              child: Text(e.address),
                              value: e.address,
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _connectionTestPageViewModel
                              .currentSelectedIpAddress = value;
                        });
                      },
                      value:
                          _connectionTestPageViewModel.currentSelectedIpAddress,
                    ),
                    RaisedButton(
                      onPressed: _findingServer ? null : findServer,
                      child: Text('FindServer'),
                    ),
                  ],
                );
                break;
              default:
                return Center(
                  child: Text('Waiting'),
                );
            }
          },
        );
      },
      future: asyncInitState(),
    );
  }

  Future<void> asyncInitState() async {
    _connectionTestPageViewModel = ConnectionTestPageViewModel();
    _transmissionService = TransmissionService();
    return _connectionTestPageViewModel.init();
  }
}

class ConnectionTestPageViewModel {
  ConnectionTestPageViewModel();

  List<NetworkInterface> _currentNetworkInterfaces;
  List<NetworkInterface> get currentNetworkInterfaces =>
      _currentNetworkInterfaces;

  Future<void> init() async {
    _currentNetworkInterfaces = await NetworkInterface.list(
        includeLinkLocal: true, includeLoopback: true);
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
