package uk.ac.cam.jdw74.ai1;

import java.lang.Iterable;

public class Branch implements Node {
  public Iterable<Node> children;

  public Branch(Iterable<Node> children) {
    this.children = children;
  }
}
