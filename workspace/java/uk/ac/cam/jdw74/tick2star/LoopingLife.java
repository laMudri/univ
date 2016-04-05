package uk.ac.cam.jdw74.tick2star;

class LoopingLife {
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

    public static long nextGeneration(long world) {
        long nextWorld = 0;
        for (int col = 0; col < 8; col++)
            for (int row = 0; row < 8; row++)
                nextWorld = setCell(nextWorld, col, row,
                                    computeCell(world, col, row));
        return nextWorld;
    }

    public static void findLoop(long world) {
        long[] history = new long[100];
        int j = 0;
        history[0] = world;
        while (j <= 100) {
            history[j + 1] = nextGeneration(history[j]);
            j++;
            for (int i = j - 1; i >= 0; i--)
                if (history[i] == history[j]) {
                    System.out.println(i + " to " + (j - 1));
                    return;
                }
        }
        System.out.println("No loops found");
    }

    public static void main(String[] args) {
        findLoop(Long.decode(args[0]));
    }
}
