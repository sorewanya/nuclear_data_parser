#include <string>
#include "SystValue.h"
#include "NuclideStateTypeEnum.h"

class NubaseEntry
{
private:
    const int a;
    const int z;
    const std::string_view s;
    const int isomerIndexChar;
    const std::optional<SystValue<double>> massExcess;
    const std::optional<SystValue<double>> massExcessUncertainty;
    const std::optional<SystValue<double>> excitationEnergy;
    const std::optional<SystValue<double>> excitationEnergyUncertainty;
    const std::string_view origin;
    const bool stbl;
    const bool pUnst;
    const std::string_view halfLife;
    const bool isHalfLifeSystematic;
    const std::string_view halfLifeUnit;
    const std::string_view halfLifeUncertainty;
    const std::string_view spinParity;
    const std::string_view spinParitySource;
    const std::string_view isospin;
    const std::string_view ensdfYear;
    const std::string_view discoveryYear;
    const std::string_view decayModes;
    const NuclideStateTypeEnum stateType = NuclideStateTypeEnum::UNKNOWN;

public:
    constexpr NubaseEntry(
        const int a, int z,
        const std::string_view &s,
        const int &isomerIndexChar,
        const NuclideStateTypeEnum stateType,
        const std::optional<SystValue<double>> &massExcess,
        const std::optional<SystValue<double>> &massExcessUncertainty,
        const std::optional<SystValue<double>> &excitationEnergy,
        const std::optional<SystValue<double>> &excitationEnergyUncertainty,
        const std::string_view &origin,
        const bool stbl,
        const bool pUnst,
        const std::string_view &halfLife,
        const bool isHalfLifeSystematic,
        const std::string_view &halfLifeUnit,
        const std::string_view &halfLifeUncertainty,
        const std::string_view &spinParity,
        const std::string_view &spinParitySource,
        const std::string_view &isospin,
        const std::string_view &ensdfYear,
        const std::string_view &discoveryYear,
        const std::string_view &decayModes) noexcept : a(a), z(z), s(s), isomerIndexChar(isomerIndexChar), stateType(stateType),
                                                       massExcess(massExcess), massExcessUncertainty(massExcessUncertainty),
                                                       excitationEnergy(excitationEnergy), excitationEnergyUncertainty(excitationEnergyUncertainty),
                                                       origin(origin), stbl(stbl), pUnst(pUnst), halfLife(halfLife),
                                                       isHalfLifeSystematic(isHalfLifeSystematic), halfLifeUnit(halfLifeUnit),
                                                       halfLifeUncertainty(halfLifeUncertainty), spinParity(spinParity),
                                                       spinParitySource(spinParitySource), isospin(isospin), ensdfYear(ensdfYear),
                                                       discoveryYear(discoveryYear), decayModes(decayModes) {}

    // Геттеры
    int getA() const { return a; }
    int getZ() const { return z; }
    std::string_view getS() const { return s; }
    int getIsomerIndexChar() const { return isomerIndexChar; }
    std::optional<SystValue<double>> getMassExcess() const { return massExcess; }
    std::optional<SystValue<double>> getMassExcessUncertainty() const { return massExcessUncertainty; }
    std::optional<SystValue<double>> getExcitationEnergy() const { return excitationEnergy; }
    std::optional<SystValue<double>> getExcitationEnergyUncertainty() const { return excitationEnergyUncertainty; }
    std::string_view getOrigin() const { return origin; }
    bool isStbl() const { return stbl; }
    bool isPUnst() const { return pUnst; }
    std::string_view getHalfLife() const { return halfLife; }
    bool getIsHalfLifeSystematic() const { return isHalfLifeSystematic; }
    std::string_view getHalfLifeUnit() const { return halfLifeUnit; }
    std::string_view getHalfLifeUncertainty() const { return halfLifeUncertainty; }
    std::string_view getSpinParity() const { return spinParity; }
    std::string_view getSpinParitySource() const { return spinParitySource; }
    std::string_view getIsospin() const { return isospin; }
    std::string_view getEnsdfYear() const { return ensdfYear; }
    std::string_view getDiscoveryYear() const { return discoveryYear; }
    std::string_view getDecayModes() const { return decayModes; }
    NuclideStateTypeEnum getStateType() const { return stateType; }

    // Уникальный ключ для поиска данных из AME/RCT
    std::string getAmeKey() const
    {
        return std::to_string(a) + "-" + std::to_string(z);
    }
};