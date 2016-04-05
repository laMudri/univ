package uk.ac.cam.acr31.arqtest;

import java.io.IOException;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketTimeoutException;
import java.util.LinkedList;
import java.util.Queue;
import java.util.NoSuchElementException;

public class Client {
  private InetAddress serverAddress;
  private int serverPort;

  private enum State {
    IDLE_0, WAIT_FOR_ACK_0, IDLE_1, WAIT_FOR_ACK_1
  }

  public Client(InetAddress serverAddress, int serverPort) {
    super();
    this.serverAddress = serverAddress;
    this.serverPort = serverPort;
  }

  private String toggle(String s) {
    if (s.equals("0")) return "1";
    if (s.equals("1")) return "0";
    return "";
  }

  public void run(DatagramSocket socket) throws IOException {
    String sequenceNumber = "0";
    String returnAddress = socket.getLocalAddress().getCanonicalHostName();
    String returnPort = Integer.toString(socket.getLocalPort());
    String returnInfo = returnAddress + "|" + returnPort;
    Queue<String> messageQueue = new LinkedList<>();
    for(int i=0;i<5;++i) {
      String message = "Message " + i;
      messageQueue.add(message);
    }
    try {
      String message = messageQueue.remove();
      while (true) {
        try {
          new DataPacket(serverAddress, serverPort,
              sequenceNumber + "|" + returnInfo + "|" + message)
            .send(socket);
          DataPacket ack = DataPacket.receive(socket);
          if (ack.getPayload().equals(sequenceNumber + "ACK")) {
            message = messageQueue.remove();
            sequenceNumber = toggle(sequenceNumber);
          }
        }
        catch (SocketTimeoutException e) {
          // try again
        }
      }
    }
    catch (NoSuchElementException e) {
      // done
    }
  }

  /**
   * @param args
   * @throws IOException
   */
  public static void main(String[] args) throws IOException {
    int clientPort = Integer.parseInt(args[0]);
    InetAddress serverAddress = InetAddress.getByName(args[1]);
    int serverPort = Integer.parseInt(args[2]);
    double lossProbability = Double.parseDouble(args[3]);
    long propagationTimeMillis = Long.parseLong(args[4]);

    DatagramSocket socket = new TestDatagramSocket(clientPort,
        lossProbability, propagationTimeMillis);
    socket.setSoTimeout(1000);

    Client c = new Client(serverAddress, serverPort);
    c.run(socket);
  }
}
