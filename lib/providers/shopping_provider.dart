import 'dart:convert';
import 'package:dailygurus/constants/api_constants.dart';
import 'package:dailygurus/models/address.dart';
import 'package:dailygurus/models/cart.dart';
import 'package:dailygurus/models/http_result.dart';
import 'package:dailygurus/models/order.dart';
import 'package:dailygurus/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingProvider extends ChangeNotifier {
  List<Product> _productsInCart = [];
  double _cartTotal = 0.0;
  final logger = Logger();
  CartTotal _cartTotalData;
  List<CartItem> _cartItems = [];

  double get cartTotal => _cartTotal;

  set cartTotal(double cartTotal) {
    _cartTotal = cartTotal;
    notifyListeners();
  }

  CartTotal get cartTotalData => _cartTotalData;

  set cartTotalData(CartTotal cartTotal) {
    _cartTotalData = cartTotal;
    notifyListeners();
  }

  List<Product> get productsInCart => _productsInCart;
  set productsInCart(List<Product> updatedProductsInCart) {
    _productsInCart = updatedProductsInCart;
    notifyListeners();
  }

  List<CartItem> get cartItems => _cartItems;

  set cartItems(List<CartItem> updatedProductsInCart) {
    _cartItems = updatedProductsInCart;
    notifyListeners();
  }

  // ADD PRODUCT TO CART
  void incrementProduct(Product selectedProduct, bool isProductInCart,
      BuildContext context, int indexInCart) {
    if (isProductInCart &&
        productsInCart[indexInCart].selectedQuantity >=
            selectedProduct.b2BMinQuantity) {
      var currentCart = productsInCart;
      selectedProduct.selectedQuantity =
          currentCart[indexInCart].selectedQuantity + 1;
      selectedProduct.backendQuantity =
          currentCart[indexInCart].backendQuantity;
      currentCart[indexInCart] = selectedProduct;
      productsInCart = currentCart;
      cartTotal += selectedProduct.b2BPrice;
    } else {
      var currentCart = productsInCart;
      selectedProduct.selectedQuantity = selectedProduct.b2BMinQuantity;
      currentCart.add(selectedProduct);
      productsInCart = currentCart;
      cartTotal += (selectedProduct.b2BPrice * selectedProduct.b2BMinQuantity);
    }
  }

  void decrementProduct(Product selectedProduct, bool isProductInCart,
      BuildContext context, int indexInCart) {
    if (isProductInCart &&
        productsInCart[indexInCart].selectedQuantity >
            selectedProduct.b2BMinQuantity) {
      var currentCart = productsInCart;
      selectedProduct.selectedQuantity =
          currentCart[indexInCart].selectedQuantity - 1;
      selectedProduct.backendQuantity =
          currentCart[indexInCart].backendQuantity;
      currentCart[indexInCart] = selectedProduct;
      productsInCart = currentCart;
      cartTotal -= selectedProduct.b2BPrice;
    } else {
      var currentCart = productsInCart;
      selectedProduct.selectedQuantity = 0;
      if (currentCart[indexInCart].backendQuantity != 0) {
        removeProduct(selectedProduct, true, context, indexInCart);
      }
      currentCart.removeWhere((element) => element.id == selectedProduct.id);
      productsInCart = currentCart;
      cartTotal -= (selectedProduct.b2BPrice * selectedProduct.b2BMinQuantity);
    }
  }

  Future<HTTPResult> removeProduct(Product selectedProduct,
      bool isProductInCart, BuildContext context, int indexInCart) async {
    var currentCart = productsInCart;
    HTTPResult result;
    print(currentCart[indexInCart].backendQuantity);
    if (currentCart[indexInCart].backendQuantity > 0) {
      print("${cartItems.length} <== Cart items length");
      int index = cartItems
          .indexWhere((element) => element.productID == selectedProduct.id);
      CartItem selectedItem = cartItems[index];
      result = await removeItemFromCart(selectedItem);
      if (result.status == ERROR) {
        productsInCart = currentCart;
      } else {
        currentCart.removeAt(index);
        productsInCart = currentCart;
      }
      return result;
    } else {
      currentCart.removeAt(indexInCart);
      productsInCart = currentCart;
      result = HTTPResult(status: SUCCESS, message: 'Cart Updated');
      return result;
    }
  }

  Future<HTTPResult> addToCart(String userID) async {
    var data = [];
    for (var item in productsInCart) {
      var index = item.productVariant
          .indexWhere((element) => element.productType == 'b2b');
      var itemJSON = {
        'product_id': item.id,
        'user_id': userID,
        'qty': item.selectedQuantity - item.backendQuantity,
        'price': item.b2BPrice,
        'varient_id': item.productVariant[index].id,
      };
      print(data);
      data.add(itemJSON);
    }

    final payload = jsonEncode({
      'product_cart': data,
    });

    logger.i(jsonDecode(payload).toString());

    http.Response response;
    try {
      response = await http.post(
        ADD_TO_CART,
        body: payload,
      );
    } catch (e) {
      return HTTPResult(
          status: ERROR, message: 'There was an error while updating the cart');
    }

    logger.i(jsonDecode(response.body)['carttotal'].toString());

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['status'].toString() == "1") {
      final cartTotalJSON =
          jsonDecode(response.body)['carttotal'].cast<String, dynamic>();
      _cartTotalData = CartTotal.fromJson(cartTotalJSON);

      final cartItemsJSON =
          jsonDecode(response.body)['cartitems'].cast<Map<String, dynamic>>();
      List<CartItem> cartItemsData = cartItemsJSON.map<CartItem>((json) {
        return CartItem.fromJson(json);
      }).toList();
      cartItems = cartItemsData;

      for (var item in cartItemsData) {
        Product product = item.product;
        product.backendQuantity = item.qty;
        int index =
            productsInCart.indexWhere((element) => element.id == product.id);
        if (index == -1) {
          product.selectedQuantity = item.qty;
          product.b2BMinQuantity = item.productVariant.b2BMinQuantity;
          product.b2BPrice = item.productVariant.b2BPrice;
          product.productVariant.add(item.productVariant);
          productsInCart.add(product);
        } else {
          productsInCart[index].backendQuantity = item.qty;
        }
      }
      cartItems = cartItemsData;

      return HTTPResult(status: SUCCESS, message: 'Cart updated successfully');
    } else {
      return HTTPResult(
          status: ERROR, message: 'There was an error while updating the cart');
    }
  }

  Future<HTTPResult> removeItemFromCart(CartItem selectedItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userID = prefs.getInt('id').toString();

    http.Response response;
    try {
      response = await http.post(
        DELETE_CART,
        body: jsonEncode(
          {
            'user_id': userID,
            'item_id': selectedItem.id,
          },
        ),
      );
    } catch (e) {
      return HTTPResult(
          status: ERROR, message: 'An unexpected Error Occurred.');
    }

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['status'].toString() == "1") {
      logger.i(jsonDecode(response.body).toString());
      final cartItemsJSON =
          jsonDecode(response.body)['cartitems'].cast<Map<String, dynamic>>();
      List<CartItem> cartItemsData = cartItemsJSON.map<CartItem>((json) {
        return CartItem.fromJson(json);
      }).toList();
      cartItems = cartItemsData;
      final cartTotalJSON =
          jsonDecode(response.body)['carttotal'].cast<String, dynamic>();
      _cartTotalData = CartTotal.fromJson(cartTotalJSON);
      return HTTPResult(
          status: SUCCESS,
          message: '${selectedItem.product.name} Removed from Cart');
    } else if (response.statusCode == 200 &&
        jsonDecode(response.body)['status'].toString() == "0" &&
        jsonDecode(response.body)['message'] == 'Cart is empty') {
      return HTTPResult(
          status: SUCCESS,
          message: '${selectedItem.product.name} Removed from Cart');
    } else {
      logger.e(jsonDecode(response.body).toString());
      return HTTPResult(
          status: ERROR, message: 'There was an error while updating the cart');
    }
  }

  clearCart() {
    productsInCart = [];
    cartTotalData = null;
    cartTotal = 0;
  }

  Future<bool> fetchCartInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String id = prefs.getInt('id').toString();
    print("USER ID =>> " + id);
    http.Response response = await http.post(
      GET_CART,
      body: jsonEncode(
        {'user_id': id},
      ),
    );

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['status'].toString() == "1") {
      final cartTotalJSON =
          jsonDecode(response.body)['carttotal'].cast<String, dynamic>();
      _cartTotalData = CartTotal.fromJson(cartTotalJSON);
      cartTotal = _cartTotalData.isPrice.toDouble();
      final cartItemsJSON =
          jsonDecode(response.body)['cartitems'].cast<Map<String, dynamic>>();

      List<CartItem> cartItemsData = cartItemsJSON.map<CartItem>((json) {
        return CartItem.fromJson(json);
      }).toList();
      cartItems = cartItemsData;
      for (var item in cartItemsData) {
        Product product = item.product;
        product.backendQuantity = item.qty;
        if (!productsInCart.contains(product)) {
          product.selectedQuantity = item.qty;
          product.b2BPrice = item.productVariant.b2BPrice;
          product.b2BMinQuantity = item.productVariant.b2BMinQuantity;
          product.productVariant.add(item.productVariant);
          productsInCart.add(product);
        }
      }
      cartItems = cartItemsData;
      return true;
    } else {
      logger.e(jsonDecode(response.body).toString());
      return false;
    }
  }

  Future<HTTPResult> fetchWalletInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String id = prefs.getInt('id').toString();
    print(id);
    http.Response response = await http.post(
      WALLET_INFO,
      body: jsonEncode(
        {'user_id': id},
      ),
    );

    print(jsonDecode(response.body).toString());

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['status'] == 1) {
      final body = jsonDecode(response.body);
      return HTTPResult(
        status: SUCCESS,
        message: body['message'],
        data: jsonEncode(
          {
            'balance': body['data']['wallet_balance'],
          },
        ),
      );
    } else {
      return HTTPResult(
        status: ERROR,
        message: jsonDecode(response.body)['message'] ??
            'There was a problem while getting the data',
      );
    }
  }

  Future<HTTPResult> addAddress(Address address) async {
    final body = jsonEncode({
      'address': address.address,
      'pincode': address.pinCode,
      'user_id': address.userID,
      'city': address.city.trim(),
      'complex_id': address.complexID,
    });

    http.Response response = await http.post(ADD_ADDRESS, body: body);

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['status'] == 1) {
      logger.i(jsonDecode(response.body));
      return HTTPResult(
          status: SUCCESS, message: 'Address Added Successfully.');
    } else {
      return HTTPResult(status: ERROR, message: 'An error occurred.');
    }
  }

  Future<List<Address>> fetchAddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');

    http.Response response;

    try {
      response = await http.post(
        GET_ADDRESS,
        body: jsonEncode(
          {
            'user_id': id,
          },
        ),
      );
    } catch (e) {
      return null;
    }

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['status'].toString() == "1") {
      final data =
          jsonDecode(response.body)['data'].cast<Map<String, dynamic>>();
      logger.i(data.toString());
      List<Address> addresses = data.map<Address>((json) {
        return Address.fromJson(json);
      }).toList();
      return addresses;
    } else {
      logger.e(jsonDecode(response.body));
      return null;
    }
  }

  Future<HTTPResult> editAddress(Address updatedAddress) async {
    http.Response response;

    try {
      response = await http.post(
        UPDATE_ADDRESS,
        body: jsonEncode(
          {
            'address': updatedAddress.address,
            'pincode': updatedAddress.pinCode,
            'user_address_id': updatedAddress.id,
            'city': updatedAddress.city,
            'complex_id': updatedAddress.complexID,
          },
        ),
      );
    } catch (e) {
      return HTTPResult(
          status: ERROR,
          message: 'There was an error while updating your address.');
    }

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['status'] == "1") {
      logger.i(jsonDecode(response.body).toString());
      return HTTPResult(
          status: SUCCESS, message: 'Address updated successfully');
    } else {
      logger.e(jsonDecode(response.body).toString());
      return HTTPResult(
          status: ERROR,
          message: 'There was an error while updating your address.');
    }
  }

  Future<HTTPResult> initOrder(OrderDetails orderDetails) async {
    final body = jsonEncode({
      'user_pk': orderDetails.userID.toString(),
      'total_price': _cartTotalData.isPrice,
      'discount': orderDetails.discount,
      'shipping_method': orderDetails.shippingMethod ?? "",
      'coupon_id': orderDetails.couponID,
      'shipping_amount': orderDetails.shippingAmount,
      'payment_method': orderDetails.paymentMethod,
      'address_id': orderDetails.addressID,
      'cart_id': _cartTotalData.id,
    });

    logger.e(body.toString());

    http.Response response = await http.post(GET_ORDER, body: body);

    print(response.reasonPhrase);

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['status'].toString() == "1") {
      final body = jsonDecode(response.body);
      final data = body['data'];
      logger.i(data.toString());
      return HTTPResult(
        status: SUCCESS,
        message: body['message'],
        data: jsonEncode({
          'order_id': data['id'],
          'user_id': data['user_id'],
          'status': data['status'],
          'grand_total': data['grand_total'],
          'payment_mode': data['payment_mode'],
        }),
      );
    } else {
      logger.i(jsonDecode(response.body).toString());
      return HTTPResult(
        status: ERROR,
        message: jsonDecode(response.body)['message'] ?? 'An error occurred',
      );
    }
  }

  Future<HTTPResult> paymentResponse(
      String orderID, String paymentID, String userID) async {
    print("PAYMENT Details =>>>>> Order ID: " +
        orderID +
        "  Payment ID: " +
        paymentID);
    final payload = jsonEncode({
      'user_id': userID,
      'razorpay_payment_id': paymentID,
    });
    print(payload.toString());
    http.Response response = await http.post(
      PAYMENT_CONFIRM,
      body: payload,
    );
    logger.i(payload.toString());
    logger.e(response.reasonPhrase);
    logger.i(response.body.toString());

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['status'].toString() == "1") {
      return HTTPResult(
        status: SUCCESS,
        message: jsonDecode(response.body)['message'],
      );
    } else {
      return HTTPResult(
        status: ERROR,
        message: jsonDecode(response.body)['message'] ?? 'There was an error',
      );
    }
  }
}
