class Product {
  final int id;
  final ProductCategory productCategory;
  final String code;
  final String prCode;
  final String name;
  final String description;
  final int offerPrice;
  final int originalPrice;
  final int stock;
  final String nos;
  final String weight;
  final String status;
  final String image;
  final String brandName;
  final String videoURL;
  final String createdAt;
  final String updatedAt;
  final String isImage;
  final List<ProductVariant> productVariant;
  int selectedQuantity;
  int b2BPrice;
  int b2BMinQuantity;
  int backendQuantity;

  Product({
    this.id,
    this.productCategory,
    this.code,
    this.prCode,
    this.name,
    this.description,
    this.offerPrice,
    this.originalPrice,
    this.stock,
    this.nos,
    this.weight,
    this.status,
    this.image,
    this.brandName,
    this.videoURL,
    this.createdAt,
    this.updatedAt,
    this.isImage,
    this.productVariant,
    this.selectedQuantity,
    this.b2BPrice,
    this.b2BMinQuantity,
    this.backendQuantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      productCategory: json['product_category'] != null
          ? ProductCategory.fromJson(json['product_category'][0])
          : null,
      code: json['code'],
      prCode: json['pr_code'],
      name: json['name'],
      description: json['description'],
      offerPrice: json['offer_price'],
      originalPrice: json['original_price'],
      stock: json['stock'],
      nos: json['nos'],
      weight: json['weight'],
      status: json['status'],
      image: json['image'],
      brandName: json['brand_name'],
      videoURL: json['video_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isImage: json['is_image'],
      productVariant: json['product_varient'] != null
          ? json['product_varient'].map<ProductVariant>((json) {
              return ProductVariant.fromJson(json);
            }).toList()
          : [],
      selectedQuantity: 0,
      b2BPrice: json['b2b_price'] ?? 0,
      b2BMinQuantity: json['b2b_min_qty'] ?? 0,
      backendQuantity: 0,
    );
  }
}

class ProductVariant {
  final int id;
  final String vaCode;
  final int productID;
  final String productType;
  final int b2BPrice;
  final int b2BMinQuantity;
  final String variant;
  final String shortName;
  final int sellingPrice;
  final double mrpPrice;
  final int stock;
  final int minStock;
  final String stockStatus;
  final int isHighlight;
  final int isPosition;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String isProductName;
  final String isProductImage;

  ProductVariant({
    this.id,
    this.vaCode,
    this.productID,
    this.productType,
    this.b2BPrice,
    this.b2BMinQuantity,
    this.variant,
    this.shortName,
    this.sellingPrice,
    this.mrpPrice,
    this.stock,
    this.minStock,
    this.stockStatus,
    this.isHighlight,
    this.isPosition,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.isProductName,
    this.isProductImage,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'],
      vaCode: json['va_code'],
      productID: json['product_id'],
      productType: json['product_type'],
      b2BPrice: json['b2b_price'],
      b2BMinQuantity: json['b2b_min_qty'],
      variant: json['varient'],
      shortName: json['short_name'],
      sellingPrice: json['selling_price'],
      mrpPrice: json['mrp_price'].toDouble(),
      stock: json['stock'],
      minStock: json['min_stock'],
      stockStatus: json['stock_status'],
      isHighlight: json['is_highlight'],
      isPosition: json['is_position'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isProductName: json['is_product_name'],
      isProductImage: json['is_product_image'],
    );
  }
}

class ProductCategory {
  final int id;
  final int categoryID;
  final int productID;

  ProductCategory({
    this.id,
    this.categoryID,
    this.productID,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> filteredJson) {
    return ProductCategory(
      id: filteredJson['id'],
      categoryID: filteredJson['category_id'],
      productID: filteredJson['product_id'],
    );
  }
}
