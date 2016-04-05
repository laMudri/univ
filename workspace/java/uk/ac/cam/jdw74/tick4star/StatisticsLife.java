package uk.ac.cam.jdw74.tick4star;

import java.util.List;
import java.util.ArrayList;

class StatisticsLife {
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

    public static Statistics analyse(Pattern p) throws PatternFormatException {
        boolean[][] world = new boolean[p.getHeight()][p.getWidth()];
        p.initialise(world);
        return new Statistics(world, p.getName());
    }

    public static void main(String[] args) throws Exception {
        if (args.length == 0) {
            System.out.println("No argument given");
            return;
        }

        List<Pattern> ps;
        String path = args[0];
        if (path.contains("://"))
            ps = PatternLoader.loadFromURL(path);
        else
            ps = PatternLoader.loadFromDisk(path);

        if (args.length == 1) {
            List<Statistics> stats = new ArrayList<>();
            for (Pattern p : ps) {
                System.out.println("Analysing " + p.getName());
                stats.add(analyse(p));
            }

            System.out.println();

            int longestStart = 0;
            String nameWithLongestStart = "";
            int longestCycle = 0;
            String nameWithLongestCycle = "";
            double biggestGrowthRate = 0.0;
            String nameWithBiggestGrowthRate = "";
            double biggestDeathRate = 0.0;
            String nameWithBiggestDeathRate = "";
            int largestPopulation = 0;
            String nameWithLargestPopulation = "";
            for (Statistics s : stats) {
                String name = s.getName();
                int start = s.getLoopStart();
                int cycle = s.getLoopEnd() - start;
                double growthRate = s.getMaximumGrowthRate();
                double deathRate = s.getMaximumDeathRate();
                int population = s.getMaximumPopulation();
                if (start > longestStart) {
                    longestStart = start;
                    nameWithLongestStart = name;
                }
                if (cycle > longestCycle) {
                    longestCycle = cycle;
                    nameWithLongestCycle = name;
                }
                if (growthRate > biggestGrowthRate) {
                    biggestGrowthRate = growthRate;
                    nameWithBiggestGrowthRate = name;
                }
                if (deathRate > biggestDeathRate) {
                    biggestDeathRate = deathRate;
                    nameWithBiggestDeathRate = name;
                }
                if (population > largestPopulation) {
                    largestPopulation = population;
                    nameWithLargestPopulation = name;
                }
            }

            System.out.println("Longest start: " + nameWithLongestStart + " (" +
                               Integer.toString(longestStart) + ")");
            System.out.println("Longest cycle: " + nameWithLongestCycle + " (" +
                               Integer.toString(longestCycle) + ")");
            System.out.println("Biggest growth rate: " +
                               nameWithBiggestGrowthRate + " (" +
                               Double.toString(biggestGrowthRate) + ")");
            System.out.println("Biggest death rate: " +
                               nameWithBiggestDeathRate + " (" +
                               Double.toString(biggestDeathRate) + ")");
            System.out.println("Largest population: " +
                               nameWithLargestPopulation + " (" +
                               Integer.toString(largestPopulation) + ")");
        }
        else if (args.length == 2)
            try {
                Pattern p = ps.get(Integer.parseInt(args[1]));
                boolean[][] world = new boolean[p.getHeight()][p.getWidth()];
                p.initialise(world);
                play(world);
            }
            catch (IndexOutOfBoundsException | NumberFormatException e) {
                System.out.println("Second argument is not a valid index");
            }
            catch (PatternFormatException e) {
                System.out.println("Malformed pattern");
            }
        else {
            System.out.println("Too many arguments");
            return;
        }
    }
}
