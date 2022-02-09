import 'dart:convert';

import 'package:dailygurus/constants/api_constants.dart';
import 'package:dailygurus/models/category.dart';
import 'package:dailygurus/models/http_result.dart';
import 'package:dailygurus/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ProductsProvider extends ChangeNotifier {
  List<Product> _products = [];
  var logger = Logger();
  int _pageNumber = 0;
  bool hasMoreData = true;

  Category allCategory = Category(
      id: 0,
      code: "",
      name: "All",
      image: "assets/images/all-vegetables.jpg",
      status: "ACTIVE",
      isMenu: 0,
      createdAt: "",
      updatedAt: "",
      isImage: null);
  List<Category> _categories = [
    Category(
        id: 0,
        code: "",
        name: "All",
        image: "assets/images/all-vegetables.jpg",
        status: "ACTIVE",
        isMenu: 0,
        createdAt: "",
        updatedAt: "",
        isImage: null),
  ];

  set products(List<Product> products) {
    _products = products;
    notifyListeners();
  }

  List<Product> get products => _products;

  set categories(List<Category> categories) {
    _categories = categories;
    notifyListeners();
  }

  int get pageNumber => _pageNumber;

  set pageNumber(int pageNumber) {
    _pageNumber = pageNumber;
    notifyListeners();
  }

  List<Category> get categories => _categories;

  Future<List<Product>> fetchProducts() async {
    http.Response response;
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-type": "application/x-www-form-urlencoded",
    };
    try {
      response = await http.post(
        GET_PRODUCTS,
        headers: headers,
        encoding: Encoding.getByName("utf-8"),
      );
    } catch (e) {
      print("ERROR" + e.toString());
      return null;
    }

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['status'] == 1) {
      final productsJSON =
          jsonDecode(response.body)['data'].cast<Map<String, dynamic>>();
      List<Product> productList = productsJSON.map<Product>((json) {
        return Product.fromJson(json);
      }).toList();
      List<Product> b2bList = [];
      productList.forEach((product) {
        bool done = false;
        product.productVariant.forEach((varient) {
          if (varient.productType == 'b2b' && done == false) {
            product.b2BPrice = varient.b2BPrice;
            product.b2BMinQuantity = varient.b2BMinQuantity;
            b2bList.add(product);
            done = true;
          }
        });
      });

      _products.addAll(b2bList);

      return b2bList;
    } else {
      print(response.body.toString());
      print("ERROR");
      return null;
    }
  }

  Future<HTTPResult> fetchCategories() async {
    http.Response response;
    try {
      response = await http.post(GET_CATEGORIES);
    } catch (e) {
      return HTTPResult(
          status: ERROR, message: 'Error while getting categories.');
    }

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['status'].toString() == "1") {
      final categoryJSON =
          jsonDecode(response.body)['data'].cast<Map<String, dynamic>>();
      List<Category> categoryList = categoryJSON.map<Category>((json) {
        return Category.fromJson(json);
      }).toList();
      _categories = [allCategory] + categoryList;
      return HTTPResult(status: SUCCESS, message: 'Success!');
    } else {
      return HTTPResult(
        status: ERROR,
        message: jsonDecode(response.body).toString() ??
            "Error while getting categories.",
      );
    }
  }
}
