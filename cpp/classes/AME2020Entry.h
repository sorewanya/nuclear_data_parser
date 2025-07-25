#include <string>
#include <optional>
#include "ParsedValue.h"

#include "ElementEnum.h"
class AME2020Entry
{
private:
    std::optional<int> nMinusZ;
    int n;
    int z;
    int a;
    std::string o;
    ParsedValue<std::optional<double>> massExcess;
    ParsedValue<std::optional<double>> massExcessUncertainty;
    ParsedValue<std::optional<double>> bindingEnergyPerA;
    ParsedValue<std::optional<double>> bindingEnergyPerAUncertainty;
    std::string betaDecayType;
    ParsedValue<std::optional<double>> betaDecayEnergy;
    ParsedValue<std::optional<double>> betaDecayEnergyUncertainty;
    ParsedValue<std::optional<double>> atomicMassMicroU;
    ParsedValue<std::optional<double>> atomicMassUncertaintyMicroU;

public:
    // Конструктор
    AME2020Entry(
        const std::optional<int> &nMinusZ,
        int n,
        int z,
        int a,
        const std::string &o,
        const ParsedValue<std::optional<double>> &massExcess,
        const ParsedValue<std::optional<double>> &massExcessUncertainty,
        const ParsedValue<std::optional<double>> &bindingEnergyPerA,
        const ParsedValue<std::optional<double>> &bindingEnergyPerAUncertainty,
        const std::string &betaDecayType,
        const ParsedValue<std::optional<double>> &betaDecayEnergy,
        const ParsedValue<std::optional<double>> &betaDecayEnergyUncertainty,
        const ParsedValue<std::optional<double>> &atomicMassMicroU,
        const ParsedValue<std::optional<double>> &atomicMassUncertaintyMicroU) : nMinusZ(nMinusZ), n(n), z(z), a(a), o(o),
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
    std::string getO() const { return o; }
    ParsedValue<std::optional<double>> getMassExcess() const { return massExcess; }
    ParsedValue<std::optional<double>> getMassExcessUncertainty() const { return massExcessUncertainty; }
    ParsedValue<std::optional<double>> getBindingEnergyPerA() const { return bindingEnergyPerA; }
    ParsedValue<std::optional<double>> getBindingEnergyPerAUncertainty() const { return bindingEnergyPerAUncertainty; }
    std::string getBetaDecayType() const { return betaDecayType; }
    ParsedValue<std::optional<double>> getBetaDecayEnergy() const { return betaDecayEnergy; }
    ParsedValue<std::optional<double>> getBetaDecayEnergyUncertainty() const { return betaDecayEnergyUncertainty; }
    ParsedValue<std::optional<double>> getAtomicMassMicroU() const { return atomicMassMicroU; }
    ParsedValue<std::optional<double>> getAtomicMassUncertaintyMicroU() const { return atomicMassUncertaintyMicroU; }

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