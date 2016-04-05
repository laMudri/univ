#include <stdio.h>
#include <float.h>

int main() {
    double a = DBL_MAX, b = 1.5, c = -DBL_MAX;
    printf("%f\n", a * b + c);
    double t = a * b;
    printf("%f\n", t + c);
    return 0;
}
