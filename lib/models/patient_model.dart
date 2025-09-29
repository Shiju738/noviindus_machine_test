class PatientModel {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? dateOfBirth;
  final String? gender;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  PatientModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.dateOfBirth,
    this.gender,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
