import 'package:flutter/material.dart';
import 'package:food_tracker_app/service/local_notification_service.dart';
import 'package:food_tracker_app/view/charts_view.dart';
import 'package:food_tracker_app/view/settings_view.dart';
import 'package:food_tracker_app/viewmodel/charts_viewmodel.dart';
import 'package:food_tracker_app/viewmodel/homepage_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_tracker_app/view/custom_food_view.dart';
import 'login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'provider/app_provider.dart';
import 'service/navigator_service.dart';
import 'view/home_page_view.dart';
import 'view/meal_list_view.dart';
import 'view/search_view.dart';

void main() async {
  final NavigatorService navigatorService = NavigatorService();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final NotificationService notificationService = NotificationService();
  runApp(MyApp(
    navigatorService: navigatorService,
    isLoggedIn: isLoggedIn,
    notificationService: notificationService,
  ));
}

class MyApp extends StatelessWidget {
  final NavigatorService navigatorService;
  final bool isLoggedIn;
  final NotificationService notificationService;

  const MyApp(
      {super.key,
      required this.navigatorService,
      required this.isLoggedIn,
      required this.notificationService});

  @override
  Widget build(context) {
    notificationService.startWaterTimer();
    notificationService.lateMealNotification();
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AppProvider(
              navigatorService: navigatorService,
              notificationService: notificationService,
              child: MaterialApp(
                title: 'Food Tracker App',
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.deepPurpleAccent,
                    brightness: Brightness.dark,
                  ),
                  primarySwatch: Colors.blue,
                ),
                home: isLoggedIn
                    ? ChangeNotifierProvider<HomePageViewModel>(
                        create: (_) => HomePageViewModel(),
                        builder: (context, child) {
                          return MyHomePage(
                            title: 'Hot Dog',
                            username: 'User',
                            viewModel: Provider.of<HomePageViewModel>(context),
                          );
                        },
                      )
                    : const LoginApp(title: 'Login'),
                navigatorKey: navigatorService.navigatorKey,
                routes: {
                  'MyHomePage': (context) => MyHomePage(
                        title: 'Hot Dog',
                        username: '',
                        viewModel: Provider.of<HomePageViewModel>(context),
                      ),
                  'MealListView': (context) => const MealListView(),
                  'SearchView': (context) => const SearchView(),
                  'SettingsView': (context) => const SettingsView(username: ''),
                  'CustomFoodView': (context) => CustomFoodView(),
                  'ChartsView': (context) => ChartsView(
                        chartsViewModel: Provider.of<ChartsViewModel>(context),
                      ),
                },
              ),
            );
          }
          return const MaterialApp(home: CircularProgressIndicator());
        });
  }
}
