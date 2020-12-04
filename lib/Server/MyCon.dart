import "dart:convert" as convert;

Future<List<MyCon>> fetchdata(String data) async {
  List<MyCon> datavalue = List<MyCon>();
  var myjson = convert.jsonDecode(data);

  for (var single in myjson) {
    datavalue.add(MyCon.fromJson(single));
  }
  return datavalue;
}

class MyCon {
  int tranID;
  String receiver;
  String amount;
  String sender;
  String date;

  MyCon(this.tranID, this.receiver, this.amount, this.date, this.sender);

  MyCon.fromJson(Map<String, dynamic> json) {
    tranID = json["TranID"] as int;
    receiver = json["Receiver"] as String;
    sender = json["Sender"] as String;
    amount = json["Amount"] as String;
    date = json["Date"] as String;
  }
}
