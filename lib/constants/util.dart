// ignore_for_file: depend_on_referenced_packages

import 'package:intl/intl.dart';

class Util {
  static String formatMoney(dynamic value) {
    var format =
        NumberFormat.currency(locale: 'HI', symbol: "₹", decimalDigits: 0);
    return format.format(value);
  }
}
