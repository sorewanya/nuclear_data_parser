#include <string>
#include "SystValue.h"
#include "NuclideStateTypeEnum.h"
#include "Spin.h"

class NubaseEntry
{
private:
    const int a;
    const int z;
    const std::optional<std::string_view> s;
    const int isomerIndexChar;
    const std::optional<SystValue<double>> massExcess;
    const std::optional<SystValue<double>> massExcessUncertainty;
    const std::optional<SystValue<double>> excitationEnergy;
    const std::optional<SystValue<double>> excitationEnergyUncertainty;
    const std::optional<std::string_view> origin;
    const bool stbl;
    const bool pUnst;
    const std::optional<SystValue<std::string_view>> halfLife;
    const std::optional<std::string_view> halfLifeUnit;
    const std::optional<std::string_view> halfLifeUncertainty;
    const std::optional<Spin> spin;
    const std::optional<int> ensdfYear;
    const int discoveryYear;
    const std::optional<std::string_view> decayModes;
    const NuclideStateTypeEnum stateType = NuclideStateTypeEnum::UNKNOWN;

public:
    constexpr NubaseEntry(
        const int a, int z,
        const std::optional<std::string_view> &s,
        const int &isomerIndexChar,
        const NuclideStateTypeEnum stateType,
        const std::optional<SystValue<double>> &massExcess,
        const std::optional<SystValue<double>> &massExcessUncertainty,
        const std::optional<SystValue<double>> &excitationEnergy,
        const std::optional<SystValue<double>> &excitationEnergyUncertainty,
        const std::optional<std::string_view> &origin,
        const bool stbl,
        const bool pUnst,
        const std::optional<SystValue<std::string_view>> &halfLife,
        const std::optional<std::string_view> &halfLifeUnit,
        const std::optional<std::string_view> &halfLifeUncertainty,
        const std::optional<Spin> &spin,
        const std::optional<int> &ensdfYear,
        const int &discoveryYear,
        const std::optional<std::string_view> &decayModes) noexcept : a(a), z(z), s(s), isomerIndexChar(isomerIndexChar), stateType(stateType),
                                                                      massExcess(massExcess), massExcessUncertainty(massExcessUncertainty),
                                                                      excitationEnergy(excitationEnergy), excitationEnergyUncertainty(excitationEnergyUncertainty),
                                                                      origin(origin), stbl(stbl), pUnst(pUnst), halfLife(halfLife),
                                                                      halfLifeUnit(halfLifeUnit),
                                                                      halfLifeUncertainty(halfLifeUncertainty), spin(spin), ensdfYear(ensdfYear),
                                                                      discoveryYear(discoveryYear), decayModes(decayModes) {}

    // Геттеры
    int getA() const { return a; }
    int getZ() const { return z; }
    std::optional<std::string_view> getS() const { return s; }
    int getIsomerIndexChar() const { return isomerIndexChar; }
    std::optional<SystValue<double>> getMassExcess() const { return massExcess; }
    std::optional<SystValue<double>> getMassExcessUncertainty() const { return massExcessUncertainty; }
    std::optional<SystValue<double>> getExcitationEnergy() const { return excitationEnergy; }
    std::optional<SystValue<double>> getExcitationEnergyUncertainty() const { return excitationEnergyUncertainty; }
    std::optional<std::string_view> getOrigin() const { return origin; }
    bool isStbl() const { return stbl; }
    bool isPUnst() const { return pUnst; }
    std::optional<SystValue<std::string_view>> getHalfLife() const { return halfLife; }
    std::optional<std::string_view> getHalfLifeUnit() const { return halfLifeUnit; }
    std::optional<std::string_view> getHalfLifeUncertainty() const { return halfLifeUncertainty; }
    std::optional<Spin> getSpin() const { return spin; }
    std::optional<int> getEnsdfYear() const { return ensdfYear; }
    int getDiscoveryYear() const { return discoveryYear; }
    std::optional<std::string_view> getDecayModes() const { return decayModes; }
    NuclideStateTypeEnum getStateType() const { return stateType; }

    // Уникальный ключ для поиска данных из AME/RCT
    std::string getAmeKey() const
    {
        return std::to_string(a) + "-" + std::to_string(z);
    }
};