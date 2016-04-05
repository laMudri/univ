#include <stdio.h>
#include "swap.h"

int main() {
  int a = 6, b = 2;
  SWAP(a, b);
  printf("%d %d\n", a, b);
  return 0;
}
