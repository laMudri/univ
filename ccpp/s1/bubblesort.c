#include <stdio.h>
#include <stdbool.h>

void bubbleSort(int a[], int n) {
  bool notFinished = true;
  int tmp;
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
  int a[] = {6,32,9,1,9,4,943,49,3,7};
  unsigned int n = sizeof(a) / sizeof(a[0]);
  bubbleSort(a, n);
  unsigned int i;
  for (i = 0; i < n; i++)
    printf("%d\n", a[i]);
  return;
}
