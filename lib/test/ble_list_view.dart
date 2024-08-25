import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BleListView extends StatefulWidget {
  const BleListView({super.key});

  @override
  State<BleListView> createState() => _BleListViewState();
}

class _BleListViewState extends State<BleListView> {
  static const platform = MethodChannel('ble_advertise_scanner');
  List<String> peripheralList = [];
  List<Map<String, dynamic>> advertisementData = [];

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler(_methodCallHandler);
  }

  Future<void> _methodCallHandler(MethodCall call) async {
    try {
      if (call.method == 'addPeripheral') {
        final dynamic arguments = call.arguments;
        if (arguments is Map) {
          final Map<String, dynamic> advertisementInfo = Map<String, dynamic>.from(arguments);
          setState(() {
            // 네이티브 코드에서 받은 주변 기기의 이름을 리스트에 추가합니다.
            peripheralList.add(advertisementInfo['uuid']);
            advertisementData.add(advertisementInfo);
          });
        } else {
          print('Unexpected data format: $arguments');
        }

      }
    } catch (e) {
      print('Failed to handle method call: $e');
    }
  }

  void _navigateToAdvertisementDataPage(Map<String, dynamic> advertisementInfo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdvertisementDataPage(advertisementInfo: advertisementInfo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
      ),
      body: ListView.builder(
        itemCount: peripheralList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(peripheralList[index]),
            trailing: ElevatedButton(
                onPressed: () => _navigateToAdvertisementDataPage(advertisementData[index]),
                child: Text('Advertisement Data'),
            ),
          );
        },
      ),
    );
  }
}

class AdvertisementDataPage extends StatelessWidget {
  final Map<String, dynamic> advertisementInfo;
  const AdvertisementDataPage({super.key, required this.advertisementInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advertisement Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: advertisementInfo.keys.map((key) {
              return ListTile(
                title: Text(key),
                subtitle: Text(advertisementInfo[key].toString()),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

