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
    const std::optional<std::string_view> o;
    const SystValue<double> massExcess;
    const SystValue<double> massExcessUncertainty;
    const SystValue<double> bindingEnergyPerA;
    const SystValue<double> bindingEnergyPerAUncertainty;
    const bool betaDecayBMinus;
    const std::optional<SystValue<double>> betaDecayEnergy;
    const std::optional<SystValue<double>> betaDecayEnergyUncertainty;
    const SystValue<double> atomicMassMicroU;
    const SystValue<double> atomicMassUncertaintyMicroU;

public:
    // Конструктор
    constexpr AME2020Entry(
        const std::optional<int> &nMinusZ,
        const int n,
        const int z,
        const int a,
        const std::optional<std::string_view> &o,
        const SystValue<double> &massExcess,
        const SystValue<double> &massExcessUncertainty,
        const SystValue<double> &bindingEnergyPerA,
        const SystValue<double> &bindingEnergyPerAUncertainty,
        const bool &betaDecayBMinus,
        const std::optional<SystValue<double>> &betaDecayEnergy,
        const std::optional<SystValue<double>> &betaDecayEnergyUncertainty,
        const SystValue<double> &atomicMassMicroU,
        const SystValue<double> &atomicMassUncertaintyMicroU) : nMinusZ(nMinusZ), n(n), z(z), a(a), o(o),
                                                                massExcess(massExcess), massExcessUncertainty(massExcessUncertainty),
                                                                bindingEnergyPerA(bindingEnergyPerA), bindingEnergyPerAUncertainty(bindingEnergyPerAUncertainty),
                                                                betaDecayBMinus(betaDecayBMinus), betaDecayEnergy(betaDecayEnergy),
                                                                betaDecayEnergyUncertainty(betaDecayEnergyUncertainty),
                                                                atomicMassMicroU(atomicMassMicroU), atomicMassUncertaintyMicroU(atomicMassUncertaintyMicroU) {}

    // Геттеры
    std::optional<int> getNMinusZ() const { return nMinusZ; }
    int getN() const { return n; }
    int getZ() const { return z; }
    int getA() const { return a; }
    std::optional<std::string_view> getO() const { return o; }
    SystValue<double> getMassExcess() const { return massExcess; }
    SystValue<double> getMassExcessUncertainty() const { return massExcessUncertainty; }
    SystValue<double> getBindingEnergyPerA() const { return bindingEnergyPerA; }
    SystValue<double> getBindingEnergyPerAUncertainty() const { return bindingEnergyPerAUncertainty; }
    bool getbetaDecayBMinus() const { return betaDecayBMinus; }
    std::optional<SystValue<double>> getBetaDecayEnergy() const { return betaDecayEnergy; }
    std::optional<SystValue<double>> getBetaDecayEnergyUncertainty() const { return betaDecayEnergyUncertainty; }
    SystValue<double> getAtomicMassMicroU() const { return atomicMassMicroU; }
    SystValue<double> getAtomicMassUncertaintyMicroU() const { return atomicMassUncertaintyMicroU; }

    // Метод toString()
    std::string toString() const
    {
        std::string elementName = "UNKNOWN";
        if (z >= 0 && z < static_cast<int>(ElementEnum::UNKNOWN))
        {
            elementName = ElementEnumToString(static_cast<ElementEnum>(z));
        }
        std::string result = "A=" + std::to_string(a) +
                             ", Z=" + std::to_string(z) +
                             ", El=" + elementName +
                             std::to_string(massExcess.getValue()) +
                             std::to_string(atomicMassMicroU.getValue());

        return result;
    }
};