// ignore_for_file: depend_on_referenced_packages, avoid_returning_null_for_void

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import "package:intl/intl.dart";

class PlanningService extends ChangeNotifier {
  static final CollectionReference _cards =
      FirebaseFirestore.instance.collection("cards");
  static final CollectionReference _budget =
      FirebaseFirestore.instance.collection("budget");

  List<dynamic> cards = [];
  dynamic planning = {};
  bool isPlanned = false;
  bool isCardsDataLoaded = false;
  String budgetCategory = "Food";
  List<dynamic> allocations = [];
  int budget = 0;

  Future<void> getBudgetData() async {
    var date = DateFormat('yyyy-MM').format(DateTime.now());
    var ref = await _budget.doc(date).get();
    if (!ref.exists) {
      isPlanned = false;
      notifyListeners();
    } else {
      planning = ref.data();
      budget = planning["budget"];
      isPlanned = true;
      notifyListeners();
    }
  }

  setBudgetAllocation(String budgetOption) {
    budgetCategory = budgetOption;
    notifyListeners();
  }

  bool isBudgetAllocated() {
    bool isAllocated = false;
    for (var element in allocations) {
      if (element["budgetCategory"] == budgetCategory) {
        isAllocated = true;
      }
    }
    return isAllocated;
  }

  int calculateBudget() {
    double budget = 0;
    for (var element in allocations) {
      budget += element["allocationAmount"];
    }
    return budget.toInt();
  }

  addAllocation(double allocation) {
    if (allocation != 0) {
      if (isBudgetAllocated()) {
        for (var element in allocations) {
          if (element["budgetCategory"] == budgetCategory) {
            element["allocationAmount"] = allocation;
          }
        }
      } else {
        allocations.add(
            {"budgetCategory": budgetCategory, "allocationAmount": allocation});
      }
      notifyListeners();
    }
  }

  int percentageToAmount(dynamic percentage) {
    return ((budget / 100) * percentage).toInt();
  }

  Future<void> deleteBudget() async {
    var date = DateFormat('yyyy-MM').format(DateTime.now());
    try {
      await _budget.doc(date).delete();
      planning = {};
      isPlanned = false;
      budget = 0;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<String> createBudget(int amount) async {
    var date = DateFormat('yyyy-MM').format(DateTime.now());
    try {
      await _budget.doc(date).set({
        "budget": amount,
        "allocations": allocations,
        "expenses": 0,
        "createdOn": Timestamp.now()
      });
      await getBudgetData();
      return "Budget Created succesfully";
    } catch (e) {
      return "Opps something went wrong";
    }
  }

  Future<void> getCards() async {
    try {
      cards = [];
      await _cards.get().then((QuerySnapshot doc) {
        if (doc.size == 0) {
          isCardsDataLoaded = false;
          return isCardsDataLoaded;
        }
        for (var element in doc.docs) {
          cards.add(element);
        }
        isCardsDataLoaded = true;
        notifyListeners();
      });
    } catch (e) {
      return null;
    }
  }

  Future<String> addCard(dynamic data) async {
    try {
      await _cards.add(data);
      await getCards();
      return "Card added succesfully";
    } catch (e) {
      return "Opps something went wrong";
    }
  }
}
