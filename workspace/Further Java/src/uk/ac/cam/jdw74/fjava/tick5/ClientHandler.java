package uk.ac.cam.jdw74.fjava.tick5;

import java.io.EOFException;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.sql.SQLException;
import java.util.Random;

import uk.ac.cam.cl.fjava.messages.ChangeNickMessage;
import uk.ac.cam.cl.fjava.messages.ChatMessage;
import uk.ac.cam.cl.fjava.messages.Message;
import uk.ac.cam.cl.fjava.messages.RelayMessage;
import uk.ac.cam.cl.fjava.messages.StatusMessage;

public class ClientHandler {
  private Socket socket;
  private MultiQueue<Message> multiQueue;
  private String nickname;
  private MessageQueue<Message> clientMessages;
  private Database database;

  public ClientHandler(Socket s, MultiQueue<Message> q, Database db) {
    socket = s;
    multiQueue = q;
    database = db;

    clientMessages = new SafeMessageQueue<>();

    try {
      for (RelayMessage m : database.getRecent()) {
        clientMessages.put(m);
      }
      database.incrementLogins();
    }
    catch (SQLException e) { e.printStackTrace(); }

    multiQueue.register(clientMessages);
    Random r = new Random();
    nickname = String.format("Anonymous%05d", r.nextInt(100000));
    multiQueue.put(new StatusMessage(String.format("%s connected from %s.",
      nickname, socket.getInetAddress().getHostName())));

    Thread in = new Thread() {
      @Override
      public void run() {
        try (ObjectInputStream is =
             new ObjectInputStream(socket.getInputStream())) {
          while (true) {
            try {
              Object msg = is.readObject();
              if (msg instanceof ChangeNickMessage) {
                ChangeNickMessage cnm = (ChangeNickMessage)msg;
                multiQueue.put(new StatusMessage(String.format(
                  "%s is now known as %s", nickname, cnm.name)));
                nickname = cnm.name;
              }
              else if (msg instanceof ChatMessage) {
                ChatMessage cm = (ChatMessage)msg;
                RelayMessage rm = new RelayMessage(nickname, cm);
                multiQueue.put(rm);
                database.addMessage(rm);
              }
            }
            catch (ClassNotFoundException e) { e.printStackTrace(); }
            catch (SQLException e) { e.printStackTrace(); }
          }
        }
        catch (EOFException e) {
          multiQueue.deregister(clientMessages);
          multiQueue.put(new StatusMessage(String.format(
            "%s has disconnected", nickname)));
        }
        catch (IOException e) { e.printStackTrace(); }
      }
    };
    in.setDaemon(true);
    in.start();

    Thread out = new Thread() {
      @Override
      public void run() {
        try (ObjectOutputStream os =
             new ObjectOutputStream(socket.getOutputStream())) {
          while (true) {
            os.writeObject(clientMessages.take());
          }
        }
        catch (IOException e) { e.printStackTrace(); }
      }
    };
    out.setDaemon(true);
    out.start();
  }
}
