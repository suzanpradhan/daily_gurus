const String ORDER_STATUS_RECIEVED = "ORDER_RECEIVED";
const String ORDER_STATUS_PROCESSING = "PROCESSING";
const String ORDER_STATUS_CONFIRMED = "ORDER_CONFIRMED";
const String ORDER_STATUS_DISPATCHED = "DISPATCHED";
const String ORDER_STATUS_DELIVERED = "DELIVERED";
const String ORDER_STATUS_CANCELLED = "CANCELLED";
const String ORDER_STATUS_REFUNDED = "REFUNDED";

class OrderRouteArguments {
  final int id;
  final int index;

  OrderRouteArguments({this.id, this.index});
}

class OrderDetails {
  final int userID;
  final double totalPrice;
  final int discount;
  final String shippingMethod;
  final int couponID;
  final int shippingAmount;
  final String paymentMethod;
  final String addressID;
  final String cartID;

  OrderDetails({
    this.userID,
    this.totalPrice,
    this.discount,
    this.shippingMethod,
    this.couponID,
    this.shippingAmount,
    this.paymentMethod,
    this.addressID,
    this.cartID,
  });

  Map<String, dynamic> toJson() => {
        'user_pk': userID,
        'total_price': totalPrice,
        'discount': discount,
        'shipping_method': shippingMethod,
        'coupon_id': couponID,
        'shipping_amount': shippingAmount,
        'payment_method': paymentMethod,
        'address_id': addressID,
        'cart_id': cartID,
      };
}

class OrderData {
  final int id;
  final String invoiceNo;
  final String orderID;
  final int userID;
  final int netTotal;
  final int grandTotal;
  final String paymentMode;
  final String status;
  final String paymentStatus;
  final String isOrderVideo;
  final String orderDate;
  final OrderAddress orderAddress;
  bool isTrackOrdersOpen;

  OrderData({
    this.id,
    this.invoiceNo,
    this.orderID,
    this.userID,
    this.netTotal,
    this.grandTotal,
    this.paymentMode,
    this.status,
    this.paymentStatus,
    this.isOrderVideo,
    this.orderDate,
    this.orderAddress,
    this.isTrackOrdersOpen,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id'],
      invoiceNo: json['invoice_no'],
      orderID: json['order_id'],
      userID: json['user_id'],
      netTotal: json['net_total'],
      grandTotal: json['grand_total'],
      paymentMode: json['payment_mode'],
      status: json['status'],
      paymentStatus: json['payment_status'],
      isOrderVideo: json['is_order_video'],
      orderDate: json['order_date'],
      orderAddress: json['order_shipping_address'] == null
          ? OrderAddress(address: "", pinCode: "", city: "")
          : OrderAddress.fromJson(json['order_shipping_address']),
      isTrackOrdersOpen: false,
    );
  }
}

class OrderAddress {
  final String address;
  final String city;
  final String pinCode;

  OrderAddress({
    this.address,
    this.city,
    this.pinCode,
  });

  factory OrderAddress.fromJson(Map<String, dynamic> data) {
    return OrderAddress(
      address: data['address'],
      pinCode: data['pin_code'],
      city: data['city'],
    );
  }
}
