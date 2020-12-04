import "dart:convert" as convert;

Future<List<RefConvert>> fetchdata(String data) async {
  List<RefConvert> datavalue = List<RefConvert>();
  var myjson = convert.jsonDecode(data);

  for (var single in myjson) {
    datavalue.add(RefConvert.fromJson(single));
  }
  return datavalue;
}

class RefConvert {
  String fullname;
  RefConvert(this.fullname);

  RefConvert.fromJson(Map<String, dynamic> json) {
    fullname = json["Fullname"] as String;
  }
}
