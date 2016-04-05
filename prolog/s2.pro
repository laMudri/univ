eval(plus(A,B),C) :- !, eval(A,AE), eval(B,BE), C is AE + BE.
eval(mult(A,B),C) :- !, eval(A,AE), eval(B,BE), C is AE * BE.
eval(subt(A,B),C) :- !, eval(A,AE), eval(B,BE), C is AE - BE.
eval(divd(A,B),C) :- !, eval(A,AE), eval(B,BE), C is AE // BE.
eval(A,A).

choose(0,XS,[],XS) :- !.
choose(N,[X|XS],[X|LS],RS) :- Nm1 is N - 1, choose(Nm1,XS,LS,RS).
choose(N,[X|XS],LS,[X|RS]) :- choose(N,XS,LS,RS).

isGreater(A,B) :- eval(A,AE), eval(B,BE), AE > BE.
notOne(A) :- eval(A,AE), AE =\= 1.
isFactor(A,B) :- eval(A,AE), eval(B,BE), 0 is BE rem AE.

arithop(A,B,plus(A,B)).
arithop(A,B,subt(A,B)) :- isGreater(A,B).
arithop(A,B,subt(B,A)) :- isGreater(B,A).
arithop(A,B,mult(A,B)) :- notOne(A), notOne(B).
arithop(A,B,divd(A,B)) :- notOne(B), isFactor(B,A).
arithop(A,B,divd(B,A)) :- notOne(A), isFactor(A,B).

countdown([S|_],T,S) :- eval(S,T).
countdown(XS,T,S) :-
  choose(2,XS,[A,B],RS), arithop(A,B,C), countdown([C|RS],T,S).

%%%

minRest([X|XS],Y,[X|YS]) :- minRest(XS,Y,YS), X >= Y, !.
minRest([X|XS],X,XS).

minSort([],[]) :- !.
minSort(XS,[X|ZS]) :- minRest(XS,X,YS), minSort(YS,ZS).

pivot(_,[],[],[]).
pivot(X,[Y|YS],[Y|LS],RS) :- Y =< X, !, pivot(X,YS,LS,RS).
pivot(X,[Y|YS],LS,[Y|RS]) :- pivot(X,YS,LS,RS).

quicksort([],[]).
quicksort([X|XS],YS) :-
  pivot(X,XS,LS,RS), !, quicksort(LS,SLS), quicksort(RS,SRS),
  append(SLS,[X|SRS],YS).

pivot3(_,[],[],[],[]).
pivot3(X,[X|YS],LS,[X|CS],RS) :- !, pivot3(X,YS,LS,CS,RS).
pivot3(X,[Y|YS],[Y|LS],CS,RS) :- Y < X, !, pivot3(X,YS,LS,CS,RS).
pivot3(X,[Y|YS],LS,CS,[Y|RS]) :- pivot3(X,YS,LS,CS,RS).

quicksort3([],[]).
quicksort3([X|XS],YS) :-
  pivot3(X,XS,LS,CS,RS), !, quicksort3(LS,SLS), quicksort3(RS,SRS),
  append([X|CS],SRS,ZS), append(SLS,ZS,YS).

dnfDo(XS-XP,RS-RP,WS-WP,BS-BP) :-
  unify_with_occurs_check(XS,XP),
  unify_with_occurs_check(RS,RP),
  unify_with_occurs_check(WS,WP),
  unify_with_occurs_check(BS,BP).
dnfDo([r|XS]-XP,[r|RS]-RP,WS-WP,BS-BP) :- dnfDo(XS-XP,RS-RP,WS-WP,BS-BP).
dnfDo([w|XS]-XP,RS-RP,[w|WS]-WP,BS-BP) :- dnfDo(XS-XP,RS-RP,WS-WP,BS-BP).
dnfDo([b|XS]-XP,RS-RP,WS-WP,[b|BS]-BP) :- dnfDo(XS-XP,RS-RP,WS-WP,BS-BP).

dnf(XS-XP,YS-YP) :- dnfDo(XS-XP,YS-WS,WS-BS,BS-YP).

:- use_module(library(clpfd)).

solve1(Base,[S,E,N,D],[M,O,R,E],[M,O,N,E,Y]) :-
  Var = [S,E,N,D,M,O,R,Y],
  TopDigit is Base - 1,
  Var ins 0 .. TopDigit, all_different(Var),
  S #\= 0, M #\= 0,
  Base ^ 3 * S + Base ^ 2 * E + Base * N + D +
  Base ^ 3 * M + Base ^ 2 * O + Base * R + E #=
  Base ^ 4 * M + Base ^ 3 * O + Base ^ 2 * N + Base * E + Y,
  labeling([],Var).
