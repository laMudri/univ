package uk.ac.cam.acr31.arqtest;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;

public class DataPacket {
  private static final int MAX_SIZE = 256;

  private InetAddress host;
  private int port;
  private String payload;

  public String getPayload() {
    return payload;
  }

  public DataPacket(InetAddress host, int port, String payload) {
    super();
    this.host = host;
    this.port = port;
    this.payload = payload;
  }

  public void send(DatagramSocket s) throws IOException {
    ByteArrayOutputStream bos = new ByteArrayOutputStream();
    DataOutputStream dos = new DataOutputStream(bos);
    dos.writeUTF(payload);
    dos.close();
    byte[] bytes = bos.toByteArray();
    if (bytes.length > MAX_SIZE)
      throw new IOException("Payload too large!");
    DatagramPacket p = new DatagramPacket(bytes, bytes.length);
    p.setAddress(host);
    p.setPort(port);
    s.send(p);
  }

  public static DataPacket receive(DatagramSocket s) throws IOException {
    byte[] data = new byte[MAX_SIZE];
    DatagramPacket p = new DatagramPacket(data, data.length);
    s.receive(p);
    ByteArrayInputStream bis = new ByteArrayInputStream(data);
    DataInputStream dis = new DataInputStream(bis);
    String payload = dis.readUTF();
    return new DataPacket(p.getAddress(), p.getPort(), payload);
  }
}
