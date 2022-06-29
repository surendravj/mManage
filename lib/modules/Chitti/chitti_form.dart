// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, unnecessary_const, unused_local_variable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import "package:intl/intl.dart";
import 'package:mmanage/backend/chitti_service.dart';
import 'package:mmanage/constants/colors.dart';
import 'package:mmanage/constants/styles.dart';
import 'package:provider/provider.dart';

class ChittiForm extends StatefulWidget {
  const ChittiForm({Key? key}) : super(key: key);

  @override
  State<ChittiForm> createState() => _ChittiFormState();
}

class _ChittiFormState extends State<ChittiForm> {
  final _formkey = GlobalKey<FormState>();
  final format = DateFormat("yyyy-MM-dd");
  final amount = TextEditingController();
  final months = TextEditingController();
  final date = TextEditingController();
  final name = TextEditingController();

  @override
  void dispose() {
    amount.dispose();
    months.dispose();
    date.dispose();
    name.dispose();
    super.dispose();
  }

  onSubmit() async {
    if (_formkey.currentState!.validate()) {
      String response = await Provider.of<ChittiService>(context, listen: false)
          .createChitti(date.text, months.text, amount.text, name.text);
      Navigator.pop(context);
      SnackBar(content: Text(response));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Create new chitti",
                  style: TextStyle(
                      color: AppTheme.filler,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      letterSpacing: 0.7),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: name,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                  decoration: Styles.inputDecoration("Add name to your chitti"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DateTimeField(
                  validator: (value) {
                    if (value == null) {
                      return "Required";
                    }
                    return null;
                  },
                  controller: date,
                  decoration: Styles.inputDecoration("Start date"),
                  format: format,
                  onShowPicker: (context, value) {
                    return showDatePicker(
                      context: context,
                      initialDate: value ?? DateTime.now(),
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2040),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: months,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                  decoration:
                      Styles.inputDecoration("Chitti duration in months"),
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
                  decoration: Styles.inputDecoration("Amount/month"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: AppTheme.primaryText,
                      primary: AppTheme.filler,
                      minimumSize: Size(88, 36),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                    ),
                    onPressed: onSubmit,
                    child: Text(
                      'Create Chitti',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
