enum NuclideStateTypeEnum {
  ///  Основное состояние
  /// The lowest energy state of a nuclide (i=0 in NUBASE notation)
  GROUND_STATE,

  /// Неоднозначные случаи, зависящие от контекста
  /// Metastable excited states including:
  /// Explicit isomers (i=1,2 or s=m,n in NUBASE)
  /// Context-dependent isomers (i=3,4,5,6 or s=p,q,r,x when nuclide has multiple isomers)
  ISOMER,

  /// Дискретные возбужденные состояния ядер
  /// Discrete excited nuclear states that:
  /// Are not long-lived enough to be considered isomers
  /// Typically marked with i=3,4 or s=p,q in NUBASE
  /// Represent bound quantum states of the nucleus
  LEVEL,

  /// Кратковременные несвязанные состояния
  /// Short-lived unbound states that:
  /// Are marked with i=5 or s=r in NUBASE
  /// Appear as peaks in nuclear reaction cross-sections
  /// Have energies above particle emission thresholds
  RESONANCE,

  /// Явные изобар-аналоговые состояния
  /// (IAS) - Explicit Isobaric Analog States - IAS that:
  /// Are marked with i=8,9 or s=i,j in NUBASE
  /// Result from isospin symmetry in nuclei
  /// Have same structure as ground state of isobaric neighbor
  ISOBARIC_ANALOG_STATE,

  /// Для любых других случаев
  /// Any states that don't match the above criteria
  UNKNOWN,
}
