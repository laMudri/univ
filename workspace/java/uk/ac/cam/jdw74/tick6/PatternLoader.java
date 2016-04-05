package uk.ac.cam.jdw74.tick6;

import java.io.Reader;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.FileReader;
import java.util.List;
import java.util.LinkedList;
import java.net.URL;
import java.net.URLConnection;

public class PatternLoader {

    public static List<Pattern> load(Reader r) throws IOException {
        BufferedReader buff = new BufferedReader(r);
        List<Pattern> results = new LinkedList<>();

        String line;
        while ((line = buff.readLine()) != null)
            try {
                results.add(new Pattern(line));
            }
            catch (PatternFormatException e) {}

        return results;
    }

    public static List<Pattern> loadFromURL(String url) throws IOException {
        URL destination = new URL(url);
        URLConnection conn = destination.openConnection();
        return load(new InputStreamReader(conn.getInputStream()));
    }

    public static List<Pattern> loadFromDisk(String filename)
        throws IOException {
        return load(new FileReader(filename));
    }
}
