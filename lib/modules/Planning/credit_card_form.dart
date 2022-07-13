// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:mmanage/backend/planning_service.dart';
import 'package:mmanage/constants/colors.dart';
import 'package:mmanage/constants/styles.dart';
import 'package:provider/provider.dart';

class CreditCardFormPage extends StatefulWidget {
  const CreditCardFormPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MySampleState();
  }
}

class MySampleState extends State<CreditCardFormPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  onSubmit() async {
    String response =
        await Provider.of<PlanningService>(context, listen: false).addCard({
      "cardNumber": cardNumber,
      "expiryDate": expiryDate,
      "cardHolderName": cardHolderName,
      "cvvCode": cvvCode
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response)),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.filler,
        title: Text(
          "Create a card",
          style: Styles.textDecoration(color: AppTheme.primaryText),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CreditCardForm(
                    formKey: formKey,
                    obscureCvv: false,
                    obscureNumber: false,
                    cardNumber: cardNumber,
                    cvvCode: cvvCode,
                    isHolderNameVisible: true,
                    isCardNumberVisible: true,
                    isExpiryDateVisible: true,
                    cardHolderName: cardHolderName,
                    expiryDate: expiryDate,
                    themeColor: Colors.blue,
                    textColor: AppTheme.filler,
                    cardNumberDecoration:
                        Styles.inputDecoration("Enter card number"),
                    expiryDateDecoration:
                        Styles.inputDecoration("Enter expiry date"),
                    cvvCodeDecoration: Styles.inputDecoration("Enter cvv"),
                    cardHolderDecoration:
                        Styles.inputDecoration("Enter cardholder name"),
                    onCreditCardModelChange: onCreditCardModelChange,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      primary: AppTheme.filler,
                    ),
                    onPressed: onSubmit,
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      child: Text(
                        'Add card',
                        style:
                            Styles.textDecoration(color: AppTheme.primaryText),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
