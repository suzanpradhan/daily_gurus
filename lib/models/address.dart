class Address {
  final int id;
  final String address;
  final int pinCode;
  final int userID;
  final String city;
  final int complexID;
  final String complexName;

  Address({
    this.id,
    this.address,
    this.pinCode,
    this.userID,
    this.city,
    this.complexID,
    this.complexName,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      address: json['address'],
      userID: json['user_id'],
      pinCode: int.parse(json['pin_code']),
      city: json['city'],
      complexID: json['complex_id'],
      complexName: json['is_complex_name'],
    );
  }
}
