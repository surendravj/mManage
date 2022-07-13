// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Util {
  static String formatMoney(dynamic? value) {
    var format =
        NumberFormat.currency(locale: 'HI', symbol: "₹", decimalDigits: 0);
    return format.format(value);
  }

  static String formatDate(dynamic date) {
    final format = DateFormat('yyyy-MM-dd');
    return format.format(date);
  }

  static IconData getPlanningIcon(String category) {
    if (category == "Food") {
      return Icons.fastfood_outlined;
    } else if (category == "Shopping") {
      return Icons.shopping_cart_checkout;
    } else if (category == "Bills") {
      return Icons.receipt;
    } else if (category == "Travel") {
      return Icons.card_travel_outlined;
    } else if (category == "Groceries") {
      return Icons.shopping_bag_outlined;
    } else {
      return Icons.more_horiz_outlined;
    }
  }
}
