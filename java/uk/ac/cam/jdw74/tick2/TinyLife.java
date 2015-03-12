package uk.ac.cam.jdw74.tick2;

class TinyLife {
    public static void print(long world) {
        System.out.println("-");
        for (int row = 0; row < 8; row++) {
            for (int col = 0; col < 8; col++) {
                System.out.print(getCell(world, col, row) ? "#" : "_");
            }
            System.out.println();
        }
    }

    public static boolean getCell(long world, int col, int row) {
        return 0 <= col && 0 <= row && col < 8 && row < 8 ?
            PackedLong.get(world, row * 8 + col) : false;
    }

    public static long setCell(long world, int col, int row, boolean value) {
        return 0 <= col && 0 <= row && col < 8 && row < 8 ?
            PackedLong.set(world, row * 8 + col, value) : world;
    }

    public static int countNeighbours(long world, int col, int row) {
        return
            (getCell(world, col - 1, row - 1) ? 1 : 0)
          + (getCell(world, col    , row - 1) ? 1 : 0)
          + (getCell(world, col + 1, row - 1) ? 1 : 0)
          + (getCell(world, col - 1, row    ) ? 1 : 0)
          + (getCell(world, col + 1, row    ) ? 1 : 0)
          + (getCell(world, col - 1, row + 1) ? 1 : 0)
          + (getCell(world, col    , row + 1) ? 1 : 0)
          + (getCell(world, col + 1, row + 1) ? 1 : 0);
    }

    // Skeleton looks awful
    public static boolean computeCell(long world, int col, int row) {
        int count = countNeighbours(world, col, row);
        return count == 3 || (getCell(world, col, row) && count == 2);
    }

    /*public static boolean computeCell(long world,int col,int row) {

        // liveCell is true if the cell at position (col,row) in world is live
        boolean liveCell = getCell(world, col, row);
        
        // neighbours is the number of live neighbours to cell (col,row)
        int neighbours = countNeighbours(world, col, row);

        // we will return this value at the end of the method to indicate whether 
        // cell (col,row) should be live in the next generation
        boolean nextCell = false;
        
        //A live cell with less than two neighbours dies (underpopulation)
        if (neighbours < 2) {
            nextCell = false;
        }
 
        //A live cell with two or three neighbours lives (a balanced population)
        else if (liveCell && (neighbours == 2 || neighbours == 3))
            nextCell = true;

        //A live cell with with more than three neighbours dies (overcrowding)
        else if (neighbours > 3)
            nextCell = false;

        //A dead cell with exactly three live neighbours comes alive
        if (neighbours == 3)
            nextCell = true;
        
        return nextCell;
    }*/

    public static long nextGeneration(long world) {
        long nextWorld = 0;
        for (int col = 0; col < 8; col++)
            for (int row = 0; row < 8; row++)
                nextWorld = setCell(nextWorld, col, row,
                                    computeCell(world, col, row));
        return nextWorld;
    }

    public static void play(long world) throws Exception {
        int userResponse = 0;
        while (userResponse != 'q') {
            print(world);
            userResponse = System.in.read();
            world = nextGeneration(world);
        }
    }

    public static void main(String[] args) throws Exception {
        play(Long.decode(args[0]));
    }
}
