#ifndef VECTOR_H
#define VECTOR_H

#include "matrix.hpp"

class Vector {
public:
  const double a, b;
  Vector();
  Vector(double x, double y);
  void print();
};

Vector operator+(Vector x, Vector y);
Vector operator-(Vector x, Vector y);
Vector operator*(Matrix x, Vector y);
Vector operator*(double x, Vector y);

#endif
