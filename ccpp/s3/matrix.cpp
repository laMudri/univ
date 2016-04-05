#include <iostream>
#include "matrix.hpp"

using namespace std;

Matrix::Matrix(): a(1.0L), b(0.0L), c(0.0L), d(1.0L) { }
Matrix::Matrix(double x): a(x), b(0.0L), c(0.0L), d(x) { }
Matrix::Matrix(double w, double x, double y, double z):
  a(w), b(x), c(y), d(z) { }

void Matrix::print() {
  cout << '/' << a << ' ' << b << '\\' << endl
       << '\\' << c << ' ' << d << '/' << endl;
}

Matrix operator+(Matrix x, Matrix y) {
  return *new Matrix(x.a + y.a, x.b + y.b, x.c + y.c, x.d + y.d);
}

Matrix operator-(Matrix x, Matrix y) {
  return *new Matrix(x.a - y.a, x.b - y.b, x.c - y.c, x.d - y.d);
}

Matrix operator*(Matrix x, Matrix y) {
  return *new Matrix(x.a * y.a + x.b * y.c, x.a * y.b + x.b * y.d,
                     x.c * y.a + x.d * y.c, x.c * y.b + x.d * y.d);
}

Matrix operator*(double x, Matrix y) {
  return *new Matrix(x * y.a, x * y.b, x * y.c, x * y.d);
}

Matrix operator/(Matrix x, Matrix y) {
  return x * inv(y);
}

Matrix inv(Matrix x) {
  double det = x.a * x.d - x.b * x.c;
  return det * *new Matrix(x.d, -x.b, -x.c, x.a);
}
