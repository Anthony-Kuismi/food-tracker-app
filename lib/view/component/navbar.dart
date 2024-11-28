import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../service/navigator_service.dart';

class NavBar extends StatelessWidget {
  final String currentPage;

  const NavBar({required Key key, required this.currentPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NavigatorService navigatorService =
        Provider.of<NavigatorService>(context, listen: false);

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border(
          top: BorderSide(
            color:
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7),
            spreadRadius: 5.0,
            blurRadius: 15.0,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: currentPage == 'MealListView'
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              icon: const Icon(Icons.menu_book, color: Colors.white),
              onPressed: () {
                navigatorService.pushReplace('MealListView');
              },
              iconSize: 30,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: currentPage == 'MyHomePage'
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                navigatorService.pushReplace('MyHomePage');
              },
              iconSize: 30,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: currentPage == 'ChartsView'
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              icon: const Icon(Icons.insert_chart_outlined_rounded,
                  color: Colors.white),
              onPressed: () {
                navigatorService.pushReplace('ChartsView');
              },
              iconSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}
