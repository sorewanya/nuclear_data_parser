enum SEnum {
  m,
  n,
  p,
  q,
  r,
  i,
  j,
  x,
  UNKNOWN;

  static SEnum fromString(String s) => switch (s) {
    "m" => SEnum.m,
    "n" => SEnum.n,
    "p" => SEnum.p,
    "q" => SEnum.q,
    "r" => SEnum.r,
    "i" => SEnum.i,
    "j" => SEnum.j,
    "x" => SEnum.x,

    _ => SEnum.UNKNOWN,
  };
}
