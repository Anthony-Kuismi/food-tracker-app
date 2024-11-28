import 'package:flutter/material.dart';
import 'package:food_tracker_app/viewmodel/charts_viewmodel.dart';
import 'package:food_tracker_app/viewmodel/daily_viewmodel.dart';
import 'package:provider/provider.dart';
import '../service/food_selection_service.dart';
import '../service/local_notification_service.dart';
import '../service/navigator_service.dart';
import '../service/auth_service.dart';
import '../viewmodel/homepage_viewmodel.dart';
import '../viewmodel/meal_list_viewmodel.dart';
import '../viewmodel/search_viewmodel.dart';
import '../viewmodel/settings_viewmodel.dart';

class AppProvider extends StatelessWidget {
  final Widget child;
  final NavigatorService navigatorService;
  final NotificationService notificationService;

  const AppProvider(
      {super.key,
      required this.child,
      required this.navigatorService,
      required this.notificationService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<NavigatorService>(create: (context) => navigatorService),
        ChangeNotifierProvider(create: (context) => FoodSelectionService()),
        ChangeNotifierProxyProvider2<FoodSelectionService, NavigatorService,
            MealListViewModel>(
          create: (context) => MealListViewModel(navigatorService,
              Provider.of<FoodSelectionService>(context, listen: false)),
          update: (context, foodSelectionService, navigatorService,
                  previousViewModel) =>
              MealListViewModel(navigatorService, foodSelectionService),
        ),
        ChangeNotifierProxyProvider2<FoodSelectionService, NavigatorService,
            SearchViewModel>(
          create: (context) => SearchViewModel(navigatorService,
              Provider.of<FoodSelectionService>(context, listen: false)),
          update: (context, foodSelectionService, navigatorService,
                  previousViewModel) =>
              SearchViewModel(navigatorService, foodSelectionService),
        ),
        ChangeNotifierProvider(
          create: (context) => HomePageViewModel(),
        ),
        ChangeNotifierProvider(create: (context) => notificationService),
        Provider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider(
          create: (context) => SettingsViewModel(),
        ),
        ChangeNotifierProvider<DailyViewModel>(
            create: (context) => DailyViewModel(null)),
        ChangeNotifierProvider<ChartsViewModel>(
            create: (context) => ChartsViewModel(
                start: DateTime.now().subtract(Duration(days: 7)),
                end: DateTime.now()))
      ],
      child: child,
    );
  }
}
