import 'package:flutter/material.dart';
import 'package:food_tracker_app/model/meal.dart';
import '../../service/firestore_service.dart';

class NutritionRow extends StatefulWidget {
  final String label;
  dynamic value;
  final String measurement;
  final Meal currentMeal;
  Function setter;

  NutritionRow(this.label, this.value, this.measurement,
      {Key? key, required this.setter, required this.currentMeal})
      : super(key: key);

  @override
  NutritionRowState createState() => NutritionRowState();
}

class NutritionRowState extends State<NutritionRow> {
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
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black45,
          ),
          child: ListTile(
            title: Text('${widget.label}${widget.value}${widget.measurement}'),
            trailing: const Icon(Icons.edit),
          ),
        ),
      ),
    );
  }
}
