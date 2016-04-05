#include <iostream>
#include "prime.cpp"

using namespace std;

int main() {
  if (prime<757>::v)
    cout << "prime" << endl;
  else
    cout << "not prime" << endl;
  return 0;
}
