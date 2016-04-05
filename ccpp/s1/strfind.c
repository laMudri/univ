#include <string.h>

char *strfind(const char *s, const char *f) {
  size_t sn = strlen(s), fn = strlen(f);

  size_t n = sn - fn;
  size_t i, j;
  for (i = 0; i < n; i++) {
    for (j = 0; j < sn; j++)
      if (s[j] != f[i + j])
        goto fail;
    return f + i;
fail:;
  }
  return NULL;
}
