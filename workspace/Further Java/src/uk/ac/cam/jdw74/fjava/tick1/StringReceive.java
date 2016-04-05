package uk.ac.cam.jdw74.fjava.tick1;

import java.io.InputStream;
import java.io.IOException;
import java.net.Socket;

public class StringReceive {
  private static void badArgs() {
    System.err.println(
      "This application requires two arguments: <machine> <port>");
  }

  public static void main(String[] args) {
    if (args.length != 2) { badArgs(); return; }

    String host = args[0];
    int port;
    try { port = Integer.parseInt(args[1]); }
    catch (NumberFormatException e) { badArgs(); return; }

    try (InputStream in = (new Socket(host, port)).getInputStream()) {
      while (true) {
        System.out.print((char)in.read());
      }
    }
    catch (IOException e) {
      System.err.println(
        "Cannot connect to " + host + " on port " + Integer.toString(port));
      return;
    }
  }
}
