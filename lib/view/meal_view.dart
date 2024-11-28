import 'package:flutter/material.dart';
import 'package:food_tracker_app/view/search_view.dart';
import 'package:food_tracker_app/view/settings_view.dart';
import 'package:food_tracker_app/viewmodel/search_viewmodel.dart';
import 'package:provider/provider.dart';
import '../model/meal.dart';
import '../viewmodel/meal_list_viewmodel.dart';
import './component/macro_pie_chart.dart';

class MealView extends StatefulWidget {
  final Meal currentMeal;

  const MealView({super.key, required this.currentMeal});

  @override
  MealViewState createState() => MealViewState();
}

class MealViewState extends State<MealView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MealListViewModel>(context, listen: true);
    final searchViewModel =
        Provider.of<SearchViewModel>(context, listen: false);
    final foodSelectionService = searchViewModel.foodSelectionService;
    return PopScope(
      onPopInvoked: (bool didPop) {
        if (didPop) {
          searchViewModel.reset();
          foodSelectionService.reset();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            widget.currentMeal.title,
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
                    icon:
                        const Icon(Icons.person, color: Colors.white, size: 25),
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
        body: Stack(
          children: [
            SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(13.0),
                  ),
                  Text(
                    '${widget.currentMeal.calories.toInt()} Calories',
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
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Container(
                              height: 120,
                              width: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    width: 8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${widget.currentMeal.proteinG.toInt()}g',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    'Protein',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(12.0),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Container(
                              height: 120,
                              width: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    width: 8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${widget.currentMeal.carbohydratesTotalG.toInt()}g',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    'Carbs',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(12.0),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Container(
                              height: 120,
                              width: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    width: 8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${widget.currentMeal.fatTotalG.toInt()}g',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    'Fats',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  MacroPieChart(
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.tertiary,
                      widget.currentMeal.calories,
                      widget.currentMeal.proteinG,
                      widget.currentMeal.carbohydratesTotalG,
                      widget.currentMeal.fatTotalG),
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black45,
                      ),
                      child: ListTile(
                        title: Text(
                            'Saturated Fats: ${widget.currentMeal.fatSaturatedG}g'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black45,
                      ),
                      child: ListTile(
                        title: Text('Fiber: ${widget.currentMeal.fiberG}g'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black45,
                      ),
                      child: ListTile(
                        title: Text(
                            'Potassium: ${widget.currentMeal.potassiumMG}g'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black45,
                      ),
                      child: ListTile(
                        title: Text('Sodium: ${widget.currentMeal.sodiumMG}g'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black45,
                      ),
                      child: ListTile(
                        title: Text('Sugar: ${widget.currentMeal.sugarG}g'),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            )),
            Positioned(
              bottom: 5,
              left: MediaQuery.of(context).size.width * 0.22,
              right: MediaQuery.of(context).size.width * 0.22,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    viewModel.editMeal(widget.currentMeal);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => SearchView(),
                    ));
                  },
                  icon: Icon(Icons.add),
                  label: Text('Add & Edit Foods'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
