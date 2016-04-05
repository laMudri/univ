#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

#define XOR(p,q) ((xorCell *)((uintptr_t)(p) ^ (uintptr_t)(q)))

typedef struct xorCell { int val; struct xorCell *p; } xorCell;

xorCell *fromCellAndArray(xorCell *c, int *a, size_t n) {
  printf("%d ", n);
  if (n-- == 0) return NULL;
  xorCell *newCell = malloc(sizeof(xorCell));
  newCell->val = a++[0];
  xorCell *rest = fromCellAndArray(newCell, a, n);
  newCell->p = XOR(c,rest);
  return newCell;
}

xorCell *fromArray(int *a, size_t n) {
  printf("here\n");
  return fromCellAndArray(NULL, a, n);
}

xorCell *insert(int val, xorCell *before, xorCell *after) {
  xorCell *newCell = malloc(sizeof(xorCell));
  newCell->val = val;
  newCell->p = XOR(before,after);

  if (before) {
    xorCell *beforePrev = XOR(before->p,after);
    before->p = XOR(beforePrev,newCell);
  }
  if (after) {
    xorCell *afterNext = XOR(after->p,before);
    after->p = XOR(afterNext,newCell);
  }

  return newCell;
}

void printFrom(xorCell *prev, xorCell *here) {
  if (here) {
    printf("%d ", here->val);
    xorCell *next = XOR(here->p,prev);
    printFrom(here, next);
  }
}

void printXorList(xorCell *c) { printFrom(NULL, c); }

// Ran out of time
