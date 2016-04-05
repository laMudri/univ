package uk.ac.cam.jdw74.fjava.tick2;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;
import java.lang.Thread;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.Socket;
import java.net.SocketException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import uk.ac.cam.cl.fjava.messages.ChangeNickMessage;
import uk.ac.cam.cl.fjava.messages.ChatMessage;
import uk.ac.cam.cl.fjava.messages.Message;
import uk.ac.cam.cl.fjava.messages.RelayMessage;
import uk.ac.cam.cl.fjava.messages.StatusMessage;
import uk.ac.cam.cl.fjava.messages.DynamicObjectInputStream;
import uk.ac.cam.cl.fjava.messages.NewMessageType;
import uk.ac.cam.cl.fjava.messages.Execute;

import java.io.ObjectOutputStream;

@FurtherJavaPreamble(
author = "James Wood",
date = "25th October 2015",
crsid = "jdw74",
summary = "A chat client",
ticker = FurtherJavaPreamble.Ticker.A)
public class ChatClient {
  private static final DateFormat timeFormat =
    new SimpleDateFormat("HH:mm:ss");

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

    try (final Socket s = new Socket(host, port);
         final DynamicObjectInputStream in =
           new DynamicObjectInputStream(s.getInputStream())) {
      System.out.println(timeFormat.format(new Date()) +
          " [Client] Connected to " + host + " on port " + args[1] + ".");
      ObjectOutputStream out = new ObjectOutputStream(s.getOutputStream());

      Thread output = new Thread() {
        @Override
        public void run() {
          try {
            while (true) {
              try {
                Object obj = in.readObject();
                if (obj instanceof Message) {
                  Message msg = (Message)obj;
                  System.out.print(
                    timeFormat.format(msg.getCreationTime()) + " ");
                  if (msg instanceof RelayMessage) {
                    RelayMessage rmsg = (RelayMessage)msg;
                    System.out.println(
                      "[" + rmsg.getFrom() + "] " + rmsg.getMessage());
                  }
                  else if (msg instanceof StatusMessage) {
                    StatusMessage smsg = (StatusMessage)msg;
                    System.out.println("[Server] " + smsg.getMessage());
                  }
                  else if (msg instanceof NewMessageType) {
                    NewMessageType nmsg = (NewMessageType)msg;
                    in.addClass(nmsg.getName(), nmsg.getClassData());
                    System.out.println(
                      "[Client] New class " + nmsg.getName() + " loaded.");
                  }
                  else {
                    Class<?> cls = msg.getClass();
                    System.out.print(
                      "[Client] " + cls.getSimpleName() + ": ");
                    String delim = "";
                    for (Field field : cls.getDeclaredFields()) {
                      try {
                        field.setAccessible(true);
                        Object val = field.get(msg);
                        System.out.print(delim + field.getName() +
                          "(" + val.toString() + ")");
                        delim = ", ";
                      }
                      catch (IllegalAccessException e) {
                        e.printStackTrace();
                      }
                      catch (IllegalArgumentException e) {
                        e.printStackTrace();
                      }
                    }
                    System.out.println();
                    for (Method method : cls.getMethods()) {
                      try {
                        Execute ann = method.getAnnotation(Execute.class);
                        if (ann != null && method.getParameterCount() == 0) {
                          method.invoke(msg);
                        }
                      }
                      catch (IllegalAccessException e) {
                        e.printStackTrace();
                      }
                      catch (IllegalArgumentException e) {
                        e.printStackTrace();
                      }
                      catch (InvocationTargetException e) {
                        e.printStackTrace();
                      }
                    }
                  }
                }
              }
              catch (ClassNotFoundException e) { e.printStackTrace(); }
            }
          }
          catch (SocketException e) {
            System.out.println(timeFormat.format(new Date()) +
                " [Client] Connection terminated.");
          }
          catch (IOException e) { e.printStackTrace(); }
        }
      };

      output.setDaemon(true);
      output.start();

      BufferedReader r = new BufferedReader(new InputStreamReader(System.in));
      boolean run = true;
      while (run) {
        String l = r.readLine();
        if (l.startsWith("\\")) {
          String[] command_arg = l.substring(1).split(" ", 2);
          String command = command_arg[0];
          String arg = command_arg.length > 1 ? command_arg[1] : "";
          switch (command) {
            case "nick":
              out.writeObject(new ChangeNickMessage(arg));
              break;
            case "quit":
              run = false;
              break;
            default:
              System.out.println(timeFormat.format(new Date()) +
                " [Client] Unknown command \"" + command + "\"");
              break;
          }
        }
        else {
          out.writeObject(new ChatMessage(l));
        }
      }
    }
    catch (IOException e) {
      System.err.println(
        "Cannot connect to " + host + " on port " + args[1]);
    }
  }
}
