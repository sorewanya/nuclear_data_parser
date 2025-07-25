#include <string>
#include <optional>

template <typename T>
class ParsedValue
{
private:
    std::optional<T> value;
    bool isSystematic;

public:
    ParsedValue(const std::optional<T> &val, bool systematic)
        : value(val), isSystematic(systematic) {}

    std::optional<T> getValue() const
    {
        return value;
    }

    bool getIsSystematic() const
    {
        return isSystematic;
    }

    std::string toString() const
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
};