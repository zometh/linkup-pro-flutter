import 'package:get_it/get_it.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import 'localdb.dart';
final localDb = GetIt.I<LocalDBService>();

class TranslationService {

  final TranslateLanguage sourceLanguage = TranslateLanguage.french;
 // final TranslateLanguage targetLanguage = TranslateLanguage.french;
 Future<String> translateToMyLanguage(String text, TranslateLanguage targetLang) async {
    final onDeviceTranslator = OnDeviceTranslator(sourceLanguage: sourceLanguage, targetLanguage: targetLang);
    try {
      final translatedText = await onDeviceTranslator.translateText(text);
      return translatedText;
    } catch (e) {
      return text;
    } finally {
      onDeviceTranslator.close();
    }
  }

  //final onDeviceTranslator = OnDeviceTranslator(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage);
}