// ignore_for_file: prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:mmanage/backend/planning_service.dart';
import 'package:mmanage/constants/colors.dart';
import 'package:mmanage/constants/styles.dart';
import 'package:provider/provider.dart';
import 'credit_card_form.dart';
import 'credit_cards_ui.dart';

class CardsManage extends StatefulWidget {
  const CardsManage({Key? key}) : super(key: key);

  @override
  State<CardsManage> createState() => _CardsManageState();
}

class _CardsManageState extends State<CardsManage> {
  openForm() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CreditCardFormPage()));
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<PlanningService>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "My Cards",
                style: Styles.textDecoration(color: Colors.black87),
              ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: openForm,
                    child: Text(
                      "+ Add ",
                      style: Styles.textDecoration(color: AppTheme.filler),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 1,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, index) => Cards(
              
              cardNumber: data.cards[index]['cardNumber'],
              cvvNumber: data.cards[index]['cvvCode'],
              expireDate: data.cards[index]['expiryDate'],
              cardholderName: data.cards[index]['cardHolderName'],
            ),
            itemCount: data.cards.length,
          ),
        ),
      ],
    );
  }
}
