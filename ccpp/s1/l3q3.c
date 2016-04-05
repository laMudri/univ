#include <stdio.h>
#include <stdlib.h>

struct t { int *i; };

void main() {
  struct t *p = malloc(sizeof(struct t) * 3);
  int x[] = {2,-2,7};
  p[0].i = &x[2];
  p[1].i = &x[1];
  p[2].i = &x[0];
  // Increment p->i before printing it
  printf("%d\n", ++p->i);
  // Print out the same thing, then increment p
  printf("%d\n", p++->i);
  // Print the value p->i points to (x[1])
  printf("%d\n", *p->i);
  // Print the same thing, then increment p->i again
  printf("%d\n", *p->i++);
  // Print the next i value (x[2]), then increment p again
  printf("%d\n", *p++->i);
  // p->i now points to x[0]. Print that, then increment whatever is there
  printf("%d\n", (*p->i)++);
}
