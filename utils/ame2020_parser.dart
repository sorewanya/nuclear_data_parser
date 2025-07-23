import '../entities/ame2020_entity.dart';
import 'parse_double.dart';
import 'safe_string.dart';

///format    :  a1,i3,i5,i5,i5,1x,a3,a4,1x,f14.6,f12.6,f13.5,1x,f10.5,1x,a2,f13.5,f11.5,1x,i3,1x,f13.6,f12.6
///             cc NZ  N  Z  A    el  o     mass  unc binding unc      B  beta  unc    atomic_mass   unc
AME2020Entry AME2020EntryFromLine(String rawLine) => AME2020Entry(
  nMinusZ: int.tryParse(rawLine.safeSubstring(1, 4).trim()),
  n: int.parse(rawLine.safeSubstring(4, 9).trim()),
  z: int.parse(rawLine.safeSubstring(9, 14).trim()),
  a: int.parse(rawLine.safeSubstring(14, 19).trim()),
  o: rawLine.safeSubstring(23, 27).trim(),
  massExcess: parseDouble(rawLine.safeSubstring(28, 42)),
  massExcessUncertainty: parseDouble(rawLine.safeSubstring(42, 54)),
  bindingEnergyPerA: parseDouble(rawLine.safeSubstring(54, 67)),
  bindingEnergyPerAUncertainty: parseDouble(rawLine.safeSubstring(68, 78)),
  betaDecayType: rawLine.safeSubstring(79, 81).trim(),
  betaDecayEnergy: parseDouble(rawLine.safeSubstring(81, 94)),
  betaDecayEnergyUncertainty: parseDouble(rawLine.safeSubstring(94, 105)),
  atomicMassMicroU: parseDouble(rawLine.safeSubstring(106, 123).trim()),
  atomicMassUncertaintyMicroU: parseDouble(rawLine.safeSubstring(123)),
);
