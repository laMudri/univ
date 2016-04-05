#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <errno.h>

struct stack { long x; struct stack *xs; };

union result { char *error; struct stack *r; };
typedef struct { bool success; union result val; } result;

result success(struct stack *r) {
  result res;
  res.success = true;
  res.val.r = r;
  return res;
}

result failure(char *error) {
  result res;
  res.success = false;
  res.val.error = error;
  return res;
}

result eval(struct stack *s, char *tokens[], size_t n) {
  if (n-- == 0) return success(s);
  char *token = (tokens++)[0];
  if (strcmp(token, "+") == 0) {
    if (s && s->xs) {
      long y = s->x;
      long x = s->xs->x;
      struct stack *news = malloc(sizeof(struct stack));
      news->x = x + y;
      news->xs = s->xs->xs;
      return eval(news, tokens, n);
    }
    else
      return failure("Not enough arguments to `+`");
  }
  else if (strcmp(token, "*") == 0) {
    if (s && s->xs) {
      long y = s->x;
      long x = s->xs->x;
      struct stack *news = malloc(sizeof(struct stack));
      news->x = x * y;
      news->xs = s->xs->xs;
      return eval(news, tokens, n);
    }
    else
      return failure("Not enough arguments to `*`");
  }
  else {
    char *end;
    long x = strtol(token, &end, 0);
    if (token == end) return failure("Malformed token");
    if (errno) {
      errno = 0;
      return failure("Malformed token");
    }
    struct stack *news = malloc(sizeof(struct stack));
    news->x = x;
    news->xs = s;
    return eval(news, tokens, n);
  }
}

int main(int argc, char *argv[]) {
  struct stack *s = NULL;
  //int i;
  //for (i = 0; i < argc; i++)
  //  printf("%d,", *argv[i]);
  result r = eval(s, argv + 1, argc - 1);
  if (r.success)
    if (r.val.r && !r.val.r->xs) {
      printf("%d\n", r.val.r->x);
      return 0;
    }
    else {
      printf("%s\n", "Not exactly one element left on the stack");
      return 1;
    }
  else {
    printf("%s\n", r.val.error);
    return 1;
  }
}
