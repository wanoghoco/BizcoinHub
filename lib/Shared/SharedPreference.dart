import "package:shared_preferences/shared_preferences.dart";

class SharedPreference {
  Future<bool> stringSetter(String key, String value) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setString(key, value);
    return true;
  }

  Future<String> stringGetter(String key) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    String value = preference.getString(key);
    return value;
  }

  Future<bool> boolSetter(String key, bool value) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setBool(key, value);
    return true;
  }

  Future<bool> boolGetter(String key) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    bool value = preference.getBool(key);
    return value;
  }

  Future<bool> intSetter(String key, int value) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setInt(key, value);
    return true;
  }

  Future<int> intGetter(String key) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    int value = preference.getInt(key);
    return value;
  }

  static SharedPreference initializer() {
    var data = new SharedPreference();
    return data;
  }

  static Future<bool> logout() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    preference.clear();
    return true;
  }
}
