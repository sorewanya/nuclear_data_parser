import 'syst_value.dart';

/// Класс для хранения данных о реакциях и энергиях разделения из файлов rct.
///
///Q-значения — энергия, выделяемая/поглощаемая в ядерной реакции.
///   Символы в скобках (например, (d,α)) обозначают тип реакции:
///   Первая частица — захватываемая (d, p, n),
///   Вторая — испускаемая (α).
class ReactionDataEntry {
  final int z;
  final int a;

  /// from rct1.mas20.txt
  /// S(2n)	S₂ₙ	Энергия разделения двух нейтронов (Two-neutron separation energy)
  /// S(2p)	S₂ₚ	Энергия разделения двух протонов (Two-proton separation energy)
  /// Q(a)	Qₐ	Q-значение α-распада (Q-value for α-decay)
  /// Q(2B-)	Q₂ᵦ⁻	Q-значение двойного β⁻-распада (Q-value for double β⁻ decay)
  /// Q(ep)	Qₑₚ	Q-значение электронного захвата с испусканием протона (ϵp capture Q-value)
  /// Q(B- n)	Qᵦ⁻ₙ	Q-значение β⁻-запаздывающего нейтронного распада (β⁻-delayed neutron emission)
  SystValue<double?>? s2n;
  SystValue<double?>? s2nUncertainty;
  SystValue<double?>? s2p;
  SystValue<double?>? s2pUncertainty;
  SystValue<double?>? qa;
  SystValue<double?>? qaUncertainty;
  SystValue<double?>? q2b;
  SystValue<double?>? q2bUncertainty;
  SystValue<double?>? qep;
  SystValue<double?>? qepUncertainty;
  SystValue<double?>? qbn;
  SystValue<double?>? qbnUncertainty;

  /// from rct2_1.mas20.txt
  /// S(n)	Sₙ	Энергия разделения одного нейтрона (One-neutron separation energy)
  /// S(p)	Sₚ	Энергия разделения одного протона (One-proton separation energy)
  /// Q(4B-)	Q₄ᵦ⁻	Q-значение четверного β⁻-распада (Q-value for quadruple β⁻ decay)
  /// Q(d,a)	Q(d,α)	Q-значение реакции (d,α) — дейтронного захвата с испусканием α-частицы
  /// Q(p,a)	Q(p,α)	Q-значение реакции (p,α) — протонного захвата с испусканием α-частицы
  /// Q(n,a)	Q(n,α)	Q-значение реакции (n,α) — нейтронного захвата с испусканием α-частицы
  SystValue<double?>? sn;
  SystValue<double?>? snUncertainty;
  SystValue<double?>? sp;
  SystValue<double?>? spUncertainty;
  SystValue<double?>? q4b;
  SystValue<double?>? q4bUncertainty;
  SystValue<double?>? qda;
  SystValue<double?>? qdaUncertainty;
  SystValue<double?>? qpa;
  SystValue<double?>? qpaUncertainty;
  SystValue<double?>? qna;
  SystValue<double?>? qnaUncertainty;

  ReactionDataEntry({required this.z, required this.a});
  ReactionDataEntry.required(
    this.z,
    this.a,
    this.s2n,
    this.s2nUncertainty,
    this.s2p,
    this.s2pUncertainty,
    this.qa,
    this.qaUncertainty,
    this.q2b,
    this.q2bUncertainty,
    this.qep,
    this.qepUncertainty,
    this.qbn,
    this.qbnUncertainty,
    this.sn,
    this.snUncertainty,
    this.sp,
    this.spUncertainty,
    this.q4b,
    this.q4bUncertainty,
    this.qda,
    this.qdaUncertainty,
    this.qpa,
    this.qpaUncertainty,
    this.qna,
    this.qnaUncertainty,
  );
}
