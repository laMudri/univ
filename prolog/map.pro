nextTo(0,1).
nextTo(0,3).
nextTo(0,6).
nextTo(0,7).
nextTo(1,2).
nextTo(1,3).
nextTo(1,4).
nextTo(2,4).
nextTo(2,5).
nextTo(3,4).
nextTo(3,7).
nextTo(4,5).
nextTo(4,7).
nextTo(5,7).
nextTo(6,7).

take([X|XS],Y,[X|YS]) :- take(XS,Y,YS).
take([X|XS],X,XS).

good(AS,CS,I,[]).
good(AS,CS,I,[X|XS]) :- , J is 1 + I, good(J,XS)
