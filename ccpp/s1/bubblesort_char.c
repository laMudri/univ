#include <stdio.h>
#include <stdbool.h>
#include <string.h>

void bubbleSort(char a[], int n) {
  bool notFinished = true;
  char tmp;
  unsigned int i;
  for (; notFinished && n > 0; n--) {
    notFinished = false;
    for (i = 0; i + 1 < n; i++)
      if (a[i] > a[i + 1]) {
        notFinished = true;
        tmp = a[i];
        a[i] = a[i + 1];
        a[i + 1] = tmp;
      }
  }
}

void main() {
  char a[] = "Hello, world!";
  unsigned int n = strlen(a);
  bubbleSort(a, n);
  unsigned int i;
  for (i = 0; i < n; i++)
    printf("%c\n", a[i]);
  return;
}
