import 'package:cached_network_image/cached_network_image.dart';
import 'package:dailygurus/constants.dart';
import 'package:dailygurus/models/product.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String imageURL;
  final String title;
  final String weight;
  final double price;
  final String minQty;
  final int currentQuantity;
  final VoidCallback incrementProductInCart;
  final VoidCallback decrementProductInCart;
  final Product currentProduct;
  final bool isDecrementDisabled;

  ProductCard({
    @required this.imageURL,
    @required this.title,
    @required this.weight,
    @required this.price,
    @required this.minQty,
    @required this.currentQuantity,
    this.incrementProductInCart,
    this.decrementProductInCart,
    this.currentProduct,
    this.isDecrementDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: '${this.imageURL}',
              height: 120.0,
              width: 120.0,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Container(
                width: 120.0,
                height: 120.0,
                child: Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress),
                ),
              ),
              errorWidget: (context, url, error) => Image.asset(
                'assets/icons/vegetable.png',
                height: 120,
                width: 120,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Text(
                      '${this.title}',
                      style: kProximaStyle.copyWith(
                        fontSize: 22.0,
                        color: kColorPureBlack,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Min. Qty.: ${this.minQty.toString() ?? '10.0'}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: kColorRed,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              '${this.price.toString() ?? '10.0'}/Kg',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: kColorRed,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'Cost: ₹ ${(this.price * this.currentQuantity).toString() ?? '0'}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: kColorRed,
                              ),
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 10.0),
                                child: GestureDetector(
                                  onTap: () => this.decrementProductInCart(),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      border: Border.all(
                                        width: 1.0,
                                        color: isDecrementDisabled == true
                                            ? Colors.grey[300]
                                            : kColorDGrey,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Icon(
                                        Icons.remove,
                                        size: 27.0,
                                        color: isDecrementDisabled == true
                                            ? Colors.grey[300]
                                            : kColorDGrey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                '${this.currentQuantity.toString()}',
                                style: TextStyle(
                                  color: kColorPureBlack,
                                  fontSize: 16.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 5.0),
                                child: GestureDetector(
                                  onTap: () => this.incrementProductInCart(),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      border: Border.all(
                                        width: 1.0,
                                        color: kColorLightGrey,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Icon(
                                        Icons.add,
                                        size: 27.0,
                                        color: kColorLightGreen,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        Divider(
          thickness: 1.0,
          color: kColorGrey,
        ),
      ],
    );
  }
}
