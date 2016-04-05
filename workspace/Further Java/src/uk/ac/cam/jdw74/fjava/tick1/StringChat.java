package uk.ac.cam.jdw74.fjava.tick1;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.IOException;
import java.io.OutputStream;
import java.lang.Thread;
import java.net.Socket;

public class StringChat {
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

    // Makes s available in the anonymous class, which receives a copy of s.
    // `final` ensures that s won't be mutated, so a copy is as good as the
    // original.
    try (final Socket s = new Socket(host, port)) {
      InputStream in = s.getInputStream();
      OutputStream out = s.getOutputStream();

      Thread output = new Thread() {
        @Override
        public void run() {
          try {
            while (true) {
              System.out.print((char)in.read());
            }
          }
          catch (IOException e) { }
        }
      };

      output.setDaemon(true);
      output.start();

      BufferedReader r = new BufferedReader(new InputStreamReader(System.in));
      while (true) {
        out.write(r.readLine().getBytes());
      }
    }
    catch (IOException e) {
      System.err.println(
        "Cannot connect to " + host + " on port " + Integer.toString(port));
    }
  }
}
