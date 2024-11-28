import 'package:flutter/material.dart';
import '../../viewmodel/homepage_viewmodel.dart';
import '../daily_view.dart';

class DatePickerButton extends StatefulWidget {
  HomePageViewModel homePageViewModel;

  DatePickerButton({required this.homePageViewModel});

  @override
  _DatePickerButtonState createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {
  void _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DailyView(
            timestamp: pickedDate,
            homePageViewModel: widget.homePageViewModel,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: IconButton(
        icon: Icon(Icons.today),
        onPressed: () => _pickDate(context),
        iconSize: 24.0,
        constraints: BoxConstraints(minWidth: 24, minHeight: 24),
        padding: EdgeInsets.zero,
        alignment: Alignment.center,
      ),
    );
  }
}
