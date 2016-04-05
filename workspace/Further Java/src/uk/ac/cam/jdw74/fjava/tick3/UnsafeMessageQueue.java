package uk.ac.cam.jdw74.fjava.tick3;

public class UnsafeMessageQueue<T> implements MessageQueue<T> {
  private static class Link<L> {
    L val;
    Link<L> next;
    Link(L val) { this.val = val; this.next = null; }
  }
  private Link<T> first = null;
  private Link<T> last = null;

  public void put(T val) {
    Link<T> l = new Link<>(val);
    if (first == null) {
      first = l;
      last = l;
    }
    else {
      last.next = l;
      last = l;
    }
  }

  public T take() {
    while(first == null)  // use a loop to block thread until data is available
      try { Thread.sleep(100); } catch(InterruptedException ie) {}
    T x = first.val;
    first = first.next;
    return x;
  }
}
