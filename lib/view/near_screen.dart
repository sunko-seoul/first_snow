import 'dart:async';

import 'package:first_snow/provider/user_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:first_snow/provider/card_select_provider.dart';
import 'package:first_snow/component/user_card.dart';
import 'package:first_snow/component/scan_result_tile.dart';

class NearScreen extends StatefulWidget {
  NearScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<NearScreen> createState() => _NearScreenState();
}

class _NearScreenState extends State<NearScreen> {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateSubscription;

  @override
  initState() {
    super.initState();
    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _adapterStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _adapterState == BluetoothAdapterState.on
        ? ScanScreen()
        : Consumer2<CardSelectProvider, UserListProvider>(
            builder: (context, cardSelectProvider, userProvider, child) {
            void _onTap(int index) {
              cardSelectProvider.updateIndex(index);
            }

            return GestureDetector(
              onTap: () => _onTap(-1),
              child: CustomScrollView(slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(10),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return UserCardFlip(
                          userId: userProvider.nearUser.toList()[index],
                          selectedIndex: cardSelectProvider.selectedIndex,
                          pageName: PageName.near,
                          acceptStr: '첫눈 보내기',
                          denyStr: '삭제하기',
                          onTap: _onTap,
                        );
                      },
                      childCount: userProvider.nearUser.length,
                    ),
                  ),
                ),
              ]),
            );
          });
  }
}

class ScanScreen extends StatefulWidget {
  const ScanScreen({
    Key? key,
  });
  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  List<ScanResult> _scanResults = [];
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  bool _isScanning = false;
  late StreamSubscription<bool> _isScanningSubscription;

  @override
  void initState() {
    super.initState();

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      if (mounted) {
        setState(() {});
      }
    }, onError: (e) {
      print('Bluetooth scanning Error!');
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((result) {
      _isScanning = result;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  Future onRefresh() {
    if (_isScanning == false) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    }
    if (mounted) {
      setState(() {});
    }
    return Future.delayed(Duration(milliseconds: 500));
  }

  List<Widget> _buildScanResultTiles(BuildContext context) {
    return _scanResults
        .map(
          (r) => ScanResultTile(
            result: r,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          children: [
            ..._buildScanResultTiles(context),
          ],
        ),
      ),
    );
  }
}
