package uk.ac.cam.jdw74.alg1;

import java.util.List;
import java.util.ArrayList;

public class MaxHeap {
    private char heapName;
    private List<Character> contents;

    public MaxHeap(char name) {
        heapName = name;
        contents = new ArrayList<>();
    }

    public MaxHeap(char name, String str) {
        heapName = name;
        contents = new ArrayList<>(str.length());
        for (int i = 0; i < str.length(); i++) {
            contents.add(str.charAt(i));
        }

        for (int i = contents.size() - 1; i >= 0; i--) {
            siftDown(i);
        }
    }

    public void insert(char x) {
        contents.add(x);
        siftUp(contents.size() - 1);
    }

    public char getMax() {
        char result = contents.get(0);
        contents.set(0, contents.get(contents.size() - 1));
        siftDown(0);
        return result;
    }

    private void siftDown(int i) {
        int l = leftIndex(i);
        int r = rightIndex(i);
        int n = contents.size();
        if (l >= n) return; // Has no children

        if (contents.get(i) < contents.get(l)) {
            if (r >= n) swap(i, l);
            else if (contents.get(l) > contents.get(r)) {
                swap(i, l);
                siftDown(l);
            }
            else {
                swap(i, r);
                siftDown(r);
            }
        }
        else if (r < n && contents.get(i) < contents.get(r)) {
            swap(i, r);
            siftDown(r);
        }
    }

    private void siftUp(int i) {
        if (i == 0) return; // Is root
        int u = upIndex(i);
        if (contents.get(u) < contents.get(i)) {
            swap(i, u);
            siftUp(u);
        }
    }

    private void swap(int x, int y) {
        char tmp = contents.get(x);
        contents.set(x, contents.get(y));
        contents.set(y, tmp);
    }

    private int upIndex(int i) {
        return (i - 1) / 2;
    }

    private int leftIndex(int i) {
        return 2 * i + 1;
    }

    private int rightIndex(int i) {
        return 2 * i + 2;
    }

    public static void main(String[] args)
    {
        char c;
        MaxHeap h = new MaxHeap('h', "CAMBRIDGEALGORITHMS");
        c = h.getMax();
        System.out.println(c); // expect T
        h.insert('Z');
        h.insert('A');
        c = h.getMax();
        System.out.println(c); // expect Z
        c = h.getMax();
        System.out.println(c); // expect S
    }
}
