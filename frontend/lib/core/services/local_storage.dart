import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<void> saveUserId(String id) async {
    await _prefs.setString('user_id', id);
  }

  String? getUserId() {
    return _prefs.getString('user_id');
  }
}