import 'dart:async';
import 'dart:convert';
import 'dart:io';

class TransmissionService {
  static const int _packageSize = 1472;
  RawDatagramSocket _udpServer;
  RawDatagramSocket _udpClient;
  InternetAddress _clientIPAddress;

  TransmissionService() {}

  Future<void> init({String clientIP}) async {
    _clientIPAddress =
        clientIP == null ? InternetAddress.anyIPv4 : InternetAddress(clientIP);
    _udpClient = await RawDatagramSocket.bind(_clientIPAddress, 0);
  }

  Future<String> findServer(String clientIP, {int port = 0}) async {
    var udpClient =
        await RawDatagramSocket.bind(InternetAddress(clientIP), port);
    udpClient.send('Hello'.codeUnits, InternetAddress('224.168.100.2'), 10086);
    bool isResponsed = false;

    var completer = Completer<String>();

    var subscription = udpClient.listen((event) {
      if (event == RawSocketEvent.read) {
        var response = udpClient.receive();
        var msg = utf8.decode(response.data);
        completer.complete(msg);
        isResponsed = true;
        udpClient.close();
      }
    });

    Future.delayed(Duration(seconds: 5), () async {
      if (!isResponsed) {
        await subscription.cancel();
        completer.complete('timeout');
      }
    });

    return completer.future;
  }
}

class NetworkInterfaceListItem {
  int index;
  String name;
  NetworkInterfaceListItem(this.index, this.name);
}
