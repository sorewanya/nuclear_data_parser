#include <string>
#include <optional>
#include "SystValue.h"

/**
 * @brief Вспомогательный класс для хранения данных о спине
 *
 * Helper class to store spin info
 */
class Spin
{
private:
    std::optional<SystValue<std::string_view>> spin;
    bool directlyMeasured;
    std::optional<std::string_view> isospin;

public:
    // Конструктор
    constexpr Spin(std::optional<SystValue<std::string_view>> spin, bool directlyMeasured,
                   std::optional<std::string_view> isospin) noexcept
        : spin(spin), directlyMeasured(directlyMeasured), isospin(isospin) {}

    constexpr std::optional<SystValue<std::string_view>> getSpin() const;
    constexpr bool getDirectlyMeasured() const;
    constexpr std::optional<std::string_view> getIsospin() const;
};