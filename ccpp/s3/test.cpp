#include <iostream>
#include "matrix.hpp"
#include "vector.hpp"
#include "stack.hpp"
#include "prime.cpp"

using namespace std;

int main() {
  Matrix a(1, 1, 1, 0);
  Matrix b(-3, 2, 0, 4);
  Matrix c = a * b;
  c.print();
  Vector d(3, -2);
  Vector e = c * d;
  e.print();

  cout << endl;

  Stack<int> *s = new Stack<int>();
  s->append(-4); s->push(5);
  Stack<int> t = *s;
  s->append(-2); s->push(3); s->append(0);
  t.append(1);
  cout << "s:" << endl;
  s->print();
  delete s;
  cout << "t:" << endl;
  t.print();

  cout << endl;

  struct prime<0> zero;
  struct prime<1> one;
  struct prime<2> two;
  struct prime<3> three;
  struct prime<4> four;
  cout << zero.v << endl
       << one.v << endl
       << two.v << endl
       << three.v << endl
       << four.v << endl;

  return 0;
}
