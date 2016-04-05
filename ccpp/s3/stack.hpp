#ifndef STACK_H
#define STACK_H

#include <stdlib.h>
#include <iostream>

using namespace std;

template<class T> class Stack {
  struct Item {
    T val;
    Item *next;
    Item(T v): val(v), next(NULL) { }
  };

  Item *head;

public:
  Stack(const Stack &s);
  Stack &operator=(const Stack &s);

  Stack(): head(NULL) { }
  ~Stack();
  T pop();
  void push(T val);
  void append(T val);
  void print();
};

#include "stack.cpp"

template<class T> void Stack<T>::push(T val) {
  Item *newhead = new Item(val);
  newhead->next = head;
  head = newhead;
}

template<class T> void Stack<T>::append(T val) {
  struct I {
    static void appendItem(T val, Item *p) {
      if (p->next)
        appendItem(val, p->next);
      else
        p->next = new Item(val);
    }
  };

  if (head)
    I::appendItem(val, head);
  else
    head = new Item(val);
}

template<class T> void Stack<T>::print() {
  struct I {
    static void printItem(Item *p) {
      if (p) {
        cout << p->val << endl;
        printItem(p->next);
      }
    }
  };

  I::printItem(head);
}

#endif
