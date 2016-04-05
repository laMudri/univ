package uk.ac.cam.jdw74.fjava.tick1;

public class HelloWorld {
  public static void main(String[] args) {
    System.out.println("Hello, " + (args.length == 1 ? args[0] : "world"));
  }
}
