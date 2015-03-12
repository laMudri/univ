package uk.ac.cam.jdw74.tick7;
import javax.swing.JFrame;       import java.awt.event.ActionListener;
import javax.swing.JLabel;       import java.awt.event.ActionEvent;
import javax.swing.JButton;      import javax.swing.BoxLayout;

public class HelloActionWorld2 extends JFrame {

    HelloActionWorld2() {
        //create window & set title text
        super("Hello Action");
        //close button on window quits app.
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        //configure the layout of the pane associated with this window as a
        //  "BoxLayout"
        setLayout(new BoxLayout(getContentPane(),BoxLayout.Y_AXIS));
        //create graphical text label
        JLabel label = new JLabel("Button unpressed");
        add(label);  //associate "label" with window
        JButton button = new JButton("Press me"); //create graphical button
        add(button); //associated "button" with window
        //create an instance of an anonymous inner class to hand the event
        button.addActionListener(new ActionListener(){
                private int count = 0;

                public void actionPerformed(ActionEvent e) {
                    count++;
                    label.setText(count == 1 ?
                                  "Button pressed 1 time" :
                                  "Button pressed " + Integer.toString(count) +
                                  " times");
                }
            });
        setSize(320,240);                        //set size of window
    }

    public static void main(String[] args) {
        HelloActionWorld2 hello = new HelloActionWorld2(); //create instance
        hello.setVisible(true);                          //display window to user
    }
}
