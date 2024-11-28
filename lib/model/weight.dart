import 'package:intl/intl.dart';

class Weight {
  DateTime date;

  String get dateStr => DateFormat('yyyy-MM-dd').format(date);
  double weight;

  Weight({required timestamp, required this.weight})
      : date = DateTime(timestamp.year, timestamp.month, timestamp.day);

  factory Weight.fromJson(Map<String, dynamic> json) {
    return Weight(
      timestamp: json['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['date'])
          : DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
      weight: json['amount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.millisecondsSinceEpoch,
      'weight': weight,
    };
  }
}
