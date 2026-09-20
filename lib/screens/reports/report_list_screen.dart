import 'package:flutter/material.dart';

import '../../models/report.dart';
import '../../services/report_service.dart';
import 'report_details_screen.dart';
import 'package:intl/intl.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({super.key});

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  final ReportService reportService = ReportService();

  List<Map<String, dynamic>> reports = [];
  List<Map<String, dynamic>> filteredReports = [];

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadReports();
  }

  void searchReports(String value) {
    setState(() {
      filteredReports = reports.where((report) {
        return report["name"]
                .toString()
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            report["prediction"]
                .toString()
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            report["patientId"].toString().contains(value);
      }).toList();
    });
  }

  Future<void> loadReports() async {
    reports = await reportService.getReportsWithPatient();
    filteredReports = reports;

    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reports")),
      body: reports.isEmpty
          ? const Center(
              child: Text(
                "No Reports Available",
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Card(
                        color: const Color(0xFFE3F2FD),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFF0D47A1),
                            child: Icon(Icons.description, color: Colors.white),
                          ),
                          title: const Text(
                            "Total Reports",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("${reports.length} Reports"),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: searchController,
                        onChanged: searchReports,
                        decoration: InputDecoration(
                          hintText:
                              "Search by patient name, diagnosis or Patient ID",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredReports.length,
                    itemBuilder: (context, index) {
                      final report = filteredReports[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReportDetailsScreen(
                                  report: Report.fromMap(report),
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 22,
                                      backgroundColor:
                                          report["prediction"] ==
                                                  "Possible Cataract"
                                              ? Colors.red.shade100
                                              : Colors.green.shade100,
                                      child: Icon(
                                        report["prediction"] ==
                                                "Possible Cataract"
                                            ? Icons.remove_red_eye
                                            : Icons.check_circle,
                                        color:
                                            report["prediction"] ==
                                                    "Possible Cataract"
                                                ? Colors.red
                                                : Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        report["name"],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios,
                                        size: 18),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  "Patient ID : ${report["patientId"]}",
                                  style: const TextStyle(fontSize: 15),
                                ),
                                const SizedBox(height: 12),
                                Chip(
                                  label: Text(report["prediction"]),
                                  backgroundColor:
                                      report["prediction"] ==
                                              "Possible Cataract"
                                          ? Colors.red.shade100
                                          : Colors.green.shade100,
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  "Confidence",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                LinearProgressIndicator(
                                  value: (report["confidence"] as num).toDouble(),
                                  minHeight: 8,
                                  backgroundColor: Colors.grey.shade300,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    report["prediction"] ==
                                            "Possible Cataract"
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "${((report["confidence"] as num).toDouble() * 100).toStringAsFixed(2)}%",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text(
                                      DateFormat("dd MMM yyyy • hh:mm a")
                                          .format(DateTime.parse(
                                              report["screeningDate"])),
                                      style: TextStyle(
                                          color: Colors.grey.shade600),
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
              ],
            ),
    );
  }
}
