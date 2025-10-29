
import 'package:flutter/material.dart';

pickDate({required Function(DateTime) onDatePicked, required BuildContext context, DateTime? initialDate, DateTime? lastDate}) async {
    final DateTime initial = initialDate ?? DateTime.now();
    final DateTime finalLastDate = lastDate ?? DateTime(2010);
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initial ,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().isBefore(finalLastDate) ? DateTime.now() : finalLastDate,
     
    );
    if (pickedDate != null) {
      onDatePicked.call(pickedDate);
    }
  }