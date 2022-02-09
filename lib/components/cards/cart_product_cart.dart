import 'package:cached_network_image/cached_network_image.dart';
import 'package:dailygurus/components/fonts/custom_icons_icons.dart';
import 'package:dailygurus/constants.dart';
import 'package:flutter/material.dart';

class CartProductCard extends StatelessWidget {
  final String imageURL;
  final String title;
  final String weight;
  final String price;
  final int currentQuantity;
  final VoidCallback incrementProductInCart;
  final VoidCallback decrementProductInCart;
  final VoidCallback removeFromCart;
  final bool isDecrementDisabled;

  CartProductCard({
    this.imageURL,
    this.title,
    this.weight,
    this.price,
    this.currentQuantity,
    this.incrementProductInCart,
    this.decrementProductInCart,
    this.isDecrementDisabled,
    this.removeFromCart,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3.0,
        child: Container(
          height: 120.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
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
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            this.title,
                          ),
                          Text('${this.weight} Kg'),
                          Text('₹ ${this.price}'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 8.0,
                        top: 4.0,
                        bottom: 10.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              CustomIcons.trash,
                              size: 20.0,
                            ),
                            onPressed: () => this.removeFromCart(),
                            color: kColorRed,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: kColorLightGrey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            child: Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => this.decrementProductInCart(),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        4.0, 4.0, 10.0, 4.0),
                                    child: Icon(
                                      Icons.remove,
                                      color: kColorDGrey,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${this.currentQuantity}',
                                  style: TextStyle(
                                    color: kColorPureBlack,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => this.incrementProductInCart(),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 4.0, 4.0, 4.0),
                                    child: Icon(
                                      Icons.add,
                                      color: kColorLightGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
