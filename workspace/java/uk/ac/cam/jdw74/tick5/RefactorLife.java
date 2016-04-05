package uk.ac.cam.jdw74.tick5;

import java.util.List;
import java.io.OutputStreamWriter;
import java.io.Writer;
import uk.ac.cam.acr31.life.World;
import uk.ac.cam.acr31.life.WorldViewer;

class RefactorLife {
    public static void play(World world) throws Exception {
        int userResponse = 0;
        Writer w = new OutputStreamWriter(System.out);
        WorldViewer viewer = new WorldViewer();
        while (userResponse != 'q') {
            world.print(w);
            viewer.show(world);
            userResponse = System.in.read();
            world = world.nextGeneration(0);
        }
        viewer.close();
    }

    public static void main(String[] args) throws Exception {
        if (args.length == 0) {
            System.out.println("No argument given");
            return;
        }

        boolean flagGiven = args[0].startsWith("--");
        int flagOffset = flagGiven ? 1 : 0;
        int mode;
        if (flagGiven)
            switch (args[0]) {
            case "--array": mode = 0; break;
            case  "--long": mode = 1; break;
            case "--aging": mode = 2; break;
            default:
                System.out.println("Invalid flag given");
                return;
            }
        else
            mode = 0;

        List<Pattern> ps;
        String path = args[flagOffset + 0];
        if (path.contains("://"))
            ps = PatternLoader.loadFromURL(path);
        else
            ps = PatternLoader.loadFromDisk(path);

        if (args.length == flagOffset + 1) {
            int i = 0;
            for (Pattern p : ps) {
                System.out.println(Integer.toString(i) + ") " + p.toString());
                i++;
            }
        }
        else if (args.length == flagOffset + 2)
            try {
                Pattern p = ps.get(Integer.parseInt(args[flagOffset + 1]));
                World world = null;
                switch (mode) {
                case 0: world = new ArrayWorld(p.getWidth(), p.getHeight());
                    break;
                case 1: world = new PackedWorld();
                    break;
                case 2: world = new AgingWorld(p.getWidth(), p.getHeight());
                    break;
                }
                p.initialise(world);
                play(world);
            }
            catch (IndexOutOfBoundsException | NumberFormatException e) {
                System.out.println("Second argument is not a valid index");
            }
        else {
            System.out.println("Too many arguments");
            return;
        }
    }
}
