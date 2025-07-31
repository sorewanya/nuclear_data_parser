import 'dart:io';
import 'entities/ame2020_entity.dart';
import 'entities/elements_enum.dart';
import 'entities/nubase_entity.dart';
import 'entities/reaction_data_entity.dart';
import 'utils/ame2020_parser.dart';
import 'utils/get_nuclide_state_type.dart';
import 'utils/nubase_parser.dart';
import 'utils/parsed_to.dart';
import 'utils/reaction_parser.dart';

///
///файлы mass_1.mas20.txt rct1.mas20.txt rct2_1.mas20.txt nubase_4.mas20.txt находятся по адресу:
///https://www-nds.iaea.org/amdc/
///
///

void main() async {
  final massFile = File('mass_1.mas20.txt');
  final rct1File = File('rct1.mas20.txt');
  final rct2File = File('rct2_1.mas20.txt');
  final nubaseFile = File('nubase_4.mas20.txt');

  final outputFile = File('output/csv/nubase_ame_rct_combined.csv');
  final outputFileWithoutUnc = File('output/csv/nubase_ame_rct_combined_without_Unc.csv');

  final outputDartNubase = File('output/dart/nubase.dart');
  final outputDartAme = File('output/dart/ame.dart');
  final outputDartRct = File('output/dart/rct.dart');

  final outputCppNubase = File('output/cpp/nubase.h');
  final outputCppAme = File('output/cpp/ame.h');
  final outputCppRct = File('output/cpp/rct.h');

  await Directory('output/csv').create(recursive: true);
  await Directory('output/dart').create(recursive: true);
  await Directory('output/cpp').create(recursive: true);

  // --- 1. Парсинг данных AME о массах ---
  final ameDataMap = <String, AME2020Entry>{};
  if (massFile.existsSync()) {
    final massLines = massFile.readAsLinesSync();
    // Данные начинаются с 37-й строки (индекс 36)
    for (int i = 36; i < massLines.length; i++) {
      final line = massLines[i];
      if (line.trim().isEmpty) continue;
      try {
        final entry = AME2020EntryFromLine(line);
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
  parseReactionFile(rct1File, reactionDataMap, true, 35); // isRct1 = true
  // rct2_1.mas20.txt: данные с 38-й строки (индекс 37)
  parseReactionFile(rct2File, reactionDataMap, false, 37); // isRct1 = false

  // --- 3. Парсинг данных NUBASE ---
  final nubaseEntries = parseNubaseFile(nubaseFile);

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
      if (entry.s == 'm' || entry.s == 'n' || entry.isomerIndex == 1 || entry.isomerIndex == 2) {
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
    entry.stateType = getNuclideStateType(entry, hasMany);
  }

  // --- 4. Объединение данных и запись в CSV ---
  final outputLines = <String>[];
  final outputLinesWithoutUnc = <String>[];
  final outputLinesDartNubase = <String>[
    "// dart format width=9999",
    "import '../../entities/syst_value.dart';",
    "import '../../entities/nubase_entity.dart';",
    "import '../../entities/nuclide_state_type_enum.dart';",
    "import '../../entities/spin.dart';",
    "\nList<NubaseEntry> nubaseList=[",
  ];
  final outputLinesDartAme = <String>[
    "// dart format width=9999",
    "import '../../entities/syst_value.dart';",
    "import '../../entities/ame2020_entity.dart';",
    "\nList<AME2020Entry> ame2020List=[",
  ];
  final outputLinesDartRct = <String>[
    "// dart format width=9999",
    "import '../../entities/syst_value.dart';",
    "import '../../entities/reaction_data_entity.dart';",
    "\nList<ReactionDataEntry> rctList=[",
  ];
  final outputLinesCppNubase = <String>[
    '#include "SystValue.h"',
    '#include "NubaseEntry.h"',
    '#include "Spin.h"',
    "\nstatic constexpr NubaseEntry nubaseList[] = {",
  ];
  final outputLinesCppAme = <String>[
    '#include "SystValue.h"',
    '#include "AME2020Entry.h"',
    "\nstatic constexpr AME2020Entry ame2020List[] = {",
  ];
  final outputLinesCppRct = <String>[
    '#include "SystValue.h"',
    '#include "ReactionDataEntry.h"',
    "\nstatic constexpr ReactionDataEntry rctList[] = {",
  ];

  /// Заголовок для CSV файла
  String getcsvOutputTopic([bool withUnc = true]) {
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
      'Origin',
      'Stable_Element', 'p-unst', 'HalfLife_Val', 'HalfLife_Unit',
      if (withUnc) 'HalfLife_Unc',
      'HalfLife_Syst', 'Jpi', 'Jpi_Systematics', 'Jpi_Directly_Measured', 'Isospin', 'Decay_Modes',
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

  outputLines.add(getcsvOutputTopic());
  outputLinesWithoutUnc.add(getcsvOutputTopic(false));

  for (final nubaseEntry in nubaseEntries) {
    final key = nubaseEntry.ameKey;
    final ameEntry = nubaseEntry.isomerIndex == 0 ? ameDataMap[key] : null;
    final rctEntry = nubaseEntry.isomerIndex == 0 ? reactionDataMap[key] : null;

    ///CSV
    String getRow([bool withUnc = true]) => [
      // Nubase
      '"${nubaseEntry.a}"',
      '"${nubaseEntry.z}"',
      '"${ElementsEnum.values[nubaseEntry.z]}"',
      '"${nubaseEntry.isomerIndex}"',
      '"${nubaseEntry.s}"',
      '"${nubaseEntry.stateType.name}"',
      ...parsedToCsv(nubaseEntry.massExcess),
      if (withUnc) ...parsedToCsv(nubaseEntry.massExcessUncertainty),
      ...parsedToCsv(nubaseEntry.excitationEnergy),
      if (withUnc) ...parsedToCsv(nubaseEntry.excitationEnergyUncertainty),
      '"${nubaseEntry.origin}"',
      '"${nubaseEntry.stbl ? "#" : ""}"',
      '"${nubaseEntry.halfLife?.value}"',
      '"${nubaseEntry.halfLifeUnit}"',
      if (withUnc) '"${nubaseEntry.halfLifeUncertainty}"',
      nubaseEntry.halfLife?.isSystematic == true ? '"#"' : '""',
      '"${nubaseEntry.spin?.spin?.value}"',
      '"${nubaseEntry.spin?.spin?.isSystematic}"',
      '"${nubaseEntry.spin?.directlyMeasured}"',
      '"${nubaseEntry.spin?.isospin}"',
      '"${nubaseEntry.decayModes}"',
      '"${nubaseEntry.discoveryYear}"',
      // AME
      ...parsedToCsv(ameEntry?.massExcess),
      if (withUnc) ...parsedToCsv(ameEntry?.massExcessUncertainty),
      ...parsedToCsv(ameEntry?.bindingEnergyPerA),
      if (withUnc) ...parsedToCsv(ameEntry?.bindingEnergyPerAUncertainty),
      ...parsedToCsv(ameEntry?.betaDecayEnergy),
      if (withUnc) ...parsedToCsv(ameEntry?.betaDecayEnergyUncertainty),
      ...parsedToCsv(ameEntry?.atomicMassMicroU),
      if (withUnc) ...parsedToCsv(ameEntry?.atomicMassUncertaintyMicroU),
      // RCT1
      ...parsedToCsv(rctEntry?.s2n),
      if (withUnc) ...parsedToCsv(rctEntry?.s2nUncertainty),
      ...parsedToCsv(rctEntry?.s2p),
      if (withUnc) ...parsedToCsv(rctEntry?.s2pUncertainty),
      ...parsedToCsv(rctEntry?.qa),
      if (withUnc) ...parsedToCsv(rctEntry?.qaUncertainty),
      ...parsedToCsv(rctEntry?.q2b),
      if (withUnc) ...parsedToCsv(rctEntry?.q2bUncertainty),
      ...parsedToCsv(rctEntry?.qep),
      if (withUnc) ...parsedToCsv(rctEntry?.qepUncertainty),
      ...parsedToCsv(rctEntry?.qbn),
      if (withUnc) ...parsedToCsv(rctEntry?.qbnUncertainty),
      // RCT2
      ...parsedToCsv(rctEntry?.sn),
      if (withUnc) ...parsedToCsv(rctEntry?.snUncertainty),
      ...parsedToCsv(rctEntry?.sp),
      if (withUnc) ...parsedToCsv(rctEntry?.spUncertainty),
      ...parsedToCsv(rctEntry?.q4b),
      if (withUnc) ...parsedToCsv(rctEntry?.q4bUncertainty),
      ...parsedToCsv(rctEntry?.qda),
      if (withUnc) ...parsedToCsv(rctEntry?.qdaUncertainty),
      ...parsedToCsv(rctEntry?.qpa),
      if (withUnc) ...parsedToCsv(rctEntry?.qpaUncertainty),
      ...parsedToCsv(rctEntry?.qna),
      if (withUnc) ...parsedToCsv(rctEntry?.qnaUncertainty),
    ].join(',');
    outputLines.add(getRow());
    outputLinesWithoutUnc.add(getRow(false));

    ///Dart
    outputLinesDartNubase.add(
      'NubaseEntry.required('
      '${nubaseEntry.a},'
      '${nubaseEntry.z},'
      '${nubaseEntry.s != null ? '"${nubaseEntry.s}"' : 'null'},'
      '${nubaseEntry.isomerIndex},'
      '${nubaseEntry.stateType},'
      '${parsedToDart(nubaseEntry.massExcess)},'
      '${parsedToDart(nubaseEntry.massExcessUncertainty)},'
      '${parsedToDart(nubaseEntry.excitationEnergy)},'
      '${parsedToDart(nubaseEntry.excitationEnergyUncertainty)},'
      '${nubaseEntry.origin != null ? '"${nubaseEntry.origin}"' : 'null'},'
      '${nubaseEntry.stbl},'
      '${nubaseEntry.pUnst},'
      '${parsedToDartString(nubaseEntry.halfLife)},'
      '${nubaseEntry.halfLifeUnit != null ? '"${nubaseEntry.halfLifeUnit}"' : 'null'},'
      '${nubaseEntry.halfLifeUncertainty != null ? '"${nubaseEntry.halfLifeUncertainty}"' : 'null'},'
      '${spinToDart(nubaseEntry.spin)},'
      '${nubaseEntry.ensdfYear},'
      '${nubaseEntry.discoveryYear},'
      '${nubaseEntry.decayModes != null ? '"${nubaseEntry.decayModes}"' : 'null'}'
      '),',
    );
    if (ameEntry != null)
      outputLinesDartAme.add(
        'AME2020Entry.required('
        '${ameEntry.nMinusZ},'
        '${ameEntry.n},'
        '${ameEntry.z},'
        '${ameEntry.a},'
        '"${ameEntry.o}",'
        "${parsedToDart(ameEntry.massExcess)},"
        "${parsedToDart(ameEntry.massExcessUncertainty)},"
        "${parsedToDart(ameEntry.bindingEnergyPerA)},"
        "${parsedToDart(ameEntry.bindingEnergyPerAUncertainty)},"
        '"${ameEntry.betaDecayType}",'
        "${parsedToDart(ameEntry.betaDecayEnergy)},"
        "${parsedToDart(ameEntry.betaDecayEnergyUncertainty)},"
        "${parsedToDart(ameEntry.atomicMassMicroU)},"
        "${parsedToDart(ameEntry.atomicMassUncertaintyMicroU)}"
        '),',
      );
    if (rctEntry != null)
      outputLinesDartRct.add(
        'ReactionDataEntry.required('
        '${nubaseEntry.a},'
        '${nubaseEntry.z},'
        '${parsedToDart(rctEntry.s2n)},'
        '${parsedToDart(rctEntry.s2nUncertainty)},'
        '${parsedToDart(rctEntry.s2p)},'
        '${parsedToDart(rctEntry.s2pUncertainty)},'
        '${parsedToDart(rctEntry.qa)},'
        '${parsedToDart(rctEntry.qaUncertainty)},'
        '${parsedToDart(rctEntry.q2b)},'
        '${parsedToDart(rctEntry.q2bUncertainty)},'
        '${parsedToDart(rctEntry.qep)},'
        '${parsedToDart(rctEntry.qepUncertainty)},'
        '${parsedToDart(rctEntry.qbn)},'
        '${parsedToDart(rctEntry.qbnUncertainty)},'
        '${parsedToDart(rctEntry.sn)},'
        '${parsedToDart(rctEntry.snUncertainty)},'
        '${parsedToDart(rctEntry.sp)},'
        '${parsedToDart(rctEntry.spUncertainty)},'
        '${parsedToDart(rctEntry.q4b)},'
        '${parsedToDart(rctEntry.q4bUncertainty)},'
        '${parsedToDart(rctEntry.qda)},'
        '${parsedToDart(rctEntry.qdaUncertainty)},'
        '${parsedToDart(rctEntry.qpa)},'
        '${parsedToDart(rctEntry.qpaUncertainty)},'
        '${parsedToDart(rctEntry.qna)},'
        '${parsedToDart(rctEntry.qnaUncertainty)}'
        '),',
      );

    ///Cpp
    outputLinesCppNubase.add(
      '{'
      '${nubaseEntry.a},'
      '${nubaseEntry.z},'
      '${nubaseEntry.s != null ? '"${nubaseEntry.s}"' : 'std::nullopt'},'
      '${nubaseEntry.isomerIndex},'
      '${nubaseEntry.stateType.toString().replaceFirst(".", "::")},'
      '${parsedToCpp(nubaseEntry.massExcess)},'
      '${parsedToCpp(nubaseEntry.massExcessUncertainty)},'
      '${parsedToCpp(nubaseEntry.excitationEnergy)},'
      '${parsedToCpp(nubaseEntry.excitationEnergyUncertainty)},'
      '${nubaseEntry.origin != null ? '"${nubaseEntry.origin}"' : 'std::nullopt'},'
      '${nubaseEntry.stbl},'
      '${nubaseEntry.pUnst},'
      '${parsedToCppString(nubaseEntry.halfLife)},'
      '${nubaseEntry.halfLifeUnit != null ? '"${nubaseEntry.halfLifeUnit}"' : 'std::nullopt'},'
      '${nubaseEntry.halfLifeUncertainty != null ? '"${nubaseEntry.halfLifeUncertainty}"' : 'std::nullopt'},'
      '${spinToCpp(nubaseEntry.spin)},'
      '${nubaseEntry.ensdfYear != null ? nubaseEntry.ensdfYear : 'std::nullopt'},'
      '${nubaseEntry.discoveryYear},'
      '${nubaseEntry.decayModes != null ? '"${nubaseEntry.decayModes}"' : 'std::nullopt'}'
      '},',
    );
    if (ameEntry != null)
      outputLinesCppAme.add(
        '{'
        '${ameEntry.nMinusZ},'
        '${ameEntry.n},'
        '${ameEntry.z},'
        '${ameEntry.a},'
        '"${ameEntry.o}",'
        "${parsedToCpp(ameEntry.massExcess)},"
        "${parsedToCpp(ameEntry.massExcessUncertainty)},"
        "${parsedToCpp(ameEntry.bindingEnergyPerA)},"
        "${parsedToCpp(ameEntry.bindingEnergyPerAUncertainty)},"
        '"${ameEntry.betaDecayType}",'
        "${parsedToCpp(ameEntry.betaDecayEnergy)},"
        "${parsedToCpp(ameEntry.betaDecayEnergyUncertainty)},"
        "${parsedToCpp(ameEntry.atomicMassMicroU)},"
        "${parsedToCpp(ameEntry.atomicMassUncertaintyMicroU)}"
        '},',
      );
    if (rctEntry != null)
      outputLinesCppRct.add(
        '{'
        '${nubaseEntry.a},'
        '${nubaseEntry.z},'
        '${parsedToCpp(rctEntry.s2n)},'
        '${parsedToCpp(rctEntry.s2nUncertainty)},'
        '${parsedToCpp(rctEntry.s2p)},'
        '${parsedToCpp(rctEntry.s2pUncertainty)},'
        '${parsedToCpp(rctEntry.qa)},'
        '${parsedToCpp(rctEntry.qaUncertainty)},'
        '${parsedToCpp(rctEntry.q2b)},'
        '${parsedToCpp(rctEntry.q2bUncertainty)},'
        '${parsedToCpp(rctEntry.qep)},'
        '${parsedToCpp(rctEntry.qepUncertainty)},'
        '${parsedToCpp(rctEntry.qbn)},'
        '${parsedToCpp(rctEntry.qbnUncertainty)},'
        '${parsedToCpp(rctEntry.sn)},'
        '${parsedToCpp(rctEntry.snUncertainty)},'
        '${parsedToCpp(rctEntry.sp)},'
        '${parsedToCpp(rctEntry.spUncertainty)},'
        '${parsedToCpp(rctEntry.q4b)},'
        '${parsedToCpp(rctEntry.q4bUncertainty)},'
        '${parsedToCpp(rctEntry.qda)},'
        '${parsedToCpp(rctEntry.qdaUncertainty)},'
        '${parsedToCpp(rctEntry.qpa)},'
        '${parsedToCpp(rctEntry.qpaUncertainty)},'
        '${parsedToCpp(rctEntry.qna)},'
        '${parsedToCpp(rctEntry.qnaUncertainty)}'
        '},',
      );
  }
  outputLinesDartNubase.add("];");
  outputLinesDartAme.add("];");
  outputLinesDartRct.add("];");

  outputLinesCppNubase.add("};");
  outputLinesCppAme.add("};");
  outputLinesCppRct.add("};");

  outputFile.writeAsStringSync(outputLines.join('\n'));
  outputFileWithoutUnc.writeAsStringSync(outputLinesWithoutUnc.join('\n'));
  outputDartNubase.writeAsStringSync(outputLinesDartNubase.join('\n'));
  outputDartAme.writeAsStringSync(outputLinesDartAme.join('\n'));
  outputDartRct.writeAsStringSync(outputLinesDartRct.join('\n'));

  outputCppNubase.writeAsStringSync(outputLinesCppNubase.join('\n'));
  outputCppAme.writeAsStringSync(outputLinesCppAme.join('\n'));
  outputCppRct.writeAsStringSync(outputLinesCppRct.join('\n'));

  print(
    'Обработка завершена. Результат записан в папке `output`.\nParsing completed. Result written to `output` folder',
  );
}
