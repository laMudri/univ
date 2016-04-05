winner((X,X,X,_,_,_,_,_,_),X) :- X \= e.
winner((_,_,_,X,X,X,_,_,_),X) :- X \= e.
winner((_,_,_,_,_,_,X,X,X),X) :- X \= e.
winner((X,_,_,X,_,_,X,_,_),X) :- X \= e.
winner((_,X,_,_,X,_,_,X,_),X) :- X \= e.
winner((_,_,X,_,_,X,_,_,X),X) :- X \= e.
winner((X,_,_,_,X,_,_,_,X),X) :- X \= e.
winner((_,_,X,_,X,_,X,_,_),X) :- X \= e.
winner(_,e).

move(P,B)
