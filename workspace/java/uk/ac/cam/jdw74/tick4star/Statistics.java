package uk.ac.cam.jdw74.tick4star;

import java.util.List;
import java.util.ArrayList;

public class Statistics {
    private String mName;
    private boolean[][] mWorld;
    private double mMaximumGrowthRate;
    private double mMaximumDeathRate;
    private int mLoopStart;
    private int mLoopEnd;
    private int mMaximumPopulation;

    public String getName() {
        return mName;
    }

    private static int getPopulation(boolean[][] w) {
        int r = 0;
        for (boolean[] a : w)
            for (boolean c : a)
                if (c) r++;
        return r;
    }

    private static boolean[][] copyWorld(boolean[][] w) {
        boolean[][] copy = new boolean[w.length][w[0].length];
        for (int i = 0; i < w.length; i++)
            for (int j = 0; j < w[i].length; j++)
                copy[i][j] = w[i][j];
        return copy;
    }

    public double getMaximumGrowthRate() {
        return mMaximumGrowthRate;
    }

    public double getMaximumDeathRate() {
        return mMaximumDeathRate;
    }

    public int getLoopStart() {
        return mLoopStart;
    }

    public int getLoopEnd() {
        return mLoopEnd;
    }

    public int getMaximumPopulation() {
        return mMaximumPopulation;
    }

    private static boolean worldsEqual(boolean[][] u, boolean[][] v) {
        for (int i = 0; i < u.length; i++)
            for (int j = 0; j < u[i].length; j++)
                if (u[i][j] != v[i][j])
                    return false;
        return true;
    }

    public Statistics(boolean[][] w, String name) {
        mWorld = w;
        mName = name;

        mMaximumGrowthRate = 0.0;
        mMaximumDeathRate = 0.0;
        mMaximumPopulation = getPopulation(w);

        List<boolean[][]> history = new ArrayList<>();
        history.add(w);
        int population = mMaximumPopulation;
        int generation = 0;
        boolean notFoundLoop = true;
        while (notFoundLoop) {
            double dLastPopulation = (double)population;
            history.add(StatisticsLife.nextGeneration(history.get(generation)));
            generation++;

            population = getPopulation(history.get(generation));
            double growthRate = ((double)population - dLastPopulation) /
                dLastPopulation;
            double deathRate = -growthRate;

            if (population > mMaximumPopulation)
                mMaximumPopulation = population;
            if (growthRate > mMaximumGrowthRate)
                mMaximumGrowthRate = growthRate;
            if (deathRate > mMaximumDeathRate)
                mMaximumDeathRate = deathRate;

            for (int i = 0; i < generation; i++) {
                if (worldsEqual(history.get(i), history.get(generation))) {
                    mLoopStart = i;
                    mLoopEnd = generation - 1;
                    notFoundLoop = false;
                }
            }
        }
    }
}
