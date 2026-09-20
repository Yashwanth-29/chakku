class Patient {
  final int? patientId;
  final String name;
  final int age;
  final String gender;
  final String? phone;
  final String? address;
  final String? medicalHistory;
  final String createdAt;

  Patient({
    this.patientId,
    required this.name,
    required this.age,
    required this.gender,
    this.phone,
    this.address,
    this.medicalHistory,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'name': name,
      'age': age,
      'gender': gender,
      'phone': phone,
      'address': address,
      'medicalHistory': medicalHistory,
      'createdAt': createdAt,
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      patientId: map['patientId'],
      name: map['name'],
      age: map['age'],
      gender: map['gender'],
      phone: map['phone'],
      address: map['address'],
      medicalHistory: map['medicalHistory'],
      createdAt: map['createdAt'],
    );
  }
}