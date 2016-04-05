canBeOn(_,[]).
canBeOn(X,[Y|_]) :- X =< Y.

nextState(([X|XS],YS,ZS),(XS,[X|YS],ZS)) :- canBeOn(X,YS).
nextState(([X|XS],YS,ZS),(XS,YS,[X|ZS])) :- canBeOn(X,ZS).
nextState((XS,[Y|YS],ZS),([Y|XS],YS,ZS)) :- canBeOn(Y,XS).
nextState((XS,[Y|YS],ZS),(XS,YS,[Y|ZS])) :- canBeOn(Y,ZS).
nextState((XS,YS,[Z|ZS]),([Z|XS],YS,ZS)) :- canBeOn(Z,XS).
nextState((XS,YS,[Z|ZS]),(XS,[Z|YS],ZS)) :- canBeOn(Z,YS).

go(_,A,A,[A]).
go(ACC,A,C,[A|LS]) :- nextState(A,B), \+member(B,ACC), go([B|ACC],B,C,LS).

fullTower(N,N,[]) :- !.
fullTower(N,M,[M|XS]) :- NewM is M + 1, fullTower(N,NewM,XS).
fullTower(N,XS) :- fullTower(N,0,XS).

start(N,(XS,[],[])) :- fullTower(N,XS).
finish(N,([],[],ZS)) :- fullTower(N,ZS).

solve(N,LS) :- start(N,A), finish(N,B), go([A],A,B,LS).
