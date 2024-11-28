import 'package:flutter/cupertino.dart';
import 'package:food_tracker_app/service/basal_metabolic_rate_service.dart';
import 'package:food_tracker_app/model/settings.dart';
import '../service/firestore_service.dart';
import '../service/navigator_service.dart';

class SettingsViewModel extends ChangeNotifier {
  late final NavigatorService navigatorService;

  var firestore = FirestoreService();

  final Settings _model = Settings();

  String get firstName => _model.firstName;

  String get lastName => _model.lastName;

  int get heightInInches => _model.heightInInches;

  double get weightInPounds => _model.weightInPounds;

  String get birthDate => _model.birthDate;

  String get gender => _model.gender;

  Lifestyle get lifestyle => _model.lifestyle;

  Future<void> load() async {
    await _model.fetchSettings();
    notifyListeners();
  }

  String getFirstName() {
    return _model.firstName;
  }

  String getLastName() {
    return _model.lastName;
  }

  int getHeightInInches() {
    return _model.heightInInches;
  }

  double getWeightInPounds() {
    return _model.weightInPounds;
  }

  String getBirthDate() {
    return _model.birthDate;
  }

  void setFirstName(String firstName) {
    _model.firstName = firstName;
    firestore.setUserFirstName(firstName);
    notifyListeners();
  }

  void setLastName(String lastName) {
    _model.lastName = lastName;
    firestore.setUserLastName(lastName);
    notifyListeners();
  }

  void setHeightInInches(int heightInInches) {
    _model.heightInInches = heightInInches;
    firestore.setUserHeightInInches(heightInInches);
    notifyListeners();
  }

  void setWeightInPounds(double weightInPounds) {
    _model.weightInPounds = weightInPounds;
    firestore.setUserWeightInPounds(weightInPounds);
    notifyListeners();
  }

  void setBirthDate(String birthDate) {
    _model.birthDate = birthDate;
    firestore.setUserBirthdate(birthDate);
    notifyListeners();
  }

  void setGender(String gender) {
    _model.gender = gender;
    firestore.setUserGender(gender);
    notifyListeners();
  }

  void setLifestyle(Lifestyle lifestyle) {
    _model.lifestyle = lifestyle;
    print(_model.lifestyle);
    firestore.setUserLifestyle(getLifestyleAsString());
    notifyListeners();
  }

  String getLifestyleAsString() {
    switch (_model.lifestyle) {
      case Lifestyle.SEDENTARY:
        return 'Sedentary';
      case Lifestyle.SLIGHTLY_ACTIVE:
        return 'Slightly Active';
      case Lifestyle.MODERATELY_ACTIVE:
        return 'Moderately Active';
      case Lifestyle.VERY_ACTIVE:
        return 'Very Active';
      case Lifestyle.EXTREMELY_ACTIVE:
        return 'Extremely Active';
    }
  }

  void setLifestyleByString(String s) {
    switch (s) {
      case 'Sedentary':
        setLifestyle(Lifestyle.SEDENTARY);
        break;
      case 'Slightly Active':
        setLifestyle(Lifestyle.SLIGHTLY_ACTIVE);
        break;
      case 'Moderately Active':
        setLifestyle(Lifestyle.MODERATELY_ACTIVE);
        break;
      case 'Very Active':
        setLifestyle(Lifestyle.VERY_ACTIVE);
        break;
      case 'Extremely Active':
        setLifestyle(Lifestyle.EXTREMELY_ACTIVE);
        break;
    }
  }
}
