import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:first_snow/database/bt_communicate.dart';

class BluetoothDbList extends StatefulWidget {
  const BluetoothDbList({super.key});

  @override
  State<BluetoothDbList> createState() => _BluetoothDbListState();
}

class _BluetoothDbListState extends State<BluetoothDbList> {
  List<BTCommunicateData>? _btCommunicateData;

  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  void initStateAsync() async {
    _btCommunicateData = await GetIt.I<BTDatabase>().getBTCommunicates();
  }

  Future onRefresh() async {
    _btCommunicateData = await GetIt.I<BTDatabase>().getBTCommunicates();
    if (mounted) {
      setState(() {});
    }
    return Future.delayed(Duration(milliseconds: 500));
  }

  List<Widget>? _buildBTCommunicateTiles() {
    return _btCommunicateData?.map((data) {
      return ListTile(
        title: Text('data : ${data.data}'),
        subtitle: Text('date: ${data.date.toIso8601String()}'),
      );
    }).toList();
  }

  void deleteDBonPressed() {
    GetIt.I<BTDatabase>().deleteAll();
    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: deleteDBonPressed,
              child: Text('delete DB'),
            ),
            if (_btCommunicateData?.length != 0) ListTile(
              title: Text('data : ${_btCommunicateData?.last.data}'),
              subtitle: Text(
                  'data : ${_btCommunicateData?.last.date.toIso8601String()}'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('BT num : ${_btCommunicateData?.length}'),
              ],
            ),
            ..._buildBTCommunicateTiles() ?? [Text('No Data')],
          ],
        ),
        onRefresh: onRefresh,
      ),
    );
  }
}
