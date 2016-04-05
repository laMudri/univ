diffApp(XS-YS,YS-ZP,XS-ZP).

lift(_,XS-XP,YS-YP) :-
  unify_with_occurs_check(XS,XP), unify_with_occurs_check(YS,YP).
lift((OldAS,OldBS,OldCS),[(AS,BS,CS)|XP]-XP,[(NewAS,NewBS,NewCS)|YP]-YP) :-
  append(AS,OldAS,NewAS), append(BS,OldBS,NewBS), append(CS,OldCS,NewCS),
  lift((OldAS,OldBS,OldCS),XP-XP,YP-YP).

other(M,N,O) :- permutation([a,b,c],[M,N,O]).

snoc([],X,[X]) :- !.
snoc([X|XS],Y,[X|YS]) :- snoc(XS,Y,YS).

snocat(a,(AS,BS,CS),X,(NewAS,BS,CS)) :- snoc(AS,X,NewAS).
snocat(b,(AS,BS,CS),X,(AS,NewBS,CS)) :- snoc(BS,X,NewBS).
snocat(c,(AS,BS,CS),X,(AS,BS,NewCS)) :- snoc(CS,X,NewCS).

put(a,X,(X,[],[])).
put(b,X,([],X,[])).
put(c,X,([],[],X)).

go(M->N,State,[State,NewState|P]-P) :- put(M,[X],State), put(N,[X],NewState).
go(M->N,State,States) :-
  other(M,N,O),
  snocat(M,SmallState,Large,State),
  put(M,Init,SmallState),
  go(M->O,SmallState,FirstSmallStates),
  put(M,[Large],FirstLiftBase),
  lift(FirstLiftBase,FirstSmallStates,FirstStates),
  put(O,Init,MidSmallState),
  go(O->N,MidSmallState,LastSmallStates),
  put(N,[Large],LastLiftBase),
  lift(LastLiftBase,LastSmallStates,LastStates),
  diffApp(FirstStates,LastStates,States).
