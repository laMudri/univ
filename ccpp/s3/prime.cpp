template<unsigned int M, unsigned int N> struct primeFrom {
  static const bool v = N % M != 0 && primeFrom<M - 1, N>::v;
};
template<> template<unsigned int N> struct primeFrom<1, N> {
  static const bool v = true;
};

template<unsigned int N> struct prime {
  static const bool v = primeFrom<N - 1, N>::v;
};
template<> struct prime<0> {
  static const bool v = false;
};
template<> struct prime<1> {
  static const bool v = false;
};
