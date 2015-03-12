package code;

import java.util.ArrayList;

class A {
    public void write() {
        System.out.println("Hello from A");
    }
}

class B extends A {
    @Override
    public void write() {
        System.out.println("Hello from B");
    }
}

public class S2a {
    public static void main(String[] args) {
        A a = new A();
        B b = new B();
        ArrayList<A> arr = new ArrayList<>();
        arr.add(a);
        arr.add(b);
        for (A e : arr) {
            e.write();
        }
    }
}
