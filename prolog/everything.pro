a(hello).
a(world).
a(foo).
a(bar).

notIn(_,[]).
notIn(X,[Y|YS]) :- X \= Y, notIn(X,YS).

everything(XS,YS) :- a(X), notIn(X,XS), !, everything(XS,[X|YS]).
everything(A,A).
