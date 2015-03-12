package code;

import java.util.TreeMap;

public class S2l {
    public static void main(String[] args) {
        TreeMap<String,Double> map = new TreeMap<>();
        map.put("Alex", 13.0/0.2);
        map.put("Matthew", 20.0/0.2);
        map.put("Devan", 13.0/0.2);
        map.put("Laszlo", 12.0/0.2);
        map.put("Michael", 16.0/0.2);
        map.put("James", 13.0/0.2);
        Students ss = new Students(map);
        System.out.println(ss.alphabeticList());
        System.out.println(ss.topStudents(50.0));
        System.out.println(ss.median());
    }
}
