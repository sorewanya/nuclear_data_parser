import 'dart:io';

import '../entities/nubase_entity.dart';
import '../entities/spin.dart';
import '../entities/syst_value.dart';
import 'log_if_null.dart';
import 'parse_double.dart';
import 'safe_string.dart';

NubaseEntry NubaseEntryFromLine(String line) {
  final _isospinRegex = RegExp(r'T=([\d./\s]+)');

  /// Извлекает значение изоспина из поля Jpi.
  String? _parseIsospin(String jpiRaw) {
    final match = _isospinRegex.firstMatch(jpiRaw);
    return match?.group(1)?.trim();
  }

  Spin _parseSpinParityAndSource(String jpiRaw) {
    var temp = jpiRaw.replaceAll(_isospinRegex, '').trim();

    if (temp.endsWith('*') || temp.endsWith('#')) {
      temp = temp.substring(0, temp.length - 1).trim();
    }
    final isospin = _parseIsospin(jpiRaw);
    return Spin(SystValue(temp, jpiRaw.contains("#")), jpiRaw.contains("*"), isospin);
  }

  final jpiRaw = line.safeSubstring(88, 102);
  final spin = _parseSpinParityAndSource(jpiRaw);
  final halfLifeSubstring = line.safeSubstring(69, 78);
  final zzzi = line.safeSubstring(4, 8).trim();

  final a = int.tryParse(line.safeSubstring(0, 4));
  if (a == null) logNull("a");
  final z = int.tryParse(line.safeSubstring(4, 7));
  if (z == null) logNull("z");
  final s = line.safeSubstring(16, 17).trim();
  final isomerIndex = int.tryParse(zzzi.isNotEmpty ? zzzi.substring(zzzi.length - 1) : '');
  if (isomerIndex == null) logNull("isomerIndex");
  final origin = line.safeSubstring(65, 67).trim();
  final halfLife = halfLifeSubstring.trim().replaceAll('#', '').replaceAll('stbl', '').replaceAll('p-unst', '');
  final halfLifeUnit = line.safeSubstring(78, 80).trim();
  final halfLifeUncertainty = line.safeSubstring(81, 88).trim();
  final ensdfYear = int.tryParse(line.safeSubstring(102, 104).trim());
  final discoveryYear = int.tryParse(line.safeSubstring(114, 118).trim());
  if (discoveryYear == null) logNull("discoveryYear");
  final decayModes = line.safeSubstring(119).trim();

  return NubaseEntry(
    a: a ?? 0,
    z: z ?? 0,
    s: s.isEmpty ? null : s,
    isomerIndex: isomerIndex ?? 0,
    massExcess: parseDouble(line.safeSubstring(18, 31).trim()),
    massExcessUncertainty: parseDouble(line.safeSubstring(31, 42).trim()),
    excitationEnergy: parseDouble(line.safeSubstring(42, 54).trim()),
    excitationEnergyUncertainty: parseDouble(line.safeSubstring(54, 65).trim()),
    origin: origin.isEmpty ? null : origin,
    stbl: halfLifeSubstring.contains('stbl'),
    pUnst: halfLifeSubstring.contains('p-unst'),
    halfLife: halfLife.isEmpty ? null : SystValue(halfLife, halfLifeSubstring.contains('#')),
    halfLifeUnit: halfLifeUnit.isEmpty ? null : halfLifeUnit,
    halfLifeUncertainty: halfLifeUncertainty.isEmpty ? null : halfLifeUncertainty,
    spin: spin,
    ensdfYear: ensdfYear,
    discoveryYear: discoveryYear ?? 0,
    decayModes: decayModes.isEmpty ? null : decayModes,
  );
}

/// Парсит файл NUBASE2020.
List<NubaseEntry> parseNubaseFile(File file) {
  if (!file.existsSync()) {
    print('Файл не найден: ${file.path}');
    return [];
  }
  final lines = file.readAsLinesSync();
  final entries = <NubaseEntry>[];
  // Пропускаем строки заголовка
  for (final line in lines) {
    if (line.startsWith('#') || line.trim().isEmpty) continue;
    try {
      entries.add(NubaseEntryFromLine(line));
    } catch (e, s) {
      print('Ошибка парсинга строки NUBASE: "$line"');
      print(e);
      print(s);
    }
  }
  return entries;
}
