import 'package:http/http.dart' as http;

class Server {
  final String url;
  Server(this.url);

  Future<String> connect() async {
    try {
      print(url);

      var response =
          await http.get(url).timeout(Duration(seconds: 15), onTimeout: () {
        throw Exception();
      });
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "An Error Occured";
      }
    } catch (e) {
      return e.toString();
    }
  }
}
