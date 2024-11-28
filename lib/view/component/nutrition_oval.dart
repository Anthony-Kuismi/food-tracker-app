import 'package:flutter/material.dart';
import 'package:food_tracker_app/model/meal.dart';
import '../../service/firestore_service.dart';

class NutritionOval extends StatefulWidget {
  final String label;
  dynamic value;
  final String measurement;
  final Meal currentMeal;
  Function setter;

  NutritionOval(this.label, this.value, this.measurement,
      {Key? key, required this.setter, required this.currentMeal})
      : super(key: key);

  @override
  NutritionOvalState createState() => NutritionOvalState();
}

class NutritionOvalState extends State<NutritionOval> {
  FirestoreService firestoreService = FirestoreService();

  void updateValue(newValue) {
    widget.setter(newValue);
    firestoreService.updateMealForUser(
        widget.currentMeal.id, widget.currentMeal);
    setState(() {
      widget.value = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                TextEditingController controller = TextEditingController();
                return AlertDialog(
                  title: Text('Editing ${widget.label}'),
                  content: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter New Value',
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        dynamic newValue = double.tryParse(controller.text);
                        if (newValue != null) {
                          if (widget.measurement == 'mg') {
                            newValue = newValue.round();
                          }
                          updateValue(newValue);
                        }
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Container(
            height: 120,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  width: 8),
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.value.toInt()}${widget.measurement}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${widget.label}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
                Positioned(
                  top: 10,
                  child: Icon(Icons.edit, size: 14),
                ),
              ],
            ),
          ),
        ));
  }
}
