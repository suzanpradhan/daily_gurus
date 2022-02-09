import 'package:dailygurus/constants.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderCompleteTimeline extends StatelessWidget {
  OrderCompleteTimeline({
    @required this.orderRecievedColor,
    @required this.orderPackedColor,
    @required this.outForDeliveryColor,
    @required this.deliveredColor,
  });

  final Color orderRecievedColor;
  final Color orderPackedColor;
  final Color outForDeliveryColor;
  final Color deliveredColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TimelineTile(
          alignment: TimelineAlign.left,
          isFirst: true,
          rightChild: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Order Recieved',
                  style: kTimelineTextStyle.copyWith(color: orderRecievedColor),
                ),
              ],
            ),
          ),
          indicatorStyle: IndicatorStyle(
            color: orderRecievedColor,
            width: 20.0,
          ),
          topLineStyle: LineStyle(
            color: orderRecievedColor,
          ),
          bottomLineStyle: LineStyle(
            color: orderPackedColor,
          ),
        ),
        TimelineTile(
          alignment: TimelineAlign.left,
          rightChild: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Order Packed',
                  style: kTimelineTextStyle.copyWith(color: orderPackedColor),
                ),
              ],
            ),
          ),
          indicatorStyle: IndicatorStyle(
            color: orderPackedColor,
            width: 20.0,
          ),
          topLineStyle: LineStyle(
            color: orderPackedColor,
          ),
          bottomLineStyle: LineStyle(
            color: outForDeliveryColor,
          ),
        ),
        TimelineTile(
          alignment: TimelineAlign.left,
          rightChild: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Out for delivery',
                  style:
                      kTimelineTextStyle.copyWith(color: outForDeliveryColor),
                ),
              ],
            ),
          ),
          indicatorStyle: IndicatorStyle(
            color: outForDeliveryColor,
            width: 20.0,
          ),
          topLineStyle: LineStyle(
            color: outForDeliveryColor,
          ),
          bottomLineStyle: LineStyle(
            color: deliveredColor,
          ),
        ),
        TimelineTile(
          alignment: TimelineAlign.left,
          rightChild: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Delivered',
                  style: kTimelineTextStyle.copyWith(color: deliveredColor),
                ),
              ],
            ),
          ),
          indicatorStyle: IndicatorStyle(
            color: deliveredColor,
            width: 20.0,
          ),
          topLineStyle: LineStyle(
            color: deliveredColor,
          ),
          isLast: true,
        ),
      ],
    );
  }
}
