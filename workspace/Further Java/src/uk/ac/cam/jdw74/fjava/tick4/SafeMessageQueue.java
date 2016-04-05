package uk.ac.cam.jdw74.fjava.tick4;

public class SafeMessageQueue<T> implements MessageQueue<T> {
  private static class Link<L> {
    L val;
    Link<L> next;
    Link(L val) { this.val = val; this.next = null; }
  }
  private Link<T> first = null;
  private Link<T> last = null;

  public synchronized void put(T val) {
    Link<T> l = new Link<>(val);
    if (first == null) {
      first = l;
      last = l;
    }
    else {
      last.next = l;
      last = l;
    }
    this.notify();
  }

  public synchronized T take() {
    while(first == null) {
      try { this.wait(); }
      catch (InterruptedException e) { e.printStackTrace(); }
    }
    T x = first.val;
    first = first.next;
    return x;
  }
}
