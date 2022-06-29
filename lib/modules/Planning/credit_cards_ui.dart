import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

class Cards extends StatelessWidget {
  const Cards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CreditCardWidget(
      cardNumber: "5450 7879 4864 7854",
      expiryDate: "10/25",
      cardHolderName: "Surendra Vadaparthy",
      cvvCode: "2343",
      showBackView: false,
      cardType: CardType.visa,
      isHolderNameVisible: true,
      cardBgColor: Colors.red,
      isSwipeGestureEnabled: true,
      onCreditCardWidgetChange:
          (CreditCardBrand) {}, //true when you want to show cvv(back) view
    );
  }
}
