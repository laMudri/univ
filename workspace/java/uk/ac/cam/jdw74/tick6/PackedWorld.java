package uk.ac.cam.jdw74.tick6;

public class PackedWorld extends WorldImpl {
    private int generation;
    private long cells;

    public PackedWorld() {
        super(8, 8);
        cells = 0;
    }

    protected PackedWorld(PackedWorld prev) {
        super(prev);
        cells = 0;
    }

    @Override
    public boolean getCell(int col, int row) {
        return 0 <= row && row < 8 && 0 <= col && col < 8 ?
            PackedLong.get(cells, row * 8 + col) : false;
    }

    @Override
    public void setCell(int col, int row, boolean alive) {
        if (0 <= row && row < 8 && 0 <= col && col < 8)
            cells = PackedLong.set(cells, row * 8 + col, alive);
    }

    @Override
    protected PackedWorld nextGeneration() {
        PackedWorld world = new PackedWorld(this);
        for (int i = 0; i < 8; i++)
            for (int j = 0; j < 8; j++)
                world.setCell(j, i, computeCell(j, i));
        return world;
    }
}
