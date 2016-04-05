#include <string.h>
#include <ctype.h>

int cntlower(char str[]) {
  int r = 0;
  size_t i;
  for (i = 0; str[i]; i++)
    if (islower(str[i]))
      r++;
  return r;
}
