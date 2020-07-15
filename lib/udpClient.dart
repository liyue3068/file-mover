import 'dart:html';

import 'dart:io';

import 'dart:isolate';

class UdpClient {
  RawDatagramSocket _ipv4Client;
  RawDatagramSocket _ipv6Client;
  bool _isInitialized = false;

  void FindServer() {}

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
