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
