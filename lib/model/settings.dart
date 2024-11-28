import 'package:food_tracker_app/service/basal_metabolic_rate_service.dart';
import '../service/firestore_service.dart';

class Settings {
  FirestoreService firestore = FirestoreService();

  String firstName = '';
  String lastName = '';
  int heightInInches = 0;
  double weightInPounds = 0;
  String birthDate = '';
  String gender = '';
  Lifestyle lifestyle = Lifestyle.EXTREMELY_ACTIVE;

  Future<void> fetchSettings() async {
    firstName = await firestore.getUserFirstName();
    lastName = await firestore.getUserLastName();
    heightInInches = await firestore.getUserHeightInInches();
    weightInPounds = await firestore.getUserWeightInPounds();
    birthDate = await firestore.getUserBirthdate();
    gender = await firestore.getUserGender();
    lifestyle = await firestore.getUserLifestyle();
  }
}
