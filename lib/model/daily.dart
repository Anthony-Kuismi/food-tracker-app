import 'package:food_tracker_app/service/firestore_service.dart';

import 'meal.dart';

class Daily {
  List<Meal> meals = [];
  Meal? data;

  FirestoreService firestoreService = FirestoreService();

  DateTime timestamp;

  Daily(this.timestamp);

  Future<void> fetchData(DateTime timestamp) async {
    meals = await firestoreService.getMealsFromUserByTimestamp(timestamp);
    data =
        Meal.fromFoodList(meals.expand((meal) => meal.foods.values).toList());
  }

  Future<void> init() async {
    await fetchData(timestamp);
  }
}
