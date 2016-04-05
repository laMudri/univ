typedef struct xorCell { int val; struct xorCell *p; } xorCell;
xorCell *fromArray(int *a, size_t n);
xorCell *insert(int val, xorCell *before, xorCell *after);
void printXorList(xorCell *c);
