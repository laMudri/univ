package code;

interface INinja {
    public void hide();
}

class Student {
    private boolean mSleeping = false;
    
    public void sleep() {
        mSleeping = true;
        System.out.println("zzz");
    }

    public void wake() {
        try {
            Thread.sleep(10000);
        } catch (InterruptedException ignore) { }

        mSleeping = false;
        System.out.println("yawn");
    }

    public Student(boolean sleeping) {
        mSleeping = sleeping;
    }

    public Student() {
        mSleeping = true;
    }
}

class Ninja implements INinja {
    @Override
    public void hide() {
        System.out.println("...");
    }
}

class NinjaStudent extends Student implements INinja {
    private Ninja mNinja = new Ninja();

    @Override public void hide() {
        mNinja.hide();
    }
}

public class S2h {
    public static void main(String[] args) {
        NinjaStudent ns = new NinjaStudent();
        ns.wake();
        ns.hide();
    }
}
