import '../entities/nubase_entity.dart';
import '../entities/nuclide_state_type_enum.dart';

/// Определяет тип ядерного состояния, используя контекст.
/// Эта функция использует информацию из колонок 's' и 'ZZZi', а также
/// контекст о том, есть ли у нуклида множество изомеров.
///
/// Determines the nuclide state type based on file conventions and context.
/// This function uses information from the 's' and 'ZZZi' columns, as well as
/// context about whether the nuclide has many isomers.
NuclideStateTypeEnum getNuclideStateType(NubaseEntry entry, bool hasManyIsomers) {
  final s = entry.s;
  final isomerIndex = entry.isomerIndex;

  // Основное состояние (Ground state)
  if (isomerIndex == 0) return NuclideStateTypeEnum.GROUND_STATE;

  // Явные изомеры (Explicit isomers)
  if (s == 'm' || s == 'n' || s == 'x' || isomerIndex == 1 || isomerIndex == 2 || isomerIndex == 6) {
    return NuclideStateTypeEnum.ISOMER;
  }

  // Явные изобар-аналоговые состояния (Explicit Isobaric Analog States - IAS)
  if (s == 'i' || s == 'j' || isomerIndex == 8 || isomerIndex == 9) {
    return NuclideStateTypeEnum.ISOBARIC_ANALOG_STATE;
  }

  // Неоднозначные случаи, зависящие от контекста (Ambiguous cases depending on context)
  if (hasManyIsomers) {
    if (s == 'p' || s == 'q' || s == 'r' || isomerIndex == 3 || isomerIndex == 4 || isomerIndex == 5) {
      return NuclideStateTypeEnum.ISOMER;
    }
  }

  // Если контекст не указывает на изомер, используем первичное значение (If context doesn't indicate an isomer, use the primary meaning)
  if (s == 'p' || s == 'q' || isomerIndex == 3 || isomerIndex == 4) return NuclideStateTypeEnum.LEVEL;
  if (s == 'r' || isomerIndex == 5) return NuclideStateTypeEnum.RESONANCE;

  return NuclideStateTypeEnum.UNKNOWN;
}
