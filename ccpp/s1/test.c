#include <stdio.h>
#include <stdlib.h>
#include "cntlower.h"
#include "mergesort.h"
#include "swapt.h"
#include "strfind.h"

void main() {
  printf("%d\n\n", cntlower("Hello, world!"));

  int a[] = {1,3,2,-6,18,-5,-3,3};
  size_t n = sizeof(a) / sizeof(a[0]);
  mergeSort(a, n);
  size_t i;
  for (i = 0; i < n; i++)
    printf("%d ", a[i]);
  printf("\n");

  int c = 6, d = 2;
  SWAP(int, c, d);
  printf("%d %d\n", c, d);

  int p[] = {0,1,2,3,4,5,6};
  int *q = p;
  q += 5;
  printf("%d\n", q[-2]);

  printf("%s\n", strfind("or", "Hello, world!"));

  return;
}
