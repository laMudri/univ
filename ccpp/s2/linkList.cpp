#include <stdlib.h>

class LinkList {
private:
  bool isCons;
  int x;
  LinkList *xs;

public:
  int pop();
  LinkList(const LinkList &old);
  LinkList &operator=(const LinkList &r);
  LinkList();
  LinkList(int *a, size_t n);
};

LinkList::LinkList(const LinkList &old) {
  isCons = old.isCons;
  x = old.x;
  xs = new LinkList(*old.xs);
}

LinkList &LinkList::operator=(const LinkList &r) {
  return *new LinkList(r);
}

int LinkList::pop() {
  int r = x;
  *this = *xs;
  return r;
}

LinkList::LinkList() {
  isCons = false;
  x = -1;
  xs = NULL;
}

LinkList::LinkList(int *a, size_t n) {
  if (n-- <= 0) {
    isCons = false;
    x = -1;
    xs = NULL;
  }
  else {
    isCons = true;
    x = a++[0];
    xs = new LinkList(a, n);
  }
}
