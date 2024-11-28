import 'package:flutter/material.dart';
import 'package:food_tracker_app/view/component/macro_pie_chart.dart';
import 'package:food_tracker_app/view/search_view.dart';
import 'package:food_tracker_app/view/settings_view.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../model/meal.dart';
import '../viewmodel/meal_list_viewmodel.dart';
import 'component/navbar.dart';
import 'meal_view.dart';

class MealListView extends StatelessWidget {
  const MealListView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MealListViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Log', style: TextStyle(color: Colors.black)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.black),
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
      body: FutureBuilder(
        future: viewModel.load(),
        builder: (context, snapshot) {
          return Consumer<MealListViewModel>(
            builder: (context, viewModel, child) {
              final mealsByDay = viewModel.mealsByDay;
              return ListView.builder(
                itemCount: mealsByDay.keys.length,
                itemBuilder: (context, index) {
                  DateTime date = mealsByDay.keys.elementAt(index);
                  List<Meal> dayMeals = mealsByDay[date]!;
                  double calories = 0;
                  double proteinG = 0;
                  double carbohydratesTotalG = 0;
                  double fatTotalG = 0;
                  dayMeals.forEach((meal) {
                    calories += meal.calories;
                    proteinG += meal.proteinG;
                    carbohydratesTotalG += meal.carbohydratesTotalG;
                    fatTotalG += meal.fatTotalG;
                  });
                  return ExpansionTile(
                    trailing: SizedBox(
                      width: 50,
                      height: 50,
                      child: MacroPieChart(
                        Theme.of(context).colorScheme.primaryContainer,
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.tertiary,
                        calories,
                        proteinG,
                        carbohydratesTotalG,
                        fatTotalG,
                        chartRadius: 50,
                        chartValuesOptions:
                            const ChartValuesOptions(showChartValues: false),
                        legendOptions: const LegendOptions(showLegends: false),
                        centerText: '',
                        ringStrokeWidth: 8,
                      ),
                    ),
                    title: Text(DateFormat('yyyy-MM-dd').format(date)),
                    children: dayMeals
                        .map((meal) => ListTile(
                              title: Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: MacroPieChart(
                                      Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context).colorScheme.tertiary,
                                      meal.calories,
                                      meal.proteinG,
                                      meal.carbohydratesTotalG,
                                      meal.fatTotalG,
                                      chartRadius: 50,
                                      chartValuesOptions:
                                          const ChartValuesOptions(
                                              showChartValues: false),
                                      legendOptions: const LegendOptions(
                                          showLegends: false),
                                      centerText: '',
                                      ringStrokeWidth: 8,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(meal.title),
                                        Text(meal.timestampString),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => viewModel.removeMeal(meal),
                                padding: const EdgeInsets.only(left: 0),
                              ),
                              onTap: () {
                                viewModel.editMeal(meal);
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      MealView(currentMeal: meal),
                                ));
                              },
                            ))
                        .toList(),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () => _showAddMealDialog(context, viewModel),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar:
          const NavBar(key: Key('customNavBar'), currentPage: 'MealListView'),
    );
  }

  void _showAddMealDialog(BuildContext context, MealListViewModel viewModel) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          TextEditingController controller = TextEditingController();
          return AlertDialog(
            title: const Text('Adding New Meal'),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                hintText: 'Meal Name',
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  String mealName = controller.text;
                  if (mealName == '') {
                    mealName = 'Empty Name';
                  }
                  dynamic json = {
                    'title': mealName,
                    'id': const Uuid().v4(),
                    'timestamp': DateTime.now().millisecondsSinceEpoch,
                    'items': [],
                  };
                  Meal newMeal = Meal(json: json);
                  viewModel.addMealFromMeal(newMeal);
                  viewModel.editMeal(newMeal);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SearchView()));
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }
}
