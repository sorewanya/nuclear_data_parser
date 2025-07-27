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
    const SystValue<std::optional<double>> massExcess;
    const SystValue<std::optional<double>> massExcessUncertainty;
    const SystValue<std::optional<double>> bindingEnergyPerA;
    const SystValue<std::optional<double>> bindingEnergyPerAUncertainty;
    const std::string_view betaDecayType;
    const SystValue<std::optional<double>> betaDecayEnergy;
    const SystValue<std::optional<double>> betaDecayEnergyUncertainty;
    const SystValue<std::optional<double>> atomicMassMicroU;
    const SystValue<std::optional<double>> atomicMassUncertaintyMicroU;

public:
    // Конструктор
    constexpr AME2020Entry(
        const std::optional<int> &nMinusZ,
        const int n,
        const int z,
        const int a,
        const std::string_view &o,
        const SystValue<std::optional<double>> &massExcess,
        const SystValue<std::optional<double>> &massExcessUncertainty,
        const SystValue<std::optional<double>> &bindingEnergyPerA,
        const SystValue<std::optional<double>> &bindingEnergyPerAUncertainty,
        const std::string_view &betaDecayType,
        const SystValue<std::optional<double>> &betaDecayEnergy,
        const SystValue<std::optional<double>> &betaDecayEnergyUncertainty,
        const SystValue<std::optional<double>> &atomicMassMicroU,
        const SystValue<std::optional<double>> &atomicMassUncertaintyMicroU) : nMinusZ(nMinusZ), n(n), z(z), a(a), o(o),
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
    SystValue<std::optional<double>> getMassExcess() const { return massExcess; }
    SystValue<std::optional<double>> getMassExcessUncertainty() const { return massExcessUncertainty; }
    SystValue<std::optional<double>> getBindingEnergyPerA() const { return bindingEnergyPerA; }
    SystValue<std::optional<double>> getBindingEnergyPerAUncertainty() const { return bindingEnergyPerAUncertainty; }
    std::string_view getBetaDecayType() const { return betaDecayType; }
    SystValue<std::optional<double>> getBetaDecayEnergy() const { return betaDecayEnergy; }
    SystValue<std::optional<double>> getBetaDecayEnergyUncertainty() const { return betaDecayEnergyUncertainty; }
    SystValue<std::optional<double>> getAtomicMassMicroU() const { return atomicMassMicroU; }
    SystValue<std::optional<double>> getAtomicMassUncertaintyMicroU() const { return atomicMassUncertaintyMicroU; }

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

        return "A=" + std::to_string(a) +
               ", Z=" + std::to_string(z) +
               ", El=" + elementName +
               ", Mass Excess: " + optionalToStr(massExcess.getValue().value()) + " keV" +
               ", Atomic Mass: " + optionalToStr(atomicMassMicroU.getValue().value()) + " micro-u";
    }
};