import '../entities/parsed_value.dart';

/// Вспомогательная функция для парсинга числовых значений из файла.
/// Обрабатывает значения, полученные из систематики ('#') и отсутствующие значения ('*').
///
/// Helper function for parsing numeric values from a file.
/// Handles values obtained from taxonomy ('#') and missing values ('*').
ParsedValue<double?> parseDouble(String text, [bool nubase = false]) {
  final trimmed = text.trim();
  if (trimmed.isEmpty || trimmed == '*') {
    return ParsedValue(null, false);
  }
  final isSystematic = trimmed.contains('#');

  /// Заменяем # на . для парсинга(# используется в оригинальном файле как замена точки для оценочных значений)
  /// и удаляем нечисловые символы, если они есть.
  ///
  /// Replace # with . for parsing (# is used in the original file as a replacement for a period for systematic)
  /// and remove non-numeric characters, if any.
  final parsable = nubase
      ? trimmed.replaceAll(RegExp(r'[^\d\.\-\+]'), '')
      : trimmed.replaceAll('#', '.').replaceAll(RegExp(r'[^\d\.\-\+]'), '');
  return ParsedValue(double.tryParse(parsable), isSystematic);
}
