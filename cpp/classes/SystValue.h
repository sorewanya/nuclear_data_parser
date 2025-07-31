#include <string>
#include <optional>

/**
 * @brief Вспомогательный класс для хранения значения и флага,
 * указывающего, было ли оно получено на основе систематических закономерностей (from systematic) (#).
 *
 * Helper class to store a value and a flag indicating whether it was obtained from systematic (#).
 */
template <typename T>
class SystValue
{
private:
    T value;
    bool isSystematic;

public:
    // Конструктор
    constexpr SystValue(T val, bool systematic) noexcept(std::is_nothrow_move_constructible_v<T>)
        : value(std::move(val)), isSystematic(systematic);
    // Получение значения
    constexpr T getValue() const;

    // Проверка, является ли значение систематическим
    constexpr bool getIsSystematic() const;

    // Преобразование в строку (аналог toString() в Dart)
    constexpr std::string toString() const;
};