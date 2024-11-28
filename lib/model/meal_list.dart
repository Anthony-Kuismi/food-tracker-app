import 'meal.dart';
import '../service/firestore_service.dart';

class MealList {
  FirestoreService firestore = FirestoreService();
  List<Meal> meals = [];
  Map<String, int>? _id2Idx;

  Map<DateTime, List<Meal>> get mealsByDay {
    Map<DateTime, List<Meal>> out = {};
    for (Meal meal in meals) {
      if (out[meal.day] != null) {
        out[meal.day]!.add(meal);
      } else {
        out[meal.day] = [meal];
      }
    }
    return out;
  }

  void updateId2Idx() {
    _id2Idx = {for (int i = 0; i < meals.length; i++) meals[i].id: i};
  }

  get id2idx {
    if (_id2Idx == null) {
      updateId2Idx();
    }
    ;
    return _id2Idx;
  }

  Future<void> fetch() async {
    meals = await firestore.getMealsFromUser();
  }
}
