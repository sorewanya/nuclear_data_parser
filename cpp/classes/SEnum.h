#include "enumMacros.h"
#include <string>
#include <map>

// Enum для хранения значений s из nubase
enum class SEnum
{
    m,
    n,
    p,
    q,
    r,
    i,
    j,
    x,
    UNKNOWN,
};

DECLARE_ENUM(SEnum, m, n, p, q, r, i, j, x, UNKNOWN)
