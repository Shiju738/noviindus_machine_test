class TreatmentModel {
  final int id;
  final String name;
  final String duration;
  final double price;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final List<dynamic> branches;

  TreatmentModel({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.branches,
  });

  factory TreatmentModel.fromJson(Map<String, dynamic> json) {
    // Handle price as either string or number
    double price = 0.0;
    if (json['price'] != null) {
      if (json['price'] is String) {
        price = double.tryParse(json['price']) ?? 0.0;
      } else if (json['price'] is num) {
        price = json['price'].toDouble();
      }
    }

    return TreatmentModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      duration: json['duration'] ?? '',
      price: price,
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      branches: json['branches'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'price': price,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'branches': branches,
    };
  }

  @override
  String toString() {
    return 'TreatmentModel(id: $id, name: $name, duration: $duration, price: $price, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, branches: ${branches.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TreatmentModel &&
        other.id == id &&
        other.name == name &&
        other.duration == duration &&
        other.price == price &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      duration,
      price,
      isActive,
      createdAt,
      updatedAt,
    );
  }
}
