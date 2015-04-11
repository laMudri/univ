#include <stdio.h>
#include <stdint.h>

#define NUM(N,V) uint32_t N = V
#define XSTR(X) STR(X)
#define STR(X) #X

void print_reprs(const char *lbl, const char *decl, uint32_t v) {
  float f = *(float *) &v;

  printf(lbl);
  printf(": ");
  printf(decl);
  printf("\n");
  printf("unsigned %30u\n", v);
  printf("signed   %30d\n", (int32_t) v);
  printf("float    %30f\n", f);
  printf("\n\n");
}

int main() {
  #define A NUM(a,0x00000000)
  A;
  print_reprs("A",XSTR(A),a);

  #define B NUM(b,0x95000001)
  B;
  print_reprs("B",XSTR(B),b);

  #define C NUM(c,0xD5000001)
  C;
  print_reprs("C",XSTR(C),c);

  #define D NUM(d,0xC0111100)
  D;
  print_reprs("D",XSTR(D),d);

  #define E NUM(e,0x60000000)
  E;
  print_reprs("E",XSTR(E),e);

  #define F NUM(f,0x40400000)
  F;
  print_reprs("F",XSTR(F),f);
  
  return 0;
}
