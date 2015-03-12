package uk.ac.cam.jdw74.tick3;

class StringArrayLife {
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

        String formatString = args[0];
        String[] parts = formatString.split(":");
        if (parts.length != 7) {
            System.out.println("Error: incorrect format");
            return;
        }

        String name = parts[0];
        String author = parts[1];
        int width = Integer.parseInt(parts[2]);
        int height = Integer.parseInt(parts[3]);
        int x = Integer.parseInt(parts[4]);
        int y = Integer.parseInt(parts[5]);
        String pattern = parts[6];

        String[] rows = pattern.split(" ");
        int patternHeight = rows.length;
        int patternWidth = rows[0].length();
        char[][] cells = new char[patternHeight][patternWidth];
        for (int i = 0; i < cells.length; i++)
            cells[i] = rows[i].toCharArray();

        boolean[][] world = new boolean[height][width];

        for (int i = 0; i < patternHeight; i++)
            for (int j = 0; j < patternWidth; j++)
                setCell(world, x + j, y + i, cells[i][j] == '1');

        play(world);
    }
}
