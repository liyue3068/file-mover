import 'dart:io';

import 'dart:isolate';

class UdpClient {
  RawDatagramSocket _ipv4Client;
  RawDatagramSocket _ipv6Client;
  bool _inited = false;

  Future<void> init(String ipAddress) async {
    if (_inited) return;

    var idx = ipAddress.indexOf('%');
    if (idx >= 0) {
      ipAddress = ipAddress.substring(0, idx);
    }
    var ip = InternetAddress(ipAddress);
    if (ip.rawAddress.length == 4)
      _ipv4Client = await RawDatagramSocket.bind(ip, 0);
    else
      _ipv6Client =
          await RawDatagramSocket.bind(InternetAddress.anyIPv6, 0, ttl: 10);
    print('UdpCLient inited');
    _inited = true;
  }

  void findServer() {
    var sendedLength4 = _ipv4Client?.send(
        'Hello!!'.codeUnits, InternetAddress('224.168.100.2'), 10086);
    var sendedLength6 = _ipv6Client?.send(
        'Hello!!'.codeUnits, InternetAddress('FF12::1206'), 10086);
    print('sendedLength4:$sendedLength4,sendedLength6:$sendedLength6');
  }

  void StartTransmission() async {
    ReceivePort receivePort = ReceivePort();
    var workerIsolate = await Isolate.spawn<SendPort>(
        UdpClient.SendFolderFiles, receivePort.sendPort,
        debugName: "LLL_Isolate");
    // workerIsolate.ping(responsePort)
  }

  static void SendFolderFiles(SendPort sendPort) {
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    var subscription = receivePort.listen((message) {
      var urls = message as List<String>;
    });
  }
}
