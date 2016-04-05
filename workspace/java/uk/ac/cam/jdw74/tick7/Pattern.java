package uk.ac.cam.jdw74.tick7;

import java.text.ParseException;
import uk.ac.cam.acr31.life.World;

public class Pattern {

    private String name;
    private String author;
    private int width;
    private int height;
    private int startCol;
    private int startRow;
    private String cells;

    public String getName() { return name; }
    public void setName(String x) { name = x; }

    public String getAuthor() { return author; }
    public void setAuthor(String x) { author = x; }

    public int getWidth() { return width; }
    public void setWidth(int x) { width = x; }

    public int getHeight() { return height; }
    public void setHeight(int x) { height = x; }

    public int getStartCol() { return startCol; }
    public void setStartCol(int x) { startCol = x; }

    public int getStartRow() { return startRow; }
    public void setStartRow(int x) { startRow = x; }

    public String getCells() { return cells; }
    public void setCells(String x) { cells = x; }

    public Pattern(String format) throws PatternFormatException {
        String[] parts = format.split(":");
        if (parts.length < 7)
            throw new PatternFormatException("Too few arguments");
        if (parts.length > 7)
            throw new PatternFormatException("Too many arguments");

        name = parts[0];
        author = parts[1];
        try {
            width = Integer.parseInt(parts[2]);
            if (width <= 0) throw new NumberFormatException();
        }
        catch (NumberFormatException e) {
            throw new PatternFormatException(
                "Width argument not a positive integer");
        }
        try {
            height = Integer.parseInt(parts[3]);
            if (height <= 0) throw new NumberFormatException();
        }
        catch (NumberFormatException e) {
            throw new PatternFormatException(
                "Height argument not a positive integer");
        }
        try {
            startCol = Integer.parseInt(parts[4]);
        }
        catch (NumberFormatException e) {
            throw new PatternFormatException(
                "x coördinate not an integer");
        }
        try {
            startRow = Integer.parseInt(parts[5]);
        }
        catch (NumberFormatException e) {
            throw new PatternFormatException(
                "y coördinate not an integer");
        }
        cells = parts[6];
    }

    public void initialise(World world) throws PatternFormatException {
        String[] rows = cells.split(" ");
        char[][] values = new char[rows.length][];
        for (int i = 0; i < rows.length; i++)
            values[i] = rows[i].toCharArray();

        for (int i = 0; i < values.length; i++)
            for (int j = 0; j < values[i].length; j++)
                if (" 01".indexOf(values[i][j]) == -1)
                    throw new PatternFormatException(
                    "Pattern contains characters other than ‘0’, ‘1’ and ‘ ’");
                else
                    world.setCell(startCol + j, startRow + i,
                                  values[i][j] == '1');
    }

    @Override
    public String toString() {
        return name + ":" + author + ":" + width + ":" + height + ":" +
            startCol + ":" + startRow + ":" + cells;
    }
}
