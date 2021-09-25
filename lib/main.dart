import 'package:covid_tracker/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() {
  runApp(MaterialApp(home: HomePage()));
}

class SmartRefreshTest extends StatefulWidget {
  const SmartRefreshTest({Key? key}) : super(key: key);

  @override
  _SmartRefreshTestState createState() => _SmartRefreshTestState();
}

class _SmartRefreshTestState extends State<SmartRefreshTest> {
  RefreshController _controller = RefreshController();
  List<int> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Refresh"),
      ),
      body: SmartRefresher(
        header: WaterDropMaterialHeader(),
        controller: _controller,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: () {
          Future.delayed(Duration(seconds: 2), () {
            list.clear();
            setState(() {
              list.add(1);
            });
            _controller.refreshCompleted();
          });
        },
        onLoading: () {
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              list.add(1);
            });
            _controller.loadComplete();
          });
        },
        child: ListView(
          children: list.map((data) {
            return ListTile(
              title: Text(data.toString()),
            );
          }).toList(),
        ),
      ),
    );
  }
}
