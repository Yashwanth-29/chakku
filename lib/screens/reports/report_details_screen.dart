import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../models/report.dart';
import '../../services/pdf_service.dart';

class ReportDetailsScreen extends StatelessWidget {
  final Report report;

  const ReportDetailsScreen({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    final bool cataract = report.prediction == "Possible Cataract";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Screening Report"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "AI Cataract Screening Report",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "Eye Image",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    if (File(report.imagePath).existsSync())
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(report.imagePath),
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                    const SizedBox(height: 25),

                    Card(
                      color: Colors.grey.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Report Summary",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),

                            Chip(
                              label: Text(report.prediction),
                              backgroundColor: cataract
                                  ? Colors.red.shade100
                                  : Colors.green.shade100,
                            ),

                            const SizedBox(height: 15),

                            const Text(
                              "Confidence",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),

                            LinearProgressIndicator(
                              value: report.confidence,
                              minHeight: 10,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                cataract ? Colors.red : Colors.green,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "${(report.confidence * 100).toStringAsFixed(2)}%",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 15),

                            buildTile(
                              "Screening Date",
                              DateFormat("dd MMM yyyy • hh:mm a").format(
                                DateTime.parse(report.screeningDate),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Recommendation",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Card(
                      color: Colors.amber.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          cataract
                              ? "Possible cataract detected. Please consult an ophthalmologist for a comprehensive eye examination."
                              : "No signs of cataract detected. Routine eye examination is recommended every 6–12 months.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            final pdfFile =
                                await PdfService().generateReport(report);

                            await Printing.layoutPdf(
                              onLayout: (format) async =>
                                  pdfFile.readAsBytes(),
                            );
                          } catch (e) {
                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Failed to generate PDF\n$e",
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text("Generate PDF"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
