package uk.ac.cam.jdw74.fjava.tick0;

import java.io.*;

public class Show {
  public static void main(String[] args) throws Exception {
    RandomAccessFile f = new RandomAccessFile(args[0], "rw");
    DataInputStream fi = new DataInputStream(new BufferedInputStream(
      new FileInputStream(f.getFD())));
    while (fi.available() > 0)
      System.out.print(" " + Integer.toString(fi.readInt()));
  }
}
