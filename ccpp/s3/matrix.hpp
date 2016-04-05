#ifndef MATRIX_H
#define MATRIX_H

class Matrix {
public:
  const double a, b, c, d;
  Matrix();
  Matrix(double x);
  Matrix(double w, double x, double y, double z);
  void print();
};

Matrix operator+(Matrix x, Matrix y);
Matrix operator-(Matrix x, Matrix y);
Matrix operator*(Matrix x, Matrix y);
Matrix operator*(double x, Matrix y);
Matrix operator/(Matrix x, Matrix y);
Matrix inv(Matrix x);

#endif
