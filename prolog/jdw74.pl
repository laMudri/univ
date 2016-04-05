piece(['74', [[1,1,0,0,1,0], [0,1,0,1,0,0], [0,1,0,0,1,0], [0,1,0,0,1,1]]]).
piece(['65', [[1,1,0,0,1,1], [1,0,1,1,0,0], [0,0,1,1,0,0], [0,1,0,1,0,1]]]).
piece(['13', [[0,1,0,1,0,1], [1,1,0,1,0,1], [1,1,0,0,1,1], [1,1,0,0,1,0]]]).
piece(['Cc', [[0,0,1,1,0,0], [0,0,1,1,0,0], [0,1,0,0,1,0], [0,0,1,1,0,0]]]).
piece(['98', [[1,1,0,0,1,0], [0,1,0,0,1,0], [0,0,1,1,0,0], [0,0,1,1,0,1]]]).
piece(['02', [[0,0,1,1,0,0], [0,1,0,0,1,1], [1,0,1,1,0,0], [0,0,1,1,0,0]]]).

allPieces([
  ['74', [[1,1,0,0,1,0], [0,1,0,1,0,0], [0,1,0,0,1,0], [0,1,0,0,1,1]]],
  ['65', [[1,1,0,0,1,1], [1,0,1,1,0,0], [0,0,1,1,0,0], [0,1,0,1,0,1]]],
  ['13', [[0,1,0,1,0,1], [1,1,0,1,0,1], [1,1,0,0,1,1], [1,1,0,0,1,0]]],
  ['Cc', [[0,0,1,1,0,0], [0,0,1,1,0,0], [0,1,0,0,1,0], [0,0,1,1,0,0]]],
  ['98', [[1,1,0,0,1,0], [0,1,0,0,1,0], [0,0,1,1,0,0], [0,0,1,1,0,1]]],
  ['02', [[0,0,1,1,0,0], [0,1,0,0,1,1], [1,0,1,1,0,0], [0,0,1,1,0,0]]]]).

rotate(Xs, N, Ys) :- length(As, N), append(As, Bs, Xs), append(Bs, As, Ys).

revApp([], Ys, Ys).
revApp([X|Xs], Ys, Zs) :- revApp(Xs, [X|Ys], Zs).
reverse(Xs, Zs) :- revApp(Xs, [], Zs).

xor(0, 1).
xor(1, 0).

xorlist([], []).
xorlist([X|Xs], [Y|Ys]) :- xor(X, Y), xorlist(Xs, Ys).

range(Min, Max, Min) :- Min < Max.
range(Min, Max, R) :- NewMin is Min + 1, NewMin < Max, range(NewMin, Max, R).

%      S0              S0
%    ^--->|    =>    |<---^
% S3 |    | S1 => S1 |    | S3
%    |<---v    =>    v--->|
%      S2              S2
flipped([N, [S0, S1, S2, S3]], [N, [W, X, Y, Z]]) :-
  reverse(S0, W), reverse(S1, Z), reverse(S2, Y), reverse(S3, X).

orientation(P, 0, P).
orientation([N, Ss], Or, [N, Ts]) :- Or > 0, rotate(Ss, Or, Ts).
orientation([N, Ss], Or, [N, Ts]) :-
  Or < 0, M is -Or, flipped([N, Ss], [N, Xs]), rotate(Xs, M, Ts).

init([_], []).
init([X|Xs], [X|Ys]) :- init(Xs, Ys).
interior([_|Xs], Ys) :- init(Xs, Ys).

index([X|_], 0, X).
index([_|Xs], N, Y) :- M is N - 1, index(Xs, M, Y).

% Ignore corners, since they could be filled by the third side and checked
% elsewhere.
sideCompatible(S, T) :- interior(S, IS), interior(T, IT), xorlist(IS, IT).
compatible([_, Ss], X, [_, Ts], Y) :-
  index(Ss, X, S), index(Ts, Y, T), reverse(T, RT), sideCompatible(S, RT).

oneOfThree(1, 0, 0).
oneOfThree(0, 1, 0).
oneOfThree(0, 0, 1).

compatibleCorner([_, Ss], X, [_, Ts], Y, [_, Us], Z) :-
  index(Ss, X, [S|_]), index(Ts, Y, [T|_]), index(Us, Z, [U|_]),
  oneOfThree(S, T, U).

choose(Z, Xs, [Z|Xs]).
choose(Z, [X|Xs], [X|Ys]) :- choose(Z, Xs, Ys).
permute([], []).
permute([X|Xs], Ys) :- permute(Xs, Zs), choose(X, Zs, Ys).

puzzle([P0|Ps], [[P0, O0], [P1, O1], [P2, O2], [P3, O3], [P4, O4], [P5, O5]]) :-
  permute(Ps, [P1, P2, P3, P4, P5]),
  O0 = 0, range(-4, 4, O1), range(-4, 4, O2),
  range(-4, 4, O3), range(-4, 4, O4), range(-4, 4, O5),
  orientation(P0, O0, OP0), orientation(P1, O1, OP1), orientation(P2, O2, OP2),
  orientation(P3, O3, OP3), orientation(P4, O4, OP4), orientation(P5, O5, OP5),
  compatible(OP0, 2, OP1, 0),
  compatible(OP0, 3, OP2, 0),
  compatible(OP1, 3, OP2, 1),
  compatible(OP0, 1, OP3, 0),
  compatible(OP1, 1, OP3, 3),
  compatible(OP1, 2, OP4, 0),
  compatible(OP2, 2, OP4, 3),
  compatible(OP3, 2, OP4, 1),
  compatible(OP4, 2, OP5, 0),
  compatible(OP2, 3, OP5, 3),
  compatible(OP0, 0, OP5, 2),
  compatible(OP3, 1, OP5, 1),
  compatibleCorner(OP0, 1, OP1, 0, OP2, 1),
  compatibleCorner(OP0, 2, OP1, 1, OP3, 0),
  compatibleCorner(OP2, 2, OP1, 3, OP4, 0),
  compatibleCorner(OP3, 3, OP1, 2, OP4, 1),
  compatibleCorner(OP5, 0, OP4, 3, OP2, 3),
  compatibleCorner(OP5, 2, OP0, 1, OP3, 1),
  compatibleCorner(OP5, 3, OP0, 0, OP2, 0).

goal :- allPieces(Ps), puzzle(Ps, _).
