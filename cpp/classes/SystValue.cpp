#include <string_view>
#include <concepts>
#include <optional>

template <typename T>
class SystValue
{
private:
    constexpr std::optional<T> value;
    constexpr bool isSystematic;

public:
    constexpr SystValue(std::optional<T> val, bool systematic) noexcept(std::is_nothrow_move_constructible_v<T>)
        : value(std::move(val)), isSystematic(systematic) {}

    constexpr std::optional<T> getValue() const noexcept
    {
        return value;
    }

    constexpr bool getIsSystematic() const noexcept
    {

        return isSystematic;
    }

    constexpr std::string_view toString() const
    {
        if (value.has_value())
        {
            // Для типов, поддерживающих преобразование в строку
            if constexpr (std::is_same_v<T, std::string>)
            {
                return value.value();
            }
            else
            {
                return std::to_string(value.value());
            }
        }
        return "";
    }

    constexpr bool operator==(const SystValue &) const = default;
};