import 'package:uuid/uuid.dart';

class Food {
  String title;
  String id;
  String name;

  double servingSizeG;
  double fatTotalG;
  double fatSaturatedG;
  double proteinG;
  int sodiumMG;
  int potassiumMG;
  int cholesterolMG;
  double carbohydratesTotalG;
  double fiberG;
  double sugarG;
  bool custom;

  Food(
      {required this.title,
      required this.id,
      required this.name,
      required this.servingSizeG,
      required this.fatTotalG,
      required this.fatSaturatedG,
      required this.proteinG,
      required this.sodiumMG,
      required this.potassiumMG,
      required this.cholesterolMG,
      required this.carbohydratesTotalG,
      required this.fiberG,
      required this.sugarG,
      required this.custom});

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      title: json['title'] ?? 'New Food',
      id: json['id'] ?? const Uuid().v4(),
      name: json['name'] ?? 'New Food',
      servingSizeG: json['serving_size_g']?.toDouble() ?? 0.0,
      fatTotalG: json['fat_total_g']?.toDouble() ?? 0.0,
      fatSaturatedG: json['fat_saturated_g']?.toDouble() ?? 0.0,
      proteinG: json['protein_g']?.toDouble() ?? 0.0,
      sodiumMG: json['sodium_mg'] ?? 0,
      potassiumMG: json['potassium_mg'] ?? 0,
      cholesterolMG: json['cholesterol_mg'] ?? 0,
      carbohydratesTotalG: json['carbohydrates_total_g']?.toDouble() ?? 0.0,
      fiberG: json['fiber_g']?.toDouble() ?? 0.0,
      sugarG: json['sugar_g']?.toDouble() ?? 0.0,
      custom: json['custom'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'id': id,
      'name': name,
      'calories': calories,
      'serving_size_g': servingSizeG,
      'fat_total_g': fatTotalG,
      'fat_saturated_g': fatSaturatedG,
      'protein_g': proteinG,
      'sodium_mg': sodiumMG,
      'potassium_mg': potassiumMG,
      'cholesterol_mg': cholesterolMG,
      'carbohydrates_total_g': carbohydratesTotalG,
      'fiber_g': fiberG,
      'sugar_g': sugarG,
      'custom': custom,
    };
  }

  set setTitle(newValue) {
    title = newValue.toString();
    custom = true;
  }

  set setName(newValue) {
    name = newValue;
    custom = true;
  }

  set setServingSizeG(newValue) {
    servingSizeG = newValue;
    custom = true;
  }

  set setFatTotalG(newValue) {
    fatTotalG = newValue;
    custom = true;
  }

  set setFatSaturatedG(newValue) {
    fatSaturatedG = newValue;
    custom = true;
  }

  set setProteinG(newValue) {
    proteinG = newValue;
    custom = true;
  }

  set setSodiumMg(newValue) {
    sodiumMG = newValue;
    custom = true;
  }

  set setPotassiumMg(newValue) {
    potassiumMG = newValue;
    custom = true;
  }

  set setCholesterolMg(newValue) {
    cholesterolMG = newValue;
    custom = true;
  }

  set setCarbohydratesTotalG(newValue) {
    carbohydratesTotalG = newValue;
    custom = true;
  }

  set setFiberG(newValue) {
    fiberG = newValue;
    custom = true;
  }

  set setSugarG(newValue) {
    sugarG = newValue;
    custom = true;
  }

  double get calories {
    return fatTotalG * 9 + carbohydratesTotalG * 4 + proteinG * 4;
  }

  Food clone() {
    Food clone = Food.fromJson(this.toJson());
    clone.id = Uuid().v4();
    return clone;
  }
}
