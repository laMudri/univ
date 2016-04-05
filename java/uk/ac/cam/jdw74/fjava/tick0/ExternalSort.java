package uk.ac.cam.jdw74.fjava.tick0;

import java.io.*;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.PriorityQueue;
import java.security.DigestInputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class ExternalSort
{
  // Take up to n integers from ai, sort them, and write them to bo.
  // Returns the number of integers actually read and sorted.
  // In all but the last chunk, this value is n.
  private static int sortSmall(DataInputStream ai, DataOutputStream bo, int n)
    throws IOException
  {
    // Heapsort
    PriorityQueue<Integer> data = new PriorityQueue<>(n);
    int i;
    for (i = 0; i < n; i++) {
      try {
        int d = ai.readInt();
        data.add(new Integer(d));
      }
      catch (EOFException e) { break; }
    }
    while (true) {
      Integer d = data.poll();
      if (d == null) break;
      bo.writeInt(d.intValue());
    }
    bo.flush();
    return i;
  }

  // Exhaust stream collection bis, outputting to ao.
  // One could call it a "multimerge".
  private static void merge(PriorityQueue<DataInputStreamWithInt> bis,
                            DataOutputStream ao)
    throws IOException
  {
    for (DataInputStreamWithInt bi = bis.poll(); bi != null; bi = bis.poll()) {
      Optional<Integer> d = bi.readOptional();
      if (d.isPresent()) {
        ao.writeInt(d.get().intValue());
        // Add the modified stream back into the queue
        bis.add(bi);
      }
      // If not present, the stream has finished
      // and isn't added back into the queue.
    }
    ao.flush();
  }

  // Sort chunks of file a, writing the sorted chunks to file b. Then, write
  // the values back to file a by repeatedly taking the smallest chunk head.
  public static void sort(String aPath, String bPath)
    throws FileNotFoundException, IOException
  {
    // Number of integers per chunk
    int n = 0x10000;

    // Sort chunks.

    RandomAccessFile a = new RandomAccessFile(aPath, "rw");
    DataInputStream ai = new DataInputStream(new BufferedInputStream(
      new FileInputStream(a.getFD())));
    RandomAccessFile b = new RandomAccessFile(bPath, "rw");
    DataOutputStream bo = new DataOutputStream(new BufferedOutputStream(
      new FileOutputStream(b.getFD())));

    List<Integer> lengths = new ArrayList<>();
    while (ai.available() > 0) {
      lengths.add(sortSmall(ai, bo, n));
    }

    b.close();

    // Set up the input streams for merging.

    int offset = 0;
    // DataInputStreamWithInt objects compare based on the cached value they
    // hold.
    PriorityQueue<DataInputStreamWithInt> bis = new PriorityQueue<>();
    // Keep a record of what needs to be closed later.
    Collection<RandomAccessFile> bs = new ArrayList<>(lengths.size());

    for (Integer length : lengths) {
      // New instance needed to avoid clashes.
      RandomAccessFile b_ = new RandomAccessFile(bPath, "r");

      DataInputStream bi = new DataInputStream (new BufferedInputStream(
        new FileInputStream(b_.getFD())));
      bi.skipBytes(4 * offset);
      bis.add(new DataInputStreamWithInt(bi, length.intValue()));

      bs.add(b_);
      offset += length.intValue();
    }

    // Clear a, then write to it.

    a.setLength(0);
    DataOutputStream ao = new DataOutputStream(new BufferedOutputStream(
      new FileOutputStream(a.getFD())));
    merge(bis, ao);

    // Close everything

    a.close();
    for (RandomAccessFile b_ : bs) {
      b_.close();
    }
  }

  // Template code

  private static String byteToHex(byte b) {
    String r = Integer.toHexString(b);
    if (r.length() == 8) {
      return r.substring(6);
    }
    return r;
  }

  public static String checkSum(String f) {
    try {
      MessageDigest md = MessageDigest.getInstance("MD5");
      DigestInputStream ds = new DigestInputStream(
        new FileInputStream(f), md);
      byte[] b = new byte[512];
      while (ds.read(b) != -1)
        ;

      String computed = "";
      for(byte v : md.digest())
        computed += byteToHex(v);

      return computed;
    }
    catch (NoSuchAlgorithmException e) { e.printStackTrace(); }
    catch (FileNotFoundException e) { e.printStackTrace(); }
    catch (IOException e) { e.printStackTrace(); }
    return "<error computing checksum>";
  }

  public static void main(String[] args) throws Exception
  {
    String f1 = args[0];
    String f2 = args[1];
    sort(f1, f2);
    System.out.println("The checksum is: " + checkSum(f1));
  }
}
