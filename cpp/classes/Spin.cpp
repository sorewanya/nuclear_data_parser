#include <string_view>
#include <concepts>
#include <optional>
#include "SystValue.h"

class Spin
{
private:
    std::optional<SystValue<std::string_view>> spin;
    bool directlyMeasured;
    std::optional<std::string_view> isospin;

public:
    constexpr Spin(std::optional<SystValue<std::string_view>> spin, bool directlyMeasured,
                   std::optional<std::string_view> isospin) noexcept
        : spin(spin), directlyMeasured(directlyMeasured), isospin(isospin) {}

    constexpr std::optional<SystValue<std::string_view>> getSpin() const { return spin; }
    constexpr bool getDirectlyMeasured() const { return directlyMeasured; }
    constexpr std::optional<std::string_view> getIsospin() const { return isospin; }
};