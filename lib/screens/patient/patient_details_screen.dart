import 'package:flutter/material.dart';

import '../../models/patient.dart';
import '../../services/patient_service.dart';
import 'edit_patient_screen.dart';
import '../screening/start_screening_screen.dart';

import 'package:intl/intl.dart';

class PatientDetailsScreen extends StatelessWidget {
  final Patient patient;

  const PatientDetailsScreen({
    super.key,
    required this.patient,
  });

  Future<void> _deletePatient(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Patient"),
        content: const Text(
          "Are you sure you want to delete this patient?\n\nThis action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await PatientService().deletePatient(patient.patientId!);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Patient deleted successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete patient\n$e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget buildInfoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF0D47A1),
            size: 22,
          ),
          const SizedBox(width: 15),
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Header
            const CircleAvatar(
              radius: 45,
              backgroundColor: Color(0xFFE3F2FD),
              child: Icon(
                Icons.person,
                size: 55,
                color: Color(0xFF0D47A1),
              ),
            ),

            const SizedBox(height: 15),

            Text(
              patient.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              "Patient ID: ${patient.patientId ?? '-'}",
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 25),

            // Patient Information
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.badge, color: Color(0xFF0D47A1)),
                        SizedBox(width: 10),
                        Text(
                          "Patient Information",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                        ),
                      ],
                    ),
                    const Divider(height: 25),

                    buildInfoRow(
                      Icons.cake,
                      "Age",
                      "${patient.age} Years",
                    ),

                    buildInfoRow(
                      Icons.person_outline,
                      "Gender",
                      patient.gender,
                    ),

                    buildInfoRow(
                      Icons.phone,
                      "Phone",
                      patient.phone ?? "-",
                    ),

                    buildInfoRow(
                      Icons.home,
                      "Address",
                      patient.address ?? "-",
                    ),

                    buildInfoRow(
                      Icons.medical_information,
                      "Medical History",
                      patient.medicalHistory ?? "-",
                    ),

                    buildInfoRow(
                      Icons.calendar_today,
                      "Created",
                      DateFormat('dd MMM yyyy, hh:mm a' ,
                      )
                          .format(
                            DateTime.parse(patient.createdAt),
                          ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Status Card
            Card(
              color: Colors.green.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const ListTile(
                leading: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                title: Text(
                  "Ready for Screening",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "Patient can now undergo cataract screening.",
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Start Screening
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.visibility),
                label: const Text(
                  "Start Screening",
                  style: TextStyle(fontSize: 17),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          StartScreeningScreen(patient: patient),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            // Edit
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text("Edit Patient"),
                onPressed: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          EditPatientScreen(patient: patient),
                    ),
                  );

                  if (updated == true && context.mounted) {
                    Navigator.pop(context, true);
                  }
                },
              ),
            ),

            const SizedBox(height: 10),

            // Delete
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text("Delete Patient"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _deletePatient(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}