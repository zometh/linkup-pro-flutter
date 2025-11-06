import 'package:flutter/material.dart';

/// Ouvre un sélecteur de date en appliquant des règles métier.
///
/// - `onDatePicked`: callback quand l'utilisateur choisit une date.
/// - `context`: contexte Flutter.
/// - `initialDate` et `lastDate`: valeurs initiales optionnelles.
/// - `onAdjusted`: optional callback called when the provided initialDate/lastDate
///   had to be adjusted to fit into the allowed range.
pickDate({required Function(DateTime) onDatePicked, required BuildContext context, DateTime? initialDate, DateTime? lastDate, Function()? onAdjusted}) async {
    // Business rules:
    // - lastDate defaults to today (no future dates allowed)
    // - firstDate defaults to 120 years before today
    final DateTime now = DateTime.now();

    bool adjusted = false; // track if we had to adjust any incoming value

    DateTime mutableLast = lastDate ?? now;
    // Prevent lastDate in the future
    if (mutableLast.isAfter(now)) {
      mutableLast = now;
      adjusted = true;
    }

    DateTime firstDate = DateTime(now.year - 120);

    // Ensure firstDate is not after mutableLast (edge case if mutableLast was forced earlier)
    if (firstDate.isAfter(mutableLast)) {
      firstDate = DateTime(mutableLast.year - 100);
      adjusted = true;
    }

    // Ensure initialDate is within [firstDate, mutableLast]
    DateTime mutableInitial = initialDate ?? now;
    if (mutableInitial.isAfter(mutableLast)) {
      mutableInitial = mutableLast;
      adjusted = true;
    }
    if (mutableInitial.isBefore(firstDate)) {
      mutableInitial = firstDate;
      adjusted = true;
    }

    // If we adjusted incoming parameters, notify the caller so they can show a message
    if (adjusted && onAdjusted != null) {
      try {
        onAdjusted.call();
      } catch (_) {}
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: mutableInitial,
      firstDate: firstDate,
      lastDate: mutableLast,
    );

    if (pickedDate != null) {
      onDatePicked.call(pickedDate);
    }
  }