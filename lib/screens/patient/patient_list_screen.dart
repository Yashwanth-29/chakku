import 'package:flutter/material.dart';

import '../../models/patient.dart';
import '../../services/patient_service.dart';
import 'patient_details_screen.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final PatientService _patientService = PatientService();

  List<Patient> patients = [];
  List<Patient> filteredPatients = [];

  bool isLoading = true;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPatients();
  }

  Future<void> loadPatients() async {
    final data = await _patientService.getAllPatients();

    if (!mounted) return;

    setState(() {
      patients = data;
      filteredPatients = data;
      isLoading = false;
    });
  }

  Future<void> refreshPatients() async {
    await loadPatients();
  }

  void searchPatient(String value) {
    setState(() {
      filteredPatients = patients.where((patient) {
        final query = value.toLowerCase();

        return patient.name.toLowerCase().contains(query) ||
            patient.gender.toLowerCase().contains(query) ||
            patient.age.toString().contains(query) ||
            (patient.phone ?? "").contains(query) ||
            (patient.patientId?.toString() ?? "").contains(query);
      }).toList();
    });
  }

  Color genderColor(String gender) {
    if (gender.toLowerCase() == "male") {
      return Colors.blue;
    }
    return Colors.pink;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient List"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    children: [
                      Card(
                        color: const Color(0xFFE3F2FD),
                        elevation: 0,
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFF0D47A1),
                            child: Icon(
                              Icons.people,
                              color: Colors.white,
                            ),
                          ),
                          title: const Text(
                            "Registered Patients",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle:
                              Text("${filteredPatients.length} Patients"),
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: searchController,
                        onChanged: searchPatient,
                        decoration: InputDecoration(
                          hintText:
                              "Search by name, ID or phone...",
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    searchController.clear();
                                    searchPatient("");
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: filteredPatients.isEmpty
                      ? const Center(
                          child: Text(
                            "No Patients Found",
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: refreshPatients,
                          child: ListView.builder(
                            padding:
                                const EdgeInsets.only(bottom: 20),
                            itemCount: filteredPatients.length,
                            itemBuilder: (context, index) {
                              final patient =
                                  filteredPatients[index];

                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(15),
                                ),
                                child: InkWell(
                                  borderRadius:
                                      BorderRadius.circular(15),
                                  onTap: () async {
                                    final result =
                                        await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            PatientDetailsScreen(
                                                patient: patient),
                                      ),
                                    );

                                    if (result == true) {
                                      loadPatients();
                                    }
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 28,
                                          backgroundColor:
                                              const Color(
                                                  0xFFE3F2FD),
                                          child: Text(
                                            patient.name
                                                .substring(0, 1)
                                                .toUpperCase(),
                                            style:
                                                const TextStyle(
                                              fontSize: 22,
                                              fontWeight:
                                                  FontWeight.bold,
                                              color: Color(
                                                  0xFF0D47A1),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 15),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                            children: [
                                              Text(
                                                patient.name,
                                                style:
                                                    const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight
                                                          .bold,
                                                ),
                                              ),

                                              const SizedBox(
                                                  height: 5),

                                              Text(
                                                  "Patient ID : ${patient.patientId}"),

                                              Text(
                                                  "${patient.age} Years"),

                                              Text(
                                                  patient.phone ??
                                                      "-"),
                                            ],
                                          ),
                                        ),

                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .end,
                                          children: [
                                            Chip(
                                              backgroundColor:
                                                  genderColor(
                                                          patient
                                                              .gender)
                                                      .withOpacity(
                                                          0.15),
                                              label: Text(
                                                patient.gender,
                                                style:
                                                    TextStyle(
                                                  color:
                                                      genderColor(
                                                          patient
                                                              .gender),
                                                  fontWeight:
                                                      FontWeight
                                                          .bold,
                                                ),
                                              ),
                                            ),

                                            const SizedBox(
                                                height: 10),

                                            const Icon(
                                              Icons
                                                  .arrow_forward_ios,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}