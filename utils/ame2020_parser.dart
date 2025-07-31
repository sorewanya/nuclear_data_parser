import '../entities/ame2020_entity.dart';
import '../entities/syst_value.dart';
import 'log_if_null.dart';
import 'parse_double.dart';
import 'safe_string.dart';

///format    :  a1,i3,i5,i5,i5,1x,a3,a4,1x,f14.6,f12.6,f13.5,1x,f10.5,1x,a2,f13.5,f11.5,1x,i3,1x,f13.6,f12.6
///             cc NZ  N  Z  A    el  o     mass  unc binding unc      B  beta  unc    atomic_mass   unc
AME2020Entry AME2020EntryFromLine(String rawLine) {
  final nMinusZ = int.tryParse(rawLine.safeSubstring(1, 4).trim());
  if (nMinusZ == null) logNull("nMinusZ");
  final n = int.tryParse(rawLine.safeSubstring(4, 9).trim());
  if (n == null) logNull("n");
  final z = int.tryParse(rawLine.safeSubstring(9, 14).trim());
  if (z == null) logNull("z");
  final a = int.tryParse(rawLine.safeSubstring(14, 19).trim());
  if (a == null) logNull("a");
  final o = rawLine.safeSubstring(23, 27).trim();
  final massExcess = parseDouble(rawLine.safeSubstring(28, 42));
  if (massExcess == null) logNull("massExcess");
  final massExcessUncertainty = parseDouble(rawLine.safeSubstring(42, 54));
  if (massExcessUncertainty == null) logNull("massExcessUncertainty");
  final bindingEnergyPerA = parseDouble(rawLine.safeSubstring(54, 67));
  if (bindingEnergyPerA == null) logNull("bindingEnergyPerA");
  final bindingEnergyPerAUncertainty = parseDouble(rawLine.safeSubstring(68, 78));
  if (bindingEnergyPerAUncertainty == null) logNull("bindingEnergyPerAUncertainty");
  final betaDecayType = rawLine.safeSubstring(79, 81).trim();
  if (betaDecayType == "") logNull("betaDecayType");
  final atomicMassMicroU = parseDouble(rawLine.safeSubstring(106, 123).trim());
  if (atomicMassMicroU == null) logNull("atomicMassMicroU");
  final atomicMassUncertaintyMicroU = parseDouble(rawLine.safeSubstring(123));
  if (atomicMassUncertaintyMicroU == null) logNull("atomicMassUncertaintyMicroU");

  return AME2020Entry(
    nMinusZ: nMinusZ ?? 0,
    n: n ?? 0,
    z: z ?? 0,
    a: a ?? 0,
    o: o == "" ? null : o,
    massExcess: massExcess ?? SystValue(0, true),
    massExcessUncertainty: massExcessUncertainty ?? SystValue(0, true),
    bindingEnergyPerA: bindingEnergyPerA ?? SystValue(0, true),
    bindingEnergyPerAUncertainty: bindingEnergyPerAUncertainty ?? SystValue(0, true),
    betaDecayType: betaDecayType,
    betaDecayEnergy: parseDouble(rawLine.safeSubstring(81, 94)),
    betaDecayEnergyUncertainty: parseDouble(rawLine.safeSubstring(94, 105)),
    atomicMassMicroU: atomicMassMicroU ?? SystValue(0, true),
    atomicMassUncertaintyMicroU: atomicMassUncertaintyMicroU ?? SystValue(0, true),
  );
}
