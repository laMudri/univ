package oop;

import java.lang.String;
import java.lang.System;
import oop2.X;

class Y extends X {
    private int v;
    public Y() {
        v = new X().value;
    }
}

public class S2g {
    public static void main(String[] args) {
        System.out.println(new Y().getValue());
    }
}
