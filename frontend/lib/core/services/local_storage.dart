import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  Future<void> saveUserId(String id) async {
    await _prefs.setString('user_id', id);
  }

  String? getUserId() {
    return _prefs.getString('user_id');
  }
}