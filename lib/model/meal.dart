import 'package:uuid/uuid.dart';

import 'food.dart';
import 'package:intl/intl.dart';

class Meal {
  String title;
  Map<String, Food> foods;
  String id;
  DateTime timestamp;
  static DateFormat dateFormat = DateFormat('HH:mm MM-dd-yyyy');

  String get timestampString => dateFormat.format(timestamp);

  int get timestampInt => timestamp.millisecondsSinceEpoch;

  Meal({required dynamic json})
      : title = json?['title'] ?? 'TITLE',
        id = json?['id'] ?? Uuid().v4(),
        timestamp = json?['timestamp'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['timestamp'])
            : DateTime.now(),
        foods = json?['items'] != null
            ? {for (var item in json?['items']) item['id']: Food.fromJson(item)}
            : {};

  Meal.fromFoodList(List<Food> foodList)
      : title = 'New Meal',
        id = const Uuid().v4(),
        timestamp = DateTime.now(),
        foods = {for (var item in foodList) item.id: item};

  get day => DateTime(timestamp.year, timestamp.month, timestamp.day);

  void add(Food food) {
    foods[food.id] = food;
  }

  void remove(Food food) {
    foods.remove(food.id);
  }

  void update(dynamic json) {
    foods = {for (var item in json['items']) item['id']: Food.fromJson(item)};
  }

  void updateFood(Food newFood) {
    foods[newFood.id] = newFood;
  }

  String get description {
    return foods.values.map((food) => food.title).join(', ');
  }

  List<String> get titles {
    return foods.values.map((food) => food.title).toList();
  }

  void rename(String title) {
    this.title = title;
  }

  List<String> get foodTitles =>
      foods.values.map((food) => food.title).toList();

  void entitle() {
    if (foods.isNotEmpty) {
      title = foodTitles.join(', ');
    } else {
      title = 'New Meal';
    }
  }

  Meal.clone(Meal other)
      : title = other.title,
        id = other.id,
        foods = Map<String, Food>.from(other.foods),
        timestamp = other.timestamp;

  Meal operator +(Meal other) {
    var newMeal = Meal.clone(this);

    newMeal.foods.addAll(foods);

    for (var food in other.foods.values) {
      newMeal.add(food);
    }
    return newMeal;
  }

  Meal operator -(Meal other) {
    var newMeal = Meal(json: {'items': []});
    newMeal.foods.addAll(foods);

    for (var food in other.foods.values) {
      if (newMeal.foods.containsKey(food.id)) {
        newMeal.remove(food);
      }
    }

    return newMeal;
  }

  void addUniqueTitles(Meal b) {
    Set<String> titles = this.titles.toSet();
    Iterable<Food> foods = b.foods.values;
    for (var food in foods) {
      if (!titles.contains(food.title) | food.custom == true) {
        add(food);
      }
    }
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> foodItemsJson =
        foods.values.map((food) => food.toJson()).toList();
    return {
      'title': title,
      'id': id,
      'timestamp': timestampInt,
      'items': foodItemsJson,
    };
  }

  List<Food> getFoodsByQuery(String query) {
    List<Food> out = [];
    for (var food in foods.values) {
      if (query.toLowerCase().contains(food.title.toLowerCase())) {
        out.add(food);
      }
    }
    return out;
  }

  double get calories {
    double out = 0;
    for (Food food in foods.values) {
      out += food.calories;
    }
    return out;
  }

  double get servingSizeG {
    double out = 0;
    for (Food food in foods.values) {
      out += food.servingSizeG;
    }
    return out;
  }

  double get fatTotalG {
    double out = 0;
    for (Food food in foods.values) {
      out += food.fatTotalG;
    }
    return out;
  }

  double get fatSaturatedG {
    double out = 0;
    for (Food food in foods.values) {
      out += food.fatSaturatedG;
    }
    return out;
  }

  double get proteinG {
    double out = 0;
    for (Food food in foods.values) {
      out += food.proteinG;
    }
    return out;
  }

  int get sodiumMG {
    int out = 0;
    for (Food food in foods.values) {
      out += food.sodiumMG;
    }
    return out;
  }

  int get potassiumMG {
    int out = 0;
    for (Food food in foods.values) {
      out += food.potassiumMG;
    }
    return out;
  }

  int get cholesterolMG {
    int out = 0;
    for (Food food in foods.values) {
      out += food.cholesterolMG;
    }
    return out;
  }

  double get carbohydratesTotalG {
    double out = 0;
    for (Food food in foods.values) {
      out += food.carbohydratesTotalG;
    }
    return out;
  }

  double get fiberG {
    double out = 0;
    for (Food food in foods.values) {
      out += food.fiberG;
    }
    return out;
  }

  double get sugarG {
    double out = 0;
    for (Food food in foods.values) {
      out += food.sugarG;
    }
    return out;
  }
}
