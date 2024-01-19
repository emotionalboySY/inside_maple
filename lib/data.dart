import 'package:hive/hive.dart';

class WeekType {
  WeekType({
    required this.year,
    required this.month,
    required this.weekNum,
    required this.startDate,
    required this.endDate,
  });

  final int year;
  final int month;
  final int weekNum;
  final DateTime startDate;
  final DateTime endDate;

  @override
  String toString() {
    return "<WeekType instance>\n"
        "year: $year\n"
        "month: $month\n"
        "weekNum: $weekNum\n"
        "startDate: $startDate\n"
        "endDate: $endDate\n";
  }

  String toTitleString() {
    return "$year년 $month월 $weekNum주차";
  }

  String getPeriodKorString() {
    return "${startDate.month}/${startDate.day} ~ ${endDate.month}/${endDate.day}";
  }

  @override
  bool operator ==(Object other) {
    if (other is WeekType) {
      return year == other.year && month == other.month && weekNum == other.weekNum;
    }
    return false;
  }

  @override
  int get hashCode {
    return Object.hash(year, month, weekNum);
  }

  WeekType.clone(WeekType weekType)
      : year = weekType.year,
        month = weekType.month,
        weekNum = weekType.weekNum,
        startDate = weekType.startDate,
        endDate = weekType.endDate;
}