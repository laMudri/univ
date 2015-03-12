package code;

class A {
    public int a = 2;
    public void f() {
        System.out.print("A");
    }
}

class B extends A {
    public int a = 3;
    public void f() {
        System.out.print("B");
    }
}

public class S2e {
    public static void main(String[] args) {
        A x = new A();
        A y = new B();
        B z = new B();
        System.out.print(x.a);
        System.out.print(y.a);
        System.out.print(z.a);
        x.f();
        y.f();
        z.f();
        System.out.println("");
    }
}
