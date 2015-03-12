package uk.ac.cam.jdw74.tick6;

import javax.swing.JFrame;
import javax.swing.JLabel;

public class HelloSwingWorld extends JFrame {
    HelloSwingWorld() {
        super("Hello Swing");
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        JLabel text = new JLabel("Hello Swing");
        add(text);
        setSize(320,240);
    }

    public static void main(String[] args) {
        HelloSwingWorld hello = new HelloSwingWorld();
        hello.setVisible(true);
    }
}
