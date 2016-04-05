range03(0).
range03(1).
range03(2).
range03(3).

state((M,C)) :- range03(M), range03(C).

nextState((l,M,C),(r,NewM,NewC)) :-
  state((NewM,NewC)), abs(M - NewM) + abs(C - NewC) =< 2, NewM =< M, NewC =< C,
  (NewM = 0; NewM >= NewC).
nextState((r,M,C),(l,NewM,NewC)) :-
  state((NewM,NewC)), abs(M - NewM) + abs(C - NewC) =< 2, NewM >= M, NewC >= C,
  (NewM = 3; 3 - NewM >= 3 - NewC).

go(_,A,A,[]).
go(ACC,A,C,[B|LS]) :- nextState(A,B), \+member(B,ACC), go([B|ACC],B,C,LS).

solve([A|LS]) :- A = (l,3,3), B = (r,0,0), go([A],A,B,LS).
