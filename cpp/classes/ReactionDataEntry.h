#include <memory>
#include "SystValue.h"

class ReactionDataEntry
{
private:
    const int z;
    const int a;

    const std::optional<SystValue<double>> s2n;
    const std::optional<SystValue<double>> s2nUncertainty;
    const std::optional<SystValue<double>> s2p;
    const std::optional<SystValue<double>> s2pUncertainty;
    const std::optional<SystValue<double>> qa;
    const std::optional<SystValue<double>> qaUncertainty;
    const std::optional<SystValue<double>> q2b;
    const std::optional<SystValue<double>> q2bUncertainty;
    const std::optional<SystValue<double>> qep;
    const std::optional<SystValue<double>> qepUncertainty;
    const std::optional<SystValue<double>> qbn;
    const std::optional<SystValue<double>> qbnUncertainty;

    const std::optional<SystValue<double>> sn;
    const std::optional<SystValue<double>> snUncertainty;
    const std::optional<SystValue<double>> sp;
    const std::optional<SystValue<double>> spUncertainty;
    const std::optional<SystValue<double>> q4b;
    const std::optional<SystValue<double>> q4bUncertainty;
    const std::optional<SystValue<double>> qda;
    const std::optional<SystValue<double>> qdaUncertainty;
    const std::optional<SystValue<double>> qpa;
    const std::optional<SystValue<double>> qpaUncertainty;
    const std::optional<SystValue<double>> qna;
    const std::optional<SystValue<double>> qnaUncertainty;

public:
    constexpr ReactionDataEntry(
        int z, int a,
        const std::optional<SystValue<double>> &s2n,
        const std::optional<SystValue<double>> &s2nUncertainty,
        const std::optional<SystValue<double>> &s2p,
        const std::optional<SystValue<double>> &s2pUncertainty,
        const std::optional<SystValue<double>> &qa,
        const std::optional<SystValue<double>> &qaUncertainty,
        const std::optional<SystValue<double>> &q2b,
        const std::optional<SystValue<double>> &q2bUncertainty,
        const std::optional<SystValue<double>> &qep,
        const std::optional<SystValue<double>> &qepUncertainty,
        const std::optional<SystValue<double>> &qbn,
        const std::optional<SystValue<double>> &qbnUncertainty,
        const std::optional<SystValue<double>> &sn,
        const std::optional<SystValue<double>> &snUncertainty,
        const std::optional<SystValue<double>> &sp,
        const std::optional<SystValue<double>> &spUncertainty,
        const std::optional<SystValue<double>> &q4b,
        const std::optional<SystValue<double>> &q4bUncertainty,
        const std::optional<SystValue<double>> &qda,
        const std::optional<SystValue<double>> &qdaUncertainty,
        const std::optional<SystValue<double>> &qpa,
        const std::optional<SystValue<double>> &qpaUncertainty,
        const std::optional<SystValue<double>> &qna,
        const std::optional<SystValue<double>> &qnaUncertainty) : z(z), a(a),
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

    std::optional<SystValue<double>> gets2n() const { return s2n; };
    std::optional<SystValue<double>> gets2nUncertainty() const { return s2nUncertainty; };
    std::optional<SystValue<double>> gets2p() const { return s2p; };
    std::optional<SystValue<double>> gets2pUncertainty() const { return s2pUncertainty; };
    std::optional<SystValue<double>> getqa() const { return qa; };
    std::optional<SystValue<double>> getqaUncertainty() const { return qaUncertainty; };
    std::optional<SystValue<double>> getq2b() const { return q2b; };
    std::optional<SystValue<double>> getq2bUncertainty() const { return q2bUncertainty; };
    std::optional<SystValue<double>> getqep() const { return qep; };
    std::optional<SystValue<double>> getqepUncertainty() const { return qepUncertainty; };
    std::optional<SystValue<double>> getqbn() const { return qbn; };
    std::optional<SystValue<double>> getqbnUncertainty() const { return qbnUncertainty; };

    std::optional<SystValue<double>> getsn() const { return sn; };
    std::optional<SystValue<double>> getsnUncertainty() const { return snUncertainty; };
    std::optional<SystValue<double>> getsp() const { return sp; };
    std::optional<SystValue<double>> getspUncertainty() const { return spUncertainty; };
    std::optional<SystValue<double>> getq4b() const { return q4b; };
    std::optional<SystValue<double>> getq4bUncertainty() const { return q4bUncertainty; };
    std::optional<SystValue<double>> getqda() const { return qda; };
    std::optional<SystValue<double>> getqdaUncertainty() const { return qdaUncertainty; };
    std::optional<SystValue<double>> getqpa() const { return qpa; };
    std::optional<SystValue<double>> getqpaUncertainty() const { return qpaUncertainty; };
    std::optional<SystValue<double>> getqna() const { return qna; };
    std::optional<SystValue<double>> getqnaUncertainty() const { return qnaUncertainty; };
};