class AppSettings {
  final String language;
  final bool darkMode;
  final bool notificationsEnabled;
  final String currency;
  final String distanceUnit;

  const AppSettings({
    required this.language,
    required this.darkMode,
    required this.notificationsEnabled,
    required this.currency,
    required this.distanceUnit,
  });
}

class LanguageOption {
  final String code;
  final String name;
  final String nativeName;

  const LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
  });
}

const supportedLanguages = [
  LanguageOption(code: 'en', name: 'English', nativeName: 'English'),
  LanguageOption(code: 'ar', name: 'Arabic', nativeName: 'العربية'),
];
