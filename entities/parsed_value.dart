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
