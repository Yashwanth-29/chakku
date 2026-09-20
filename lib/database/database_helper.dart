    import 'package:path/path.dart';
    import 'package:sqflite/sqflite.dart';

    class DatabaseHelper {
      DatabaseHelper._();
      static final DatabaseHelper instance = DatabaseHelper._();
      Database? _database;

      Future<Database> get database async {
        if (_database != null) return _database!;
        _database = await _initDatabase();
        return _database!;
      }

      Future<Database> _initDatabase() async {
        final databasePath = await getDatabasesPath();
        final path = join(databasePath, 'chakshu.db');
        return await openDatabase(path, version: 2, onCreate: _onCreate);
      }

      Future<void> _onCreate(Database db, int version) async {
        await db.execute("""CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          email TEXT NOT NULL UNIQUE,
          password TEXT NOT NULL)""");

        await db.execute("""CREATE TABLE patients(
          patientId INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          age INTEGER NOT NULL,
          gender TEXT NOT NULL,
          phone TEXT,
          address TEXT,
          medicalHistory TEXT,
          createdAt TEXT NOT NULL)""");

        await db.execute("""CREATE TABLE reports(
          reportId INTEGER PRIMARY KEY AUTOINCREMENT,
          patientId INTEGER,
          screeningDate TEXT,
          prediction TEXT,
          confidence REAL,
          imagePath TEXT)""");

        await db.insert('users',{
          'name':'Administrator',
          'email':'admin@chakshu.com',
          'password':'admin123'
        });
      }

      Future<int> getPatientCount() async {
        final db = await database;
        final result = await db.rawQuery('SELECT COUNT(*) FROM patients');
        return Sqflite.firstIntValue(result) ?? 0;
      }

      Future<int> getReportCount() async {
        final db = await database;
        final result = await db.rawQuery('SELECT COUNT(*) FROM reports');
        return Sqflite.firstIntValue(result) ?? 0;
      }

      Future<Map<String,dynamic>?> getAdmin() async {
        final db = await database;
        final result = await db.query('users', limit: 1);
        if(result.isEmpty) return null;
        return result.first;
      }

      Future<bool> changePassword(String email,String currentPassword,String newPassword) async {
        final db = await database;
        final result = await db.query(
          'users',
          where:'email=? AND password=?',
          whereArgs:[email,currentPassword],
        );
        if(result.isEmpty) return false;

        await db.update(
          'users',
          {'password':newPassword},
          where:'email=?',
          whereArgs:[email],
        );
        return true;
      }

      Future<void> updateAdminName(String newName) async {
        final db = await database;
        await db.update('users', {'name':newName}, where:'id=1');
      }

      Future<void> clearDatabase() async {
        final db = await database;
        await db.delete('reports');
        await db.delete('patients');
      }

      Future<void> closeDatabase() async {
        final db = await database;
        await db.close();
      }
    }
