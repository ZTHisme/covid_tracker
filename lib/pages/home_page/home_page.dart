import 'package:covid_tracker/ob/covid_summary_ob.dart';
import 'package:covid_tracker/ob/response_ob.dart';
import 'package:covid_tracker/pages/home_page/home_bloc.dart';
import 'package:covid_tracker/pages/search_page/search_page.dart';
import 'package:covid_tracker/widgets/covid_country_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _bloc = HomeBloc();
  var numberFormat = NumberFormat(",###");

  RefreshController _controller = RefreshController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.getCovidSummaryData();
    _bloc.getCovidSummaryStream().listen((ResponseOb respOb) {
      if(respOb.msgState == MsgState.data){
        _controller.refreshCompleted();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Text("Covid 19"),
          backgroundColor: Colors.indigo,
          actions: [
            IconButton(onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => SearchPage()));
            }, icon: Icon(Icons.search))
          ],
        ),
        body: StreamBuilder<ResponseOb>(
          initialData: ResponseOb(msgState: MsgState.loading),
          builder: (BuildContext context, AsyncSnapshot<ResponseOb> snapshot) {
            ResponseOb? respOb = snapshot.data;
            if (respOb!.msgState == MsgState.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (respOb.msgState == MsgState.data) {
              CovidSummaryOb cob = respOb.data;
              return mainWidget(cob);
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
          stream: _bloc.getCovidSummaryStream(),
        ));
  }

  Widget mainWidget(CovidSummaryOb cob) {
    return Column(
      children: [
        //Summary
        Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text("Updated Date : " + DateFormat("EEEE, MMMM dd, yyyy, HH:MM").format(DateTime.parse(cob.date!)),
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue)),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total\nConfirmed",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          SizedBox(height: 10),
                          Text(numberFormat.format(cob.global!.totalConfirmed),
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          SizedBox(height: 5),
                          RichText(
                              text: TextSpan(
                                  text: "New : ",
                                  style: TextStyle(color: Colors.black54),
                                  children: [
                                TextSpan(
                                    text: "+ "+numberFormat.format(cob.global!.newConfirmed),
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold))
                              ]))
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total\nDeath",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          SizedBox(height: 10),
                          Text(numberFormat.format(cob.global!.totalDeaths),
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          SizedBox(height: 5),
                          RichText(
                              text: TextSpan(
                                  text: "New : ",
                                  style: TextStyle(color: Colors.black54),
                                  children: [
                                TextSpan(
                                    text: "+ "+numberFormat.format(cob.global!.newDeaths),
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold))
                              ]))
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total\nRecovered",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          SizedBox(height: 10),
                          Text(numberFormat.format(cob.global!.totalRecovered),
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          SizedBox(height: 5),
                          RichText(
                              text: TextSpan(
                                  text: "New : ",
                                  style: TextStyle(color: Colors.black54),
                                  children: [
                                TextSpan(
                                    text: "+ "+numberFormat.format(cob.global!.newRecovered),
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold))
                              ]))
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        Text("Countries", style: TextStyle(color: Colors.indigo, fontSize: 20, fontWeight: FontWeight.bold)),
        Expanded(
          child: SmartRefresher(
            header: ClassicHeader(),
            controller: _controller,
            enablePullDown: true,
            onRefresh: (){
              _bloc.getCovidSummaryData();
            },
            child: ListView.builder(
                itemCount: cob.countries!.length,
                itemBuilder: (context,index){
                  return CovidCountryWidget(cob.countries![index]);
            }),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.dispose();
    super.dispose();
  }
}
