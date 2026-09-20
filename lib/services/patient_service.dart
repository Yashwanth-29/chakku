import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/patient.dart';

class PatientService {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Insert Patient
  Future<int> insertPatient(Patient patient) async {
    final Database db = await _databaseHelper.database;

    return await db.insert(
      'patients',
      patient.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get All Patients
  Future<List<Patient>> getAllPatients() async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'patients',
      orderBy: 'patientId DESC',
    );

    return List.generate(
      maps.length,
      (index) => Patient.fromMap(maps[index]),
    );
  }

  // Get Patient By ID
  Future<Patient?> getPatientById(int patientId) async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'patients',
      where: 'patientId = ?',
      whereArgs: [patientId],
    );

    if (maps.isNotEmpty) {
      return Patient.fromMap(maps.first);
    }

    return null;
  }

  // Update Patient
  Future<int> updatePatient(Patient patient) async {
    final Database db = await _databaseHelper.database;

    return await db.update(
      'patients',
      patient.toMap(),
      where: 'patientId = ?',
      whereArgs: [patient.patientId],
    );
  }

  // Delete Patient
  Future<int> deletePatient(int patientId) async {
    final Database db = await _databaseHelper.database;

    return await db.delete(
      'patients',
      where: 'patientId = ?',
      whereArgs: [patientId],
    );
  }
}