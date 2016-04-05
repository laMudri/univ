time(a,1).  time(b,2).  time(c,5).  time(d,10).

yn(0).
yn(1).

halfState((A,B,C,D)) :- yn(D), yn(C), yn(B), yn(A).

changes((A,B,C,D),(A,NewB,NewC,NewD),CS) :-
  changesB((B,C,D),(NewB,NewC,NewD),CS), !.
changes((_,B,C,D),(_,NewB,NewC,NewD),[a|CS]) :-
  changesB((B,C,D),(NewB,NewC,NewD),CS).

changesB((B,C,D),(B,NewC,NewD),CS) :- changesC((C,D),(NewC,NewD),CS), !.
changesB((_,C,D),(_,NewC,NewD),[b|CS]) :- changesC((C,D),(NewC,NewD),CS).

changesC((C,D),(C,NewD),CS) :- changesD(D,NewD,CS), !.
changesC((_,D),(_,NewD),[c|CS]) :- changesD(D,NewD,CS).

changesD(D,D,[]) :- !.
changesD(_,_,[d]).

maxTimes([],0).
maxTimes([X|XS],T) :- time(X,U), maxTimes(XS,V), T is max(U,V).

lessThan(X,X) :- !, fail.
lessThan((A,B,C,D),(NewA,NewB,NewC,NewD)) :-
  A =< NewA, B =< NewB, C =< NewC, D =< NewD.

nextState((0,X),T,(1,Y)) :-
  halfState(Y), changes(X,Y,CS), length(CS,N), N =< 2, lessThan(X,Y),
  maxTimes(CS,T).
nextState((1,X),T,(0,Y)) :-
  halfState(Y), changes(X,Y,CS), length(CS,N), N =< 2, lessThan(Y,X),
  maxTimes(CS,T).

go(_,X,X,[],0).
go(ACC,X,Z,[Y|LS],NewT) :-
  nextState(X,CT,Y), \+member(Y,ACC), go([Y|ACC],Y,Z,LS,T), NewT is CT + T.

solve([A|LS],T) :- A = (0,(0,0,0,0)), go([A],A,(1,(1,1,1,1)),LS,T).
