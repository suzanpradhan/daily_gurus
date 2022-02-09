import 'package:dailygurus/constants.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderCancelledTimeline extends StatelessWidget {
  const OrderCancelledTimeline({
    @required this.orderRecievedColor,
    @required this.orderCancelledColor,
    @required this.orderRefundedColor,
  });

  final Color orderRecievedColor;
  final Color orderCancelledColor;
  final Color orderRefundedColor;

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
            color: orderCancelledColor,
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
                  'Order Cancelled',
                  style:
                      kTimelineTextStyle.copyWith(color: orderCancelledColor),
                ),
              ],
            ),
          ),
          indicatorStyle: IndicatorStyle(
            color: orderCancelledColor,
            width: 20.0,
          ),
          topLineStyle: LineStyle(
            color: orderCancelledColor,
          ),
          bottomLineStyle: LineStyle(
            color: orderRefundedColor,
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
                  'Refunded',
                  style: kTimelineTextStyle.copyWith(color: orderRefundedColor),
                ),
              ],
            ),
          ),
          indicatorStyle: IndicatorStyle(
            color: orderRefundedColor,
            width: 20.0,
          ),
          topLineStyle: LineStyle(
            color: orderRefundedColor,
          ),
          isLast: true,
        ),
      ],
    );
  }
}
