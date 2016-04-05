package uk.ac.cam.jdw74.fjava.tick0;

import java.io.*;

public class Check {
  public static void main(String[] args) throws Exception {
    RandomAccessFile f = new RandomAccessFile(args[0], "rw");
    DataInputStream fi = new DataInputStream(new BufferedInputStream(
      new FileInputStream(f.getFD())));
    int last = 0;
    while (fi.available() > 0) {
      int d = fi.readInt();
      if (last > fi.readInt())
        System.out.println("Wrong: " + Integer.toString(last) + ", " + Integer.toString(d));
      last = d;
    }
  }
}
