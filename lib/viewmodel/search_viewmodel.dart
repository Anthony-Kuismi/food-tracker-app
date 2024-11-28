import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:food_tracker_app/model/search.dart';
import 'package:food_tracker_app/service/food_selection_service.dart';
import 'package:food_tracker_app/service/navigator_service.dart';
import 'package:http/http.dart' as http;
import '../model/meal.dart';

class SearchViewModel extends ChangeNotifier {
  final Search _searchModel;
  final NavigatorService navigatorService;
  final FoodSelectionService foodSelectionService;
  bool _disposed = false;
  Timer? searchTimer;
  String name = 'foobar';

  String get query => _searchModel.query;
  DateTime timestamp = DateTime.now();

  SearchViewModel(this.navigatorService, this.foodSelectionService)
      : _searchModel = Search() {
    _initializeSearchModel();
  }

  Future<void> _initializeSearchModel() async {
    await _searchModel.initialize();
    notifyListeners();
  }

  Meal get searchResults {
    Meal out = Meal.clone(foodSelectionService.data);
    out += _searchModel.data;
    return out;
  }

  List<String> get searchResultTitles {
    return searchResults.titles;
  }

  get data => _searchModel.data;

  void updateQuery(String newQuery) {
    _searchModel.query = newQuery;
    if (searchTimer?.isActive ?? false) {
      searchTimer?.cancel();
    }
    searchTimer = Timer(const Duration(milliseconds: 500), () {
      updateSearchResults();
    });
  }

  void reset() {
    _searchModel.query = '';
    _searchModel.data = Meal(json: {
      'title': 'Food Selection',
      'id': 'id',
      'items': [],
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });
  }

  String cleanQuerySegment(String querySegment) {
    List<String> wordsToRemove = ['and', 'also', 'plus', 'another'];
    String pattern = '\\b(${wordsToRemove.join('|')})\\b';
    pattern += '|,';
    String cleanedSegment =
        querySegment.replaceAll(RegExp(pattern, caseSensitive: false), '');
    cleanedSegment = cleanedSegment.replaceAll(RegExp('\\s+'), ' ').trim();
    return cleanedSegment;
  }

  List<String> segmentQuery(String query, dynamic data) {
    List<dynamic> items = data?['items'] ?? [];
    List foodItems = items
        .where(
            (item) => query.toLowerCase().contains(item['name'].toLowerCase()))
        .map((item) => item['name'].toLowerCase())
        .toList();
    List<String> out = [];

    if (foodItems.isEmpty) {
      return [query];
    }

    int? segmentPointer = 0;
    for (var foodItem in foodItems) {
      int itemIndex = query.toLowerCase().indexOf(foodItem, segmentPointer!);
      if (itemIndex >= 0) {
        String segment =
            '${query.substring(segmentPointer, itemIndex).trim()} ${query.substring(itemIndex, (itemIndex + foodItem.length) as int?)}';
        out.add(cleanQuerySegment(segment));
        segmentPointer = (itemIndex + foodItem.length) as int?;
      }
    }
    return out;
  }

  void entitleData(String query, dynamic data) {
    List<String> querySegments = segmentQuery(query, data);
    int minLen = min(data?['items'].length ?? 0, querySegments.length);
    for (var i = 0; i < minLen; i++) {
      data['items'][i]['title'] = querySegments[i];
    }
    if ((data?['items'].length ?? 0) == 1 && querySegments.isNotEmpty) {
      data['items'][0]['title'] = querySegments.first;
    }
    data['title'] = query;
  }

  Future<dynamic> fetchData() async {
    String apiKey = '';
    if (_searchModel.query.isNotEmpty) {
      var response = await http.get(
        Uri.parse(
            'https://api.calorieninjas.com/v1/nutrition?query=${_searchModel.query}'),
        headers: {'X-Api-Key': apiKey},
      );
      if (response.statusCode == 200) {
        dynamic out = jsonDecode(response.body);
        return out;
      } else {
        throw Exception('Failed to load nutrition data');
      }
    }
  }

  Future<void> updateSearchResults() async {
    await _searchModel.fetchCustomData();
    if (_searchModel.query.isNotEmpty) {
      return fetchData().then((dynamic json) {
        entitleData(_searchModel.query, json);
        identifyData(json);
        json.addAll(foodSelectionService.data.foods);
        _searchModel.data.update(json);
        _searchModel.customData.foods.values.forEach((food) {
          if (_searchModel.query.toLowerCase().contains(food.title)) {
            _searchModel.data.add(food.clone());
          }
        });
        if (!_disposed) {
          notifyListeners();
        }
      });
    }
  }

  void toggleSelection(bool? isSelected, foodId) {
    if (isSelected ?? false) {
      foodSelectionService.addSelectedFood(foodId);
    } else {
      foodSelectionService.removeSelectedFood(foodId);
    }
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void identifyData(json) {
    Uuid uuid = const Uuid();
    for (var item in json['items']) {
      item['id'] = uuid.v4();
    }
    json['id'] = uuid.v4();
  }
}
