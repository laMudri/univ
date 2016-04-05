template<class T> T Stack<T>::pop() {
  T r = head->val;
  head = head->next;
  return r;
}

template<class T> Stack<T>::~Stack() {
  struct I {
    static void deleteItem(Item *p) {
      if (p) {
        deleteItem(p->next);
        delete p;
      }
    }
  };

  I::deleteItem(head);
}

template<class T> Stack<T>::Stack(const Stack<T> &s) {
  struct I {
    static Item *copyItem(Item *p) {
      if (p) {
        Item *r = new Item(p->val);
        r->next = copyItem(p->next);
        return r;
      }
      else return NULL;
    }
  };

  head = I::copyItem(s.head);
}

template<class T> Stack<T> &Stack<T>::operator=(const Stack<T> &s) {
  this = new Stack(s);
  return *this;
}
