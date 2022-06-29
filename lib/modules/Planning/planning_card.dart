// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/styles.dart';
import '../../constants/util.dart';

class PlanningCardUI extends StatelessWidget {
  PlanningCardUI(this.name, this.amount, this.percentage, this.icon);

  final String name;
  final int amount;
  final double percentage;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[200],
          child: Icon(
            icon,
            color: AppTheme.filler,
          ),
        ),
        subtitle: Text(
          Util.formatMoney(amount),
          style: Styles.textDecoration(color: Colors.black45),
        ),
        title: Text(name, style: Styles.textDecoration(color: Colors.green)),
        dense: true,
        trailing: Text(
          '$percentage%',
          style: Styles.textDecoration(color: Colors.green),
        ),
      ),
    );
  }
}
