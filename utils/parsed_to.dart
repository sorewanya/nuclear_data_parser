import '../entities/parsed_value.dart';

/// Вспомогательная функция для генерации CSV полей из ParsedValue.
List<String> parsedToCsv(ParsedValue? pv) {
  if (pv == null) return ['""', '""'];
  return ['"${pv.value?.toString() ?? ""}"', pv.isSystematic ? '"#"' : '""'];
}

String parsedToDart(ParsedValue<double?>? pv) {
  if (pv == null) return 'ParsedValue<double?>(null,false)';
  return 'ParsedValue<double?>(${pv.value?.toString() ?? "null"},${pv.isSystematic})';
}

String parsedToCpp(ParsedValue<double?>? pv) {
  if (pv == null) return 'ParsedValue<std::optional<double>>(std::nullopt,false)';
  return 'ParsedValue<std::optional<double>>(${pv.value?.toString() ?? "std::nullopt"},${pv.isSystematic})';
}
