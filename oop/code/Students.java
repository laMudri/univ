package code;

import java.util.TreeMap;
import java.util.ArrayList;
import java.util.Map;
import java.util.Collections;

public class Students {
    TreeMap<String,Double> mStudents = new TreeMap<>();

    public ArrayList<String> alphabeticList() {
        return new ArrayList<>(mStudents.keySet());
    }

    // arr is in descending order on values
    private ArrayList<Map.Entry<String,Double>> insert(
            ArrayList<Map.Entry<String,Double>> arr,
            Map.Entry<String,Double> e) {
        for (int i = arr.size() - 1; i >= 0; i--) {
            if (e.getValue() <= arr.get(i).getValue()) {
                arr.add(i + 1, e);
                return arr;
            }
        }
        arr.add(0, e);
        return arr;
    }

    public ArrayList<String> topStudents(double percentage) {
        int n = (int)Math.round(
                    (double)mStudents.size() * (percentage / 100));
        ArrayList<Map.Entry<String,Double>> acc = new ArrayList<>(n + 1);
        for (Map.Entry<String,Double> e : mStudents.entrySet()) {
            acc = insert(acc, e);
            if (acc.size() == n + 1)
                acc.remove(n);
        }

        ArrayList<String> ret = new ArrayList<>();
        for (Map.Entry<String,Double> e : acc)
            ret.add(e.getKey());
        return ret;
    }

    public Double median() {
        ArrayList<Double> sortedScores =
            new ArrayList<Double>(mStudents.values());
        Collections.sort(sortedScores);
        int l = sortedScores.size();
        if (l % 2 == 0)
            return (sortedScores.get(l / 2 - 1) + sortedScores.get(l / 2))
                / 2;
        else
            return sortedScores.get(l / 2);
    }

    public Students(TreeMap<String,Double> students) {
        mStudents = students;
    }
}
