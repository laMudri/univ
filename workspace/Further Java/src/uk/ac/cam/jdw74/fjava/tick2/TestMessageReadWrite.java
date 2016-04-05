package uk.ac.cam.jdw74.fjava.tick2;

import java.io.FileOutputStream;
import java.io.ObjectOutputStream;
import java.io.IOException;
import java.net.URL;
import java.net.MalformedURLException;
import java.net.URLConnection;
import java.io.FileInputStream;
import java.io.ObjectInputStream;

class TestMessageReadWrite {

  static boolean writeMessage(String message, String filename) {
    TestMessage m = new TestMessage();
    m.setMessage(message);

    try (FileOutputStream fos = new FileOutputStream(filename);
         ObjectOutputStream oos = new ObjectOutputStream(fos)) {
      oos.writeObject(m);
      return true;
    }
    catch (IOException e) {
      return false;
    }
  }

  static String readMessage(String location) {
    if (location.startsWith("http://")) {
      try {
        URLConnection conn = new URL(location).openConnection();
        conn.connect();
        ObjectInputStream ois = new ObjectInputStream(conn.getInputStream());
        TestMessage m = (TestMessage)ois.readObject();
        return m.getMessage();
      }
      catch (MalformedURLException e) {
        return null;
      }
      catch (ClassNotFoundException e) {
        return null;
      }
      catch (IOException e) {
        return null;
      }
    }
    else {
      try (FileInputStream fis = new FileInputStream(location);
           ObjectInputStream ois = new ObjectInputStream(fis)) {
        TestMessage m = (TestMessage)ois.readObject();
        return m.getMessage();
      }
      catch (ClassNotFoundException e) {
        return null;
      }
      catch (IOException e) {
        return null;
      }
    }
  }

  public static void main(String args[]) {
    String msg = readMessage(
"http://www.cl.cam.ac.uk/teaching/current/FJava/testmessage-jdw74.jobj"
    );
    writeMessage(msg, "/tmp/message.jobj");
    System.out.println(readMessage("/tmp/message.jobj"));
  }
}
