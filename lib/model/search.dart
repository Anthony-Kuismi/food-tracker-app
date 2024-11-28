import 'dart:core';
import 'meal.dart';
import '../service/firestore_service.dart';

class Search {
  var firestore = FirestoreService();
  String query = '';
  Meal data = Meal(json: {
    'title': 'Food Search',
    'id': 'id',
    'items': [],
    'timestamp': DateTime.now().millisecondsSinceEpoch
  });
  Meal customData = Meal(json: {
    'title': 'Food Search',
    'id': 'id',
    'items': [],
    'timestamp': DateTime.now().millisecondsSinceEpoch
  });

  Search();

  Future<void> initialize() async {
    await fetchCustomData();
  }

  Future<void> fetchCustomData() async {
    customData = Meal.fromFoodList(await firestore.getCustomFoodsFromUser());
  }

  List<String> get searchResults {
    return data.titles;
  }
}
