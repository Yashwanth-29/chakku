import 'package:flutter/material.dart';

import '../patient/patient_list_screen.dart';
import '../patient/register_patient_screen.dart';
import '../reports/report_list_screen.dart';

import '../../database/database_helper.dart';
import '../../services/session_service.dart';
import '../auth/login_screen.dart';

import '../settings/settings_screen.dart';

import '../../widgets/dashboard_action_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int patientCount = 0;
  int reportCount = 0;

  @override
  void initState() {
    super.initState();
    loadCounts();
  }

  Future<void> loadCounts() async {
    patientCount = await DatabaseHelper.instance.getPatientCount();
    reportCount = await DatabaseHelper.instance.getReportCount();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CHAKSHU Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () async {
              bool? logout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Logout"),
                  content: const Text(
                    "Are you sure you want to logout?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              );

              if (logout == true) {
                await SessionService().logout();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
        child: Column(
          children: [
            // Welcome Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0D47A1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Administrator",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "AI Powered Cataract Screening System",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Statistics Cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.people,
                          color: Color(0xFF0D47A1),
                          size: 35,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          patientCount.toString(),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text("Patients"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.description,
                          color: Colors.green,
                          size: 35,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          reportCount.toString(),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text("Reports"),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            DashboardActionCard(
              icon: Icons.person_add,
              title: "Register Patient",
              subtitle: "Add a new patient",
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterPatientScreen(),
                  ),
                );

                loadCounts();
              },
            ),

            DashboardActionCard(
              icon: Icons.people,
              title: "Patient List",
              subtitle: "View and manage patients",
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PatientListScreen(),
                  ),
                );

                loadCounts();
              },
            ),

            DashboardActionCard(
              icon: Icons.router,
              title: "Connect Device",
              subtitle: "Connect to the screening device",
              onTap: () {
                // Raspberry Pi Integration (Later)
              },
            ),

            DashboardActionCard(
              icon: Icons.description,
              title: "Reports",
              subtitle: "View screening reports",
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ReportListScreen(),
                  ),
                );

                loadCounts();
              },
            ),

            DashboardActionCard(
              icon: Icons.settings,
              title: "Settings",
              subtitle: "Application settings",
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );

                loadCounts();
              },
            ),
          ],
        ),
      ),
    );
  }
}