package uk.ac.cam.jdw74.tick3;

public class FibonacciCache {
    public static long[] fib = new long[20];

    public static void store() {
        if (fib.length == 0)
            return;
        fib[0] = 1L;
        if (fib.length == 1)
            return;
        fib[1] = 1L;
        for (int i = 2; i < fib.length; i++)
            fib[i] = fib[i - 2] + fib[i - 1];
    }

    public static void reset() {
        for (int i = 0; i < fib.length; i++)
            fib[i] = 0L;
    }
 
    public static long get(int i) {
        if (i < 0 || fib.length <= i)
            return -1L;
        else
            return fib[i];
    }
}
