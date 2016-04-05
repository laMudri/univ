package uk.ac.cam.jdw74.fjava.tick5;

import uk.ac.cam.cl.fjava.messages.RelayMessage;

import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Database {
  private Connection connection;

  public Database(String databasePath) throws SQLException {
    try {
      Class.forName("org.hsqldb.jdbcDriver");
      connection =
        DriverManager.getConnection("jdbc:hsqldb:file:" + databasePath,
                                    "SA", "");

      Statement delayStmt = connection.createStatement();
      try { delayStmt.execute("SET WRITE_DELAY FALSE"); }
      finally { delayStmt.close(); }

      connection.setAutoCommit(false);

      Statement sqlStmt = connection.createStatement();
      try {
        sqlStmt.execute(
          "CREATE TABLE messages(nick VARCHAR(255) NOT NULL," +
          "message VARCHAR(4096) NOT NULL,timeposted BIGINT NOT NULL)");
      }
      catch (SQLException e) { }  // Table already exists

      try {
        sqlStmt.execute("CREATE TABLE statistics(key VARCHAR(255),value INT)");
        sqlStmt.execute(
          "INSERT INTO statistics(key,value) VALUES ('Total messages',0");
        sqlStmt.execute(
          "INSERT INTO statistics(key,value) VALUES ('Total logins',0");
      }
      // Table already exists. Don't make fields again.
      catch (SQLException e) { }
    }
    catch (ClassNotFoundException e) { e.printStackTrace(); System.exit(1); }
  }

  public void close() throws SQLException {
    connection.close();
  }

  public void incrementLogins() throws SQLException {
    Statement sqlStmt = connection.createStatement();
    sqlStmt.execute(
      "UPDATE statistics SET value = value+1 WHERE key='Total logins'");
    connection.commit();
  }

  public void addMessage(RelayMessage m) throws SQLException {
    String stmt =
      "INSERT INTO MESSAGES(nick,message,timeposted) VALUES (?,?,?)";
    PreparedStatement insertMessage = connection.prepareStatement(stmt);
    try {
      insertMessage.setString(1, m.getFrom());
      insertMessage.setString(2, m.getMessage());
      insertMessage.setLong(3, m.getCreationTime().getTime());
      insertMessage.executeUpdate();
    }
    finally {
      insertMessage.close();
    }

    Statement sqlStmt = connection.createStatement();
    sqlStmt.execute(
      "UPDATE statistics SET value = value+1 WHERE key='Total messages'");

    connection.commit();
  }

  public List<RelayMessage> getRecent() throws SQLException {
    String stmt = "SELECT nick,message,timeposted FROM messages " +
      "ORDER BY timeposted DESC LIMIT 10";
    PreparedStatement recentMessages = connection.prepareStatement(stmt);
    LinkedList<RelayMessage> messages = new LinkedList<>();
    try {
      ResultSet rs = recentMessages.executeQuery();
      try {
        while (rs.next()) {
          messages.addFirst(new RelayMessage(rs.getString(1), rs.getString(2),
                                             new Date(rs.getLong(3))));
        }
      }
      finally { rs.close(); }
    }
    finally { recentMessages.close(); }
    return messages;
  }

  public static void main(String[] args)
      throws ClassNotFoundException, SQLException {
    if (args.length == 0) {
      System.out.println(
        "Usage: java uk.ac.cam.crsid.fjava.tick5.Database <database name>");
      return;
    }

    Class.forName("org.hsqldb.jdbcDriver");
    Connection connection = DriverManager.getConnection(
      "jdbc:hsqldb:file:" + args[0],"SA","");

    Statement delayStmt = connection.createStatement();
    // Always update data on disk
    try { delayStmt.execute("SET WRITE_DELAY FALSE"); }
    finally { delayStmt.close(); }

    connection.setAutoCommit(false);

    Statement sqlStmt = connection.createStatement();
    try {
      sqlStmt.execute(
        "CREATE TABLE messages(nick VARCHAR(255) NOT NULL," +
        "message VARCHAR(4096) NOT NULL,timeposted BIGINT NOT NULL)");
    }
    catch (SQLException e) {
      System.out.println(
        "Warning: Database table \"messages\" already exists.");
    }
    finally {
      sqlStmt.close();
    }

    String stmt =
      "INSERT INTO MESSAGES(nick,message,timeposted) VALUES (?,?,?)";
    PreparedStatement insertMessage = connection.prepareStatement(stmt);
    try {
      // set value of first "?" to "Alastair"
      insertMessage.setString(1, "Alastair");
      insertMessage.setString(2, "Hello, Andy");
      insertMessage.setLong(3, System.currentTimeMillis());
      insertMessage.executeUpdate();
    }
    finally {  // Notice use of finally clause here to finish statement
      insertMessage.close();
    }

    connection.commit();

    stmt = "SELECT nick,message,timeposted FROM messages " +
      "ORDER BY timeposted DESC LIMIT 10";
    PreparedStatement recentMessages = connection.prepareStatement(stmt);
    try {
      ResultSet rs = recentMessages.executeQuery();
      try {
        while (rs.next())
          System.out.println(
            rs.getString(1) + ": " + rs.getString(2) +
            " [" + rs.getLong(3) + "]");
      }
      finally { rs.close(); }
    }
    finally { recentMessages.close(); }

    connection.close();
  }
}
