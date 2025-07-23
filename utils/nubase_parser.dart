import 'dart:io';

import '../entities/nubase_entity.dart';
import 'parse_double.dart';
import 'safe_string.dart';

/// Вспомогательный класс для хранения разобранной информации о спине.
class _SpinInfo {
  final String value;
  final String source;
  _SpinInfo(this.value, this.source);
}

NubaseEntry NubaseEntryFromLine(String line) {
  final _isospinRegex = RegExp(r'T=([\d./\s]+)');

  /// Извлекает значение изоспина из поля Jpi.
  String _parseIsospin(String jpiRaw) {
    final match = _isospinRegex.firstMatch(jpiRaw);
    return match?.group(1)?.trim() ?? '';
  }

  /// Извлекает значение спина/чётности и источника, удаляя информацию об изоспине.
  _SpinInfo _parseSpinParityAndSource(String jpiRaw) {
    var temp = jpiRaw.replaceAll(_isospinRegex, '').trim();
    String source = '';

    if (temp.endsWith('*')) {
      source = '*';
      temp = temp.substring(0, temp.length - 1).trim();
    } else if (temp.endsWith('#')) {
      source = '#';
      temp = temp.substring(0, temp.length - 1).trim();
    }
    return _SpinInfo(temp, source);
  }

  final jpiRaw = line.safeSubstring(88, 102);
  final spinInfo = _parseSpinParityAndSource(jpiRaw);
  final halfLifeSubstring = line.safeSubstring(69, 78);
  final zzzi = line.safeSubstring(4, 8).trim();

  return NubaseEntry(
    a: int.parse(line.safeSubstring(0, 4)),
    z: int.parse(line.safeSubstring(4, 7)),
    s: line.safeSubstring(16, 17).trim(),
    isomerIndexChar: zzzi.isNotEmpty ? zzzi.substring(zzzi.length - 1) : '',
    // elementSymbol: line.safeSubstring(11, 16).trim().replaceAll(RegExp(r'\d'), ''),
    massExcess: parseDouble(line.safeSubstring(18, 31).trim()),
    massExcessUncertainty: parseDouble(line.safeSubstring(31, 42).trim()),
    excitationEnergy: parseDouble(line.safeSubstring(42, 54).trim()),
    excitationEnergyUncertainty: parseDouble(line.safeSubstring(54, 65).trim()),
    origin: line.safeSubstring(65, 67).trim(),
    stbl: halfLifeSubstring.contains('stbl'),
    pUnst: halfLifeSubstring.contains('p-unst'),
    halfLife: halfLifeSubstring.trim().replaceAll('#', '').replaceAll('stbl', '').replaceAll('p-unst', ''),
    isHalfLifeSystematic: halfLifeSubstring.contains('#'),
    halfLifeUnit: line.safeSubstring(78, 80).trim(),
    halfLifeUncertainty: line.safeSubstring(81, 88).trim(),
    spinParity: spinInfo.value,
    spinParitySource: spinInfo.source,
    isospin: _parseIsospin(jpiRaw),
    ensdfYear: line.safeSubstring(102, 104).trim(),
    discoveryYear: line.safeSubstring(114, 118).trim(),
    decayModes: line.safeSubstring(119).trim(),
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
