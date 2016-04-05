package uk.ac.cam.jdw74.tick5;

import java.io.Writer;
import java.awt.Graphics;
import java.io.PrintWriter;

public class TestPackedWorld implements World {

    private int generation;
    private long cells;

    public TestPackedWorld() {
        generation = 0;
        cells = 0;
    }

    protected TestPackedWorld(TestPackedWorld prev) {
        generation = prev.generation;
        cells = 0;
    }

    public boolean getCell(int col, int row) {
        return 0 <= row && row < 8 && 0 <= col && col < 8 ?
            PackedLong.get(cells, row * 8 + col) : false;
    }
    public void setCell(int col, int row, boolean alive) {
        if (0 <= row && row < 8 && 0 <= col && col < 8)
            cells = PackedLong.set(cells, row * 8 + col, alive);
    }
    public int getWidth() { return 8; }
    public int getHeight() { return 8; }
    public int getGeneration() { return generation; }
    public int getPopulation() {
        int n = 0;
        for (int i = 0; i < 8; i++)
            for (int j = 0; j < 8; j++)
                if (getCell(j, i)) n++;
        return n;
    }
    public void print(Writer w) {
        PrintWriter pw = new PrintWriter(w);

        pw.println("-");
        for (int row = 0; row < 8; row++) {
            for (int col = 0; col < 8; col++)
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

    private TestPackedWorld nextGeneration() {
        //Construct a new TestPackedWorld object to hold the next generation:
        TestPackedWorld world = new TestPackedWorld(this);
        for (int i = 0; i < 8; i++)
            for (int j = 0; j < 8; j++)
                world.setCell(j, i, computeCell(j, i));
        return world;
    }

    public World nextGeneration(int log2StepSize) {
        TestPackedWorld world = this;
        for (int i = 0; i < 1 << log2StepSize; i++)
            world = world.nextGeneration();
        return world;
    }
}
