import 'package:flutter/cupertino.dart';
import '../model/food.dart';
import '../model/meal.dart';

enum FoodSelectionMode { add, edit }

class FoodSelectionService extends ChangeNotifier {
  FoodSelectionMode mode = FoodSelectionMode.add;
  Meal data = Meal(json: {
    'title': 'Food Selection',
    'id': 'id',
    'items': [],
    'timestamp': DateTime.now().millisecondsSinceEpoch
  });
  Meal? editingMeal;

  List<String> get selections {
    return data.titles;
  }

  void addSelectedFood(Food food) {
    data.add(food);
  }

  void removeSelectedFood(Food food) {
    data.remove(food);
  }

  bool isSelected(Food food) {
    return data.foods.containsKey(food.id);
  }

  void update(Meal meal) {
    data = meal;
  }

  void reset() {
    mode = FoodSelectionMode.add;
    editingMeal = null;
    data = Meal(json: {
      'title': 'Food Selection',
      'id': 'id',
      'items': [],
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });
  }
}
