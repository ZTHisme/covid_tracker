import 'dart:async';
import 'dart:convert';

import 'package:covid_tracker/ob/country_ob.dart';
import 'package:covid_tracker/ob/covid_summary_ob.dart';
import 'package:covid_tracker/ob/response_ob.dart';
import 'package:covid_tracker/utils/app_constants.dart';
import 'package:http/http.dart' as http;

class CountryBloc {
  StreamController<ResponseOb> _controller = StreamController<ResponseOb>();

  Stream<ResponseOb> getCountryStream() => _controller.stream;

  getCountryData() async {
    ResponseOb respOb = ResponseOb(msgState: MsgState.loading);
    _controller.sink.add(respOb);
    var response = await http.get(Uri.parse(COUNTRY_URL));
    if (response.statusCode == 200) {
      List<CountryOb> countryList = [];
      List<dynamic> list = json.decode(response.body);
      list.forEach((element) {
        countryList.add(CountryOb.fromJson(element));
      });
      respOb.data = countryList;
      respOb.msgState = MsgState.data;
      _controller.sink.add(respOb);
    } else if (response.statusCode == 404) {
      respOb.data = null;
      respOb.msgState = MsgState.error;
      respOb.errState = ErrState.notFoundErr;
      _controller.sink.add(respOb);
    } else if (response.statusCode == 500) {
      respOb.data = null;
      respOb.msgState = MsgState.error;
      respOb.errState = ErrState.serverErr;
      _controller.sink.add(respOb);
    } else {
      respOb.data = null;
      respOb.msgState = MsgState.error;
      respOb.errState = ErrState.unknownErr;
      _controller.sink.add(respOb);
    }
  }

  dispose() {
    _controller.close();
  }
}
