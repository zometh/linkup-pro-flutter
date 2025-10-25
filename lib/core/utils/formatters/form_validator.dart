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
    } else if (input.length < nbCar || input.length > maxCar) {
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
  static String? isValidName({required String name, int min = 2, int max = 20, field = "field"}) {
    if (name.isEmpty) {
      return "Champs requis";
    }
    else if (name.length < min || name.length > max) {
      return "field_length".tr(namedArgs: {
        "min": min.toString(),
        "max": max.toString()
      });
    }
    // Starts and ends with a letter.
    // Allows letters (including accented), spaces, apostrophes, and hyphens.
    // Disallows consecutive spaces, apostrophes, or hyphens.
    else if (!RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿĀ-ž](?!.*(?:[' -]{2}))[A-Za-zÀ-ÖØ-öø-ÿĀ-ž' -]*[A-Za-zÀ-ÖØ-öø-ÿĀ-ž]$", unicode: true).hasMatch(name)) {
      return "invalid_field".tr();
    }
    return null;
  }
  static String? isValidUsername({required String username, int min = 5, int max = 12}) {
    if (username.isEmpty) {
      return "required_field".tr();
    }
    if (username.length < min) {
      return "username_min_length".tr(namedArgs: {"min": min.toString()});
    }
    if (username.length > max) {
      return "username_max_length".tr(namedArgs: {"max": max.toString()});
    }

    // commence par une lettre, contient lettres/chiffres/._,
    final regex = RegExp(r'^[A-Za-z](?!.*[._]{2})[A-Za-z0-9._]*[A-Za-z0-9]$');
    if (!regex.hasMatch(username)) {
      return "invalid_username".tr();
    }
    return null;
  }
static String? isValidWebsite({required String website}) {
  if (website.isEmpty) {
    return "required_field".tr();
  }
  final uri = Uri.tryParse(website);
  if (uri == null ||
      (!uri.isAbsolute) ||
      (uri.scheme != 'http' && uri.scheme != 'https')) {
    // Translation key 'invalid_field_name' is expected to provide an error message for invalid website fields.
    // It should accept a named argument 'field' for the field name.
        return 'invalid_field_name'.tr(
          namedArgs: {
            'field': 'website'.tr(),
          },
        );
  }
  return null;
}
}
