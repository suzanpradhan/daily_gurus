class Complex {
  int id;
  String code;
  String name;
  String address;
  String noFamily;
  String pinCode;
  String city;
  String updatedBy;
  String isDisplay;
  String createdAt;
  String updatedAt;

  Complex({
    this.id,
    this.code,
    this.name,
    this.address,
    this.noFamily,
    this.pinCode,
    this.city,
    this.updatedBy,
    this.isDisplay,
    this.createdAt,
    this.updatedAt,
  });

  factory Complex.fromJson(Map<String, dynamic> json) {
    return Complex(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      address: json['address'],
      noFamily: json['no_family'],
      pinCode: json['pin_code'],
      city: json['city'],
      updatedBy: json['updated_by'],
      isDisplay: json['is_display'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
