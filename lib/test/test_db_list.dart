import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:first_snow/database/drift_test.dart';

class TestDbList extends StatefulWidget {
  const TestDbList({super.key});

  @override
  State<TestDbList> createState() => _TestDbListState();
}

class _TestDbListState extends State<TestDbList> {
  List<DriftTestData>? _driftTestData;

  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  void initStateAsync() async {
    _driftTestData = await GetIt.I<TestDatabase>().getDriftTests();
  }

  Future onRefresh() async {
    _driftTestData = await GetIt.I<TestDatabase>().getDriftTests();
    if (mounted) {
      setState(() {});
    }
    return Future.delayed(Duration(milliseconds: 500));
  }

  List<Widget>? _buildDriftTestTiles() {
    return _driftTestData?.map((data) {
      return ListTile(
        title: Text('data : ${data.data}'),
        subtitle: Text('date: ${data.date.toIso8601String()}'),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        child: ListView(
          children: _buildDriftTestTiles() ?? [Text('No Data')],
        ),
        onRefresh: onRefresh,
      ),
    );
  }
}
