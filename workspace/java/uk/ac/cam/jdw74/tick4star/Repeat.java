package uk.ac.cam.jdw74.tick4star;

public class Repeat {
    public static void main(String[] args) {
        System.out.println(parseAndRep(args));
    }

    public static String parseAndRep(String[] args) {
        if (args.length < 2)
            return "Error: insufficient arguments";
        int n;
        try {
            n = Integer.parseInt(args[1]);
            if (n < 1) throw new NumberFormatException();
        } catch (NumberFormatException ex) {
            return "Error: second argument is not a positive integer";
        }

        int i = n;
        String r = "";
        while (i > 1) {
            r += args[0] + " ";
            i--;
        }
        return r + args[0];
    }
}
