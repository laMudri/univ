#include <stdlib.h>
typedef struct tree { int x; struct tree *l; struct tree *r; } tree;
tree *heapify(int *xs, size_t n);
