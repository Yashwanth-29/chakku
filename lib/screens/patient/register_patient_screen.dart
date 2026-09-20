import 'package:flutter/material.dart';

import '../../models/patient.dart';
import '../../services/patient_service.dart';

class RegisterPatientScreen extends StatefulWidget {
  const RegisterPatientScreen({super.key});

  @override
  State<RegisterPatientScreen> createState() =>
      _RegisterPatientScreenState();
}

class _RegisterPatientScreenState extends State<RegisterPatientScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final historyController = TextEditingController();

  final PatientService patientService = PatientService();

  String gender = "Male";
  bool isSaving = false;

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    phoneController.dispose();
    addressController.dispose();
    historyController.dispose();
    super.dispose();
  }

  Future<void> savePatient() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSaving = true;
    });

    try {
      Patient patient = Patient(
        name: nameController.text.trim(),
        age: int.parse(ageController.text.trim()),
        gender: gender,
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        medicalHistory: historyController.text.trim(),
        createdAt: DateTime.now().toIso8601String(),
      );

      await patientService.insertPatient(patient);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Patient Registered Successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save patient.\n$e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Patient"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Patient Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter patient name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Age",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter age";
                  }

                  final age = int.tryParse(value);

                  if (age == null) {
                    return "Enter a valid age";
                  }

                  if (age <= 0 || age > 120) {
                    return "Age must be between 1 and 120";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: gender,
                decoration: const InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Male",
                    child: Text("Male"),
                  ),
                  DropdownMenuItem(
                    value: "Female",
                    child: Text("Female"),
                  ),
                  DropdownMenuItem(
                    value: "Other",
                    child: Text("Other"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                  });
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  }

                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return "Enter a valid 10-digit phone number";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: historyController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Medical History",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: isSaving ? null : savePatient,
                  child: isSaving
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Save Patient",
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}