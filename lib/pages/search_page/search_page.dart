import 'package:covid_tracker/ob/covid_country_ob.dart';
import 'package:covid_tracker/ob/response_ob.dart';
import 'package:covid_tracker/pages/country_page/country_page.dart';
import 'package:covid_tracker/pages/search_page/search_bloc.dart';
import 'package:covid_tracker/widgets/covid_country_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var _cityTex = TextEditingController();

  String dateRange = "Select Date Range";

  SearchBloc _bloc = SearchBloc();

  String? fromDate;
  String? toDate;

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Search Page"),
      ),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CountryPage();
                })).then((value) {
                  if (value != null) {
                    print(value);
                    _cityTex.text = value;
                  }
                });
              },
              child: TextFormField(
                controller: _cityTex,
                enabled: false,
                decoration: InputDecoration(
                    labelText: "Select City",
                    labelStyle: TextStyle(
                        color: Colors.indigo, fontWeight: FontWeight.bold)),
              ),
            ),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    primary: Colors.indigo,
                    side: BorderSide(color: Colors.indigo)),
                onPressed: () {
                  showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now())
                      .then((value) {
                    if (value != null) {
                      fromDate = value.start.toString();
                      toDate = value.end.toString();

                      String firstDate = value.start.toString().split(" ")[0];
                      String lastDate = value.end.toString().split(" ")[0];
                      setState(() {
                        dateRange = firstDate + " - " + lastDate;
                      });
                    }
                  });
                },
                child: Text(dateRange)),
            TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.white, backgroundColor: Colors.indigo),
                onPressed: () {
                  if (_cityTex.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("You need to select city",
                            style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.red));
                    return;
                  }
                  if (fromDate == null || toDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("You need to select from date and to date",
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.red,
                    ));
                    return;
                  }
                  _bloc.getSearchData(_cityTex.text, fromDate!, toDate!);
                },
                child: Text("Search")),
            Expanded(
                child: StreamBuilder<ResponseOb>(
              stream: _bloc.getSearchStream(),
              builder:
                  (BuildContext context, AsyncSnapshot<ResponseOb> snapshot) {
                if (snapshot.hasData) {
                  ResponseOb? respOb = snapshot.data;
                  if (respOb!.msgState == MsgState.loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (respOb.msgState == MsgState.data) {
                    List<CovidCountryOb> cList = respOb.data;
                    return mainWidget(cList);
                  } else {
                    if (respOb.errState == ErrState.notFoundErr) {
                      return Center(
                        child: Text("404 Not Found!!",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                      );
                    } else if (respOb.errState == ErrState.serverErr) {
                      return Center(
                        child: Text("500 Server Error!!",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                      );
                    } else {
                      return Center(
                        child: Text("Unknown Error!!",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                      );
                    }
                  }
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 50,
                        color: Colors.indigo,
                      ),
                      Text("You can search data with country and date")
                    ],
                  );
                }
              },
            ))
          ],
        ),
      ),
    );
  }

  Widget mainWidget(List<CovidCountryOb> ccList) {
    return ccList.length == 0
        ? Center(child: Text("Empty Data"))
        : ListView.builder(
            itemBuilder: (context, index) {
              return CovidCountryDate(ccList[index]);
            },
            itemCount: ccList.length);
  }
}
