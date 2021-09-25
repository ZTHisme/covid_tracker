import 'dart:async';
import 'dart:convert';

import 'package:covid_tracker/ob/covid_summary_ob.dart';
import 'package:covid_tracker/ob/response_ob.dart';
import 'package:covid_tracker/utils/app_constants.dart';
import 'package:http/http.dart' as http;

class HomeBloc {
  StreamController<ResponseOb> _controller = StreamController.broadcast();

  Stream<ResponseOb> getCovidSummaryStream() => _controller.stream;

  getCovidSummaryData() async {
    ResponseOb respOb = ResponseOb(msgState: MsgState.loading);
    // _controller.sink.add(respOb);
    var response = await http.get(Uri.parse(SUMMARY_URL));
    if (response.statusCode == 200) {
      CovidSummaryOb cob = CovidSummaryOb.fromJson(json.decode(response.body));
      respOb.data = cob;
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
