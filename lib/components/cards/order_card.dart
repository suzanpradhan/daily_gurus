import 'package:dailygurus/components/timelines/order_cancelled_timeline.dart';
import 'package:dailygurus/components/timelines/order_complete_timeline.dart';
import 'package:dailygurus/constants.dart';
import 'package:dailygurus/models/order.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  OrderCard({
    @required this.order,
    @required this.status,
    @required this.formattedDate,
    @required this.openTracking,
    @required this.closeTracking,
    @required this.isTrackOrdersOpen,
    @required this.orderRecievedColor,
    @required this.orderPackedColor,
    @required this.outForDeliveryColor,
    @required this.deliveredColor,
    @required this.orderCancelledColor,
    @required this.orderRefundedColor,
  });

  final OrderData order;
  final String status;
  final String formattedDate;
  final Function openTracking;
  final Function closeTracking;
  final bool isTrackOrdersOpen;
  final Color orderRecievedColor;
  final Color orderPackedColor;
  final Color outForDeliveryColor;
  final Color deliveredColor;
  final Color orderCancelledColor;
  final Color orderRefundedColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 8.0, 8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Order # ${order.orderID}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: kColorPureBlack,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Text(
                        'Amount ₹ ${order.grandTotal}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: kColorPureBlack,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.fiber_manual_record,
                            color: order.status == ORDER_STATUS_RECIEVED
                                ? kColorWelcomeText
                                : Colors.orangeAccent[700],
                            size: 15.0,
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            '$status',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: kColorLightGrey,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        '$formattedDate',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: kColorPureBlack,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      RaisedButton(
                        child: Text("Track Order"),
                        onPressed: openTracking,
                        color: Colors.orangeAccent[700],
                        textColor: kColorWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50.0),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              isTrackOrdersOpen == true
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10.0),
                          Text(
                            'Your Order Details',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: kColorLightGrey,
                            ),
                          ),
                          SizedBox(height: 15.0),
                          order.status == ORDER_STATUS_CANCELLED ||
                                  order.status == ORDER_STATUS_REFUNDED
                              ? OrderCancelledTimeline(
                                  orderRecievedColor: orderRecievedColor,
                                  orderCancelledColor: orderCancelledColor,
                                  orderRefundedColor: orderRefundedColor,
                                )
                              : OrderCompleteTimeline(
                                  orderRecievedColor: orderRecievedColor,
                                  orderPackedColor: orderPackedColor,
                                  outForDeliveryColor: outForDeliveryColor,
                                  deliveredColor: deliveredColor,
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(
                                onPressed: closeTracking,
                                child: Text('Close'),
                                textColor: Colors.redAccent,
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
