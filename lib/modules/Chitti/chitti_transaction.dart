// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, non_constant_identifier_names, unnecessary_new, use_build_context_synchronously, empty_constructor_bodies, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mmanage/backend/chitti_service.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';
import '../../constants/util.dart';
import 'chitti_transaction_card.dart';

class ChittiTransactionPage extends StatefulWidget {
  @override
  State<ChittiTransactionPage> createState() => _ChittiTransactionPageState();
}

class _ChittiTransactionPageState extends State<ChittiTransactionPage> {
  final _formkey = GlobalKey<FormState>();
  final amount = new TextEditingController();
  var data;

  @override
  void initState() {
    data = Provider.of<ChittiService>(context, listen: false).transaction;
    amount.text = '${data['totalAmount']}';
    super.initState();
  }

  void markAsComplete() async {
    String response = await Provider.of<ChittiService>(context, listen: false)
        .markAsComplete(data.id);
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response)));
  }

  @override
  void dispose() {
    amount.dispose();
    super.dispose();
  }

  onTransact() async {
    if (_formkey.currentState!.validate()) {
      String response = await Provider.of<ChittiService>(context, listen: false)
          .withdrawChitti(data.id, amount.text);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response)));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var bills = [];
    data['transactions'].forEach((key, value) => {
          bills.add({"date": key, "amount": value})
        });
    bills.sort((a, b) => b["date"].compareTo(a["date"]));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.filler,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: AppTheme.primaryText,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: data['isCompleted'] ? () {} : markAsComplete,
              child: Icon(
                data['isCompleted']
                    ? Icons.verified_rounded
                    : Icons.verified_outlined,
                size: 25,
              ),
            ),
          )
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width * 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TopSection(data: data),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        '${data['name']}',
                        style: Styles.textDecoration(color: AppTheme.filler),
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemBuilder: ((context, index) {
                        return ChittiTransactionCard(
                          bills[index]['date'],
                          int.parse(bills[index]['amount']),
                        );
                      }),
                      itemCount: bills.length,
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        focusElevation: 0,
        onPressed: !data['isWithdrawed']
            ? () {
                showDialog(
                  context: context,
                  builder: (BuildContext ctx) => SimpleDialog(children: [
                    Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Enter Recived Amount",
                              style:
                                  Styles.textDecoration(color: Colors.black87),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Required";
                                }
                                return null;
                              },
                              controller: amount,
                              keyboardType: TextInputType.number,
                              decoration: Styles.inputDecoration("Amount"),
                            ),
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: onTransact,
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  primary: AppTheme.filler,
                                  onPrimary: Colors.white),
                              child: Text(
                                "Withdraw Chitti",
                                style: Styles.textDecoration(),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ]),
                );
              }
            : () {},
        label: Text(
            !data['isWithdrawed'] ? "Withdraw Chitti" : "Chitti withdrawed",
            style: Styles.textDecoration(
              color: AppTheme.primaryText,
            )),
        icon: Icon(Icons.handshake),
        backgroundColor:
            !data['isWithdrawed'] ? AppTheme.filler : AppTheme.secondaryFiller,
      ),
    );
  }
}

class TopSection extends StatelessWidget {
  const TopSection({
    Key? key,
    required this.data,
  }) : super(key: key);

  final QueryDocumentSnapshot data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 0.2,
      child: Card(
        color: AppTheme.filler.withOpacity(1),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Center(
                    child: Text("Chitti Amount",
                        style: Styles.textDecoration(
                            color: AppTheme.secondaryText,
                            fontWeight: FontWeight.bold)),
                  ),
                  Center(
                    child: Text(
                      Util.formatMoney(data['totalAmount']),
                      style: Styles.textDecoration(fontSize: 20),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text("Completed",
                          style: Styles.textDecoration(
                              color: AppTheme.secondaryText,
                              fontWeight: FontWeight.bold)),
                      Text(
                        '${data['transactions'].length}',
                        style: Styles.textDecoration(fontSize: 20),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Amount Paid",
                        style: Styles.textDecoration(
                            color: AppTheme.secondaryText,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        Util.formatMoney(data['paidAmount']),
                        style: Styles.textDecoration(fontSize: 20),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Amount Recived",
                        style: Styles.textDecoration(
                            color: AppTheme.secondaryText,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        Util.formatMoney(data['recivedAmount']),
                        style: Styles.textDecoration(fontSize: 20),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
