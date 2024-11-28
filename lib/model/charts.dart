import 'dart:developer';

import 'package:food_tracker_app/service/firestore_service.dart';
import 'package:intl/intl.dart';

import 'meal.dart';

class DataPoint {
  DateTime timestamp;

  String get timestampString =>
      DateFormat('HH:mm MM-dd-yyyy').format(timestamp);
  double value;

  DataPoint({required this.timestamp, required this.value});
}

class Charts {
  DateTime start;
  DateTime end;

  int currentTabIndex = 0;

  int currentDateTabIndex = 0;

  int dateModifier = 0;

  Charts({required this.start, required this.end});

  List<DataPoint> calories = [];
  List<DataPoint> proteinTotalG = [];
  List<DataPoint> carbohydratesTotalG = [];
  List<DataPoint> fatTotalG = [];
  List<DataPoint> weight = [];

  Future<void> init() async {
    await fetchData();
  }

  Future<void> fetchData() async {
    calories = [];
    proteinTotalG = [];
    carbohydratesTotalG = [];
    fatTotalG = [];
    weight = [];
    final firestore = FirestoreService();
    final data = await firestore.getMealsFromUserByTimestampRange(start, end);
    final weightData =
        await firestore.getUserWeightEntriesByTimestampRange(start, end);
    Map<DateTime, Meal> mukbangs = {};
    var date = DateTime(start.year, start.month, start.day);
    var endDate = DateTime(end.year, end.month, end.day);
    while (date.millisecondsSinceEpoch <= endDate.millisecondsSinceEpoch) {
      mukbangs[date] = Meal.fromFoodList([]);
      date = DateTime(date.year, date.month, date.day + 1);
    }
    for (var item in data.entries) {
      log('Item ${item.key}');
      if (mukbangs[item.key] != null)
        mukbangs[item.key] = Meal.fromFoodList(
            (item.value.expand((meal) => meal.foods.values).toList()));
    }
    calories = mukbangs.entries
        .map<DataPoint>((mukbang) =>
            DataPoint(timestamp: mukbang.key, value: mukbang.value.calories))
        .toList();
    proteinTotalG = mukbangs.entries
        .map<DataPoint>((mukbang) =>
            DataPoint(timestamp: mukbang.key, value: mukbang.value.proteinG))
        .toList();
    carbohydratesTotalG = mukbangs.entries
        .map<DataPoint>((mukbang) => DataPoint(
            timestamp: mukbang.key, value: mukbang.value.carbohydratesTotalG))
        .toList();
    fatTotalG = mukbangs.entries
        .map<DataPoint>((mukbang) =>
            DataPoint(timestamp: mukbang.key, value: mukbang.value.fatTotalG))
        .toList();

    weight = weightData.entries
        .map<DataPoint>(
            (entry) => DataPoint(timestamp: entry.key, value: entry.value))
        .toList();
  }
}
