import 'package:dailygurus/components/cards/category_card.dart';
import 'package:dailygurus/components/cards/product_card.dart';
import 'package:dailygurus/constants.dart';
import 'package:dailygurus/constants/api_constants.dart';
import 'package:dailygurus/models/http_result.dart';
import 'package:dailygurus/models/product.dart';
import 'package:dailygurus/providers/products_provider.dart';
import 'package:dailygurus/providers/shopping_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class ProductsListTab extends StatefulWidget {
  @override
  _ProductsListTabState createState() => _ProductsListTabState();
}

class _ProductsListTabState extends State<ProductsListTab> {
  bool _isLoading = true;
  bool _isCategoriesLoading = true;
  bool _hasError = false;
  bool _isLoadingMore = false;
  List<Product> _products;
  ScrollController _scrollController = ScrollController();
  final logger = Logger();
  int _categoryIndex = 0;
  int _selectedCategoryID = 0;

  fetchData() async {
    HTTPResult result =
        await Provider.of<ProductsProvider>(context, listen: false)
            .fetchCategories();
    if (result.status == SUCCESS) {
      setState(() {
        _isCategoriesLoading = false;
      });
    }
    List<Product> products =
        await Provider.of<ProductsProvider>(context, listen: false)
            .fetchProducts();
    if (products != null) {
      setState(() {
        _isLoading = false;
        _hasError = false;
      });
      if (_categoryIndex == 0) {
        setState(() {
          _products = products;
        });
      } else {
        var filtered = products
            .where((element) =>
                element.productCategory.categoryID == _selectedCategoryID)
            .toList();
        setState(() {
          _products = filtered;
        });
        print("LENGTH " + filtered.length.toString());
      }
    } else {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  handleCategoryChange(int index, int categoryID) async {
    setState(() {
      _selectedCategoryID = categoryID;
      _isLoading = true;
      _hasError = false;
      _products = [];
    });
    Provider.of<ProductsProvider>(context, listen: false).pageNumber = 0;
    List<Product> products =
        await Provider.of<ProductsProvider>(context, listen: false)
            .fetchProducts();
    if (products != null) {
      setState(() {
        _isLoading = false;
        _hasError = false;
      });
      if (_categoryIndex == 0) {
        setState(() {
          _products = products;
        });
      } else {
        var filtered = products
            .where((element) =>
                element.productCategory.categoryID == _selectedCategoryID)
            .toList();
        setState(() {
          _products = filtered;
        });
        print("LENGTH " + filtered.length.toString());
      }
    } else {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ShoppingProvider shoppingProvider =
        Provider.of<ShoppingProvider>(context);
    final ProductsProvider productsProvider =
        Provider.of<ProductsProvider>(context);
    return Stack(
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            this._isLoading == false && this._hasError == false
                ? Flexible(
                    child: ListView.builder(
                      itemCount: _products.length + 1,
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return SizedBox(
                            height: 155.0,
                          );
                        }
                        if (index <= _products.length) {
                          print(index);
                          Product product = _products[index - 1];
                          int indexInCart = -1;
                          try {
                            indexInCart = shoppingProvider.productsInCart
                                .indexWhere(
                                    (element) => element.id == product.id);
                          } catch (e) {
                            indexInCart = -1;
                          }
                          bool isProductInCart =
                              indexInCart == -1 ? false : true;
                          int currentQuantity = isProductInCart
                              ? shoppingProvider
                                  .productsInCart[indexInCart].selectedQuantity
                              : 0;
                          return ProductCard(
                            imageURL: product.isImage,
                            title: product.name,
                            weight: product.weight.toString(),
                            price: product.b2BPrice.toDouble(),
                            currentQuantity: currentQuantity,
                            minQty: product.b2BMinQuantity.toString(),
                            incrementProductInCart: () {
                              shoppingProvider.incrementProduct(product,
                                  isProductInCart, context, indexInCart);
                            },
                            decrementProductInCart: () {
                              shoppingProvider.decrementProduct(product,
                                  isProductInCart, context, indexInCart);
                            },
                            isDecrementDisabled: !isProductInCart,
                          );
                        } else if (this._isLoadingMore) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Center(
                              child: Text(
                                'You have reached the end of this list',
                                style: kProximaStyle.copyWith(fontSize: 14.0),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  )
                : this._isLoading == false && this._hasError == true
                    ? ErrorMessage(
                        retry: () {
                          setState(() {
                            _isLoading = true;
                          });
                          fetchData();
                        },
                      )
                    : LoadingIndicator(),
          ],
        ),
        this._isCategoriesLoading == false && this._hasError == false
            ? Container(
                width: double.infinity,
                height: 150.0,
                decoration: BoxDecoration(
                  color: kColorWhite,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: kColorGrey,
                        offset: Offset(2.0, 2.0),
                        blurRadius: 5.0),
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(5.0),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 12.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: productsProvider.categories.length,
                      itemBuilder: (context, index) {
                        return CategoryCard(
                          categoryChanged: () {
                            if (index != _categoryIndex) {
                              setState(() {
                                _categoryIndex = index;
                                _selectedCategoryID =
                                    productsProvider.categories[index].id;
                              });
                              handleCategoryChange(index, _selectedCategoryID);
                            }
                          },
                          name: productsProvider.categories[index].name,
                          categoryIndex: _categoryIndex,
                          index: index,
                          isImage:
                              productsProvider.categories[index].isImage == ""
                                  ? null
                                  : productsProvider.categories[index].isImage,
                          image: productsProvider.categories[index].image,
                        );
                      },
                    ),
                  ),
                ),
              )
            : SizedBox()
      ],
    );
  }
}

class ErrorMessage extends StatelessWidget {
  final Function retry;

  ErrorMessage({this.retry});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              'assets/icons/fault.png',
              height: 80.0,
              width: 80.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Unable to fetch data.\nPlease check your network connection.',
                textAlign: TextAlign.center,
                style: kProximaStyle.copyWith(
                  color: kColorGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              color: kColorLightGreen,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Tap to Retry!",
                  style: kProximaStyle.copyWith(
                    color: kColorWhite,
                    fontSize: 18.0,
                  ),
                ),
              ),
              onPressed: this.retry,
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
