package uk.ac.cam.jdw74.fjava.tick0;

import java.io.DataInputStream;
import java.io.EOFException;
import java.io.IOException;
import java.util.Optional;

public class DataInputStreamWithInt
  implements Comparable<DataInputStreamWithInt>
{
  // I'd really like a sum type, Integer + EOFException, but yeah...
  private Optional<Integer> data;
  private DataInputStream stream;
  private int n;

  // Move one integer along the stream, updating data accordingly.
  private void initData() throws IOException
  {
    try {
      if (n-- == 0) { data = Optional.empty(); }
      else          { data = Optional.of(new Integer(stream.readInt())); }
    }
    catch (EOFException e) { data = Optional.empty(); }
  }

  // Return the cached data, then move on.
  // Returns empty if the end of the chunk has been reached.
  public Optional<Integer> readOptional() throws IOException
  {
    // I would have written this as a map on data, but yeah...
    if (data.isPresent()) {
      Integer d = data.get();
      initData();
      return Optional.of(d);
    }
    else {
      return Optional.empty();
    }
  }

  @Override
  // Compare streams by the values they will yield next.
  // `Nothing` serves as a bottom element.
  public int compareTo(DataInputStreamWithInt o)
  {
    if (data.isPresent())
      if (o.data.isPresent())
        return Integer.compare(data.get(), o.data.get());
      else
        return 1;
    else
      if (o.data.isPresent())
        return -1;
      else
        return 0;
  }

  // Stop reading from stream s (throwing an EOFException)
  // when dataLeft items have been read.
  public DataInputStreamWithInt(DataInputStream s, int dataLeft)
    throws IOException
  {
    stream = s;
    n = dataLeft;
    initData();
  }
}
