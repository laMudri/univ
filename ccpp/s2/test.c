#include <stdio.h>
#include "heap.h"
#include "dll.h"

void printTree(tree *t) {
  if (t) {
    printf("<");
    printTree(t->l);
    printf(" %d ", t->x);
    printTree(t->r);
    printf(">");
  }
}

void main() {
  int items[] = {4,-2,5,92,-5,-2,8};
  tree *heap = heapify(items, sizeof(items) / sizeof(items[0]));
  printTree(heap);
  printf("\n");

  xorCell *c = fromArray(items, sizeof(items) / sizeof(items[0]));
  xorCell *d = insert(6, NULL, c);
  printXorList(d);
}
