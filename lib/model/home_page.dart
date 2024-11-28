import 'package:food_tracker_app/model/water.dart';
import 'package:intl/intl.dart';
import '../service/firestore_service.dart';
import '../service/basal_metabolic_rate_service.dart';

class HomePage {
  FirestoreService firestore = FirestoreService();
  BMRService bmrService = BMRService();

  Water water = Water(
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      amount: 0,
      timestamps: []);
  int waterGoal = 10;

  double calories = 0.0;
  double proteinG = 0.0;
  double carbohydratesTotalG = 0.0;
  double fatTotalG = 0.0;

  Gender gender = Gender.NOT_SPECIFIED;
  Lifestyle lifestyle = Lifestyle.SEDENTARY;
  int height = 0;
  double age = 0;

  double weight = 0;
  double weightGoal = 0;
  int lastEntryNumber = 0;
  double lastWeight = 0;

  Future<void> fetchWaterEntry(String date) async {
    water = await FirestoreService().getWaterEntryForUser(date);
    waterGoal = await FirestoreService().getWaterGoalForUser();
  }

  void addWater() {
    water.amount++;
    water.timestamps.add(DateTime.now().millisecondsSinceEpoch);
  }

  void removeWater() {
    water.amount--;
    water.timestamps.removeLast();
  }

  void setWaterGoal(int goal) {
    this.waterGoal = goal;
  }

  int getWaterGoal() {
    return waterGoal;
  }

  int getWaterAmount() {
    return water.amount;
  }

  List<int> getTimestamps() {
    return water.timestamps;
  }

  Future<void> fetchWeightEntry(String date) async {
    try {
      lastEntryNumber = await FirestoreService().getUserLastWeightEntryNumber();

      weight = await FirestoreService().getUserWeightInPounds();
      weightGoal = await FirestoreService().getUserWeightGoal();
      var lastWeight =
          await FirestoreService().getSecondLastWeightEntryForUser();

      this.lastWeight = lastWeight;
    } catch (e) {}
  }

  Future<void> fetchUserInfo() async {
    String genderString = await firestore.getUserGender();
    String dateString = await firestore.getUserBirthdate();
    height = await firestore.getUserHeightInInches();

    switch (genderString) {
      case 'Male':
        gender = Gender.MALE;
        break;
      case 'Female':
        gender = Gender.FEMALE;
        break;
      default:
        gender = Gender.NOT_SPECIFIED;
        break;
    }
    final month = int.parse(dateString.substring(0, 2));
    final day = int.parse(dateString.substring(3, 5));
    final year = int.parse(dateString.substring(6));
    final birthdate = DateTime(year, month, day);
    final delta = DateTime.now().difference(birthdate);
    age = delta.inDays / 365;
    lifestyle = await firestore.getUserLifestyle();
  }

  double getDailyCalorieGoal() {
    return bmrService.calculateDailyCalorieGoal(
        weight * 0.453592, height * 2.54, gender, age, lifestyle, weightGoal);
  }
}
