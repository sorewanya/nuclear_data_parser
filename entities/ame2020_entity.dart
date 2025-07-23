import 'elements_enum.dart';
import 'parsed_value.dart';

/// Класс для хранения данных об оценке атомных масс из одной строки файла mass.mas20.
///
/// Class for storing atomic mass estimate data from one line of mass.mas20 file.
class AME2020Entry {
  final int? nMinusZ;
  final int n;
  final int z;
  final int a;
  final String o;
  final ParsedValue<double?> massExcess;
  final ParsedValue<double?> massExcessUncertainty;
  final ParsedValue<double?> bindingEnergyPerA;
  final ParsedValue<double?> bindingEnergyPerAUncertainty;
  final String betaDecayType;
  final ParsedValue<double?> betaDecayEnergy;
  final ParsedValue<double?> betaDecayEnergyUncertainty;
  final ParsedValue<double?> atomicMassMicroU;
  final ParsedValue<double?> atomicMassUncertaintyMicroU;
  AME2020Entry.required(
    this.nMinusZ,
    this.n,
    this.z,
    this.a,
    this.o,
    this.massExcess,
    this.massExcessUncertainty,
    this.bindingEnergyPerA,
    this.bindingEnergyPerAUncertainty,
    this.betaDecayType,
    this.betaDecayEnergy,
    this.betaDecayEnergyUncertainty,
    this.atomicMassMicroU,
    this.atomicMassUncertaintyMicroU,
  );

  AME2020Entry({
    required this.nMinusZ,
    required this.n,
    required this.z,
    required this.a,
    required this.o,
    required this.massExcess,
    required this.massExcessUncertainty,
    required this.bindingEnergyPerA,
    required this.bindingEnergyPerAUncertainty,
    required this.betaDecayType,
    required this.betaDecayEnergy,
    required this.betaDecayEnergyUncertainty,
    required this.atomicMassMicroU,
    required this.atomicMassUncertaintyMicroU,
  });

  @override
  String toString() {
    return 'A=$a, Z=$z, El=${ElementsEnum.values[z]}, Mass Excess: $massExcess keV, Atomic Mass: $atomicMassMicroU micro-u';
  }
}
