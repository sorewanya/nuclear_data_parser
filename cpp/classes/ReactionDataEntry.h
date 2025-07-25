#include <memory>
#include "ParsedValue.h"

class ReactionDataEntry
{
private:
    int z;
    int a;

    ParsedValue<std::optional<double>> s2n;
    ParsedValue<std::optional<double>> s2nUncertainty;
    ParsedValue<std::optional<double>> s2p;
    ParsedValue<std::optional<double>> s2pUncertainty;
    ParsedValue<std::optional<double>> qa;
    ParsedValue<std::optional<double>> qaUncertainty;
    ParsedValue<std::optional<double>> q2b;
    ParsedValue<std::optional<double>> q2bUncertainty;
    ParsedValue<std::optional<double>> qep;
    ParsedValue<std::optional<double>> qepUncertainty;
    ParsedValue<std::optional<double>> qbn;
    ParsedValue<std::optional<double>> qbnUncertainty;

    ParsedValue<std::optional<double>> sn;
    ParsedValue<std::optional<double>> snUncertainty;
    ParsedValue<std::optional<double>> sp;
    ParsedValue<std::optional<double>> spUncertainty;
    ParsedValue<std::optional<double>> q4b;
    ParsedValue<std::optional<double>> q4bUncertainty;
    ParsedValue<std::optional<double>> qda;
    ParsedValue<std::optional<double>> qdaUncertainty;
    ParsedValue<std::optional<double>> qpa;
    ParsedValue<std::optional<double>> qpaUncertainty;
    ParsedValue<std::optional<double>> qna;
    ParsedValue<std::optional<double>> qnaUncertainty;

public:
    ReactionDataEntry(
        int z, int a,
        const ParsedValue<std::optional<double>> &s2n,
        const ParsedValue<std::optional<double>> &s2nUncertainty,
        const ParsedValue<std::optional<double>> &s2p,
        const ParsedValue<std::optional<double>> &s2pUncertainty,
        const ParsedValue<std::optional<double>> &qa,
        const ParsedValue<std::optional<double>> &qaUncertainty,
        const ParsedValue<std::optional<double>> &q2b,
        const ParsedValue<std::optional<double>> &q2bUncertainty,
        const ParsedValue<std::optional<double>> &qep,
        const ParsedValue<std::optional<double>> &qepUncertainty,
        const ParsedValue<std::optional<double>> &qbn,
        const ParsedValue<std::optional<double>> &qbnUncertainty,
        const ParsedValue<std::optional<double>> &sn,
        const ParsedValue<std::optional<double>> &snUncertainty,
        const ParsedValue<std::optional<double>> &sp,
        const ParsedValue<std::optional<double>> &spUncertainty,
        const ParsedValue<std::optional<double>> &q4b,
        const ParsedValue<std::optional<double>> &q4bUncertainty,
        const ParsedValue<std::optional<double>> &qda,
        const ParsedValue<std::optional<double>> &qdaUncertainty,
        const ParsedValue<std::optional<double>> &qpa,
        const ParsedValue<std::optional<double>> &qpaUncertainty,
        const ParsedValue<std::optional<double>> &qna,
        const ParsedValue<std::optional<double>> &qnaUncertainty) : z(z), a(a),
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

    ParsedValue<std::optional<double>> gets2n() const { return s2n; };
    ParsedValue<std::optional<double>> gets2nUncertainty() const { return s2nUncertainty; };
    ParsedValue<std::optional<double>> gets2p() const { return s2p; };
    ParsedValue<std::optional<double>> gets2pUncertainty() const { return s2pUncertainty; };
    ParsedValue<std::optional<double>> getqa() const { return qa; };
    ParsedValue<std::optional<double>> getqaUncertainty() const { return qaUncertainty; };
    ParsedValue<std::optional<double>> getq2b() const { return q2b; };
    ParsedValue<std::optional<double>> getq2bUncertainty() const { return q2bUncertainty; };
    ParsedValue<std::optional<double>> getqep() const { return qep; };
    ParsedValue<std::optional<double>> getqepUncertainty() const { return qepUncertainty; };
    ParsedValue<std::optional<double>> getqbn() const { return qbn; };
    ParsedValue<std::optional<double>> getqbnUncertainty() const { return qbnUncertainty; };

    ParsedValue<std::optional<double>> getsn() const { return sn; };
    ParsedValue<std::optional<double>> getsnUncertainty() const { return snUncertainty; };
    ParsedValue<std::optional<double>> getsp() const { return sp; };
    ParsedValue<std::optional<double>> getspUncertainty() const { return spUncertainty; };
    ParsedValue<std::optional<double>> getq4b() const { return q4b; };
    ParsedValue<std::optional<double>> getq4bUncertainty() const { return q4bUncertainty; };
    ParsedValue<std::optional<double>> getqda() const { return qda; };
    ParsedValue<std::optional<double>> getqdaUncertainty() const { return qdaUncertainty; };
    ParsedValue<std::optional<double>> getqpa() const { return qpa; };
    ParsedValue<std::optional<double>> getqpaUncertainty() const { return qpaUncertainty; };
    ParsedValue<std::optional<double>> getqna() const { return qna; };
    ParsedValue<std::optional<double>> getqnaUncertainty() const { return qnaUncertainty; };
};