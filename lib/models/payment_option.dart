import 'package:dailygurus/components/fonts/custom_icons_icons.dart';
import 'package:flutter/material.dart';

const String PAYMENT_OPTION_CC = 'CC';
const String PAYMENT_OPTION_COD = 'COD';
const String PAYMENT_OPTION_WALLET = 'WALLET';

class PaymentOption {
  final String paymentType;
  final String menuName;
  final IconData icon;

  PaymentOption(
      {@required this.paymentType,
      @required this.menuName,
      @required this.icon});
}

List<PaymentOption> paymentOptions = <PaymentOption>[
  PaymentOption(
    paymentType: PAYMENT_OPTION_CC,
    menuName: 'Debit Cart/Credit Card/NetBanking',
    icon: Icons.credit_card,
  ),
  PaymentOption(
    paymentType: PAYMENT_OPTION_COD,
    menuName: 'Pay on Delivery',
    icon: CustomIcons.pay,
  ),
  PaymentOption(
    paymentType: PAYMENT_OPTION_WALLET,
    menuName: 'Pay from Wallet',
    icon: CustomIcons.wallet,
  ),
];
