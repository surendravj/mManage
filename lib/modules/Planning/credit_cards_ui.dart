// ignore_for_file: non_constant_identifier_names, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:mmanage/constants/colors.dart';

class Cards extends StatelessWidget {
  Cards(
      {Key? key,
      required this.cardNumber,
      required this.cvvNumber,
      required this.expireDate,
      required this.cardholderName,
      this.cardType = "visa3",
      this.cardTheme = "default"});

  final String cardNumber;
  final String cvvNumber;
  final String expireDate;
  final String cardholderName;
  final String cardType;
  final String cardTheme;

  Color getCardTheme() {
    if (cardTheme == "default") {
      return AppTheme.filler;
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CreditCardWidget(
      cardNumber: cardNumber,
      expiryDate: expireDate,
      cardHolderName: cardholderName,
      cvvCode: cvvNumber,
      showBackView: false,
      obscureCardNumber: false,
      obscureCardCvv: false,
      cardType: CardType.visa,
      isHolderNameVisible: true,
      cardBgColor: getCardTheme(),
      isSwipeGestureEnabled: true,
      onCreditCardWidgetChange:
          (CreditCardBrand) {}, //true when you want to show cvv(back) view
    );
  }
}
