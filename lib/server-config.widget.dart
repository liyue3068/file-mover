import 'dart:io';

import 'package:file_mover/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServerConfigWidget extends StatefulWidget {
  @override
  _ServerConfigWidgetState createState() => _ServerConfigWidgetState();
}

class _ServerConfigWidgetState extends State<ServerConfigWidget> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, innerSetState) {
        var currentState = Provider.of<StateNetworkInfo>(context);
        Widget result;
        if (currentState == null)
          result = Center(child: Text('Loading'));
        else
          result = SimpleDialog(
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
                    currentState.currentSelectedIndexOfNetworkInterface = value;
                  });
                },
                value: currentState.currentSelectedIndexOfNetworkInterface,
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
                  innerSetState(() {
                    currentState.currentSelectedIpAddress = value;
                  });
                },
                value: currentState.currentSelectedIpAddress,
                underline: SizedBox.shrink(),
              ),
              RaisedButton(
                child: Text('确定'),
                onPressed: () {
                  Navigator.of(context)
                      .pop(currentState.currentSelectedIpAddress);
                },
              ),
            ],
          );
        return result;
      },
    );
  }
}

class StateNetworkInfo {
  List<NetworkInterface> _currentNetworkInterfaces;
  List<NetworkInterface> get currentNetworkInterfaces =>
      _currentNetworkInterfaces;

  Future<StateNetworkInfo> init() async {
    _currentNetworkInterfaces =
        await NetworkInterface.list(includeLinkLocal: true);
    currentSelectedIndexOfNetworkInterface = _currentNetworkInterfaces[0].index;
    return this;
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
