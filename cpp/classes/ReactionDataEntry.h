#include <memory>
#include "SystValue.h"

class ReactionDataEntry
{
private:
    const int z;
    const int a;

    const SystValue<std::optional<double>> s2n;
    const SystValue<std::optional<double>> s2nUncertainty;
    const SystValue<std::optional<double>> s2p;
    const SystValue<std::optional<double>> s2pUncertainty;
    const SystValue<std::optional<double>> qa;
    const SystValue<std::optional<double>> qaUncertainty;
    const SystValue<std::optional<double>> q2b;
    const SystValue<std::optional<double>> q2bUncertainty;
    const SystValue<std::optional<double>> qep;
    const SystValue<std::optional<double>> qepUncertainty;
    const SystValue<std::optional<double>> qbn;
    const SystValue<std::optional<double>> qbnUncertainty;

    const SystValue<std::optional<double>> sn;
    const SystValue<std::optional<double>> snUncertainty;
    const SystValue<std::optional<double>> sp;
    const SystValue<std::optional<double>> spUncertainty;
    const SystValue<std::optional<double>> q4b;
    const SystValue<std::optional<double>> q4bUncertainty;
    const SystValue<std::optional<double>> qda;
    const SystValue<std::optional<double>> qdaUncertainty;
    const SystValue<std::optional<double>> qpa;
    const SystValue<std::optional<double>> qpaUncertainty;
    const SystValue<std::optional<double>> qna;
    const SystValue<std::optional<double>> qnaUncertainty;

public:
    constexpr ReactionDataEntry(
        int z, int a,
        const SystValue<std::optional<double>> &s2n,
        const SystValue<std::optional<double>> &s2nUncertainty,
        const SystValue<std::optional<double>> &s2p,
        const SystValue<std::optional<double>> &s2pUncertainty,
        const SystValue<std::optional<double>> &qa,
        const SystValue<std::optional<double>> &qaUncertainty,
        const SystValue<std::optional<double>> &q2b,
        const SystValue<std::optional<double>> &q2bUncertainty,
        const SystValue<std::optional<double>> &qep,
        const SystValue<std::optional<double>> &qepUncertainty,
        const SystValue<std::optional<double>> &qbn,
        const SystValue<std::optional<double>> &qbnUncertainty,
        const SystValue<std::optional<double>> &sn,
        const SystValue<std::optional<double>> &snUncertainty,
        const SystValue<std::optional<double>> &sp,
        const SystValue<std::optional<double>> &spUncertainty,
        const SystValue<std::optional<double>> &q4b,
        const SystValue<std::optional<double>> &q4bUncertainty,
        const SystValue<std::optional<double>> &qda,
        const SystValue<std::optional<double>> &qdaUncertainty,
        const SystValue<std::optional<double>> &qpa,
        const SystValue<std::optional<double>> &qpaUncertainty,
        const SystValue<std::optional<double>> &qna,
        const SystValue<std::optional<double>> &qnaUncertainty) : z(z), a(a),
                                                                  s2n(s2n), s2nUncertainty(s2nUncertainty),
                                                                  s2p(s2p), s2pUncertainty(s2pUncertainty),
                                                                  qa(qa), qaUncertainty(qaUncertainty),
                                                                  q2b(q2b), q2bUncertainty(q2bUncertainty),
                                                                  qep(qep), qepUncertainty(qepUncertainty),
                                                                  qbn(qbn), qbnUncertainty(qbnUncertainty),
                                                                  sn(sn), snUncertainty(snUncertainty),
                                                                  sp(sp), spUncertainty(spUncertainty),
                                                                  q4b(q4b), q4bUncertainty(q4bUncertainty),
                                                                  qda(qda), qdaUncertainty(qdaUncertainty),
                                                                  qpa(qpa), qpaUncertainty(qpaUncertainty),
                                                                  qna(qna), qnaUncertainty(qnaUncertainty) {}

    int getZ() const { return z; }
    int getA() const { return a; }

    SystValue<std::optional<double>> gets2n() const { return s2n; };
    SystValue<std::optional<double>> gets2nUncertainty() const { return s2nUncertainty; };
    SystValue<std::optional<double>> gets2p() const { return s2p; };
    SystValue<std::optional<double>> gets2pUncertainty() const { return s2pUncertainty; };
    SystValue<std::optional<double>> getqa() const { return qa; };
    SystValue<std::optional<double>> getqaUncertainty() const { return qaUncertainty; };
    SystValue<std::optional<double>> getq2b() const { return q2b; };
    SystValue<std::optional<double>> getq2bUncertainty() const { return q2bUncertainty; };
    SystValue<std::optional<double>> getqep() const { return qep; };
    SystValue<std::optional<double>> getqepUncertainty() const { return qepUncertainty; };
    SystValue<std::optional<double>> getqbn() const { return qbn; };
    SystValue<std::optional<double>> getqbnUncertainty() const { return qbnUncertainty; };

    SystValue<std::optional<double>> getsn() const { return sn; };
    SystValue<std::optional<double>> getsnUncertainty() const { return snUncertainty; };
    SystValue<std::optional<double>> getsp() const { return sp; };
    SystValue<std::optional<double>> getspUncertainty() const { return spUncertainty; };
    SystValue<std::optional<double>> getq4b() const { return q4b; };
    SystValue<std::optional<double>> getq4bUncertainty() const { return q4bUncertainty; };
    SystValue<std::optional<double>> getqda() const { return qda; };
    SystValue<std::optional<double>> getqdaUncertainty() const { return qdaUncertainty; };
    SystValue<std::optional<double>> getqpa() const { return qpa; };
    SystValue<std::optional<double>> getqpaUncertainty() const { return qpaUncertainty; };
    SystValue<std::optional<double>> getqna() const { return qna; };
    SystValue<std::optional<double>> getqnaUncertainty() const { return qnaUncertainty; };
};