import 'package:flutter/material.dart';
import '../model/daily.dart';
import '../model/meal.dart';

class DailyViewModel extends ChangeNotifier {
  final Daily _model;
  bool isLoading = false;
  bool isDisposed = false;

  DailyViewModel(timestamp) : _model = Daily(timestamp ?? DateTime.now()) {
    init();
  }

  DateTime get timestamp => _model.timestamp;

  set timestamp(newValue) {
    _model.timestamp = newValue;
  }

  void nextDay() {
    timestamp = timestamp.add(Duration(days: 1));
    init();
  }

  void previousDay() {
    timestamp = timestamp.subtract(Duration(days: 1));
    init();
  }

  get meals => _model.meals;

  double get calories {
    double out = 0;
    for (Meal meal in meals) {
      out += meal.calories;
    }
    return out;
  }

  double get servingSizeG {
    double out = 0;
    for (Meal meal in meals) {
      out += meal.servingSizeG;
    }
    return out;
  }

  double get fatTotalG {
    double out = 0;
    for (Meal meal in meals) {
      out += meal.fatTotalG;
    }
    return out;
  }

  double get fatSaturatedG {
    double out = 0;
    for (Meal meal in meals) {
      out += meal.fatSaturatedG;
    }
    return out;
  }

  double get proteinG {
    double out = 0;
    for (Meal meal in meals) {
      out += meal.proteinG;
    }
    return out;
  }

  int get sodiumMG {
    int out = 0;
    for (Meal meal in meals) {
      out += meal.sodiumMG;
    }
    return out;
  }

  int get potassiumMG {
    int out = 0;
    for (Meal meal in meals) {
      out += meal.potassiumMG;
    }
    return out;
  }

  int get cholesterolMG {
    int out = 0;
    for (Meal meal in meals) {
      out += meal.cholesterolMG;
    }
    return out;
  }

  double get carbohydratesTotalG {
    double out = 0;
    for (Meal meal in meals) {
      out += meal.carbohydratesTotalG;
    }
    return out;
  }

  double get fiberG {
    double out = 0;
    for (Meal meal in meals) {
      out += meal.fiberG;
    }
    return out;
  }

  double get sugarG {
    double out = 0;
    for (Meal meal in meals) {
      out += meal.sugarG;
    }
    return out;
  }

  Future<void> init() async {
    isLoading = true;
    await _model.init();
    isLoading = false;
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}
