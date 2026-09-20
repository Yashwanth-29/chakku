import '../database/database_helper.dart';

class AuthService {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  Future<bool> login(
    String email,
    String password,
  ) async {
    final db = await dbHelper.database;

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [
        email.trim(),
        password.trim(),
      ],
    );

    return result.isNotEmpty;
  }
}