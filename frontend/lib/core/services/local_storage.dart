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

  Future<void> removeUserId() async {
    await _prefs.remove('user_id');
  }

  Future<void> saveAttemptId(int id) async {
    await _prefs.setInt('attempt_id', id);
  }

  int? getAttemptId() {
    return _prefs.getInt('attempt_id');
  }

  Future<void> saveUsername(String username) async {
    await _prefs.setString('username', username);
  }

  String? getUsername() {
    return _prefs.getString('username');
  }

  Future<void> saveSelectedMajors(Set<String> majors) async {
    await _prefs.setStringList('selected_majors', majors.toList());
  }

  List<String> getSelectedMajors() {
    final list = _prefs.getStringList('selected_majors') ?? [];
    return list.toList();
  }

  Future<void> saveSelectedMajorIds(List<int> ids) async {
    await _prefs.setStringList(
      'selected_major_ids',
      ids.map((id) => id.toString()).toList(),
    );
  }

  List<int> getSelectedMajorIds() {
    final list = _prefs.getStringList('selected_major_ids') ?? [];
    return list.map((id) => int.parse(id)).toList();
  }
}
