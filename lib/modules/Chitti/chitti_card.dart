// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, non_constant_identifier_names, unnecessary_new, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mmanage/backend/chitti_service.dart';
import 'package:mmanage/constants/colors.dart';
import 'package:mmanage/constants/styles.dart';
import 'package:mmanage/constants/util.dart';
import 'package:mmanage/modules/Chitti/chitti_transaction.dart';
import 'package:provider/provider.dart';

class ChittiCard extends StatefulWidget {
  ChittiCard({required this.chitti});

  final QueryDocumentSnapshot chitti;
  @override
  State<ChittiCard> createState() => _ChittiCardState();
}

class _ChittiCardState extends State<ChittiCard> {
  final _formkey = GlobalKey<FormState>();
  final amount = new TextEditingController();

  @override
  void dispose() {
    amount.dispose();
    super.dispose();
  }

  onTrasact() async {
    if (_formkey.currentState!.validate()) {
      var ref = Provider.of<ChittiService>(context, listen: false);
      String response = await ref.addChittiTransaction(
          widget.chitti.id,
          amount.text,
          widget.chitti['transactions'],
          widget.chitti['paidAmount']);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response)));
    }
  }

  navigate() {
    Provider.of<ChittiService>(context, listen: false)
        .setTransaction(widget.chitti);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ChittiTransactionPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        splashColor: AppTheme.filler,
        onTap: navigate,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[200],
                      child: Icon(
                        Icons.savings,
                        color: AppTheme.filler,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.chitti['name'],
                            style: Styles.textDecoration(color: Colors.black87),
                          ),
                          Text(
                            Jiffy(widget.chitti['startDate']).fromNow(),
                            style: Styles.textDecoration(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          ),
                          Text(
                            Util.formatMoney(widget.chitti['totalAmount']),
                            style: Styles.textDecoration(
                                color: Colors.green,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                ElevatedButton(
                  onPressed: widget.chitti['isActive']
                      ? () {
                          showDialog(
                            context: context,
                            builder: (ctx) => SimpleDialog(
                              children: [
                                Form(
                                  key: _formkey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Enter Trasaction Amount",
                                          style: Styles.textDecoration(
                                              color: Colors.black87),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Required";
                                            }
                                            return null;
                                          },
                                          controller: amount,
                                          keyboardType: TextInputType.number,
                                          decoration:
                                              Styles.inputDecoration("Amount"),
                                        ),
                                      ),
                                      Center(
                                        child: ElevatedButton(
                                          onPressed: onTrasact,
                                          style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 16),
                                              primary: AppTheme.filler,
                                              onPrimary: Colors.white),
                                          child: Text(
                                            "Add Trasaction",
                                            style: Styles.textDecoration(),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      : () {},
                  style: ElevatedButton.styleFrom(
                      primary: widget.chitti['isActive']
                          ? AppTheme.filler
                          : AppTheme.secondaryFiller,
                      onPrimary: Colors.white),
                  child: Text(
                    widget.chitti['isActive'] ? "Add" : "Closed",
                    style: Styles.textDecoration(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
