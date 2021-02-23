import 'package:flutter_save_password/enums/locale/preferences_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalManager {
  static LocalManager _instance = LocalManager._init();
  SharedPreferences _preferences;
//todo burayı repo sınıfında hallet 


  static LocalManager get instance {
    if (_instance == null) _instance = LocalManager._init();
    return _instance;
  }

  LocalManager._init() {
    SharedPreferences.getInstance().then((value) {
      _preferences = value;
    });
  }

  static prefrencesInit() async {
    if (instance._preferences == null) {
      instance._preferences = await SharedPreferences.getInstance();
    }
    //_instance._preferences.set

    return;
  }

  Future<void> setStringValue(PreferencesKeys key, String value) async {
    await _preferences.setString(key.toString(), value);
  }

  String getValue(PreferencesKeys key) =>
      _preferences.getString(key.toString());

  Future<void> setBoolValue(PreferencesKeys key,bool value) async {
    await _preferences.setBool(key.toString(), value);
  }

  bool getBoolValue(PreferencesKeys key) =>
      _preferences.getBool(key.toString()) == null ? false : _preferences.getBool(key.toString()) ;

}