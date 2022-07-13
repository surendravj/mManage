// ignore_for_f ile: prefer_const_constructors

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mmanage/backend/planning_service.dart';
import 'package:mmanage/constants/colors.dart';
import 'package:mmanage/constants/contants.dart';
import 'package:mmanage/constants/styles.dart';
import 'package:mmanage/constants/util.dart';
import 'package:mmanage/modules/Planning/planning_card.dart';
import 'package:provider/provider.dart';

class BudgetPlanningScreen extends StatefulWidget {
  const BudgetPlanningScreen({Key? key}) : super(key: key);

  @override
  State<BudgetPlanningScreen> createState() => _BudgetPlanningScreenState();
}

class _BudgetPlanningScreenState extends State<BudgetPlanningScreen> {
  TextEditingController budget = TextEditingController();
  TextEditingController allocationAmount = TextEditingController();

  @override
  void dispose() {
    budget.dispose();
    allocationAmount.dispose();
    super.dispose();
  }

  createBudget() async {
    String response = await Provider.of<PlanningService>(context, listen: false)
        .createBudget(int.parse(budget.text));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Budget Plan',
          style: Styles.textDecoration(color: AppTheme.primaryText),
        ),
        backgroundColor: AppTheme.filler,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create your monthly budget",
                style: Styles.textDecoration(color: AppTheme.filler),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextFormField(
                  controller: budget,
                  decoration: Styles.inputDecoration("Enter monthly budget"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Budget allocations",
                      style: Styles.textDecoration(color: AppTheme.filler),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: AppTheme.filler,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: InkWell(
                        onTap: () => showDialog(
                          context: context,
                          builder: (BuildContext ctx) =>
                              Consumer<PlanningService>(
                            builder: (_, data, __) => SimpleDialog(
                              elevation: 0,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Enter your allocation",
                                        style: Styles.textDecoration(
                                            color: AppTheme.filler),
                                      ),
                                      DropdownButton<String>(
                                        isExpanded: true,
                                        hint: const Text("Select City"),
                                        value: data.budgetCategory,
                                        alignment: Alignment.center,
                                        icon: const Icon(Icons.arrow_downward),
                                        elevation: 16,
                                        style: Styles.textDecoration(
                                            color: AppTheme.filler),
                                        underline: Container(
                                          width: double.infinity,
                                          height: 2,
                                          color: AppTheme.filler,
                                        ),
                                        onChanged: (String? newValue) {
                                          data.setBudgetAllocation(newValue!);
                                        },
                                        items: Constants.allocationCategories
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: allocationAmount,
                                        decoration: const InputDecoration(
                                          fillColor: AppTheme.filler,
                                          labelText:
                                              "Enter Allocation Budget (%)",
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Center(
                                          child: ElevatedButton(
                                            onPressed: () => {
                                              data.addAllocation(double.parse(
                                                  allocationAmount.text)),
                                              Navigator.pop(context)
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 16),
                                              primary: AppTheme.filler,
                                              onPrimary: Colors.white,
                                            ),
                                            child: Text(
                                              "Add allocation",
                                              style: Styles.textDecoration(),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        child: Text(
                          '+ Add allocation',
                          style: Styles.textDecoration(
                            color: AppTheme.primaryText,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Consumer<PlanningService>(
                  builder: (_, data, __) => Column(
                        children: data.allocations
                            .map(
                              (e) => PlanningCardUI(
                                e["budgetCategory"],
                                2000,
                                e["allocationAmount"],
                                Util.getPlanningIcon(
                                  e["budgetCategory"],
                                ),
                              ),
                            )
                            .toList(),
                      ))
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: createBudget,
        icon: const Icon(Icons.save),
        label: Text(
          "Save Allocation",
          style: Styles.textDecoration(color: AppTheme.primaryText),
        ),
        backgroundColor: AppTheme.filler,
      ),
    );
  }
}
