package uk.ac.cam.jdw74.tick7;

import javax.swing.JPanel;
import javax.swing.JList;
import java.awt.BorderLayout;
import javax.swing.JScrollPane;
import java.util.List;
import java.util.ArrayList;
import javax.swing.event.ListSelectionListener;
import javax.swing.event.ListSelectionEvent;

public abstract class PatternPanel extends JPanel {
    private JList guiList;
    private Pattern currentPattern;
    private List<Pattern> patternList;

    protected abstract void onPatternChange();

    public PatternPanel() {
        super();
        setLayout(new BorderLayout());
        guiList = new JList();
        add(new JScrollPane(guiList));
        currentPattern = null;
        patternList = null;

        guiList.addListSelectionListener(new ListSelectionListener() {
                public void valueChanged(ListSelectionEvent e) {
                    if (!e.getValueIsAdjusting() && (patternList != null)) {
                        int sel = guiList.getSelectedIndex();
                        if (sel != -1) {
                            currentPattern = patternList.get(sel);
                            onPatternChange();
                        }
                    }
                }
            });
    }

    public void setPatterns(List<Pattern> list) {
        patternList = list;
        if (list == null) {
            currentPattern = null; //if list is null, then no valid pattern
            guiList.setListData(new String[]{}); //no list item to select
            return;
        }

        ArrayList<String> names = new ArrayList<String>();

        for (Pattern p : list) {
            names.add(p.getName() + " (" + p.getAuthor() + ")");
        }

        guiList.setListData(names.toArray());
        currentPattern = list.get(0); //select first element in list
        guiList.setSelectedIndex(0);  //select first element in guiList
    }

    public Pattern getCurrentPattern() {
        return currentPattern;
    }
}
