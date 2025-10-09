import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';

class FormValidator {
  static String? isValidMail(String email) {
    if (email.isEmpty) {
      return "Champs requis";
    } else if (!EmailValidator.validate(email)) {
      return "Adresse email incorrecte !";
    }
    return null;
  }
  static String? isValidEmailOrUsername(String input) {
    if (input.isEmpty) {
      return "required_field".tr();
    } else if (!input.contains('@') && input.length < 5) {
      return "username_min_length".tr(namedArgs: {
        "min": "5"
      });
    } else if (input.contains('@') && !EmailValidator.validate(input)) {
      return "invalid_email".tr();
    }
    return null;
  }
  static String? isValidField({required String input, int nbCar = 5, int maxCar = 50}) {
    if (input.isEmpty) {
      return "required_field".tr();
    } else if (input.length < nbCar) {
      return "field_length".tr(namedArgs: {
        "min": nbCar.toString(),
        "max": maxCar.toString()
      });
    }
    return null;
  }

  static String? isValidPassword(String pwd) {
    return pwd.length < 6
        ? "Le mot de passe doit contenir au moins 6 caractères"
        : null;
  }
  static String? isValidFullName(String fullName) {
    if (fullName.isEmpty) {
      return "Champs requis";
    } else if (!RegExp(r'^[a-zA-Z]+ [a-zA-Z]+$').hasMatch(fullName)) {
      return "Nom complet invalide";
    }
    return null;
  }
}
