import 'package:intl/intl.dart';

class Water {
  String date;
  int amount;
  List<int> timestamps;

  Water({required this.date, required this.amount, required this.timestamps});

  factory Water.fromJson(Map<String, dynamic> json) {
    List<int> _timestamps = [];
    if (json['timestamps'] != null) {
      _timestamps =
          (json['timestamps'] as List).map((item) => item as int).toList();
    }
    return Water(
      date: json['date'] ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
      amount: json['amount'] ?? 0,
      timestamps: _timestamps,
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'amount': amount, 'timestamps': timestamps};
  }
}
