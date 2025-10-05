import 'package:intl/intl.dart';

class FormatText {
  static String getMessageFromErrorCode(String errorCode) {
    switch (errorCode) {
      case 'too-many-requests':
        return "Trop de tentatives. Veuillez réessayer plus tard.";

      case "invalid-credential":
        return "Adresse email ou mot de passe incorrect";
      case "user-disabled":
        return "Votre compte est bloqué. Veuillez contacter l'administrateur";
      case "email-already-in-use":
        return "L'adresse email existe déja.";
      case "weak-password":
        return "Le mot de passe doit contenir au moins 6 caractères";
      case "invalid-email":
        return "L'adresse email est invalide";
      default:
        return "Connexion échouée. Veuillez réssayer plus tard";
    }
  }

  static String formatTitle(String title) {
    String title0 = title[0].toUpperCase();
    title0 += title.substring(1, title.length);
    return title0;
  }



  static String fromatPrenom(String prenom) {
    var liste = prenom.trim().split(' ');
    liste.removeWhere((element) => element.isEmpty);
    if (liste.length > 1) {
      return "${liste[0]} ${liste[1][0]}";
    } else {
      return liste[0];
    }
  }

  static String formatPrice(int price) {
    final NumberFormat formatter =
        NumberFormat.currency(locale: 'fr_FR', decimalDigits: 0, symbol: 'CFA');
    return (price == 0) ? "Prix sur demande" : formatter.format(price);
  }
}
