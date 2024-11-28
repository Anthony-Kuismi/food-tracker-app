import 'package:flutter/cupertino.dart';
import 'package:food_tracker_app/model/meal.dart';
import 'package:food_tracker_app/model/water.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import '../service/firestore_service.dart';
import '../service/navigator_service.dart';
import '../model/home_page.dart';
import '../model/weight.dart';

class HomePageViewModel extends ChangeNotifier {
  late final NavigatorService navigatorService;
  var firestore = FirestoreService();

  double _waterPercentage = 0.0;

  double get waterPercentage => _waterPercentage;

  int get waterCups => _model.getWaterAmount();

  int get waterCupsGoal => _model.getWaterGoal();
  double percentChange = 0;

  String? notes;

  String? get newNotes => notes;

  double _caloriePercentage = 0.0;

  double get caloriePercentage => _caloriePercentage;

  double _calorieGoal = 0.0;

  double get calorieGoal => _calorieGoal;

  get calories => _model.calories;

  set calories(newValue) => _model.calories = newValue;

  get carbohydratesTotalG => _model.carbohydratesTotalG;

  set carbohydratesTotalG(newValue) => _model.carbohydratesTotalG = newValue;

  get proteinG => _model.proteinG;

  set proteinG(newValue) => _model.proteinG = newValue;

  get fatTotalG => _model.fatTotalG;

  set fatTotalG(newValue) => _model.fatTotalG = newValue;
  DateTime now = DateTime.now();

  DateTime get date => DateTime(now.year, now.month, now.day);

  String get dateStr => DateFormat('yyyy-MM-dd').format(date);

  final HomePage _model = HomePage();

  double get weightGoal => _model.weightGoal;

  double get weight => _model.weight;

  int get lastEntryNumber => _model.lastEntryNumber;

  double get lastWeightEntry => _model.lastWeight;

  Future<void> load() async {
    now = DateTime.now();
    labelDisplayMode:
    SparkChartLabelDisplayMode.none;
    await _model.fetchWaterEntry(dateStr);
    await fetchDailyData();
    await _model.fetchWeightEntry(dateStr);
    await _model.fetchUserInfo();
    calcWeightChange();
    updateCalorieGoal();
    updateCaloriePercentage();
    updateWaterPercentage();
    notifyListeners();
  }

  Future<void> fetchDailyData({DateTime? day}) async {
    day ??= DateTime.now();
    final meals = await firestore.getMealsFromUserByTimestamp(day);
    _model.calories = 0.0;
    _model.carbohydratesTotalG = 0.0;
    _model.proteinG = 0.0;
    _model.fatTotalG = 0.0;
    for (Meal meal in meals) {
      _model.calories += meal.calories;
      _model.carbohydratesTotalG += meal.carbohydratesTotalG;
      _model.proteinG += meal.proteinG;
      _model.fatTotalG += meal.fatTotalG;
    }
  }

  void addWater() {
    _model.addWater();
    firestore.updateWaterEntryFromUser(Water(
        date: dateStr,
        amount: _model.getWaterAmount(),
        timestamps: _model.getTimestamps()));
    updateWaterPercentage();
  }

  void removeWater() {
    _model.removeWater();
    firestore.updateWaterEntryFromUser(Water(
        date: dateStr,
        amount: _model.getWaterAmount(),
        timestamps: _model.getTimestamps()));
    updateWaterPercentage();
  }

  void updateWaterPercentage() {
    if (_model.getWaterAmount() < 0) {
      _model.setWaterGoal(0);
    } else if (_model.getWaterAmount() > _model.getWaterGoal()) {
      _waterPercentage = 1.0;
    } else {
      _waterPercentage = _model.getWaterAmount() / _model.getWaterGoal();
    }

    notifyListeners();
  }

  void setWaterGoal(int goal) {
    _model.setWaterGoal(goal);
    firestore.setWaterGoalForUser(goal);
    updateWaterPercentage();
  }

  void calcWeightChange() {
    percentChange = -((lastWeightEntry - weight) / lastWeightEntry) * 100;
    notifyListeners();
  }

  void setWeightGoal(double goal) {
    _model.weightGoal = goal;
    firestore.setUserWeightGoal(goal);
    updateCaloriePercentage();
    updateCalorieGoal();
    notifyListeners();
  }

  void updateCalorieGoal() {
    _calorieGoal = _model.getDailyCalorieGoal();
    notifyListeners();
  }

  void updateCaloriePercentage() {
    _caloriePercentage = _model.calories / _model.getDailyCalorieGoal();
    if (_caloriePercentage < 0) {
      _caloriePercentage = 0;
    } else if (_caloriePercentage > 1) {
      _caloriePercentage = 1;
    }
  }

  void setWeightInPounds(double weight) {
    _model.weight = weight;
    Weight obj = Weight(timestamp: date, weight: weight);
    firestore.setUserWeightInPounds(weight);

    firestore.addUserWeightEntry(weight, DateTime.now());
    calcWeightChange();
    updateCalorieGoal();
    updateCaloriePercentage();
    notifyListeners();
  }

  updateData(Meal data) {
    calories = data.calories;
    proteinG = data.proteinG;
    carbohydratesTotalG = data.carbohydratesTotalG;
    fatTotalG = data.fatTotalG;
    notifyListeners();
  }

  void addNotes(String newNotes) {
    notes = newNotes;
    firestore.addCustomNotesForUser(notes!, DateTime.now());
    notifyListeners();
  }
}
