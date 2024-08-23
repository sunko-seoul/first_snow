import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:first_snow/test/ble_list_view.dart';

class IOSBlueTooth extends StatelessWidget
{
  const IOSBlueTooth({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('IOS Bluetooth'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BleListView()),
                  );
                },
                child: const Text('Start Scanning'),
              ),
              ElevatedButton(
                onPressed: (){},
                child: const Text('Stop Bluetooth'),
              ),
            ],
          )
        ),
      ),
    );
  }
}
