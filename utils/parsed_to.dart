import '../entities/spin.dart';
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

String parsedToDartString(SystValue<String?>? pv) {
  if (pv == null || pv.value == null || pv.value?.isEmpty == true) return 'null';
  return 'SystValue<String>("${pv.value.toString()}",${pv.isSystematic})';
}

String spinToDart(Spin? spin) {
  if (spin == null) return 'null';
  return 'Spin(${spin.spin == null ? "null" : parsedToDartString(spin.spin)},${spin.directlyMeasured},${spin.isospin == null ? "null" : "'${spin.isospin}'"})';
}

String parsedToCpp(SystValue<double?>? pv) {
  if (pv == null || pv.value == null) return 'std::nullopt';
  return 'SystValue<double>(${pv.value.toString()},${pv.isSystematic})';
}

String parsedToCppString(SystValue<String?>? pv) {
  if (pv == null || pv.value == null || pv.value?.isEmpty == true) return 'std::nullopt';
  return 'SystValue<std::string_view>("${pv.value.toString()}",${pv.isSystematic})';
}

String spinToCpp(Spin? spin) {
  if (spin == null) return 'std::nullopt';
  return 'Spin(${spin.spin == null ? "std::nullopt" : parsedToCppString(spin.spin)},${spin.directlyMeasured},${spin.isospin == null ? "std::nullopt" : "\"${spin.isospin}\""})';
}
