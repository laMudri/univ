#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

void mergeTo(int a[], size_t an, int b[], size_t bn, int r[], size_t n) {
  size_t ai = 0, bi = 0, i = 0;
  bool aChosen;
  while (ai < an && bi < bn)
    if (aChosen = a[ai] <= b[bi])
      r[i++] = a[ai++];
    else
      r[i++] = b[bi++];

  if (aChosen)
    while (i < n)
      r[i++] = b[bi++];
  else
    while (i < n)
      r[i++] = a[ai++];
}

void mergeSortUsing(int a[], size_t n, int s[]) {
  if (n <= 1) return;
  size_t an = n / 2;
  size_t bn = n - an;
  int *b = a + an;
  mergeSortUsing(a, an, s);
  mergeSortUsing(b, bn, s);
  mergeTo(a, an, b, bn, s, n);

  size_t i;
  for (i = 0; i < n; i++)
    a[i] = s[i];
}

void mergeSort(int a[], size_t n) {
  int s[n];
  mergeSortUsing(a, n, s);
}

// The program uses sizeof(int) * n extra memory,
// all of which is allocated as `s` in `mergeSort`.
