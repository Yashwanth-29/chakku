class Report {
  final int? reportId;
  final int patientId;
  final String screeningDate;
  final String prediction;
  final double confidence;
  final String imagePath;

  Report({
    this.reportId,
    required this.patientId,
    required this.screeningDate,
    required this.prediction,
    required this.confidence,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'reportId': reportId,
      'patientId': patientId,
      'screeningDate': screeningDate,
      'prediction': prediction,
      'confidence': confidence,
      'imagePath': imagePath,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      reportId: map['reportId'],
      patientId: map['patientId'],
      screeningDate: map['screeningDate'],
      prediction: map['prediction'],
      confidence: map['confidence'],
      imagePath: map['imagePath'],
    );
  }
}