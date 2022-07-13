// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:mmanage/backend/planning_service.dart';
import 'package:mmanage/modules/Planning/planning_screen.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/styles.dart';
import '../../constants/util.dart';

class PlanningCardUI extends StatelessWidget {
  PlanningCardUI(this.name, this.amount, this.percentage, this.icon);

  final String name;
  final int amount;
  final dynamic percentage;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<PlanningService>(context);
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
          Util.formatMoney(provider.percentageToAmount(percentage)),
          style: Styles.textDecoration(color: AppTheme.secondaryText),
        ),
        title: Text(name, style: Styles.textDecoration(color: AppTheme.filler)),
        dense: true,
        trailing: Text(
          '$percentage%',
          style: Styles.textDecoration(color: AppTheme.secondaryFiller),
        ),
      ),
    );
  }
}
