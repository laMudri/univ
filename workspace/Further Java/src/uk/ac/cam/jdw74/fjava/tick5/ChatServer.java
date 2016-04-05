package uk.ac.cam.jdw74.fjava.tick5;

import java.io.IOException;
import java.net.ServerSocket;
import java.sql.SQLException;

import uk.ac.cam.cl.fjava.messages.Message;

public class ChatServer {
  private static void printUsageMessage() {
    System.out.println("Usage: java ChatServer <port> <database name>");
  }
  
  private static void printSocketMessage(int port) {
    System.out.println("Cannot use port number " + Integer.toString(port));
  }

  public static void main(String[] args) {
    if (args.length != 2) { printUsageMessage(); return; }
    try {
      int port = Integer.parseInt(args[0]);
      Database db = new Database(args[1]);
      try (ServerSocket s = new ServerSocket(port)) {
        MultiQueue<Message> q = new MultiQueue<>();
        while (true) { new ClientHandler(s.accept(), q, db); }
      }
      catch (IOException e) { printSocketMessage(port); }
    }
    catch (NumberFormatException e) { printUsageMessage(); }
    catch (SQLException e) { e.printStackTrace(); }
  }
}
