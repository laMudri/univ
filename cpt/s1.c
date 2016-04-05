#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>

typedef size_t Label;
typedef size_t Register;

typedef enum { SUCC, PRED, HALT } InstrType;
typedef struct { Register r; Label l; } Succ;
typedef struct { Register r; Label s; Label z; } Pred;
typedef int Halt;  // Dummy data

typedef struct {
  InstrType type;
  union { Pred pred; Succ succ; Halt halt; } data;
} Instr;

typedef Instr* Program;

typedef unsigned int Datum;
typedef Datum* Data;

// Variable parts of a running machine
typedef struct {
  Label pc;
  Data data;
} Config;

// Modify the value at c as specified,
// and return whether there are more steps to do.
bool step(Program p, Config *c) {
  Instr i = p[c->pc];
  switch (i.type) {
    case SUCC:
      c->data[i.data.succ.r]++;
      c->pc = i.data.succ.l;
      return true;
    case PRED:
      if (c->data[i.data.pred.r] > 0) {
        c->data[i.data.pred.r]--;
        c->pc = i.data.pred.s;
      }
      else {
        c->pc = i.data.pred.z;
      }
      return true;
    case HALT:
      return false;
  }
}

void eval(Program p, Config *c) {
  while (step(p, c));
}

int main() {
  // Machine configuration section
  Instr p[] = {
    {PRED, {1, 1, 3}},
    {PRED, {1, 0, 2}},
    {SUCC, {0, 3}},
    {HALT, 0}
  };
  Datum data[] = {0, 5};
  // Machine configuration section ends

  Config c = {
    .pc = 0,
    .data = data
  };
  Config *cp = &c;
  eval(p, cp);
  printf("%d\n", cp->data[0]);
  return 0;
}
