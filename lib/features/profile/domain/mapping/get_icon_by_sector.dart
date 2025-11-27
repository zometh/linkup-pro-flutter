import 'package:flutter/material.dart';

/*
"Tech & Digital" : "Tech & Digital",
  "Finance & Banking" : "Finance & Banque",
  "Health & Biotech" : "Santé & Biotech",
  "Education & Training" : "Éducation & Formation",
  "Industry & Energy" : "Industrie & Énergie",
  "Marketing & Sales" : "Marketing & Ventes",
  "Media & Communication" : "Média & Communication",
  "Public Services": "Services Publics",
  "Construction & Real Estate" : "Construction & Immobilier",
  "Transport & Logistics" : "Transport & Logistique",
  "Agriculture & Environment" : "Agriculture & Environnement",
  "Arts & Entertainment" : "Arts & Divertissement",
  "Legal & Consulting" : "Juridique & Conseil",
  "Hospitality & Tourism" : "Hôtellerie & Tourisme",
  "Sports & Wellbeing" : "Sports & Bien-être",
  "Other" : "Autre",
 */

IconData getIconBySector(String sector) {
  switch (sector) {
    case "Tech & Digital":
      return Icons.computer;
    case "Finance & Banking":
      return Icons.account_balance;
    case "Health & Biotech":
      return Icons.health_and_safety;
    case "Education & Training":
      return Icons.school;
    case "Industry & Energy":
      return Icons.factory;
    case "Marketing & Sales":
      return Icons.campaign;
    case "Media & Communication":
      return Icons.message;
    case "Public Services":
      return Icons.account_balance_wallet;
    case "Construction & Real Estate":
      return Icons.home_work;
    case "Transport & Logistics":
      return Icons.local_shipping;
    case "Agriculture & Environment":
      return Icons.agriculture;
    case "Arts & Entertainment":
      return Icons.palette;
    case "Legal & Consulting":
      return Icons.gavel;
    case "Hospitality & Tourism":
      return Icons.hotel;
    case "Sports & Wellbeing":
      return Icons.sports_soccer;
    case "Other":
    default:
      return Icons.work;
  }
}