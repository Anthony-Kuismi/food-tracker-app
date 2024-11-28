import 'package:flutter/material.dart';
import 'package:food_tracker_app/model/meal.dart';
import 'package:food_tracker_app/view/settings_view.dart';
import '../model/food.dart';
import './component/macro_pie_chart.dart';
import './component/nutrition_row.dart';
import '../service/firestore_service.dart';
import 'component/nutrition_oval.dart';

class FoodView extends StatefulWidget {
  final Food currentFood;
  final Meal currentMeal;
  FirestoreService firestoreService = FirestoreService();

  FoodView({super.key, required this.currentFood, required this.currentMeal});

  @override
  FoodViewState createState() => FoodViewState();
}

class FoodViewState extends State<FoodView> {
  void updateMacroPieChart(MacroPieChart macroPieChart) {
    setState(() {
      macroPieChart = MacroPieChart(
          Theme.of(context).colorScheme.primaryContainer,
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.tertiary,
          widget.currentFood.calories,
          widget.currentFood.proteinG,
          widget.currentFood.carbohydratesTotalG,
          widget.currentFood.fatTotalG);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentFood = widget.currentFood;
    MacroPieChart macroPieChart = MacroPieChart(
      Theme.of(context).colorScheme.primaryContainer,
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.tertiary,
      currentFood.calories,
      currentFood.proteinG,
      currentFood.carbohydratesTotalG,
      currentFood.fatTotalG,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          '${currentFood.title[0].toUpperCase()}${currentFood.title.substring(1)} Macros',
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: const Icon(Icons.person, color: Colors.white, size: 25),
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
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(13.0),
            ),
            Text(
              '${widget.currentFood.calories.toInt()} Calories',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(12.0),
                    child: NutritionOval('Protein', currentFood.proteinG, 'g',
                        setter: (newValue) async {
                      currentFood.setProteinG = newValue;
                      updateMacroPieChart(macroPieChart);
                      await widget.firestoreService
                          .addCustomFoodForUser(currentFood);
                    }, currentMeal: widget.currentMeal),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(12.0),
                    child: NutritionOval(
                      'Carbs',
                      currentFood.carbohydratesTotalG,
                      'g',
                      setter: (newValue) async {
                        currentFood.setCarbohydratesTotalG = newValue;
                        updateMacroPieChart(macroPieChart);
                        await widget.firestoreService
                            .addCustomFoodForUser(currentFood);
                      },
                      currentMeal: widget.currentMeal,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(12.0),
                    child: NutritionOval(
                      'Fats',
                      currentFood.fatTotalG,
                      'g',
                      setter: (newValue) async {
                        currentFood.setFatTotalG = newValue;
                        updateMacroPieChart(macroPieChart);
                        await widget.firestoreService
                            .addCustomFoodForUser(currentFood);
                      },
                      currentMeal: widget.currentMeal,
                    ),
                  ),
                ),
              ],
            ),
            macroPieChart,
            const Padding(
              padding: EdgeInsets.all(12.0),
            ),
            NutritionRow(
              'Saturated Fat:',
              currentFood.fatSaturatedG,
              'g',
              setter: (newValue) async {
                currentFood.setFatSaturatedG = newValue;
                updateMacroPieChart(macroPieChart);
                await widget.firestoreService.addCustomFoodForUser(currentFood);
              },
              currentMeal: widget.currentMeal,
            ),
            NutritionRow(
              'Fiber: ',
              currentFood.fiberG,
              'g',
              setter: (newValue) async {
                currentFood.fiberG = newValue;
                updateMacroPieChart(macroPieChart);
                await widget.firestoreService.addCustomFoodForUser(currentFood);
              },
              currentMeal: widget.currentMeal,
            ),
            NutritionRow(
              'Potassium: ',
              currentFood.potassiumMG,
              'mg',
              setter: (newValue) async {
                currentFood.potassiumMG = newValue;
                updateMacroPieChart(macroPieChart);
                await widget.firestoreService.addCustomFoodForUser(currentFood);
              },
              currentMeal: widget.currentMeal,
            ),
            NutritionRow(
              'Serving Size: ',
              currentFood.servingSizeG,
              'g',
              setter: (newValue) async {
                currentFood.servingSizeG = newValue;
                updateMacroPieChart(macroPieChart);
                await widget.firestoreService.addCustomFoodForUser(currentFood);
              },
              currentMeal: widget.currentMeal,
            ),
            NutritionRow(
              'Sodium: ',
              currentFood.sodiumMG,
              'mg',
              setter: (newValue) async {
                currentFood.sodiumMG = newValue;
                updateMacroPieChart(macroPieChart);
                await widget.firestoreService.addCustomFoodForUser(currentFood);
              },
              currentMeal: widget.currentMeal,
            ),
            NutritionRow(
              'Sugar: ',
              currentFood.sugarG,
              'g',
              setter: (newValue) async {
                currentFood.setSugarG = newValue;
                updateMacroPieChart(macroPieChart);
                await widget.firestoreService.addCustomFoodForUser(currentFood);
              },
              currentMeal: widget.currentMeal,
            ),
          ],
        ),
      )),
    );
  }
}
