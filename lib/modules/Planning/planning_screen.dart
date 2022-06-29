// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:mmanage/backend/planning_service.dart';
import 'package:mmanage/constants/styles.dart';
import 'package:mmanage/constants/util.dart';
import 'package:mmanage/modules/Planning/cards_manage.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import 'planning_card.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({Key? key}) : super(key: key);

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  @override
  Widget build(BuildContext context) {
    var planning = Provider.of<PlanningService>(context);
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width * 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopSection(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                    child: Column(
                      children: [
                        !planning.isCardsDataLoaded ? CardsManage() : Text(""),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Budget Planning",
                                style: Styles.textDecoration(
                                    color: Colors.black87),
                              ),
                              Text(
                                "10 Days Ago",
                                style: Styles.textDecoration(
                                    color: Colors.black87),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          child: Column(
                            children: [
                              PlanningCardUI(
                                  "Food", 1400, 32, Icons.fastfood_outlined),
                              PlanningCardUI("Groceries", 1400, 32,
                                  Icons.shopping_cart_checkout),
                              PlanningCardUI("Shopping", 1400, 32,
                                  Icons.shopping_bag_outlined),
                              PlanningCardUI("Bills", 1400, 32, Icons.receipt),
                              PlanningCardUI("Travel", 1400, 32,
                                  Icons.card_travel_outlined),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TopSection extends StatelessWidget {
  const TopSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 0.25,
      child: Card(
        color: AppTheme.filler.withOpacity(1),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        Util.formatMoney(7500),
                        style: Styles.textDecoration(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "This month budget",
                        style: Styles.textDecoration(
                            fontSize: 12, color: Color(0XFF8B8FA1)),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        Util.formatMoney(3500),
                        style: Styles.textDecoration(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "This month expenses",
                        style: Styles.textDecoration(
                            fontSize: 12, color: Color(0XFF8B8FA1)),
                      )
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NaviagtorIcon(Icons.home_outlined, 1),
                  NaviagtorIcon(Icons.manage_accounts_outlined, 2),
                  NaviagtorIcon(Icons.credit_card_sharp, 3),
                  NaviagtorIcon(Icons.access_time_outlined, 4),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NaviagtorIcon extends StatelessWidget {
  NaviagtorIcon(
    this.icon,
    this.index,
  );

  final IconData icon;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, size: 30, color: Colors.black87),
        ),
      ),
    );
  }
}
