import 'nuclide_state_type_enum.dart';
import 'syst_value.dart';

/// Класс для хранения данных из файла NUBASE2020.
class NubaseEntry {
  /// A - массовое число
  final int a;

  /// Z - протонный номер.
  final int z;
  final String s; // s column (m, n, p, q, etc.)
  /// Isomer_Index - i=0 (gs); i=1,2 (isomers); i=3,4 (levels); i=5 (resonance); i=8,9 (IAS)
  final int isomerIndex; // The 'i' part of ZZZi
  final SystValue<double?> massExcess;
  final SystValue<double?> massExcessUncertainty;
  final SystValue<double?> excitationEnergy;
  final SystValue<double?> excitationEnergyUncertainty;
  final String origin; //Origin of Excitation Energy
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
  NuclideStateTypeEnum stateType = NuclideStateTypeEnum.UNKNOWN;

  NubaseEntry({
    required this.a,
    required this.z,
    required this.s,
    required this.isomerIndex,
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
  NubaseEntry.required(
    this.a,
    this.z,
    this.s,
    this.isomerIndex,
    this.stateType,
    this.massExcess,
    this.massExcessUncertainty,
    this.excitationEnergy,
    this.excitationEnergyUncertainty,
    this.origin,
    this.stbl,
    this.pUnst,
    this.halfLife,
    this.isHalfLifeSystematic,
    this.halfLifeUnit,
    this.halfLifeUncertainty,
    this.spinParity,
    this.spinParitySource,
    this.isospin,
    this.ensdfYear,
    this.discoveryYear,
    this.decayModes,
  );

  /// Уникальный ключ для поиска данных из AME/RCT.
  String get ameKey => '$a-$z';
}
