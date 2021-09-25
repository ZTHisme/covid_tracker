import 'package:covid_tracker/ob/country_ob.dart';
import 'package:covid_tracker/ob/response_ob.dart';
import 'package:covid_tracker/pages/country_page/country_bloc.dart';
import 'package:flutter/material.dart';

class CountryPage extends StatefulWidget {
  const CountryPage({Key? key}) : super(key: key);

  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  CountryBloc _bloc = CountryBloc();

  var _searchTec = TextEditingController();

  List<CountryOb>? cList;
  List<CountryOb>? filterList;

  @override
  void initState() {
    // TODO: implement initState
    _bloc.getCountryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Country"),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: "Search Country"
            ),
            controller: _searchTec,
            onChanged: (str) {
              if (str.isEmpty) {
                filterList = [];
              } else {
                filterList = cList!.where((CountryOb co) {
                  return co.country!.toLowerCase().contains(str.toLowerCase());
                }).toList();
              }
              setState(() {});
            },
          ),
          Expanded(
            child: StreamBuilder<ResponseOb>(
              stream: _bloc.getCountryStream(),
              initialData: ResponseOb(msgState: MsgState.loading),
              builder:
                  (BuildContext context, AsyncSnapshot<ResponseOb> snapshot) {
                ResponseOb? respOb = snapshot.data;
                if (respOb!.msgState == MsgState.loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (respOb.msgState == MsgState.data) {
                  cList = respOb.data;
                  return mainWidget(cList!);
                } else {
                  if (respOb.errState == ErrState.notFoundErr) {
                    return Center(
                      child: Text("404 Not Found!!",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold)),
                    );
                  } else if (respOb.errState == ErrState.serverErr) {
                    return Center(
                      child: Text("500 Server Error!!",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold)),
                    );
                  } else {
                    return Center(
                      child: Text("Unknown Error!!",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold)),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget mainWidget(List<CountryOb> cList) {
    return ListView.builder(
        itemCount: _searchTec.text.isEmpty ? cList.length : filterList!.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.of(context).pop(_searchTec.text.isEmpty
                    ? cList[index].slug
                    : filterList![index].slug);
              },
              leading: Icon(
                Icons.flag,
                color: Colors.indigo,
              ),
              title: Text(_searchTec.text.isEmpty
                  ? cList[index].country!
                  : filterList![index].country!),
              trailing: Icon(Icons.chevron_right),
            ),
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.dispose();
    super.dispose();
  }
}
