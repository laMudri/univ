package uk.ac.cam.jdw74.tick5;

public class ArrayWorld extends WorldImpl {
    private boolean[][] cells;

    public ArrayWorld(int w, int h) {
        super(w, h);
        this.cells = new boolean[h][w];
    }

    protected ArrayWorld(ArrayWorld prev) {
        super(prev);
        this.cells = new boolean[prev.getHeight()][prev.getWidth()];
    }

    @Override
    public boolean getCell(int col, int row) {
        return 0 <= row && row < getHeight() &&
               0 <= col && col < getWidth() ?
            cells[row][col] : false;
    }

    @Override
    public void setCell(int col, int row, boolean alive) {
        if (0 <= row && row < getHeight() &&
            0 <= col && col < getWidth())
            cells[row][col] = alive;
    }

    @Override
    protected ArrayWorld nextGeneration() {
        ArrayWorld world = new ArrayWorld(this);
        for (int i = 0; i < getHeight(); i++)
            for (int j = 0; j < getWidth(); j++)
                world.setCell(j, i, computeCell(j, i));
        return world;
    }
}
