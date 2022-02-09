import 'package:cached_network_image/cached_network_image.dart';
import 'package:dailygurus/constants.dart';
import 'package:dailygurus/constants/api_constants.dart';
import 'package:dailygurus/models/cart.dart';
import 'package:dailygurus/models/http_result.dart';
import 'package:dailygurus/models/order.dart';
import 'package:dailygurus/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailsScreen extends StatefulWidget {
  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _isLoading = true, _hasError = false;
  String _userName = "";

  void getItems() async {
    final OrderRouteArguments args = ModalRoute.of(context).settings.arguments;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('name');
    });
    Provider.of<OrdersProvider>(context, listen: false).orderItems = [];
    HTTPResult result =
        await Provider.of<OrdersProvider>(context, listen: false)
            .getOrderDetails(args.id);
    if (result.status == SUCCESS) {
      setState(() {
        _isLoading = false;
        _hasError = false;
      });
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
    Future.delayed(Duration.zero, this.getItems);
  }

  @override
  Widget build(BuildContext context) {
    final OrderRouteArguments args = ModalRoute.of(context).settings.arguments;
    final OrdersProvider ordersProvider = Provider.of<OrdersProvider>(context);
    final OrderData order = ordersProvider.orders[args.index];
    String formattedDate;
    final format = DateFormat('MMM d, y');
    DateTime parseDt = DateTime.parse(order.orderDate);
    formattedDate = format.format(parseDt);
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 8.0, 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'Order #',
                      style: kOrdersTitleStyle,
                    ),
                    Text(
                      ' ${order.orderID}',
                      style: kOrdersTitleStyle.copyWith(color: kColorLightGrey),
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  children: <Widget>[
                    Text(
                      'Order Placed at',
                      style: kOrdersTitleStyle,
                    ),
                    Text(
                      ' $formattedDate',
                      style: kOrdersTitleStyle.copyWith(color: kColorLightGrey),
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  children: <Widget>[
                    Text(
                      'Name of the Customer',
                      style: kOrdersTitleStyle,
                    ),
                    Text(
                      ' $_userName',
                      style: kOrdersTitleStyle.copyWith(color: kColorLightGrey),
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Delivery Address:',
                      style: kOrdersTitleStyle,
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      '${order.orderAddress.address}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: kColorLightGrey,
                      ),
                    ),
                    Text(
                      '${order.orderAddress.city} - ${order.orderAddress.pinCode}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: kColorBlack,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  children: <Widget>[
                    Text(
                      'Total Price ₹',
                      style: kOrdersTitleStyle,
                    ),
                    Text(
                      ' ${order.grandTotal}',
                      style: kOrdersTitleStyle.copyWith(color: kColorLightGrey),
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Text(
                  'Purchased Items:',
                  style: kOrdersTitleStyle,
                ),
                this._isLoading == false && this._hasError == false
                    ? Expanded(
                        child: ListView.builder(
                            itemCount: ordersProvider.orderItems.length,
                            itemBuilder: (context, index) {
                              CartItem item = ordersProvider.orderItems[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    CachedNetworkImage(
                                      imageUrl: '${item.product.isImage}',
                                      height: 120.0,
                                      width: 120.0,
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              Container(
                                        width: 120.0,
                                        height: 120.0,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/icons/vegetable.png',
                                        height: 120,
                                        width: 120,
                                      ),
                                    ),
                                    SizedBox(width: 10.0),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          '${item.product.name}',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        SizedBox(height: 20.0),
                                        Text(
                                          '₹ ${item.price} x ${item.qty}',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                      )
                    : Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
