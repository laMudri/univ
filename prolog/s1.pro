prim(z,0).
prim(s(X),N) :- prim(X,M), N is M + 1.

plusNat(z,X,X).
plusNat(s(X),Y,s(Z)) :- plusNat(X,Y,Z).
plus(A,B,C) :- prim(AN,A), prim(BN,B), prim(CN,C), plusNat(AN,BN,CN).

multNat(z,X,z).
multNat(s(X),Y,Z) :- multNat(X,Y,R), plusNat(Y,R,Z).
mult(A,B,C) :- prim(AN,A), prim(BN,B), prim(CN,C), multNat(AN,BN,CN).

snoc(X,[],[X]).
snoc(X,[Y|YS],[Y|ZS]) :- snoc(X,YS,ZS).

rev([],[]).
rev([X|XS],YS_X) :- snoc(X,YS,YS_X), rev(XS,YS).

revapp([],YS,YS).
revapp([X|XS],YS,ZS) :- revapp(XS,[X|YS],ZS).
rev1(XS,YS) :- revapp(XS,[],YS).

downfall(0,[]).
downfall(SN,[N|XS]) :- N is SN - 1, downfall(N,XS).

len([],Acc,Acc).
len([_|XS],Acc,R) :- Bcc is 1 + Acc, len(XS,Bcc,R).
len(XS,R) :- len(XS,0,R).

take([X|XS],X,XS).
take([X|XS],Y,[X|ZS]) :- take(XS,Y,ZS).

append([],YS,YS).
append([X|XS],YS,[X|ZS]) :- append(XS,YS,ZS).

neq(X,Y) :- X \= Y.

checkMainDiagonal(_,[]).
checkMainDiagonal(X,[z|YS]) :- checkMainDiagonal(s(X),YS).
checkMainDiagonal(X,[s(Y)|YS]) :- neq(X,Y), checkMainDiagonal(s(X),YS).

checkAlternateDiagonal(_,[]).
checkAlternateDiagonal(z,_).
checkAlternateDiagonal(s(X),[Y|YS]) :- neq(X,Y), checkAlternateDiagonal(X,YS).

checkDiagonals([]).
checkDiagonals([X|XS]) :-
  checkMainDiagonal(X,XS), checkAlternateDiagonal(X,XS), checkDiagonals(XS).

downfallNat(z,[]).
downfallNat(s(X),[X|XS]) :- downfallNat(X,XS).

permute([],[]).
permute(XS,[Y|YS]) :- take(XS,Y,ZS), permute(ZS,YS).

primList([],[]).
primList([X|XS],[Y|YS]) :- prim(X,Y), primList(XS,YS).

nqueens(N,R) :-
  prim(X,N), downfallNat(X,XS), permute(XS,YS),
  checkDiagonals(YS), primList(YS,R).
