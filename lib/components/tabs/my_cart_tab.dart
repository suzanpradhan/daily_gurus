import 'package:dailygurus/components/cards/cart_product_cart.dart';
import 'package:dailygurus/constants.dart';
import 'package:dailygurus/constants/api_constants.dart';
import 'package:dailygurus/constants/route_constants.dart';
import 'package:dailygurus/models/auth.dart';
import 'package:dailygurus/models/http_result.dart';
import 'package:dailygurus/models/product.dart';
import 'package:dailygurus/providers/shopping_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class MyCartTab extends StatefulWidget {
  @override
  _MyCartTabState createState() => _MyCartTabState();
}

class _MyCartTabState extends State<MyCartTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ShoppingProvider shoppingProvider =
        Provider.of<ShoppingProvider>(context);
    return shoppingProvider.productsInCart.length == 0
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/icons/empty-cart.png',
                    height: 80.0,
                    width: 80.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Empty Cart',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: kColorDGrey,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'Your cart is currently empty.',
                    style: TextStyle(
                      color: kColorDGrey,
                      fontSize: 16.0,
                    ),
                  )
                ],
              ),
            ],
          )
        : Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: shoppingProvider.productsInCart.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        Product item = shoppingProvider.productsInCart[index];
                        return CartProductCard(
                          imageURL: item.isImage,
                          title: item.name,
                          weight: item.selectedQuantity.toString(),
                          price: item.b2BPrice.toString(),
                          currentQuantity: item.selectedQuantity,
                          incrementProductInCart: () {
                            shoppingProvider.incrementProduct(
                              item,
                              true,
                              context,
                              index,
                            );
                          },
                          decrementProductInCart: () {
                            shoppingProvider.decrementProduct(
                              item,
                              true,
                              context,
                              index,
                            );
                          },
                          removeFromCart: () async {
                            HTTPResult result =
                                await shoppingProvider.removeProduct(
                              item,
                              true,
                              context,
                              index,
                            );
                            if (result.status == SUCCESS) {
                              Toast.show(
                                  '${item.name} Removed from Cart', context);
                              setState(() {});
                            } else {
                              Toast.show(
                                  'Error removing from cart. Please check your internet connection.',
                                  context);
                              setState(() {});
                            }
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: kColorLightGreen,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: Text(
                          'Cart Total: ₹${shoppingProvider.cartTotal ?? 0}',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: kColorWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          final loginStatus =
                              prefs.getBool('login_status') ?? false;
                          if (loginStatus == true) {
                            Navigator.of(context).pushNamed(CHECKOUT_ROUTE);
                          } else {
                            Navigator.pushNamed(
                              context,
                              LOGIN_ROUTE,
                              arguments: AuthArguments(
                                rootRoute: CHECKOUT_ROUTE,
                              ),
                            );
                          }
                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Checkout',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: kColorWhite,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: kColorWhite,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
  }
}
