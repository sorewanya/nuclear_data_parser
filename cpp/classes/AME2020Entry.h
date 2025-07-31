#include <string>
#include <optional>
#include "SystValue.h"

#include "ElementEnum.h"
class AME2020Entry
{
private:
    const std::optional<int> nMinusZ;
    const int n;
    const int z;
    const int a;
    const std::string_view o;
    const std::optional<SystValue<double>> massExcess;
    const std::optional<SystValue<double>> massExcessUncertainty;
    const std::optional<SystValue<double>> bindingEnergyPerA;
    const std::optional<SystValue<double>> bindingEnergyPerAUncertainty;
    const std::string_view betaDecayType;
    const std::optional<SystValue<double>> betaDecayEnergy;
    const std::optional<SystValue<double>> betaDecayEnergyUncertainty;
    const std::optional<SystValue<double>> atomicMassMicroU;
    const std::optional<SystValue<double>> atomicMassUncertaintyMicroU;

public:
    // Конструктор
    constexpr AME2020Entry(
        const std::optional<int> &nMinusZ,
        const int n,
        const int z,
        const int a,
        const std::string_view &o,
        const std::optional<SystValue<double>> &massExcess,
        const std::optional<SystValue<double>> &massExcessUncertainty,
        const std::optional<SystValue<double>> &bindingEnergyPerA,
        const std::optional<SystValue<double>> &bindingEnergyPerAUncertainty,
        const std::string_view &betaDecayType,
        const std::optional<SystValue<double>> &betaDecayEnergy,
        const std::optional<SystValue<double>> &betaDecayEnergyUncertainty,
        const std::optional<SystValue<double>> &atomicMassMicroU,
        const std::optional<SystValue<double>> &atomicMassUncertaintyMicroU) : nMinusZ(nMinusZ), n(n), z(z), a(a), o(o),
                                                                               massExcess(massExcess), massExcessUncertainty(massExcessUncertainty),
                                                                               bindingEnergyPerA(bindingEnergyPerA), bindingEnergyPerAUncertainty(bindingEnergyPerAUncertainty),
                                                                               betaDecayType(betaDecayType), betaDecayEnergy(betaDecayEnergy),
                                                                               betaDecayEnergyUncertainty(betaDecayEnergyUncertainty),
                                                                               atomicMassMicroU(atomicMassMicroU), atomicMassUncertaintyMicroU(atomicMassUncertaintyMicroU) {}

    // Геттеры
    std::optional<int> getNMinusZ() const { return nMinusZ; }
    int getN() const { return n; }
    int getZ() const { return z; }
    int getA() const { return a; }
    std::string_view getO() const { return o; }
    std::optional<SystValue<double>> getMassExcess() const { return massExcess; }
    std::optional<SystValue<double>> getMassExcessUncertainty() const { return massExcessUncertainty; }
    std::optional<SystValue<double>> getBindingEnergyPerA() const { return bindingEnergyPerA; }
    std::optional<SystValue<double>> getBindingEnergyPerAUncertainty() const { return bindingEnergyPerAUncertainty; }
    std::string_view getBetaDecayType() const { return betaDecayType; }
    std::optional<SystValue<double>> getBetaDecayEnergy() const { return betaDecayEnergy; }
    std::optional<SystValue<double>> getBetaDecayEnergyUncertainty() const { return betaDecayEnergyUncertainty; }
    std::optional<SystValue<double>> getAtomicMassMicroU() const { return atomicMassMicroU; }
    std::optional<SystValue<double>> getAtomicMassUncertaintyMicroU() const { return atomicMassUncertaintyMicroU; }

    // Метод toString()
    std::string toString() const
    {
        std::string elementName = "UNKNOWN";
        if (z >= 0 && z < static_cast<int>(ElementEnum::UNKNOWN))
        {
            elementName = ElementEnumToString(static_cast<ElementEnum>(z));
        }
        // Функция для безопасного преобразования optional<double> в строку
        auto optionalToStr = [](const std::optional<double> &val) -> std::string
        {
            return val.has_value() ? std::to_string(val.value()) : "null";
        };
        std::string result = "A=" + std::to_string(a) +
                             ", Z=" + std::to_string(z) +
                             ", El=" + elementName;
        if (massExcess.has_value())
            result.append(optionalToStr(massExcess.value().getValue()));
        if (atomicMassMicroU.has_value())
            result.append(optionalToStr(atomicMassMicroU.value().getValue()));

        return result;
    }
};