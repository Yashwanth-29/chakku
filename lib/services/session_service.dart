    import 'package:shared_preferences/shared_preferences.dart';

    class SessionService {
      static const String _loggedInKey = 'isLoggedIn';
      static const String _userEmailKey = 'userEmail';

      Future<void> saveLogin(String email) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_loggedInKey, true);
        await prefs.setString(_userEmailKey, email);
      }

      Future<bool> isLoggedIn() async {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getBool(_loggedInKey) ?? false;
      }

      Future<String?> getLoggedInUser() async {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getString(_userEmailKey);
      }

      Future<void> updateLoggedInUser(String email) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userEmailKey, email);
      }

      Future<void> clearSession() async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_loggedInKey);
        await prefs.remove(_userEmailKey);
      }

      Future<void> logout() async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
      }
    }
