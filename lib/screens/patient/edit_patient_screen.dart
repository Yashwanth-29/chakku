import 'package:flutter/material.dart';

import '../../models/patient.dart';
import '../../services/patient_service.dart';

class EditPatientScreen extends StatefulWidget {
  final Patient patient;

  const EditPatientScreen({
    super.key,
    required this.patient,
  });

  @override
  State<EditPatientScreen> createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final PatientService _patientService = PatientService();

  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController historyController;

  late String gender;

  bool isUpdating = false;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.patient.name);

    ageController =
        TextEditingController(text: widget.patient.age.toString());

    phoneController =
        TextEditingController(text: widget.patient.phone ?? "");

    addressController =
        TextEditingController(text: widget.patient.address ?? "");

    historyController =
        TextEditingController(text: widget.patient.medicalHistory ?? "");

    gender = widget.patient.gender;
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    phoneController.dispose();
    addressController.dispose();
    historyController.dispose();
    super.dispose();
  }

  Future<void> updatePatient() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isUpdating = true;
    });

    Patient updatedPatient = Patient(
      patientId: widget.patient.patientId,
      name: nameController.text.trim(),
      age: int.parse(ageController.text.trim()),
      gender: gender,
      phone: phoneController.text.trim(),
      address: addressController.text.trim(),
      medicalHistory: historyController.text.trim(),
      createdAt: widget.patient.createdAt,
    );

    await _patientService.updatePatient(updatedPatient);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Patient Updated Successfully"),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Patient"),
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
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? "Enter Name"
                        : null,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Age",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? "Enter Age"
                        : null,
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: gender,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Gender",
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
                decoration: const InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                ),
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
                  onPressed: isUpdating ? null : updatePatient,
                  child: Text(
                    isUpdating
                        ? "Updating..."
                        : "Update Patient",
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