import 'package:flutter/material.dart';
import 'package:food_tracker_app/model/meal.dart';
import 'package:food_tracker_app/service/food_selection_service.dart';
import 'package:food_tracker_app/view/search_view.dart';
import 'package:food_tracker_app/view/settings_view.dart';
import 'package:food_tracker_app/viewmodel/meal_list_viewmodel.dart';
import 'package:provider/provider.dart';
import '../model/food.dart';
import '../service/firestore_service.dart';

class CustomFoodView extends StatelessWidget {
  final Food? editingFood;

  late FoodSelectionService? foodSelectionService;

  CustomFoodView({Key? key, this.editingFood, this.foodSelectionService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Food editingFood = this.editingFood ?? Food.fromJson({});
    foodSelectionService ??= Provider.of<FoodSelectionService>(context);
    return FoodForm(
        editingFood: editingFood,
        foodSelectionService: this.foodSelectionService!);
  }
}

class FoodForm extends StatefulWidget {
  final Food editingFood;

  final FirestoreService firestore = FirestoreService();
  final FoodSelectionService foodSelectionService;

  FoodForm(
      {super.key,
      required this.editingFood,
      required this.foodSelectionService});

  @override
  FoodFormState createState() => FoodFormState();
}

class FoodFormState extends State<FoodForm> {
  Food? editingFood;
  Meal? editingMeal;
  late TextEditingController _nameController;
  late TextEditingController _caloriesController;
  late TextEditingController _servingController;
  late TextEditingController _fatTotalController;
  late TextEditingController _fatSatController;
  late TextEditingController _proteinController;
  late TextEditingController _sodiumController;
  late TextEditingController _potassiumController;
  late TextEditingController _cholesterolController;
  late TextEditingController _carbsController;
  late TextEditingController _fiberController;
  late TextEditingController _sugarController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.editingFood.title);
    _caloriesController =
        TextEditingController(text: widget.editingFood.calories.toString());
    _proteinController =
        TextEditingController(text: widget.editingFood.proteinG.toString());
    _carbsController = TextEditingController(
        text: widget.editingFood.carbohydratesTotalG.toString());
    _servingController =
        TextEditingController(text: widget.editingFood.servingSizeG.toString());
    _fatTotalController =
        TextEditingController(text: widget.editingFood.fatTotalG.toString());
    _fatSatController = TextEditingController(
        text: widget.editingFood.fatSaturatedG.toString());
    _sodiumController =
        TextEditingController(text: widget.editingFood.sodiumMG.toString());
    _potassiumController =
        TextEditingController(text: widget.editingFood.potassiumMG.toString());
    _cholesterolController = TextEditingController(
        text: widget.editingFood.cholesterolMG.toString());
    _fiberController =
        TextEditingController(text: widget.editingFood.fiberG.toString());
    _sugarController =
        TextEditingController(text: widget.editingFood.sugarG.toString());
  }

  @override
  Widget build(BuildContext context) {
    final mealListViewModel =
        Provider.of<MealListViewModel>(context, listen: false);
    editingFood = editingFood ?? Food.fromJson({});

    var calories = Text('Calories: ${editingFood!.calories}');

    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Custom Food'),
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: IconButton(
                icon: const Icon(Icons.person, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsView(
                                username: '',
                              )));
                },
                iconSize: 30,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name of Food'),
                  onChanged: (newValue) {
                    editingFood!.setTitle = newValue;
                  },
                ),
                const SizedBox(height: 10),
                calories,
                const SizedBox(height: 10),
                TextField(
                  controller: _proteinController,
                  decoration:
                      const InputDecoration(labelText: 'Protein (Grams)'),
                  keyboardType: TextInputType.number,
                  onChanged: (newValue) {
                    setState(() {
                      editingFood!.setProteinG = double.parse(newValue);
                      calories = Text('Calories: ${editingFood!.calories}');
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _carbsController,
                  decoration: const InputDecoration(labelText: 'Carbs (Grams)'),
                  keyboardType: TextInputType.number,
                  onChanged: (newValue) {
                    setState(() {
                      editingFood!.setCarbohydratesTotalG =
                          double.parse(newValue);
                      calories = Text('Calories: ${editingFood!.calories}');
                    });
                  },
                ),
                TextField(
                  controller: _servingController,
                  decoration: const InputDecoration(labelText: 'Servings'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _fatTotalController,
                  decoration:
                      const InputDecoration(labelText: 'Total Fat (Grams)'),
                  keyboardType: TextInputType.number,
                  onChanged: (newValue) {
                    setState(() {
                      editingFood!.setFatTotalG = double.parse(newValue);
                      calories = Text('Calories: ${editingFood!.calories}');
                    });
                  },
                ),
                TextField(
                  controller: _fatSatController,
                  decoration:
                      const InputDecoration(labelText: 'Saturated Fat (Grams)'),
                  keyboardType: TextInputType.number,
                  onChanged: (newValue) {
                    setState(() {
                      editingFood!.setFatSaturatedG = double.parse(newValue);
                    });
                  },
                ),
                TextField(
                  controller: _sodiumController,
                  decoration:
                      const InputDecoration(labelText: 'Sodium (Grams)'),
                  keyboardType: TextInputType.number,
                  onChanged: (newValue) {
                    setState(() {
                      editingFood!.setSodiumMg = double.parse(newValue);
                    });
                  },
                ),
                TextField(
                  controller: _cholesterolController,
                  decoration:
                      const InputDecoration(labelText: 'Cholesterol (Grams)'),
                  keyboardType: TextInputType.number,
                  onChanged: (newValue) {
                    setState(() {
                      editingFood!.setCholesterolMg = double.parse(newValue);
                    });
                  },
                ),
                TextField(
                  controller: _potassiumController,
                  decoration:
                      const InputDecoration(labelText: 'Potassium (Grams)'),
                  keyboardType: TextInputType.number,
                  onChanged: (newValue) {
                    setState(() {
                      editingFood!.setCholesterolMg = double.parse(newValue);
                    });
                  },
                ),
                TextField(
                  controller: _fiberController,
                  decoration: const InputDecoration(labelText: 'Fiber (Grams)'),
                  keyboardType: TextInputType.number,
                  onChanged: (newValue) {
                    setState(() {
                      editingFood!.setFiberG = double.parse(newValue);
                    });
                  },
                ),
                TextField(
                  controller: _sugarController,
                  decoration: const InputDecoration(labelText: 'Sugar (Grams)'),
                  keyboardType: TextInputType.number,
                  onChanged: (newValue) {
                    setState(() {
                      editingFood!.setSugarG = double.parse(newValue);
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await widget.firestore.addCustomFoodForUser(editingFood!);
                    Meal oldMeal =
                        widget.foodSelectionService.editingMeal as Meal;
                    widget.foodSelectionService.data.add(editingFood!);
                    mealListViewModel.updateMeal(
                        oldMeal, widget.foodSelectionService.data);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => SearchView(),
                    ));
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _servingController.dispose();
    _fatTotalController.dispose();
    _fatSatController.dispose();
    _proteinController.dispose();
    _sodiumController.dispose();
    _potassiumController.dispose();
    _cholesterolController.dispose();
    _carbsController.dispose();
    _fiberController.dispose();
    _sugarController.dispose();
    super.dispose();
  }
}
