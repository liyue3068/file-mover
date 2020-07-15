import 'dart:io';

class Transmission {
  static Future<List<NetworkInterfaceListItem>>
      getNetworkInterfaceList() async {
    var interfaces = await NetworkInterface.list();
    return interfaces
        .map((e) => NetworkInterfaceListItem(e.index, e.name))
        .toList();
  }

  static void getIPAddress() {}
}

class NetworkInterfaceListItem {
  int index;
  String name;
  NetworkInterfaceListItem(this.index, this.name);
}
