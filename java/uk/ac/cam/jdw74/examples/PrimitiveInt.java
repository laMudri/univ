package uk.ac.cam.jdw74.examples;

class PrimitiveInt {
    public static void main(String[] args) {
        int i;
        i = 1;
        i = i + 1;
        System.out.println(i = i + 1);
        int j = 10;
        System.out.println(j--);
        System.out.println(j);
        System.out.println(0x55 >> 4);
        System.out.println(0x55 << 7);
    }
}
