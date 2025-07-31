import '../entities/syst_value.dart';

/// Вспомогательная функция для генерации CSV полей из SystValue.
List<String> parsedToCsv(SystValue? pv) {
  if (pv == null) return ['""', '""'];
  return ['"${pv.value?.toString() ?? ""}"', pv.isSystematic ? '"#"' : '""'];
}

String parsedToDart(SystValue<double?>? pv) {
  if (pv == null || pv.value == null) return 'null';
  return 'SystValue<double>(${pv.value.toString()},${pv.isSystematic})';
}

String parsedToCpp(SystValue<double?>? pv) {
  if (pv == null || pv.value == null) return 'std::nullopt';
  return 'SystValue<double>(${pv.value.toString()},${pv.isSystematic})';
}
