import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/patient.dart';
import '../../models/report.dart';

import '../../services/image_preprocessor.dart';
import '../../services/report_service.dart';
import '../../services/tflite_service.dart';

class StartScreeningScreen extends StatefulWidget {
  final Patient patient;

  const StartScreeningScreen({
    super.key,
    required this.patient,
  });

  @override
  State<StartScreeningScreen> createState() =>
      _StartScreeningScreenState();
}

class _StartScreeningScreenState extends State<StartScreeningScreen> {
  final ImagePicker picker = ImagePicker();
  final TFLiteService tflite = TFLiteService();
  final ReportService reportService = ReportService();

  File? image;

  bool modelLoaded = false;

  double? probability;
  double? confidence;

  String? prediction;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      await tflite.loadModel();

      if (!mounted) return;

      setState(() {
        modelLoaded = true;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load model\n$e"),
        ),
      );
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? picked =
        await picker.pickImage(source: source);

    if (picked == null) return;

    setState(() {
      image = File(picked.path);

      prediction = null;
      probability = null;
      confidence = null;
    });
  }

  Future<void> analyzeImage() async {
    if (image == null) return;

    try {
      final input = ImagePreprocessor.preprocess(image!);

      final prob = tflite.predict(input);
      ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text("Raw Output: ${prob.toStringAsFixed(6)}"),
  ),
);

      final predictedClass =
          prob < 0.5 ? "Possible Cataract" : "Normal";

      final predictedConfidence =
          predictedClass == "Possible Cataract"
              ? prob
              : (1 - prob);

      final report = Report(
        patientId: widget.patient.patientId!,
        screeningDate:
            DateTime.now().toIso8601String(),
        prediction: predictedClass,
        confidence: predictedConfidence,
        imagePath: image!.path,
      );

      await reportService.insertReport(report);

      if (!mounted) return;

      setState(() {
        probability = prob;
        prediction = predictedClass;
        confidence = predictedConfidence;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Screening completed and report saved.",
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Analysis Failed\n$e",
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Start Screening"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.patient.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Center(
                child: image == null
                    ? const Text(
                        "No Image Selected",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )
                    : ClipRRect(
                        borderRadius:
                            BorderRadius.circular(12),
                        child: Image.file(image!),
                      ),
              ),
            ),

            ElevatedButton.icon(
              onPressed: () =>
                  pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text("Camera"),
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () =>
                  pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo),
              label: const Text("Gallery"),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    image == null || !modelLoaded
                        ? null
                        : analyzeImage,
                child: Text(
                  modelLoaded
                      ? "Analyze Image"
                      : "Loading Model...",
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (prediction != null)
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        prediction ==
                                "Possible Cataract"
                            ? Icons
                                .warning_amber_rounded
                            : Icons.check_circle,
                        color: prediction ==
                                "Possible Cataract"
                            ? Colors.red
                            : Colors.green,
                        size: 60,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        prediction!,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight:
                              FontWeight.bold,
                          color: prediction ==
                                  "Possible Cataract"
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        "Confidence : ${(confidence! * 100).toStringAsFixed(2)}%",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.w500,
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
}