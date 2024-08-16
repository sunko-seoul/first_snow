import 'package:first_snow/database/drift_test.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:first_snow/database/bt_communicate.dart';
import 'package:first_snow/database/drift_test.dart';
import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('callbackDispatcher started');
    switch (task) {
      case 'BTScanTask':
        final database = BTDatabase();
        final testDatabase = TestDatabase();
        testDatabase.createDriftTestWDuplicate(
          DriftTestCompanion(
            date: Value(DateTime.now()),
            data: Value('drift_test'),
          ),
        );
        FlutterBluePlus.scanResults.listen((results) {
          // print('result len: ${results.length}');
          results.forEach((r) {
            // print('remoteId: ${r.device.remoteId.str}');
            database.createBTCommunicate(
              BTCommunicateCompanion(
                data: Value(r.device.remoteId.str),
                date: Value(DateTime.now()),
              ),
            );
          });
        });
        for (int i = 0; i < 60; i++) {
          try {
            debugPrint('Executing BTScanTask $i');
            FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
          } catch (e) {
            debugPrint('Error while createing BTCommunicate');
          }
          await Future.delayed(Duration(seconds: 20));
        }
      default:
        print('Unknown task: $task');
    }
    return Future.value(true);
  });
}
