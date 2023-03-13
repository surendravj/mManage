// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';


class PlanningCardUI extends StatelessWidget {
  PlanningCardUI(this.name, this.amount, this.percentage, this.icon);

  final String name;
  final dynamic amount;
  final double percentage;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
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
          amount,
          style: Styles.textDecoration(color: AppTheme.secondaryText),
        ),
        title: Text(name, style: Styles.textDecoration(color: AppTheme.filler)),
        dense: true,
        trailing: Text(
          '${percentage.toInt()}%',
          style: Styles.textDecoration(color: AppTheme.secondaryFiller),
        ),
      ),
    );
  }
}
