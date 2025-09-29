class BookingModel {
  final String name;
  final String executive;
  final String payment;
  final String phone;
  final String address;
  final double totalAmount;
  final double discountAmount;
  final double advanceAmount;
  final double balanceAmount;
  final String dateAndTime;
  final String id;
  final String male;
  final String female;
  final String branch;
  final String treatments;

  BookingModel({
    required this.name,
    required this.executive,
    required this.payment,
    required this.phone,
    required this.address,
    required this.totalAmount,
    required this.discountAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    required this.dateAndTime,
    this.id = '',
    required this.male,
    required this.female,
    required this.branch,
    required this.treatments,
  });

  // Factory constructor to create instance from JSON
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      name: json['name'] ?? '',
      executive: json['executive'] ?? '',
      payment: json['payment'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      totalAmount: (json['total_amount'] ?? 0.0).toDouble(),
      discountAmount: (json['discount_amount'] ?? 0.0).toDouble(),
      advanceAmount: (json['advance_amount'] ?? 0.0).toDouble(),
      balanceAmount: (json['balance_amount'] ?? 0.0).toDouble(),
      dateAndTime: json['date_nd_time'] ?? '',
      id: json['id'] ?? '',
      male: json['male'] ?? '',
      female: json['female'] ?? '',
      branch: json['branch'] ?? '',
      treatments: json['treatments'] ?? '',
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'executive': executive,
      'payment': payment,
      'phone': phone,
      'address': address,
      'total_amount': totalAmount,
      'discount_amount': discountAmount,
      'advance_amount': advanceAmount,
      'balance_amount': balanceAmount,
      'date_nd_time': dateAndTime,
      'id': id,
      'male': male,
      'female': female,
      'branch': branch,
      'treatments': treatments,
    };
  }

  // Method to create a copy with updated fields
  BookingModel copyWith({
    String? name,
    String? executive,
    String? payment,
    String? phone,
    String? address,
    double? totalAmount,
    double? discountAmount,
    double? advanceAmount,
    double? balanceAmount,
    String? dateAndTime,
    String? id,
    String? male,
    String? female,
    String? branch,
    String? treatments,
  }) {
    return BookingModel(
      name: name ?? this.name,
      executive: executive ?? this.executive,
      payment: payment ?? this.payment,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      totalAmount: totalAmount ?? this.totalAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      advanceAmount: advanceAmount ?? this.advanceAmount,
      balanceAmount: balanceAmount ?? this.balanceAmount,
      dateAndTime: dateAndTime ?? this.dateAndTime,
      id: id ?? this.id,
      male: male ?? this.male,
      female: female ?? this.female,
      branch: branch ?? this.branch,
      treatments: treatments ?? this.treatments,
    );
  }

  @override
  String toString() {
    return 'BookingModel(name: $name, executive: $executive, payment: $payment, phone: $phone, address: $address, totalAmount: $totalAmount, discountAmount: $discountAmount, advanceAmount: $advanceAmount, balanceAmount: $balanceAmount, dateAndTime: $dateAndTime, id: $id, male: $male, female: $female, branch: $branch, treatments: $treatments)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BookingModel &&
        other.name == name &&
        other.executive == executive &&
        other.payment == payment &&
        other.phone == phone &&
        other.address == address &&
        other.totalAmount == totalAmount &&
        other.discountAmount == discountAmount &&
        other.advanceAmount == advanceAmount &&
        other.balanceAmount == balanceAmount &&
        other.dateAndTime == dateAndTime &&
        other.id == id &&
        other.male == male &&
        other.female == female &&
        other.branch == branch &&
        other.treatments == treatments;
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      executive,
      payment,
      phone,
      address,
      totalAmount,
      discountAmount,
      advanceAmount,
      balanceAmount,
      dateAndTime,
      id,
      male,
      female,
      branch,
      treatments,
    );
  }
}
