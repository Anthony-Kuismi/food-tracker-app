import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model/charts.dart';

enum ChartsViewMode { DAILY, WEEKLY, MONTHLY }

class ChartsViewModel extends ChangeNotifier {
  Charts _model;

  bool isLoading = false;

  ChartsViewModel({required DateTime start, required DateTime end})
      : _model = Charts(start: start, end: end) {
    initializeChartsModel();
  }

  get currentTabIndex => _model.currentTabIndex;

  get dateModifier => _model.dateModifier;

  set dateModifier(newValue) {
    _model.dateModifier = newValue;
  }

  set currentTabIndex(newValue) {
    _model.currentTabIndex = newValue;
  }

  get currentDateTabIndex => _model.currentDateTabIndex;

  set currentDateTabIndex(newValue) {
    _model.currentDateTabIndex = newValue;
    notifyListeners();
  }

  Future<void> initializeChartsModel() async {
    isLoading = true;
    await _model.init();
    isLoading = false;
    notifyListeners();
  }

  get weight => _model.weight;

  get calories => _model.calories;

  get proteinTotalG => _model.proteinTotalG;

  get carbohydratesTotalG => _model.carbohydratesTotalG;

  get fatTotalG => _model.fatTotalG;

  List<String> labels = [
    'Weight',
    'Calories',
    'Protein',
    'Carbs',
    'Fat',
  ];
  List<String> periods = ['1w', '4w', '3m', '1y'];

  get start => _model.start;

  get end => _model.end;

  set start(newValue) => _model.start = newValue;

  set end(newValue) => _model.end = newValue;

  Future<void> updateStart(DateTime start) async {
    this.start = start;
    await _model.fetchData();
    notifyListeners();
  }

  Future<void> updateEnd(DateTime end) async {
    this.end = end;
    await _model.fetchData();
    notifyListeners();
  }

  void load() {}
}
