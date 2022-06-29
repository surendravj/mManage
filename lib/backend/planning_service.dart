import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlanningService extends ChangeNotifier {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<dynamic, dynamic>> cards = [];
  Map<dynamic, dynamic> planning = {};
  bool isPlanned = false;
  bool isCardsDataLoaded = false;

  Future<bool> getCards() async {
    try {
      await _firestore.collection("cards").get().then((QuerySnapshot doc) {
        if (doc.size == 0) {
          isCardsDataLoaded = false;
          return isCardsDataLoaded;
        }
        for (var element in doc.docs) {
          cards.add(element as Map);
        }
        isCardsDataLoaded = true;
      });
      notifyListeners();
      return isCardsDataLoaded;
    } catch (e) {
      return false;
    }
  }
}
