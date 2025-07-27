#include <string>
#include "SystValue.h"
#include "NuclideStateTypeEnum.h"

class NubaseEntry
{
private:
    int a;
    int z;
    std::string s;
    int isomerIndexChar;
    SystValue<std::optional<double>> massExcess;
    SystValue<std::optional<double>> massExcessUncertainty;
    SystValue<std::optional<double>> excitationEnergy;
    SystValue<std::optional<double>> excitationEnergyUncertainty;
    std::string origin;
    bool stbl;
    bool pUnst;
    std::string halfLife;
    bool isHalfLifeSystematic;
    std::string halfLifeUnit;
    std::string halfLifeUncertainty;
    std::string spinParity;
    std::string spinParitySource;
    std::string isospin;
    std::string ensdfYear;
    std::string discoveryYear;
    std::string decayModes;
    NuclideStateTypeEnum stateType = NuclideStateTypeEnum::UNKNOWN;

public:
    NubaseEntry(
        int a, int z,
        const std::string &s,
        const int &isomerIndexChar,
        NuclideStateTypeEnum stateType,
        const SystValue<std::optional<double>> &massExcess,
        const SystValue<std::optional<double>> &massExcessUncertainty,
        const SystValue<std::optional<double>> &excitationEnergy,
        const SystValue<std::optional<double>> &excitationEnergyUncertainty,
        const std::string &origin,
        bool stbl,
        bool pUnst,
        const std::string &halfLife,
        bool isHalfLifeSystematic,
        const std::string &halfLifeUnit,
        const std::string &halfLifeUncertainty,
        const std::string &spinParity,
        const std::string &spinParitySource,
        const std::string &isospin,
        const std::string &ensdfYear,
        const std::string &discoveryYear,
        const std::string &decayModes) : a(a), z(z), s(s), isomerIndexChar(isomerIndexChar), stateType(stateType),
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
    std::string getS() const { return s; }
    int getIsomerIndexChar() const { return isomerIndexChar; }
    SystValue<std::optional<double>> getMassExcess() const { return massExcess; }
    SystValue<std::optional<double>> getMassExcessUncertainty() const { return massExcessUncertainty; }
    SystValue<std::optional<double>> getExcitationEnergy() const { return excitationEnergy; }
    SystValue<std::optional<double>> getExcitationEnergyUncertainty() const { return excitationEnergyUncertainty; }
    std::string getOrigin() const { return origin; }
    bool isStbl() const { return stbl; }
    bool isPUnst() const { return pUnst; }
    std::string getHalfLife() const { return halfLife; }
    bool getIsHalfLifeSystematic() const { return isHalfLifeSystematic; }
    std::string getHalfLifeUnit() const { return halfLifeUnit; }
    std::string getHalfLifeUncertainty() const { return halfLifeUncertainty; }
    std::string getSpinParity() const { return spinParity; }
    std::string getSpinParitySource() const { return spinParitySource; }
    std::string getIsospin() const { return isospin; }
    std::string getEnsdfYear() const { return ensdfYear; }
    std::string getDiscoveryYear() const { return discoveryYear; }
    std::string getDecayModes() const { return decayModes; }
    NuclideStateTypeEnum getStateType() const { return stateType; }

    // Уникальный ключ для поиска данных из AME/RCT
    std::string getAmeKey() const
    {
        return std::to_string(a) + "-" + std::to_string(z);
    }
};