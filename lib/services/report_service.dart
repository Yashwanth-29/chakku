import '../database/database_helper.dart';
import '../models/report.dart';

class ReportService {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insertReport(Report report) async {
    final db = await dbHelper.database;

    return await db.insert(
      'reports',
      report.toMap(),
    );
  }

  Future<List<Map<String, dynamic>>> getReportsWithPatient() async {
    final db = await dbHelper.database;

    return await db.rawQuery('''
      SELECT
        reports.*,
        patients.name,
        patients.age,
        patients.gender
      FROM reports
      INNER JOIN patients
      ON reports.patientId = patients.patientId
      ORDER BY reports.reportId DESC
    ''');
  }

  Future<List<Report>> getReports() async {
    final db = await dbHelper.database;

    final maps = await db.query(
      'reports',
      orderBy: 'reportId DESC',
    );

    return maps.map((e) => Report.fromMap(e)).toList();
  }
}