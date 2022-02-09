import 'package:dailygurus/components/cards/order_card.dart';
import 'package:dailygurus/constants.dart';
import 'package:dailygurus/constants/api_constants.dart';
import 'package:dailygurus/constants/route_constants.dart';
import 'package:dailygurus/models/http_result.dart';
import 'package:dailygurus/models/order.dart';
import 'package:dailygurus/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = true, _hasError = false;
  String _errorMessage;
  List<OrderData> _orders;

  getOrders() async {
    HTTPResult result =
        await Provider.of<OrdersProvider>(context, listen: false)
            .getUserOrders();

    _orders = Provider.of<OrdersProvider>(context, listen: false).orders;

    if (result.status == SUCCESS) {
      setState(() {
        _isLoading = false;
        _hasError = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = result.message;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    this.getOrders();
  }

  @override
  Widget build(BuildContext context) {
    final OrdersProvider ordersProvider = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: this._isLoading == false && this._hasError == false
          ? ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                OrderData order = _orders[index];
                String status;
                if (order.status == ORDER_STATUS_RECIEVED) {
                  status = 'Order Confirmed';
                } else {
                  status = 'Order Under Process';
                }
                Color orderRecievedColor = kColorLightGrey;
                Color orderPackedColor = kColorLightGrey;
                Color outForDeliveryColor = kColorLightGrey;
                Color deliveredColor = kColorLightGrey;
                Color orderCancelledColor = kColorLightGrey;
                Color orderRefundedColor = kColorLightGrey;
                switch (order.status) {
                  case ORDER_STATUS_PROCESSING:
                    orderRecievedColor = kColorWelcomeText;
                    break;
                  case ORDER_STATUS_RECIEVED:
                    orderRecievedColor = kColorWelcomeText;
                    orderPackedColor = kColorWelcomeText;
                    break;
                  case ORDER_STATUS_DISPATCHED:
                    orderRecievedColor = kColorWelcomeText;
                    orderPackedColor = kColorWelcomeText;
                    outForDeliveryColor = kColorWelcomeText;
                    break;
                  case ORDER_STATUS_DELIVERED:
                    orderRecievedColor = kColorWelcomeText;
                    orderPackedColor = kColorWelcomeText;
                    outForDeliveryColor = kColorWelcomeText;
                    deliveredColor = kColorWelcomeText;
                    break;
                  case ORDER_STATUS_CANCELLED:
                    orderRecievedColor = kColorWelcomeText;
                    orderCancelledColor = kColorWelcomeText;
                    break;
                  case ORDER_STATUS_REFUNDED:
                    orderRecievedColor = kColorWelcomeText;
                    orderCancelledColor = kColorWelcomeText;
                    orderRefundedColor = kColorWelcomeText;
                    break;
                  default:
                }
                String formattedDate;
                final format = DateFormat('MMM d, y');
                DateTime parseDt = DateTime.parse(order.orderDate);
                formattedDate = format.format(parseDt);
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      ORDER_DETAILS_ROUTE,
                      arguments: OrderRouteArguments(
                        id: order.id,
                        index: index,
                      ),
                    );
                  },
                  child: OrderCard(
                      order: order,
                      status: status,
                      formattedDate: formattedDate,
                      isTrackOrdersOpen:
                          ordersProvider.orders[index].isTrackOrdersOpen,
                      openTracking: () {
                        setState(() {
                          ordersProvider.orders[index].isTrackOrdersOpen = true;
                        });
                      },
                      closeTracking: () {
                        setState(() {
                          ordersProvider.orders[index].isTrackOrdersOpen =
                              false;
                        });
                      },
                      orderRecievedColor: orderRecievedColor,
                      orderPackedColor: orderPackedColor,
                      outForDeliveryColor: outForDeliveryColor,
                      deliveredColor: deliveredColor,
                      orderCancelledColor: orderCancelledColor,
                      orderRefundedColor: orderRefundedColor),
                );
              },
            )
          : this._isLoading == false && this._hasError == true
              ? Column(
                  children: <Widget>[
                    Expanded(
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
                              onPressed: () {
                                this.getOrders();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
    );
  }
}
