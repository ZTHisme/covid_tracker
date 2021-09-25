import 'dart:async';
import 'dart:convert';

import 'package:covid_tracker/ob/covid_country_ob.dart';
import 'package:covid_tracker/ob/response_ob.dart';
import 'package:covid_tracker/utils/app_constants.dart';
import 'package:http/http.dart' as http;

class SearchBloc {
  StreamController<ResponseOb> _controller = StreamController();

  Stream<ResponseOb> getSearchStream() => _controller.stream;

  getSearchData(String country, String from, String to) async {
    ResponseOb respOb = ResponseOb(msgState: MsgState.loading);
    _controller.sink.add(respOb);
    var response = await http
        .get(Uri.parse(SEARCH_BASE_URL + "$country?from=$from&to=$to"));
    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      List<CovidCountryOb> ccList = [];
      list.forEach((element) {
        ccList.add(CovidCountryOb.fromJson(element));
      });
      respOb.data = ccList;
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
