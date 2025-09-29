class BranchModel {
  final int id;
  final String name;
  final String location;
  final String phone;
  final String email;
  final String address;
  final String gst;
  final bool isActive;
  final int patientsCount;

  BranchModel({
    required this.id,
    required this.name,
    required this.location,
    required this.phone,
    required this.email,
    required this.address,
    required this.gst,
    required this.isActive,
    required this.patientsCount,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
      email: json['mail'] ?? '',
      address: json['address'] ?? '',
      gst: json['gst'] ?? '',
      isActive: json['is_active'] ?? false,
      patientsCount: json['patients_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'phone': phone,
      'mail': email,
      'address': address,
      'gst': gst,
      'is_active': isActive,
      'patients_count': patientsCount,
    };
  }

  @override
  String toString() {
    return 'BranchModel(id: $id, name: $name, location: $location, phone: $phone, email: $email, address: $address, gst: $gst, isActive: $isActive, patientsCount: $patientsCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BranchModel &&
        other.id == id &&
        other.name == name &&
        other.location == location &&
        other.phone == phone &&
        other.email == email &&
        other.address == address &&
        other.gst == gst &&
        other.isActive == isActive &&
        other.patientsCount == patientsCount;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      location,
      phone,
      email,
      address,
      gst,
      isActive,
      patientsCount,
    );
  }
}
