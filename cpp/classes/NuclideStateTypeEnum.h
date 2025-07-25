/**
 * @brief Представляет тип ядерного состояния на основе данных из Nubase2020
 * Classifies nuclear states from Nubase2020 data
 */
#include <string>
enum class NuclideStateTypeEnum
{
    /// @brief Основное состояние
    /// The lowest energy state of a nuclide (i=0 in NUBASE notation)
    GROUND_STATE,
    /// @brief Неоднозначные случаи, зависящие от контекста
    /// Metastable excited states including:
    /// Explicit isomers (i=1,2 or s=m,n in NUBASE)
    /// Context-dependent isomers (i=3,4,5,6 or s=p,q,r,x when nuclide has multiple isomers)
    ISOMER,
    /// @brief Дискретные возбужденные состояния ядер
    /// Discrete excited nuclear states that:
    /// Are not long-lived enough to be considered isomers
    /// Typically marked with i=3,4 or s=p,q in NUBASE
    /// Represent bound quantum states of the nucleus
    LEVEL,
    /// @brief Кратковременные несвязанные состояния
    /// Short-lived unbound states that:
    /// Are marked with i=5 or s=r in NUBASE
    /// Appear as peaks in nuclear reaction cross-sections
    /// Have energies above particle emission thresholds
    RESONANCE,
    /// @brief Явные изобар-аналоговые состояния
    /// (IAS) - Explicit Isobaric Analog States - IAS that:
    /// Are marked with i=8,9 or s=i,j in NUBASE
    /// Result from isospin symmetry in nuclei
    /// Have same structure as ground state of isobaric neighbor
    ISOBARIC_ANALOG_STATE,
    /// @brief Для любых других случаев
    /// Any states that don't match the above criteria
    UNKNOWN
};

NuclideStateTypeEnum StateTypeFromIndex(int index)
{
    switch (index)
    {
    case 0:
        return NuclideStateTypeEnum::GROUND_STATE;
    case 1:
        return NuclideStateTypeEnum::ISOMER;
    case 2:
        return NuclideStateTypeEnum::LEVEL;
    case 3:
        return NuclideStateTypeEnum::RESONANCE;
    case 4:
        return NuclideStateTypeEnum::ISOBARIC_ANALOG_STATE;
    case 5:
        return NuclideStateTypeEnum::UNKNOWN;
    }
}

// Вспомогательная функция для преобразования enum в строку для вывода
std::string StateTypeToString(NuclideStateTypeEnum type)
{
    switch (type)
    {
    case NuclideStateTypeEnum::GROUND_STATE:
        return "Ground State";
    case NuclideStateTypeEnum::ISOMER:
        return "Isomer";
    case NuclideStateTypeEnum::LEVEL:
        return "Level";
    case NuclideStateTypeEnum::RESONANCE:
        return "Resonance";
    case NuclideStateTypeEnum::ISOBARIC_ANALOG_STATE:
        return "Isobaric Analog States";
    default:
        return "Unknown";
    }
}