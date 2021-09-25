class ResponseOb{
  MsgState? msgState;
  ErrState? errState;
  dynamic data;
  ResponseOb({this.msgState, this.errState, this.data});

}

enum MsgState{
  data,
  error,
  loading,
  other,
}
enum ErrState{
  unknownErr,
  serverErr,
  notFoundErr,
}