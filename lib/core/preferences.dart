import 'package:twinkle/core/types.dart';

// Interface language
Language _language = Language(initValue: LanguageEnum.Eng);
set languageIndex (
    int index){_language.index = index;
    // Reload app
}
Language get language => _language;