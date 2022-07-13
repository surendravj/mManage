// ignore_for_file: unnecessary_new, unused_local_variable, depend_on_referenced_packages, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mmanage/constants/util.dart';

class ChittiService extends ChangeNotifier {
  static CollectionReference firestore =
      FirebaseFirestore.instance.collection("Chitti");

  int chittiSize = 0;
  int totalChittiAmount = 0;
  int amountPaid = 0;
  int amountRecived = 0;
  List<QueryDocumentSnapshot> chitti = [];
  late QueryDocumentSnapshot transaction;

  intializeValues() {
    chittiSize = 0;
    totalChittiAmount = 0;
    amountPaid = 0;
    amountRecived = 0;
    chitti = [];
  }

  Future<String> createChitti(
      String date, String months, String amount, String name) async {
    String id;

    Map<String, dynamic> data = {
      "name": name,
      "startDate": date,
      "months": months,
      "amount": amount,
      "totalAmount": int.parse(months) * int.parse(amount),
      "isActive": true,
      "isCompleted": false,
      "isWithdrawed": false,
      "paidAmount": 0,
      "recivedAmount": 0,
      "endDate": Util.formatDate(
          DateTime.parse(date).add(Duration(days: (int.parse(months) * 30)))),
      "transactions": {}
    };

    try {
      String id = await firestore.add(data).then((value) => value.id);
      await getChittiData();
      notifyListeners();
      return "Chitti added succesfully";
    } catch (e) {
      return "Opps something went wrong";
    }
  }

  Future<void> getChittiData() async {
    intializeValues();
    await firestore.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        if (doc["isActive"]) {
          chittiSize += 1;
        }
        chitti.add(doc);
        totalChittiAmount += doc['totalAmount'] as int;
        amountPaid += doc['paidAmount'] as int;
        amountRecived += doc['recivedAmount'] as int;
      });
    });
    notifyListeners();
  }

  Future<String> addChittiTransaction(
      String id, dynamic amount, Map transactions, dynamic paidAmount) async {
    String date = Util.formatDate(DateTime.now());
    Map<dynamic, dynamic> ref = Map<dynamic, dynamic>.from(transactions);
    if (ref.containsKey(date) && ref.isNotEmpty) {
      return "Transaction exist";
    }
    ref.addAll({date: amount});
    paidAmount += int.parse(amount);

    try {
      await firestore
          .doc(id)
          .update({"transactions": ref, "paidAmount": paidAmount});
      await getChittiData();
      notifyListeners();
      return "Transaction succesfully saved";
    } catch (e) {
      return "Transaction failed!";
    }
  }

  Future<String> withdrawChitti(String id, String amount) async {
    try {
      await firestore.doc(id).update({
        "recivedAmount": int.parse(amount),
        "isWithdrawed": true,
      });
      await getChittiData();
      notifyListeners();
      return "Transaction succesfull";
    } catch (e) {
      return "Opps something went wrong";
    }
  }

  Future<String> markAsComplete(String id) async {
    try {
      await firestore.doc(id).update({"isCompleted": true, "isActive": false});
      await getChittiData();
      notifyListeners();
      return "Chitti marked as completed";
    } catch (e) {
      return "Opps something went wrong";
    }
  }

  setTransaction(QueryDocumentSnapshot data) {
    transaction = data;
  }
}
