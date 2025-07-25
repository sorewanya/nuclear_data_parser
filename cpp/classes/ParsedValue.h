#include <string>
#include <optional>

/**
 * @brief Вспомогательный класс для хранения значения и флага,
 * указывающего, было ли оно получено на основе систематических закономерностей (from systematic) (#).
 *
 * Helper class to store a value and a flag indicating whether it was obtained from systematic (#).
 */
template <typename T>
class ParsedValue
{
private:
    std::optional<T> value;
    bool isSystematic;

public:
    // Конструктор
    ParsedValue(const std::optional<T> &val, bool systematic);

    // Получение значения
    std::optional<T> getValue() const;

    // Проверка, является ли значение систематическим
    bool getIsSystematic() const;

    // Преобразование в строку (аналог toString() в Dart)
    std::string toString() const;
};