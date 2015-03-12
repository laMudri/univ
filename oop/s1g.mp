input metauml;
beginfig(1);
  Class.U("University")()();
  Class.C("Course")()();
  Class.L("Lecturer")("name", "officeNumber")();
  Class.S("Student")("name", "specialisation")();

  topToBottom(60)(U, C);
  leftToRight(60)(C, S);
  leftToRight(60)(L, C);

  drawObjects(U, C, L, S);

  clink(associationUni)(U, C);
  item(iAssoc)("0..*")(obj.se = C.n);
  item(iAssoc)("1")(obj.ne = U.s);
  clink(associationUni)(C, S);
  item(iAssoc)("0..*")(obj.sw = C.e);
  item(iAssoc)("0..*")(obj.se = S.w);
  clink(associationUni)(C, L);
  item(iAssoc)("1")(obj.sw = L.e);
  item(iAssoc)("0..*")(obj.se = C.w);
endfig;
end
