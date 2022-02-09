import 'package:dailygurus/models/product.dart';

class CartTotal {
  final int id;
  final int userID;
  final String sessionID;
  final String cartItems;
  final int subTotal;
  final int deliveryCharges;
  final String discountCode;
  final String discount;
  final String discountAmount;
  final String cartTotal;
  final String createdAt;
  final String updatedAt;
  final int isPrice;
  final int isQty;

  CartTotal({
    this.id,
    this.userID,
    this.sessionID,
    this.cartItems,
    this.subTotal,
    this.deliveryCharges,
    this.discountCode,
    this.discount,
    this.discountAmount,
    this.cartTotal,
    this.createdAt,
    this.updatedAt,
    this.isPrice,
    this.isQty,
  });

  factory CartTotal.fromJson(Map<String, dynamic> json) {
    return CartTotal(
      id: json['id'],
      userID: json['user_id'],
      sessionID: json['session_id'],
      cartItems: json['cart_items'],
      subTotal: json['sub_total'],
      deliveryCharges: json['delivery_chareges'],
      discountCode: json['discount_code'],
      discount: json['discount'].toString(),
      discountAmount: json['discount_amount'].toString(),
      cartTotal: json['cart_total'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isPrice: json['is_price'],
      isQty: json['is_qty'] is int ? json['is_qty'] : int.parse(json['is_qty']),
    );
  }
}

class CartItem {
  final int id;
  final int userID;
  final String sessionID;
  final int cartID;
  final int productID;
  final int varientID;
  final int qty;
  final int price;
  final int total;
  final String createdAt;
  final String updatedAt;
  final String productTypeID;
  final Product product;
  final ProductVariant productVariant;

  CartItem({
    this.id,
    this.userID,
    this.sessionID,
    this.cartID,
    this.productID,
    this.varientID,
    this.qty,
    this.price,
    this.total,
    this.createdAt,
    this.updatedAt,
    this.productTypeID,
    this.product,
    this.productVariant,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      userID: json['user_id'],
      sessionID: json['session_id'],
      cartID: json['cart_id'],
      productID: json['product_id'],
      varientID: json['varient_id'],
      qty: json['qty'],
      price: json['price'],
      total: json['total'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      productTypeID: json['product_type_id'],
      product: Product.fromJson(json['product']),
      productVariant: json['product_varient'] != null
          ? ProductVariant.fromJson(json['product_varient'])
          : null,
    );
  }
}
