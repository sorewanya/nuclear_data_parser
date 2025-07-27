import '../entities/syst_value.dart';

/// Вспомогательная функция для генерации CSV полей из SystValue.
List<String> parsedToCsv(SystValue? pv) {
  if (pv == null) return ['""', '""'];
  return ['"${pv.value?.toString() ?? ""}"', pv.isSystematic ? '"#"' : '""'];
}

String parsedToDart(SystValue<double?>? pv) {
  if (pv == null) return 'SystValue<double?>(null,false)';
  return 'SystValue<double?>(${pv.value?.toString() ?? "null"},${pv.isSystematic})';
}

String parsedToCpp(SystValue<double?>? pv) {
  if (pv == null) return 'SystValue<std::optional<double>>(std::nullopt,false)';
  return 'SystValue<std::optional<double>>(${pv.value?.toString() ?? "std::nullopt"},${pv.isSystematic})';
}
