class Category {
  final int id;
  final String code;
  final String name;
  final String image;
  final String status;
  final int isMenu;
  final String createdAt;
  final String updatedAt;
  final String isImage;

  Category({
    this.id,
    this.code,
    this.name,
    this.image,
    this.status,
    this.isMenu,
    this.createdAt,
    this.updatedAt,
    this.isImage,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      image: json['image'],
      status: json['status'],
      isMenu: json['is_menu'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isImage: json['is_image'],
    );
  }
}
