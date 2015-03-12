package uk.ac.cam.jdw74.tick6;

import java.awt.Color;

public class AgingWorld extends WorldImpl {
    private int[][] world;

    public AgingWorld(int width, int height) {
        super(width,height);
        world = new int[height][width];
        for (int y = 0; y < getHeight(); ++y) {
            for (int x = 0; x < getWidth(); ++x)
                world[y][x] = 1000;
        }
    }

    private AgingWorld(AgingWorld w) {
        super(w);
        world = new int[w.getHeight()][w.getWidth()];
        for (int y = 0; y < getHeight(); ++y) {
            for (int x = 0; x < getWidth(); ++x)
                world[y][x] = w.world[y][x]+1;
        }
    }

    @Override
    public boolean getCell(int x, int y) {
        return getCellAge(x,y) == 0;
    }

    @Override
    protected WorldImpl nextGeneration() {
        WorldImpl nextWorld = new AgingWorld(this);
        for (int row = 0; row < getHeight(); ++row) {
            for (int col = 0; col < getWidth(); ++col) {
                boolean nextLive = computeCell(col, row);
                nextWorld.setCell(col, row, nextLive);
            }
        }
        return nextWorld;
    }

    @Override
    public void setCell(int x, int y, boolean live) {
        if (y<0 || y>=getHeight()) return;
        if (x<0 || x>=getWidth()) return;
        if (live)
            world[y][x] = 0;
    }

    public int getCellAge(int x, int y) {
        if (y<0 || y>=getHeight()) return Integer.MAX_VALUE;
        if (x<0 || x>=getWidth()) return Integer.MAX_VALUE;
        return world[y][x];
    }

    @Override
    protected String getCellAsString(int x, int y) {
        int age = getCellAge(x,y);
        if (age > 9) return "_";
        if (age == 0) return "#";
        return age+"";
    }
}
