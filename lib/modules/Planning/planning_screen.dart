// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:mmanage/backend/planning_service.dart';
import 'package:mmanage/constants/styles.dart';
import 'package:mmanage/constants/util.dart';
import 'package:mmanage/modules/Planning/budget_planning_screen.dart';
import 'package:mmanage/modules/Planning/cards_manage.dart';
import 'package:mmanage/modules/Planning/credit_card_form.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import 'planning_card.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({Key? key}) : super(key: key);

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  int amount = 0;

  @override
  void initState() {
    var provider = Provider.of<PlanningService>(context, listen: false);
    provider.getBudgetData();
    provider.getCards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var planning = Provider.of<PlanningService>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TopSection(planning.budget),
                planning.isPlanned
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Budget Planning",
                              style:
                                  Styles.textDecoration(color: Colors.black87),
                            ),
                            InkWell(
                              onTap: planning.deleteBudget,
                              child: Icon(
                                Icons.delete_outline_outlined,
                                color: AppTheme.secondaryText,
                              ),
                            )
                          ],
                        ),
                      )
                    : Text(""),
                planning.isPlanned
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) => PlanningCardUI(
                          planning.planning["allocations"][index]
                              ["budgetCategory"],
                          Util.formatMoney(planning.percentageToAmount(
                              planning.planning["allocations"][index]
                                  ["allocationAmount"])),
                          planning.planning["allocations"][index]
                              ["allocationAmount"],
                          Util.getPlanningIcon(
                            planning.planning["allocations"][index]
                                ["budgetCategory"],
                          ),
                        ),
                        itemCount: planning.planning["allocations"].length,
                      )
                    : Text(""),
                planning.isCardsDataLoaded ? CardsManage() : Text(""),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TopSection extends StatefulWidget {
  TopSection(this.amount);

  final int amount;
  @override
  State<TopSection> createState() => _TopSectionState();
}

class _TopSectionState extends State<TopSection> {
  openForm(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    var planning = Provider.of<PlanningService>(context);
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
                        Util.formatMoney(widget.amount),
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
                  NaviagtorIcon(
                      Icons.manage_accounts_outlined,
                      2,
                      planning.isPlanned
                          ? () =>
                              Util.snackBar(context, "Budget already created")
                          : () => openForm(BudgetPlanningScreen()),
                      "Budget"),
                  NaviagtorIcon(Icons.credit_card_sharp, 3,
                      () => openForm(CreditCardFormPage()), "Cards"),
                  NaviagtorIcon(
                      Icons.access_time_outlined, 4, () {}, "History"),
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
  NaviagtorIcon(this.icon, this.index, this.onClickFun, this.label);

  final IconData icon;
  final int index;
  final String label;
  var onClickFun;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InkWell(
        onTap: onClickFun,
        child: Column(
          children: [
            Card(
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
            Text(
              label,
              style: Styles.textDecoration(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
