import "dart:convert" as convert;

Future<List<MyConvert>> fetchdata(String data) async {
  List<MyConvert> datavalue = List<MyConvert>();
  var myjson = convert.jsonDecode(data);

  for (var single in myjson) {
    datavalue.add(MyConvert.fromJson(single));
  }
  return datavalue;
}

class MyConvert {
  int subID;
  String subType;
  String ammount;
  int days;
  String startDate;
  String endDate;
  String status;
  MyConvert(this.subID, this.subType, this.ammount, this.days, this.startDate,
      this.endDate, this.status);

  MyConvert.fromJson(Map<String, dynamic> json) {
    subID = json["SubID"] as int;
    subType = json["SubType"] as String;
    ammount = json["Amount"] as String;
    days = json["Days"] as int;
    startDate = json["StartDate"] as String;
    endDate = json["EndDate"] as String;
    status = json["Status"] as String;
  }
}
