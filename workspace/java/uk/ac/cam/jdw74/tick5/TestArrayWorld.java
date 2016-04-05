package uk.ac.cam.jdw74.tick5;

import java.io.Writer;
import java.awt.Graphics;
import java.io.PrintWriter;

public class TestArrayWorld implements World {

    private int generation;
    private int width;
    private int height;
    private boolean[][] cells;

    public TestArrayWorld(int w, int h) {
        width = w;
        height = h;
        generation = 0;
        cells = new boolean[h][w];
    }

    protected TestArrayWorld(TestArrayWorld prev) {
        width = prev.width;
        height = prev.height;
        generation = prev.generation;
        cells = new boolean[prev.height][prev.width];
    }

    public boolean getCell(int col, int row) {
        return 0 <= row && row < cells.length &&
               0 <= col && col < cells[row].length ?
            cells[row][col] : false;
    }
    public void setCell(int col, int row, boolean alive) {
        if (0 <= row && row < cells.length &&
            0 <= col && col < cells[row].length)
            cells[row][col] = alive;
    }
    public int getWidth() { return width; }
    public int getHeight() { return height; }
    public int getGeneration() { return generation; }
    public int getPopulation() {
        int n = 0;
        for (int i = 0; i < height; i++)
            for (int j = 0; j < width; j++)
                if (getCell(j, i)) n++;
        return n;
    }
    public void print(Writer w) {
        PrintWriter pw = new PrintWriter(w);

        pw.println("-");
        for (int row = 0; row < height; row++) {
            for (int col = 0; col < width; col++)
                pw.print(getCell(col, row) ? "#" : "_");
            pw.println();
        }

        pw.flush();
    }
    public void draw(Graphics g, int width, int height) { /*Leave empty*/ }

    private int countNeighbours(int col, int row) {
        return
            (getCell(col - 1, row - 1) ? 1 : 0)
          + (getCell(col    , row - 1) ? 1 : 0)
          + (getCell(col + 1, row - 1) ? 1 : 0)
          + (getCell(col - 1, row    ) ? 1 : 0)
          + (getCell(col + 1, row    ) ? 1 : 0)
          + (getCell(col - 1, row + 1) ? 1 : 0)
          + (getCell(col    , row + 1) ? 1 : 0)
          + (getCell(col + 1, row + 1) ? 1 : 0);
    }

    private boolean computeCell(int col, int row) {
        int count = countNeighbours(col, row);
        return count == 3 || (getCell(col, row) && count == 2);
    }

    private TestArrayWorld nextGeneration() {
        //Construct a new TestArrayWorld object to hold the next generation:
        TestArrayWorld world = new TestArrayWorld(this);
        for (int i = 0; i < height; i++)
            for (int j = 0; j < width; j++)
                world.setCell(j, i, computeCell(j, i));
        return world;
    }

    public World nextGeneration(int log2StepSize) {
        TestArrayWorld world = this;
        for (int i = 0; i < 1 << log2StepSize; i++)
            world = world.nextGeneration();
        return world;
    }
}
