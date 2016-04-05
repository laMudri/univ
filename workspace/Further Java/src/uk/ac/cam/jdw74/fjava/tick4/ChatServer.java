package uk.ac.cam.jdw74.fjava.tick4;

import java.io.IOException;
import java.net.ServerSocket;

import uk.ac.cam.cl.fjava.messages.Message;

public class ChatServer {
  private static void printUsageMessage() {
    System.err.println("Usage: java ChatServer <port>");
  }

  private static void printSocketMessage(int port) {
    System.err.println("Cannot use port number " + Integer.toString(port));
  }

  public static void main(String[] args) {
    if (args.length != 1) { printUsageMessage(); return; }
    try {
      int port = Integer.parseInt(args[0]);
      try (ServerSocket s = new ServerSocket(port)) {
        MultiQueue<Message> q = new MultiQueue<>();
        while (true) { new ClientHandler(s.accept(), q); }
      }
      catch (IOException e) { printSocketMessage(port); }
    }
    catch (NumberFormatException e) { printUsageMessage(); }
  }
}
