import 'dart:io';

///
///файлы mass_1.mas20.txt rct1.mas20.txt rct2_1.mas20.txt nubase_4.mas20.txt находятся по адресу:
///https://www-nds.iaea.org/amdc/
///
///

/// Расширение для `String`, добавляющее безопасный метод извлечения подстроки.
///
/// Extension for `String` that adds a safe substring extraction method.
extension SafeString on String {
  String safeSubstring(int start, [int? end]) {
    if (start >= length) {
      return '';
    }
    final realEnd = (end == null || end > length) ? length : end;
    if (start >= realEnd) return '';
    return substring(start, realEnd);
  }
}

/// Вспомогательный класс для хранения значения и флага,
/// указывающего, было ли оно получено на основе систематических закономерностей(from systematic) (#).
///
/// Helper class to store a value and a flag indicating whether it was obtained from systematic (#).
class ParsedValue<T> {
  final T? value;
  final bool isSystematic;

  ParsedValue(this.value, this.isSystematic);

  @override
  String toString() {
    /// Возвращаем только значение для CSV. Систематика обрабатывается отдельно.
    ///
    /// Return only value, systematic processed separately.
    return value?.toString() ?? '';
  }
}

/// Вспомогательная функция для парсинга числовых значений из файла.
/// Обрабатывает значения, полученные из систематики ('#') и отсутствующие значения ('*').
///
/// Helper function for parsing numeric values from a file.
/// Handles values obtained from taxonomy ('#') and missing values ('*').
ParsedValue<double?> _parseDouble(String text, [bool nubase = false]) {
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

/// Класс для хранения данных об оценке атомных масс из одной строки файла mass.mas20.
///
/// Class for storing atomic mass estimate data from one line of mass.mas20 file.
class MassAdjustmentEntry {
  final String rawLine;
  final int? nMinusZ;
  final int n;
  final int z;
  final int a;
  final String elementSymbol;
  final String origin;
  final ParsedValue<double?> massExcess;
  final ParsedValue<double?> massExcessUncertainty;
  final ParsedValue<double?> bindingEnergyPerA;
  final ParsedValue<double?> bindingEnergyPerAUncertainty;
  final String betaDecayType;
  final ParsedValue<double?> betaDecayEnergy;
  final ParsedValue<double?> betaDecayEnergyUncertainty;
  final ParsedValue<double?> atomicMassMicroU;
  final ParsedValue<double?> atomicMassUncertaintyMicroU;

  ///format    :  a1,i3,i5,i5,i5,1x,a3,a4,1x,f14.6,f12.6,f13.5,1x,f10.5,1x,a2,f13.5,f11.5,1x,i3,1x,f13.6,f12.6
  ///             cc NZ  N  Z  A    el  o     mass  unc binding unc      B  beta  unc    atomic_mass   unc
  MassAdjustmentEntry(this.rawLine)
    : nMinusZ = int.tryParse(rawLine.safeSubstring(1, 4).trim()),
      n = int.parse(rawLine.safeSubstring(4, 9).trim()),
      z = int.parse(rawLine.safeSubstring(9, 14).trim()),
      a = int.parse(rawLine.safeSubstring(14, 19).trim()),
      elementSymbol = rawLine.safeSubstring(20, 23).trim(),
      origin = rawLine.safeSubstring(23, 27).trim(),
      massExcess = _parseDouble(rawLine.safeSubstring(28, 42)),
      massExcessUncertainty = _parseDouble(rawLine.safeSubstring(42, 54)),
      bindingEnergyPerA = _parseDouble(rawLine.safeSubstring(54, 67)),
      bindingEnergyPerAUncertainty = _parseDouble(rawLine.safeSubstring(68, 78)),
      betaDecayType = rawLine.safeSubstring(79, 81).trim(),
      betaDecayEnergy = _parseDouble(rawLine.safeSubstring(81, 94)),
      betaDecayEnergyUncertainty = _parseDouble(rawLine.safeSubstring(94, 105)),
      atomicMassMicroU = _parseDouble(rawLine.safeSubstring(106, 123).trim()),
      atomicMassUncertaintyMicroU = _parseDouble(rawLine.safeSubstring(123));

  @override
  String toString() {
    return 'A=$a, Z=$z, El=$elementSymbol, Mass Excess: $massExcess keV, Atomic Mass: $atomicMassMicroU micro-u';
  }
}

/// Класс для хранения данных о реакциях и энергиях разделения из файлов rct.
class ReactionDataEntry {
  final int z;
  final int a;

  // from rct1.mas20.txt
  ParsedValue<double?>? s2n;
  ParsedValue<double?>? s2nUncertainty;
  ParsedValue<double?>? s2p;
  ParsedValue<double?>? s2pUncertainty;
  ParsedValue<double?>? qa;
  ParsedValue<double?>? qaUncertainty;
  ParsedValue<double?>? q2b;
  ParsedValue<double?>? q2bUncertainty;
  ParsedValue<double?>? qep;
  ParsedValue<double?>? qepUncertainty;
  ParsedValue<double?>? qbn;
  ParsedValue<double?>? qbnUncertainty;

  // from rct2_1.mas20.txt
  ParsedValue<double?>? sn;
  ParsedValue<double?>? snUncertainty;
  ParsedValue<double?>? sp;
  ParsedValue<double?>? spUncertainty;
  ParsedValue<double?>? q4b;
  ParsedValue<double?>? q4bUncertainty;
  ParsedValue<double?>? qda;
  ParsedValue<double?>? qdaUncertainty;
  ParsedValue<double?>? qpa;
  ParsedValue<double?>? qpaUncertainty;
  ParsedValue<double?>? qna;
  ParsedValue<double?>? qnaUncertainty;

  ReactionDataEntry({required this.z, required this.a});
}

/// Вспомогательный класс для хранения разобранной информации о спине.
class _SpinInfo {
  final String value;
  final String source;
  _SpinInfo(this.value, this.source);
}

/// Класс для хранения данных из файла NUBASE2020.
class NubaseEntry {
  final int a;
  final int z;
  final String zzzI; // Original ZZZi string from the file
  final String s; // s column (m, n, p, q, etc.)
  final String isomerIndexChar; // The 'i' part of ZZZi
  final String elementSymbol;
  final ParsedValue<double?> massExcess;
  final ParsedValue<double?> massExcessUncertainty;
  final ParsedValue<double?> excitationEnergy;
  final ParsedValue<double?> excitationEnergyUncertainty;
  final String origin;
  final bool stbl; // entry is stable
  final bool pUnst; // entry is p-unst
  final String halfLife;
  final bool isHalfLifeSystematic;
  final String halfLifeUnit;
  final String halfLifeUncertainty;
  final String spinParity;
  final String spinParitySource;
  final String isospin;
  final String ensdfYear;
  final String discoveryYear;
  final String decayModes;

  // This field will be populated after parsing, using context from other nuclides.
  String stateType = 'UNKNOWN';

  // Приватный конструктор для использования с factory.
  NubaseEntry._({
    required this.a,
    required this.z,
    required this.zzzI,
    required this.s,
    required this.isomerIndexChar,
    required this.elementSymbol,
    required this.massExcess,
    required this.massExcessUncertainty,
    required this.excitationEnergy,
    required this.excitationEnergyUncertainty,
    required this.origin,
    required this.stbl,
    required this.pUnst,
    required this.halfLife,
    required this.isHalfLifeSystematic,
    required this.halfLifeUnit,
    required this.halfLifeUncertainty,
    required this.spinParity,
    required this.spinParitySource,
    required this.isospin,
    required this.ensdfYear,
    required this.discoveryYear,
    required this.decayModes,
  });

  static final _isospinRegex = RegExp(r'T=([\d./\s]+)');

  /// Извлекает значение изоспина из поля Jpi.
  static String _parseIsospin(String jpiRaw) {
    final match = _isospinRegex.firstMatch(jpiRaw);
    return match?.group(1)?.trim() ?? '';
  }

  /// Извлекает значение спина/чётности и источника, удаляя информацию об изоспине.
  static _SpinInfo _parseSpinParityAndSource(String jpiRaw) {
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

  factory NubaseEntry.fromLine(String line) {
    final jpiRaw = line.safeSubstring(88, 102);
    final spinInfo = _parseSpinParityAndSource(jpiRaw);
    final halfLifeSubstring = line.safeSubstring(69, 78);
    final zzzi = line.safeSubstring(4, 8).trim();

    return NubaseEntry._(
      a: int.parse(line.safeSubstring(0, 4)),
      z: int.parse(line.safeSubstring(4, 7)),
      zzzI: zzzi,
      s: line.safeSubstring(16, 17).trim(),
      isomerIndexChar: zzzi.isNotEmpty ? zzzi.substring(zzzi.length - 1) : '',
      elementSymbol: line.safeSubstring(11, 16).trim().replaceAll(RegExp(r'\d'), ''),
      massExcess: _parseDouble(line.safeSubstring(18, 31).trim()),
      massExcessUncertainty: _parseDouble(line.safeSubstring(31, 42).trim()),
      excitationEnergy: _parseDouble(line.safeSubstring(42, 54).trim()),
      excitationEnergyUncertainty: _parseDouble(line.safeSubstring(54, 65).trim()),
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

  /// Уникальный ключ для поиска данных из AME/RCT.
  String get ameKey => '$a-$z';
}

/// Определяет тип ядерного состояния, используя контекст.
/// Эта функция использует информацию из колонок 's' и 'ZZZi', а также
/// контекст о том, есть ли у нуклида множество изомеров.
///
/// Determines the nuclide state type based on file conventions and context.
/// This function uses information from the 's' and 'ZZZi' columns, as well as
/// context about whether the nuclide has many isomers.
String _getNuclideStateType(NubaseEntry entry, bool hasManyIsomers) {
  final s = entry.s;
  final iChar = entry.isomerIndexChar;

  // Основное состояние (Ground state)
  if (iChar == '0') return "GROUND_STATE";

  // Явные изомеры (Explicit isomers)
  if (s == 'm' || s == 'n' || s == 'x' || iChar == '1' || iChar == '2' || iChar == '6') {
    return "ISOMER";
  }

  // Явные изобар-аналоговые состояния (Explicit Isobaric Analog States - IAS)
  if (s == 'i' || s == 'j' || iChar == '8' || iChar == '9') {
    return "ISOBARIC_ANALOG_STATE";
  }

  // Неоднозначные случаи, зависящие от контекста (Ambiguous cases depending on context)
  if (hasManyIsomers) {
    if (s == 'p' || s == 'q' || s == 'r' || iChar == '3' || iChar == '4' || iChar == '5') {
      return "ISOMER";
    }
  }

  // Если контекст не указывает на изомер, используем первичное значение (If context doesn't indicate an isomer, use the primary meaning)
  if (s == 'p' || s == 'q' || iChar == '3' || iChar == '4') return "LEVEL";
  if (s == 'r' || iChar == '5') return "RESONANCE";

  return "UNKNOWN";
}

/// Парсит файлы с данными о реакциях (rct)
void _parseReactionFile(File file, Map<String, ReactionDataEntry> reactionData, bool isRct1, int startLine) {
  if (!file.existsSync()) {
    print('Файл не найден: ${file.path}');
    return;
  }
  final lines = file.readAsLinesSync();

  for (int i = startLine; i < lines.length - 1; i++) {
    final line = lines[i];
    if (line.trim().isEmpty) continue;
    try {
      // Формат rct отличается от mass.mas20 в идентификации нуклидов
      // A(cols 2-4), Z(cols 10-12)
      final a = int.parse(line.safeSubstring(1, 4).trim());
      final z = int.parse(line.safeSubstring(9, 12).trim());
      final key = '$a-$z';

      final entry = reactionData.putIfAbsent(key, () => ReactionDataEntry(z: z, a: a));

      final dataStart = 13;
      if (isRct1) {
        // rct1.mas20.txt: S(2n), S(2p), Q(a), Q(2B-), Q(ep), Q(B-n)
        // Формат: a1,i3,1x,a3,i3,1x,6(f12.4,f10.4)
        // Позиции: 13-24 (S2n), 25-34 (unc), 35-46 (S2p), 47-56 (unc),
        //          57-68 (Qa), 69-78 (unc), 79-90 (Q2b), 91-100 (unc),
        //          101-112 (Qep), 113-122 (unc), 123-134 (Qbn), 135-144 (unc)
        entry.s2n = _parseDouble(line.safeSubstring(dataStart, dataStart + 12));
        entry.s2nUncertainty = _parseDouble(line.safeSubstring(dataStart + 12, dataStart + 22));
        entry.s2p = _parseDouble(line.safeSubstring(dataStart + 22, dataStart + 34));
        entry.s2pUncertainty = _parseDouble(line.safeSubstring(dataStart + 34, dataStart + 44));
        entry.qa = _parseDouble(line.safeSubstring(dataStart + 44, dataStart + 56));
        entry.qaUncertainty = _parseDouble(line.safeSubstring(dataStart + 56, dataStart + 66));
        entry.q2b = _parseDouble(line.safeSubstring(dataStart + 66, dataStart + 78));
        entry.q2bUncertainty = _parseDouble(line.safeSubstring(dataStart + 78, dataStart + 88));
        entry.qep = _parseDouble(line.safeSubstring(dataStart + 88, dataStart + 100));
        entry.qepUncertainty = _parseDouble(line.safeSubstring(dataStart + 100, dataStart + 110));
        entry.qbn = _parseDouble(line.safeSubstring(dataStart + 110, dataStart + 122));
        entry.qbnUncertainty = _parseDouble(line.safeSubstring(dataStart + 122, dataStart + 132));
      } else {
        // rct2_1.mas20.txt: S(n), S(p), Q(4B-), Q(d,a), Q(p,a), Q(n,a)
        // Формат: a1,i3,1x,a3,i3,1x,6(f12.4,f10.4)
        // Позиции: 13-24 (Sn), 25-34 (unc), 35-46 (Sp), 47-56 (unc),
        //          57-68 (Q4b), 69-78 (unc), 79-90 (Qda), 91-100 (unc),
        //          101-112 (Qpa), 113-122 (unc), 123-134 (Qna), 135-144 (unc)
        entry.sn = _parseDouble(line.safeSubstring(dataStart, dataStart + 12));
        entry.snUncertainty = _parseDouble(line.safeSubstring(dataStart + 12, dataStart + 22));
        entry.sp = _parseDouble(line.safeSubstring(dataStart + 22, dataStart + 34));
        entry.spUncertainty = _parseDouble(line.safeSubstring(dataStart + 34, dataStart + 44));
        entry.q4b = _parseDouble(line.safeSubstring(dataStart + 44, dataStart + 56));
        entry.q4bUncertainty = _parseDouble(line.safeSubstring(dataStart + 56, dataStart + 66));
        entry.qda = _parseDouble(line.safeSubstring(dataStart + 66, dataStart + 78));
        entry.qdaUncertainty = _parseDouble(line.safeSubstring(dataStart + 78, dataStart + 88));
        entry.qpa = _parseDouble(line.safeSubstring(dataStart + 88, dataStart + 100));
        entry.qpaUncertainty = _parseDouble(line.safeSubstring(dataStart + 100, dataStart + 110));
        entry.qna = _parseDouble(line.safeSubstring(dataStart + 110, dataStart + 122));
        entry.qnaUncertainty = _parseDouble(line.safeSubstring(dataStart + 122, dataStart + 132));
      }
      reactionData[key] = entry;
    } catch (e, s) {
      print('Ошибка парсинга строки реакции: "$line"\n$e\n$s');
    }
  }
}

/// Парсит файл NUBASE2020.
List<NubaseEntry> _parseNubaseFile(File file) {
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
      entries.add(NubaseEntry.fromLine(line));
    } catch (e, s) {
      print('Ошибка парсинга строки NUBASE: "$line"');
      print(e);
      print(s);
    }
  }
  return entries;
}

/// Вспомогательная функция для генерации CSV полей из ParsedValue.
List<String> _parsedToCsv(ParsedValue? pv) {
  if (pv == null) return ['""', '""'];
  return ['"${pv.value?.toString() ?? ""}"', pv.isSystematic ? '"#"' : '""'];
}

void main() {
  final massFile = File('mass_1.mas20.txt');
  final rct1File = File('rct1.mas20.txt');
  final rct2File = File('rct2_1.mas20.txt');
  final nubaseFile = File('nubase_4.mas20.txt');
  final outputFile = File('nubase_ame_rct_combined.csv');
  final outputFileWithoutUnc = File('nubase_ame_rct_combined_without_Unc.csv');

  // --- 1. Парсинг данных AME о массах ---
  final ameDataMap = <String, MassAdjustmentEntry>{};
  if (massFile.existsSync()) {
    final massLines = massFile.readAsLinesSync();
    // Данные начинаются с 37-й строки (индекс 36)
    for (int i = 36; i < massLines.length; i++) {
      final line = massLines[i];
      if (line.trim().isEmpty) continue;
      try {
        final entry = MassAdjustmentEntry(line);
        ameDataMap['${entry.a}-${entry.z}'] = entry;
      } catch (e, s) {
        print('Ошибка парсинга строки AME: "$line"\n$e\n$s');
      }
    }
  } else {
    print('Файл не найден: ${massFile.path}');
  }

  // --- 2. Парсинг данных о реакциях ---
  final reactionDataMap = <String, ReactionDataEntry>{};
  // rct1.mas20.txt: данные с 36-й строки (индекс 35)
  _parseReactionFile(rct1File, reactionDataMap, true, 35); // isRct1 = true
  // rct2_1.mas20.txt: данные с 38-й строки (индекс 37)
  _parseReactionFile(rct2File, reactionDataMap, false, 37); // isRct1 = false

  // --- 3. Парсинг данных NUBASE ---
  final nubaseEntries = _parseNubaseFile(nubaseFile);

  // --- 3a. Определение контекста для записей NUBASE (наличие множества изомеров) ---
  final nubaseGrouped = <String, List<NubaseEntry>>{};
  for (final entry in nubaseEntries) {
    final key = '${entry.a}-${entry.z}';
    nubaseGrouped.putIfAbsent(key, () => []).add(entry);
  }

  final nuclideHasManyIsomers = <String, bool>{};
  nubaseGrouped.forEach((key, entries) {
    int isomerCount = 0;
    for (final entry in entries) {
      // 'm', 'n' в колонке 's' или '1', '2' в 'i' части ZZZi считаются "классическими" изомерами
      if (entry.s == 'm' || entry.s == 'n' || entry.isomerIndexChar == '1' || entry.isomerIndexChar == '2') {
        isomerCount++;
      }
    }
    // Если найдено 2 или более "классических" изомеров, то неоднозначные коды также считаются изомерами.
    nuclideHasManyIsomers[key] = isomerCount >= 2;
  });

  // --- 3b. Присвоение типа состояния с учетом контекста ---
  for (final entry in nubaseEntries) {
    final key = '${entry.a}-${entry.z}';
    final hasMany = nuclideHasManyIsomers[key] ?? false;
    entry.stateType = _getNuclideStateType(entry, hasMany);
  }

  // --- 4. Объединение данных и запись в CSV ---
  final outputLines = <String>[];
  final outputLinesWithoutUnc = <String>[];
  // Заголовок для CSV файла

  String getoutputTopic([bool withUnc = true]) {
    return [
      /// NUBASE
      /// A - массовое число
      /// Z - протонный номер.
      /// Element - имя элемента
      /// Isomer_Index - i=0 (gs); i=1,2 (isomers); i=3,4 (levels); i=5 (resonance); i=8,9 (IAS)
      /// s - s=m,n (isomers); s=p,q (levels); s=r (reonance); s=i,j (IAS);
      ///     s=p,q,r,x can also indicate isomers (when more than two isomers are presented in a nuclide)
      /// StateType - тип состояния (GROUND_STATE, ISOMER, LEVEL, RESONANCE, ISOBARIC_ANALOG_STATE, UNKNOWN)- результат компиляции полей `Isomer_Index` и `s`
      /// Mass_Excess_keV(NUBASE) - избыток массы в кэВ
      /// Mass_Excess_Unc - неопределенность избытка массы
      /// Exc_Energy_keV - энергия возбуждения в кэВ
      /// Exc_Energy_Unc - неопределенность энергии возбуждения
      /// HalfLife_Val - значение периода полураспада
      /// HalfLife_Unit - единица измерения периода полураспада
      /// HalfLife_Unc - неопределенность периода полураспада
      /// HalfLife_Syst - флаг систематического значения периода полураспада (#)
      /// Jpi - спин и четность
      /// Jpi_Source - источник спина и четности (* - из систематики, # - из оценки)
      /// Isospin - изоспин
      /// Decay_Modes - моды распада
      /// Discovery_Year - год открытия
      'A', 'Z', 'Element', 'Isomer_Index', 's', 'StateType',
      'Mass_Excess_keV(NUBASE)', 'Mass_Excess_keV_Syst(NUBASE)',
      if (withUnc) 'Mass_Excess_Unc(NUBASE)',
      if (withUnc) 'Mass_Excess_Unc_Syst(NUBASE)',
      'Exc_Energy_keV',
      if (withUnc) 'Exc_Energy_Unc',
      'Stable_Element', 'p-unst', 'HalfLife_Val', 'HalfLife_Unit',
      if (withUnc) 'HalfLife_Unc',
      'HalfLife_Syst', 'Jpi', 'Jpi_Source', 'Isospin', 'Decay_Modes',
      'Discovery_Year',

      /// AME (Atomic Mass Evaluation)
      /// Mass_Excess_keV(AME) - избыток массы в кэВ
      /// Mass_Excess_Syst(AME) - флаг систематического значения избытка массы (#)
      /// Mass_Excess_Unc(AME) - неопределенность избытка массы
      /// Mass_Excess_Unc_Syst(AME) - флаг систематической неопределенности избытка массы (#)
      /// Binding_Energy_per_A_keV - энергия связи на нуклон в кэВ
      /// Binding_Energy_per_A_Syst - флаг систематического значения энергии связи на нуклон (#)
      /// Binding_Energy_per_A_Unc - неопределенность энергии связи на нуклон
      /// Binding_Energy_per_A_Unc_Syst - флаг систематической неопределенности энергии связи на нуклон (#)
      /// Beta_Decay_Energy_keV - энергия
      'Mass_Excess_keV(AME)', 'Mass_Excess_Syst(AME)',
      if (withUnc) 'Mass_Excess_Unc(AME)',
      if (withUnc) 'Mass_Excess_Unc_Syst(AME)',
      'Binding_Energy_per_A_keV', 'Binding_Energy_per_A_Syst',
      if (withUnc) 'Binding_Energy_per_A_Unc',
      if (withUnc) 'Binding_Energy_per_A_Unc_Syst',
      'Beta_Decay_Energy_keV', 'Beta_Decay_Energy_Syst',
      if (withUnc) 'Beta_Decay_Energy_Unc',
      if (withUnc) 'Beta_Decay_Energy_Unc_Syst',
      'Atomic_Mass_microU', 'Atomic_Mass_Syst',
      if (withUnc) 'Atomic_Mass_Unc_microU',
      if (withUnc) 'Atomic_Mass_Unc_Syst',

      /// RCT1
      /// S(n) — энергия разделения нейтрона (Neutron Separation Energy).
      /// S(p) — энергия разделения протона (Proton Separation Energy).
      /// Q(4B-) — энергия бета-распада (Q-value for β⁻ decay).
      /// Q(d,a) — Q-значение для реакции (d,α).
      /// Q(p,a) — Q-значение для реакции (p,α).
      /// Q(n,a) — Q-значение для реакции (n,α).
      'S2n', 'S2n_Syst',
      if (withUnc) 'S2n_Unc',
      if (withUnc) 'S2n_Unc_Syst',
      'S2p', 'S2p_Syst',
      if (withUnc) 'S2p_Unc',
      if (withUnc) 'S2p_Unc_Syst',
      'Qa', 'Qa_Syst',
      if (withUnc) 'Qa_Unc',
      if (withUnc) 'Qa_Unc_Syst',
      'Q2b', 'Q2b_Syst',
      if (withUnc) 'Q2b_Unc',
      if (withUnc) 'Q2b_Unc_Syst',
      'Qep', 'Qep_Syst',
      if (withUnc) 'Qep_Unc',
      if (withUnc) 'Qep_Unc_Syst',
      'Qbn', 'Qbn_Syst',
      if (withUnc) 'Qbn_Unc',
      if (withUnc) 'Qbn_Unc_Syst',

      /// RCT2
      'Sn', 'Sn_Syst',
      if (withUnc) 'Sn_Unc',
      if (withUnc) 'Sn_Unc_Syst',
      'Sp', 'Sp_Syst',
      if (withUnc) 'Sp_Unc',
      if (withUnc) 'Sp_Unc_Syst',
      'Q4b', 'Q4b_Syst',
      if (withUnc) 'Q4b_Unc',
      if (withUnc) 'Q4b_Unc_Syst',
      'Qda', 'Qda_Syst',
      if (withUnc) 'Qda_Unc',
      if (withUnc) 'Qda_Unc_Syst',
      'Qpa', 'Qpa_Syst',
      if (withUnc) 'Qpa_Unc',
      if (withUnc) 'Qpa_Unc_Syst',
      'Qna', 'Qna_Syst',
      if (withUnc) 'Qna_Unc',
      if (withUnc) 'Qna_Unc_Syst',
    ].join(',');
  }

  outputLines.add(getoutputTopic());
  outputLinesWithoutUnc.add(getoutputTopic(false));

  for (final nubaseEntry in nubaseEntries) {
    final key = nubaseEntry.ameKey;
    final ameEntry = nubaseEntry.isomerIndexChar == "0" ? ameDataMap[key] : null;
    final rctEntry = nubaseEntry.isomerIndexChar == "0" ? reactionDataMap[key] : null;

    String getRow([bool withUnc = true]) => [
      // Nubase
      '"${nubaseEntry.a}"',
      '"${nubaseEntry.z}"',
      '"${nubaseEntry.elementSymbol}"',
      '"${nubaseEntry.isomerIndexChar}"',
      '"${nubaseEntry.s}"',
      '"${nubaseEntry.stateType}"',
      ..._parsedToCsv(nubaseEntry.massExcess),
      if (withUnc) ..._parsedToCsv(nubaseEntry.massExcessUncertainty),
      ..._parsedToCsv(nubaseEntry.excitationEnergy),
      if (withUnc) ..._parsedToCsv(nubaseEntry.excitationEnergyUncertainty),
      '"${nubaseEntry.stbl ? "#" : ""}"',
      '"${nubaseEntry.halfLife}"',
      '"${nubaseEntry.halfLifeUnit}"',
      if (withUnc) '"${nubaseEntry.halfLifeUncertainty}"',
      nubaseEntry.isHalfLifeSystematic ? '"#"' : '""',
      '"${nubaseEntry.spinParity}"',
      '"${nubaseEntry.spinParitySource}"',
      '"${nubaseEntry.isospin}"',
      '"${nubaseEntry.decayModes}"',
      '"${nubaseEntry.discoveryYear}"',
      // AME
      ..._parsedToCsv(ameEntry?.massExcess),
      if (withUnc) ..._parsedToCsv(ameEntry?.massExcessUncertainty),
      ..._parsedToCsv(ameEntry?.bindingEnergyPerA),
      if (withUnc) ..._parsedToCsv(ameEntry?.bindingEnergyPerAUncertainty),
      ..._parsedToCsv(ameEntry?.betaDecayEnergy),
      if (withUnc) ..._parsedToCsv(ameEntry?.betaDecayEnergyUncertainty),
      ..._parsedToCsv(ameEntry?.atomicMassMicroU),
      if (withUnc) ..._parsedToCsv(ameEntry?.atomicMassUncertaintyMicroU),
      // RCT1
      ..._parsedToCsv(rctEntry?.s2n),
      if (withUnc) ..._parsedToCsv(rctEntry?.s2nUncertainty),
      ..._parsedToCsv(rctEntry?.s2p),
      if (withUnc) ..._parsedToCsv(rctEntry?.s2pUncertainty),
      ..._parsedToCsv(rctEntry?.qa),
      if (withUnc) ..._parsedToCsv(rctEntry?.qaUncertainty),
      ..._parsedToCsv(rctEntry?.q2b),
      if (withUnc) ..._parsedToCsv(rctEntry?.q2bUncertainty),
      ..._parsedToCsv(rctEntry?.qep),
      if (withUnc) ..._parsedToCsv(rctEntry?.qepUncertainty),
      ..._parsedToCsv(rctEntry?.qbn),
      if (withUnc) ..._parsedToCsv(rctEntry?.qbnUncertainty),
      // RCT2
      ..._parsedToCsv(rctEntry?.sn),
      if (withUnc) ..._parsedToCsv(rctEntry?.snUncertainty),
      ..._parsedToCsv(rctEntry?.sp),
      if (withUnc) ..._parsedToCsv(rctEntry?.spUncertainty),
      ..._parsedToCsv(rctEntry?.q4b),
      if (withUnc) ..._parsedToCsv(rctEntry?.q4bUncertainty),
      ..._parsedToCsv(rctEntry?.qda),
      if (withUnc) ..._parsedToCsv(rctEntry?.qdaUncertainty),
      ..._parsedToCsv(rctEntry?.qpa),
      if (withUnc) ..._parsedToCsv(rctEntry?.qpaUncertainty),
      ..._parsedToCsv(rctEntry?.qna),
      if (withUnc) ..._parsedToCsv(rctEntry?.qnaUncertainty),
    ].join(',');
    outputLines.add(getRow());
    outputLinesWithoutUnc.add(getRow(false));
  }

  outputFile.writeAsStringSync(outputLines.join('\n'));
  outputFileWithoutUnc.writeAsStringSync(outputLinesWithoutUnc.join('\n'));

  print('Обработка завершена. Результат записан в файлы: ${outputFile.path}, ${outputFileWithoutUnc.path}');
}
