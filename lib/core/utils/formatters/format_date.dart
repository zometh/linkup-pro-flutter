import 'package:intl/intl.dart';

class FormatDate {
  String formatDateComplete(DateTime date) {
    return DateFormat("yMMMMEEEEd", 'fr_FR').format(date);
  }

  /*String formatToDate(Timestamp date) {
    return DateFormat.yMMMMd("fr_FR").format(date.toDate());
  }
  String formatToSimple(Timestamp date) {
    return DateFormat.yMd("fr_FR").format(date.toDate());
  }*/
   String formatMessageDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(date.year, date.month, date.day);

    if (messageDay == today) {
      return DateFormat('HH:mm', 'fr_FR').format(date);
    }
    if (today.compareTo(messageDay) == 1) {
      return "Hier ${DateFormat('HH:mm', 'fr_FR').format(date)}";
    } else if (messageDay.isAfter(today.subtract(const Duration(days: 7)))) {
      return "${DateFormat('EEEE', 'fr_FR').format(date)} à ${DateFormat('HH:mm', 'fr_FR').format(date)}";
    } else {
      return DateFormat('dd/MM/yyyy à HH:mm', 'fr_FR').format(date);
    }
  }
}
