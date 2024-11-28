import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_tracker_app/service/basal_metabolic_rate_service.dart';
import 'package:intl/intl.dart';
import '../model/food.dart';
import '../model/meal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/water.dart';
import '../model/weight.dart';

class FirestoreService {
  Future<void> addMealToUser(Map<String, dynamic> meal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final foodEntries =
        FirebaseFirestore.instance.collection('Users/$username/Food Entries');
    foodEntries.doc(meal['id']).set(meal);
  }

  Future<List<Meal>> getMealsFromUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    List<Meal> mealList = [];
    final foodEntries = FirebaseFirestore.instance
        .collection('Users/$username/Food Entries')
        .orderBy('timestamp', descending: true);
    final foodEntriesSnapshot = await foodEntries.get();
    final foodEntriesDocuments = foodEntriesSnapshot.docs;
    for (var foodEntry in foodEntriesDocuments) {
      mealList.add(Meal(json: foodEntry.data()));
    }
    return mealList;
  }

  Future<void> removeMealFromUser(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');

    final foodEntries =
        FirebaseFirestore.instance.collection('Users/$username/Food Entries');
    foodEntries.doc(id).delete();
  }

  Future<void> updateMealForUser(String id, Meal newMeal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final foodEntries =
        FirebaseFirestore.instance.collection('Users/$username/Food Entries');
    foodEntries.doc(id).update(newMeal.toJson());
  }

  Future<void> addCustomFoodForUser(Food customFood) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final foodEntries =
        FirebaseFirestore.instance.collection('Users/$username/Custom Foods');
    foodEntries.doc(customFood.id).set(customFood.toJson());
  }

  Future<List<Food>> getCustomFoodsFromUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    List<Food> foodList = [];
    final foodEntries =
        FirebaseFirestore.instance.collection('Users/$username/Custom Foods');
    final foodEntriesSnapshot = await foodEntries.get();
    final foodEntriesDocuments = foodEntriesSnapshot.docs;
    for (var foodEntry in foodEntriesDocuments) {
      foodList.add(Food.fromJson(foodEntry.data()));
    }
    return foodList;
  }

  Future<void> updateWaterEntryFromUser(Water water) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final waterEntries =
        FirebaseFirestore.instance.collection('Users/$username/Water Entries');
    waterEntries.doc(water.date.toString()).update(water.toJson());
  }

  Future<void> addWaterEntryForUser(Water water) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final waterEntries =
        FirebaseFirestore.instance.collection('Users/$username/Water Entries');
    waterEntries.doc(water.date.toString()).set(water.toJson());
  }

  Future<Water> getWaterEntryForUser(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final waterEntries =
        FirebaseFirestore.instance.collection('Users/$username/Water Entries');
    final waterEntry = await waterEntries.doc(date.toString()).get();

    if (!waterEntry.exists) {
      addWaterEntryForUser(Water(date: date, amount: 0, timestamps: []));
      return Water(date: date, amount: 0, timestamps: []);
    } else {
      return Water.fromJson(waterEntry.data() ?? {});
    }
  }

  Future<void> setWaterGoalForUser(int goal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final waterGoal = FirebaseFirestore.instance.collection('Users');
    waterGoal.doc('$username').update({'Water Goal': goal});
  }

  Future<int> getWaterGoalForUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final waterGoal = FirebaseFirestore.instance.collection('Users');
    final waterGoalDoc = await waterGoal.doc('$username').get();
    return waterGoalDoc.data()!['Water Goal'];
  }

  Future<List<Map<String, String>>> getUsersFromFirestore() async {
    List<Map<String, String>> users = [];
    final firestoreUsers = FirebaseFirestore.instance.collection('Users');
    final usersSnapshot = await firestoreUsers.get();
    final usersDocuments = usersSnapshot.docs;
    for (var user in usersDocuments) {
      users.add({'username': user.id, 'password': user.get('Password')});
    }
    return users;
  }

  Future<int> getUserHeightInInches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final user = FirebaseFirestore.instance.collection('Users');
    final userDoc = await user.doc('$username').get();
    return userDoc.data()!['Height'];
  }

  Future<String> getUserBirthdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final user = FirebaseFirestore.instance.collection('Users');
    final userDoc = await user.doc('$username').get();
    return userDoc.data()!['Birthdate'];
  }

  Future<String> getUserFirstName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final user = FirebaseFirestore.instance.collection('Users');
    final userDoc = await user.doc('$username').get();
    return userDoc.data()!['First Name'];
  }

  Future<String> getUserLastName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final user = FirebaseFirestore.instance.collection('Users');
    final userDoc = await user.doc('$username').get();
    return userDoc.data()!['Last Name'];
  }

  Future<double> getUserWeightInPounds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final user = FirebaseFirestore.instance.collection('Users');
    final userDoc = await user.doc('$username').get();
    return (userDoc.data()!['Weight'] as num).toDouble();
  }

  Future<String> getUserGender() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final user = FirebaseFirestore.instance.collection('Users');
    final userDoc = await user.doc('$username').get();
    return userDoc.data()!['Gender'];
  }

  Future<DateTime?> getMostRecentWaterForUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final waterEntries = FirebaseFirestore.instance
        .collection('Users/$username/Water Entries')
        .orderBy('date', descending: true)
        .limit(1);
    final waterEntriesSnapshot = await waterEntries.get();
    final waterEntry = waterEntriesSnapshot.docs.first;

    if (waterEntry.exists) {
      return DateTime.fromMillisecondsSinceEpoch(
          Water.fromJson(waterEntry.data()).timestamps.last);
    } else {
      return null;
    }
  }

  Future<List<Meal>> getMealsFromUserByTimestamp(DateTime day) async {
    List<Meal> out = await getMealsFromUser();
    out = out
        .where((meal) =>
            meal.timestamp.year == day.year &&
            meal.timestamp.month == day.month &&
            meal.timestamp.day == day.day)
        .toList();
    return out;
  }

  Future<void> setUserFirstName(firstName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final user = FirebaseFirestore.instance.collection('Users');
    user.doc('$username').update({'First Name': firstName});
  }

  Future<void> setUserLastName(lastName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final user = FirebaseFirestore.instance.collection('Users');
    user.doc('$username').update({'Last Name': lastName});
  }

  Future<void> setUserHeightInInches(height) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final user = FirebaseFirestore.instance.collection('Users');
    user.doc('$username').update({'Height': height});
  }

  Future<void> setUserWeightInPounds(weight) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final user = FirebaseFirestore.instance.collection('Users');
    user.doc('$username').update({'Weight': weight});
  }

  Future<void> setUserGender(gender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final user = FirebaseFirestore.instance.collection('Users');
    user.doc('$username').update({'Gender': gender});
  }

  Future<void> setUserBirthdate(birthdate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final user = FirebaseFirestore.instance.collection('Users');
    user.doc('$username').update({'Birthdate': birthdate});
  }

  Future<int> getUserLastWeightEntryNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final user = FirebaseFirestore.instance.collection('Users');
    final userDoc = await user.doc('$username').get();
    return userDoc.data()!['Last Weight Entry'];
  }

  Future<void> setUserLastWeightEntry(int num) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final user = FirebaseFirestore.instance.collection('Users');
    user.doc('$username').update({'Last Weight Entry': num});
  }

  Future<void> addUserWeightEntry(double weight, DateTime timestamp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final entries =
        FirebaseFirestore.instance.collection('Users/$username/Weight Entries');
    final date = DateTime(timestamp.year, timestamp.month, timestamp.day);
    final dateStr = DateFormat('yyyy-MM-dd').format(date);

    entries.doc(dateStr).set(Weight(timestamp: date, weight: weight).toJson());
  }

  Future<Map<DateTime, double>> getUserWeightEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final entries = FirebaseFirestore.instance
        .collection('Users/$username/Weight Entries')
        .orderBy('date');
    final entriesSnapshot = await entries.get();
    final entriesDocuments = entriesSnapshot.docs;
    Map<DateTime, double> out = {};
    entriesDocuments.forEach((entry) {
      var data = entry.data();
      out[DateTime.fromMillisecondsSinceEpoch(data['date'])] = data['weight'];
    });
    return out;
  }

  Future<Map<DateTime, double>> getUserWeightEntriesByTimestampRange(
      DateTime start, DateTime end) async {
    start = DateTime(start.year, start.month, start.day);
    end = DateTime(end.year, end.month, end.day);
    final weightEntries = await getUserWeightEntries();
    Map<DateTime, double> out = {};
    for (DateTime date = start;
        date.millisecondsSinceEpoch <= end.millisecondsSinceEpoch;
        date = DateTime(date.year, date.month, date.day + 1)) {
      if (weightEntries.keys.contains(date)) {
        out[date] = weightEntries[date]!;
      }
    }
    return out;
  }

  Future<double> getLastWeightEntryForUser() async {
    final entries = await getUserWeightEntries();
    return entries.values.last;
  }

  Future<double> getSecondLastWeightEntryForUser() async {
    final entries = await getUserWeightEntries();
    if (entries.values.isEmpty) return 0;
    if (entries.values.length > 1)
      return entries.values.toList()[entries.values.length - 2];
    return entries.values.toList()[1];
  }

  Future<double> getUserWeightByEntry(DateTime timestamp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final docRef = FirebaseFirestore.instance.doc(
        'Users/$username/Weight Entries/${DateFormat('yyyy-MM-dd').format(timestamp)}');
    final docSnapshot = await docRef.get();
    return (docSnapshot.data()!['weight']).toDouble();
  }

  Future<void> setUserWeightGoal(double num) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final user = FirebaseFirestore.instance.collection('Users');
    user.doc('$username').update({'Weight Goal': num});
  }

  Future<double> getUserWeightGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final user = FirebaseFirestore.instance.collection('Users');
    final userDoc = await user.doc('$username').get();
    return (userDoc.data()!['Weight Goal'] as num).toDouble();
  }

  Future<Lifestyle> getUserLifestyle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final user = FirebaseFirestore.instance.collection('Users');
    final userDoc = await user.doc('$username').get();
    final data = userDoc.data()!['Lifestyle'];
    switch (data) {
      case 'Sedentary':
        return Lifestyle.SEDENTARY;
      case 'Slightly Active':
        return Lifestyle.SLIGHTLY_ACTIVE;
      case 'Moderately Active':
        return Lifestyle.MODERATELY_ACTIVE;
      case 'Very Active':
        return Lifestyle.VERY_ACTIVE;
      case 'Extremely Active':
        return Lifestyle.EXTREMELY_ACTIVE;
      default:
        return Lifestyle.SEDENTARY;
    }
  }

  Future<void> setUserLifestyle(String lifestyle) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final user = FirebaseFirestore.instance.collection('Users');
    user.doc('$username').update({'Lifestyle': lifestyle});
  }

  Future<void> addWeightEntry(Weight weight, String num) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final user =
        FirebaseFirestore.instance.collection('Users/$username/Weight Entries');
    user.doc('entry${num}').set(weight.toJson());
  }

  Future<void> addCustomNotesForUser(String dailyNotes, DateTime now) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final dailynotes =
        FirebaseFirestore.instance.collection('Users/$username/Daily Notes');
    dailynotes
        .doc(DateFormat('MM dd yy').format(now))
        .set({'Daily Notes': dailyNotes});
  }

  Future<Map<DateTime, List<Meal>>> getMealsFromUserByTimestampRange(
      DateTime start, DateTime end) async {
    List<Meal> mealData = await getMealsFromUser();
    Map<DateTime, List<Meal>> out = {};
    var day = DateTime(start.year, start.month, start.day);
    end = DateTime(end.year, end.month, end.day);

    if (start.millisecondsSinceEpoch > end.millisecondsSinceEpoch)
      throw Error();
    while (
        day.year != end.year || day.month != end.month || day.day != end.day) {
      out[day] = [];
      day = DateTime(day.year, day.month, day.day + 1);
    }
    for (Meal meal in mealData) {
      if (out.keys.contains(meal.day)) {
        out[meal.day]!.add(meal);
      }
    }
    return out;
  }
}
