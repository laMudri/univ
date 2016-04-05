#include <iostream>
#include "vector.hpp"
#include "matrix.hpp"

using namespace std;

Vector::Vector(): a(0.0L), b(0.0L) { }
Vector::Vector(double x, double y): a(x), b(y) { }

void Vector::print() {
  cout << '/' << a << '\\' << endl
       << '\\' << b << '/' << endl;
}

Vector operator+(Vector x, Vector y) {
  return *new Vector(x.a + y.a, x.b + y.b);
}

Vector operator-(Vector x, Vector y) {
  return *new Vector(x.a - y.a, x.b - y.b);
}

Vector operator*(Matrix x, Vector y) {
  return *new Vector(x.a * y.a + x.b * y.b, x.c * y.a + x.d * y.b);
}

Vector operator*(double x, Vector y) {
  return *new Vector(x * y.a, x * y.b);
}
