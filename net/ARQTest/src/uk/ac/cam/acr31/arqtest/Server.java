package uk.ac.cam.acr31.arqtest;

import java.io.IOException;
import java.net.DatagramSocket;
import java.net.InetAddress;

public class Server {

  private String toggle(String s) {
    if (s.equals("0")) return "1";
    if (s.equals("1")) return "0";
    return "";
  }

  public void run(DatagramSocket s) throws IOException, InterruptedException {
    String sequenceNumber = "0";
    while (true) {
      DataPacket p = DataPacket.receive(s);
      String m = p.getPayload();
      String[] parts = m.split("\\|");
      if (parts.length == 4) {
        new DataPacket(InetAddress.getByName(parts[1]),
            Integer.parseInt(parts[2]), parts[0] + "ACK")
          .send(s);
        if (parts[0].equals(sequenceNumber)) {
          // got a new message, so print it and be ready to receive the next
          System.out.println(parts[3]);
          sequenceNumber = toggle(sequenceNumber);
        }
      }
    }
  }

  public static void main(String[] args) throws IOException,
         InterruptedException {
    int serverPort = Integer.parseInt(args[0]);
    double lossProbability = Double.parseDouble(args[1]);
    long propagationTimeMillis = Long.parseLong(args[2]);

    DatagramSocket socket = new TestDatagramSocket(serverPort,
        lossProbability, propagationTimeMillis);

    Server s = new Server();
    s.run(socket);
  }

}
