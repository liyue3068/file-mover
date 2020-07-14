import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        FlatButton(
          onPressed: onButtonClick,
          child: Text('2333'),
        )
      ]),
    );
  }

  RawDatagramSocket client;
  RawDatagramSocket ipv4Client;

  void onButtonClick() async {

    print('clicked!');

    if (client == null) {
      var networkInterfaces = await NetworkInterface.list(
          includeLoopback: false, type: InternetAddressType.IPv6);

      for (var item in networkInterfaces) {
        print(item.toString());
      }

      // var ips = await NetworkInterface.list(includeLoopback: false, type: InternetAddressType.IPv4);
      // client = await RawDatagramSocket.bind(
      //     InternetAddress.fromRawAddress(
      //         Uri.parseIPv6Address("2408:8210:3c12:7f90:9687:e0ff:fe2e:c992")),
      //     0);
      client = await RawDatagramSocket.bind(
          InternetAddress.fromRawAddress(
              Uri.parseIPv6Address('2408:8210:3c12:7f90:45cf:148:8bdc:fbb1')),
          0);
    }
    if (ipv4Client == null) {
      ipv4Client = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      // ipv4Client.broadcastEnabled = true;
    }

    var data = utf8.encode('Hello!!!');
    // var serverAddress = InternetAddress.fromRawAddress(
    //     Uri.parseIPv6Address("2408:8210:3c12:7f90:45cf:148:8bdc:fbb1"));
    var serverAddress = InternetAddress.fromRawAddress(
        Uri.parseIPv6Address("FF13::2:1"),
        type: InternetAddressType.IPv6);

    var ipv4SendedLength = ipv4Client.send(
        data,
        InternetAddress.fromRawAddress(Uri.parseIPv4Address("224.168.100.2")),
        10086);
    var sendLength = client.send(data, serverAddress, 10086);

    print(
        "ipv6_sendedLength:$sendLength\r\nipv4_SendedLength:$ipv4SendedLength");
  }
}
