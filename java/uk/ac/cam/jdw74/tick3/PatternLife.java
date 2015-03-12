package uk.ac.cam.jdw74.tick3;

class PatternLife {
    public static void print(boolean[][] world) {
        System.out.println("-");
        for (int row = 0; row < world.length; row++) {
            for (int col = 0; col < world[row].length; col++) {
                System.out.print(getCell(world, col, row) ? "#" : "_");
            }
            System.out.println();
        }
    }

    public static boolean getCell(boolean[][] world, int col, int row) {
        return 0 <= row && row < world.length &&
               0 <= col && col < world[row].length ?
            world[row][col] : false;
    }

    public static void setCell(boolean[][] world, int col, int row, boolean value) {
        if (0 <= row && row < world.length &&
            0 <= col && col < world[row].length)
            world[row][col] = value;
    }

    public static int countNeighbours(boolean[][] world, int col, int row) {
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

    public static boolean computeCell(boolean[][] world, int col, int row) {
        int count = countNeighbours(world, col, row);
        return count == 3 || (getCell(world, col, row) && count == 2);
    }

    public static boolean[][] nextGeneration(boolean[][] world) {
        boolean[][] nextWorld = new boolean[world.length][world[0].length];
        for (int row = 0; row < world.length; row++)
            for (int col = 0; col < world[row].length; col++)
                setCell(nextWorld, col, row,
                        computeCell(world, col, row));
        return nextWorld;
    }

    public static void play(boolean[][] world) throws Exception {
        int userResponse = 0;
        while (userResponse != 'q') {
            print(world);
            userResponse = System.in.read();
            world = nextGeneration(world);
        }
    }

    public static void main(String[] args) throws Exception {
         Pattern p = new Pattern(args[0]);
         boolean[][] world = new boolean[p.getHeight()][p.getWidth()];
         p.initialise(world);
         play(world);
    }
}
