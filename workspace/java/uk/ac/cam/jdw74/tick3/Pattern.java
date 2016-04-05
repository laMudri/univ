package uk.ac.cam.jdw74.tick3;

import java.text.ParseException;

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

    public Pattern(String format) throws ParseException {
        String[] parts = format.split(":");
        if (parts.length != 7)
            throw new ParseException("Incorrect pattern format", 0);

        name = parts[0];
        author = parts[1];
        width = Integer.parseInt(parts[2]);
        height = Integer.parseInt(parts[3]);
        startCol = Integer.parseInt(parts[4]);
        startRow = Integer.parseInt(parts[5]);
        cells = parts[6];
    }

    public void initialise(boolean[][] world) {
        String[] rows = cells.split(" ");
        char[][] values = new char[rows.length][];
        for (int i = 0; i < rows.length; i++)
            values[i] = rows[i].toCharArray();

        for (int i = 0; i < values.length; i++)
            for (int j = 0; j < values[i].length; j++)
                world[startRow + i][startCol + j] = values[i][j] == '1';
    }
}
