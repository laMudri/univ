#include <stdlib.h>
#include <stdio.h>

typedef struct tree { int x; struct tree *l; struct tree *r; } tree;

tree *insert(int x, tree *t) {
  if (t) {
    int passedx;
    if (x <= t->x) {
      passedx = t->x;
      t->x = x;
    }
    else {
      passedx = x;
    }

    if (t->l)
      if (t->r)
        if (t->l->x <= t->r->x)
          t->r = insert(passedx, t->r);
        else
          t->l = insert(passedx, t->l);
      else
        t->r = insert(passedx, t->r);
    else
      t->l = insert(passedx, t->l);

    return t;
  }
  else {
    tree *newt = malloc(sizeof(tree));
    newt->x = x;
    newt->l = NULL;
    newt->r = NULL;
    return newt;
  }
}

tree *heapify_inner(int *xs, size_t n, tree *t) {
  if (n-- == 0) return t;
  t = insert(xs++[0], t);
  return heapify_inner(xs, n, t);
}

tree *heapify(int *xs, size_t n) {
  return heapify_inner(xs, n, NULL);
}
