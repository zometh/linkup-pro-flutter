import 'package:easy_localization/easy_localization.dart';

class FormatNumber {
  FormatNumber._();
  static Map<String, dynamic> formatReactions(int count) {
    double formattedValue = count.toDouble();
    String suffix = '';


    if (count >= 1000000) {

      suffix = 'M';
      formattedValue = count / 1000000;
    } else if (count >= 1000) {
      suffix = 'K';
      formattedValue = count / 1000;

    }
    return {'value': formattedValue, 'suffix': suffix};
  }
}