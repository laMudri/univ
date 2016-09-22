package uk.ac.cam.jdw74.ai1;

import java.lang.Exception;
import java.util.Arrays;
import java.util.LinkedList;

public class AlphaBeta {
  private static int player(int alpha, int beta, Node n) throws Exception {
    if (n instanceof Leaf) return ((Leaf)n).value;
    if (n instanceof Branch) {
      Branch b = (Branch)n;
      int value = Integer.MIN_VALUE;
      for (Node c : b.children) {
        int cv = opponent(alpha, beta, c);
        if (cv > value) {
          if (cv > beta) return cv;
          if (cv > alpha) alpha = cv;
          value = cv;
        }
      }
      return value;
    }
    else throw new Exception("Not part of a tree");
  }

  private static int opponent(int alpha, int beta, Node n) throws Exception {
    if (n instanceof Leaf) return ((Leaf)n).value;
    if (n instanceof Branch) {
      Branch b = (Branch)n;
      int value = Integer.MAX_VALUE;
      for (Node c : b.children) {
        int cv = player(alpha, beta, c);
        if (cv < value) {
          if (cv < alpha) return cv;
          if (cv < beta) beta = cv;
          value = cv;
        }
      }
      return value;
    }
    else throw new Exception("Not part of a tree");
  }

  public static void main(String[] args) {
    Node root =
      new Branch(new LinkedList<>(Arrays.asList(
        new Branch(new LinkedList<>(Arrays.asList(
          new Branch(new LinkedList<>(Arrays.asList(
            new Branch(new LinkedList<>(Arrays.asList(
              new Leaf(1),
              new Leaf(45)
            ))),
            new Branch(new LinkedList<>(Arrays.asList(
              new Leaf(2),
              new Leaf(19)
            )))
          ))),
          new Branch(new LinkedList<>(Arrays.asList(
            new Branch(new LinkedList<>(Arrays.asList(
              new Leaf(18),
              new Leaf(23)
            ))),
            new Branch(new LinkedList<>(Arrays.asList(
              new Leaf(4),
              new Leaf(3)
            )))
          )))
        ))),
        new Branch(new LinkedList<>(Arrays.asList(
          new Branch(new LinkedList<>(Arrays.asList(
            new Branch(new LinkedList<>(Arrays.asList(
              new Leaf(2),
              new Leaf(1)
            ))),
            new Branch(new LinkedList<>(Arrays.asList(
              new Leaf(7),
              new Leaf(8)
            )))
          ))),
          new Branch(new LinkedList<>(Arrays.asList(
            new Branch(new LinkedList<>(Arrays.asList(
              new Leaf(9),
              new Leaf(10)
            ))),
            new Branch(new LinkedList<>(Arrays.asList(
              new Leaf(2),
              new Leaf(5)
            )))
          )))
        ))),
        new Branch(new LinkedList<>(Arrays.asList(
          new Branch(new LinkedList<>(Arrays.asList(
            new Branch(new LinkedList<>(Arrays.asList(
              new Leaf(1),
              new Leaf(30)
            ))),
            new Branch(new LinkedList<>(Arrays.asList(
              new Leaf(4),
              new Leaf(7)
            )))
          ))),
          new Branch(new LinkedList<>(Arrays.asList(
            new Branch(new LinkedList<>(Arrays.asList(
              new Leaf(20),
              new Leaf(4)
            ))),
            new Branch(new LinkedList<>(Arrays.asList(
              new Leaf(4),
              new Leaf(5)
            )))
          )))
        )))
      )));
    try {
      System.out.println(player(Integer.MIN_VALUE, Integer.MAX_VALUE, root));
      System.out.println(opponent(Integer.MIN_VALUE, Integer.MAX_VALUE, root));
    }
    catch (Exception e) { e.printStackTrace(); }
  }
}
