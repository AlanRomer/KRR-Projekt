%Start
rp(D,X,Y,0,1,0) :- init(object(robot,D),value(at,(X,Y))).
plan(D,D,1) :- init(object(robot,D),value(at,(_,_))).
maxplan(G,J):- occurs(object(robot,G),action(move,(_,_)),J), not occurs(object(robot,G), action(move,(_,_)),J+1).
maxmove(K):- occurs(object(robot,_),action(move,(_,_)),J), not occurs(object(robot,_), action(move,(_,_)),J+1), K=J+S+1, rc(S).
maxit(U):- rc(S), U=S*2.
rp(D,X+V,Y+W,T+1,I,J+1):- rp(D,X,Y,T,I,J), occurs(object(robot,G),action(move,(V,W)),J+1), not stop(T,I), plan(D,G,I), T<K, maxmove(K), I<U, maxit(U). %normal move

plan(D,G,I+1):-rp(D,X,Y,T,I,J), rp(Q,_,_,T,I+1,_), plan(D,G,I), not switch(D,_,X,Y,T,I), not static(D,_,T,I), not waitposs(D,_,T,I), not switch(_,D,X,Y,T,I), not static(_,D,T,I), not waitposs(_,D,T,I).

rp(D,X,Y,T,I+1,J):-rp(D,X,Y,T,I,J), rp(E,_,_,T,I+1,_), not rp(E,X,Y,T,I+1,_), not wp(D,_,T,I+1), not back(D,T,I+1), E!=D, T<K, maxmove(K), I<U, maxit(U).

rp(D,V,W,T,I+1,J):-rp(D,X,Y,T,I,_), rp(D,V,W,T-1,I,J), rp(E,X,Y,T,I+1,_), not wp(D,_,T,I+1), back(E,T,I+1), E!=D.
back(D,T,I+1):-rp(D,X,Y,T,I,_), rp(D,V,W,T-1,I,J), rp(E,X,Y,T,I+1,_), not wp(D,_,T,I+1), E!=D.

static(D,Q,T,I):- rp(Q,X,Y,T,I,N), plan(D,G,I), order(G,X,Y), finish(G,H,J), H<T+1, J<I+1, D!=Q, T<K, maxmove(K), I<U, maxit(U).
rp(D,X+V,Y+W,T,I,J+1):- static(D,Q,T,I), rp(Q,X,Y,T,I,J), occurs(object(robot,G),action(move,(V,W)),J+1), plan(Q,G,I).
plan(D,G,I+1):-static(D,Q,T,I), plan(Q,G,I+1).
plan(Q,G,I+1):-static(D,Q,T,I), plan(D,G,I+1).
stop(T,I):-static(_,_,T,I).

waitposs(D,Q,T,I):- rp(D,X,Y,T,I,M), rp(Q,X,Y,T,I,N), D<Q, not static(_,D,T,I), T<K, maxmove(K), I<U, maxit(U). 
wp(D,Q,T,I+1):- waitposs(D,Q,T,I), rp(D,X,Y,T,I,M), rp(Q,X,Y,T,I,N),  plan(D,G,I+1), plan(Q,F,I+1), maxplan(G,H), maxplan(F,J), H-M<J-N.
wp(Q,D,T,I+1):- waitposs(D,Q,T,I), rp(D,X,Y,T,I,M), rp(Q,X,Y,T,I,N),  plan(D,G,I+1), plan(Q,F,I+1), maxplan(G,H), maxplan(F,J), H-M>J-N.
1{wp(D,Q,T,I+1); wp(Q,D,T,I+1)}1:- waitposs(D,Q,T,I), rp(D,X,Y,T,I,M), rp(Q,X,Y,T,I,N),  plan(D,G,I+1), plan(Q,F,I+1), maxplan(G,H), maxplan(F,J), H-M=J-N.
plan(D,G,I+1):-waitposs(D,Q,T,I), plan(D,G,I+1).
plan(Q,G,I+1):-waitposs(D,Q,T,I), plan(Q,G,I+1).
back(Q,T,I+1):-wp(Q,D,T,I+1).
stop(T,I):-waitposs(_,_,T,I).
rp(D,V2,W2,T,I+1,L-1):-wp(D,Q,T,I+1), rp(D,V2,W2,T-1,I,L-1), T<K, maxmove(K), I<U, maxit(U). %stop for a turn


order(G,X,Y) :- init(object(shelf,G),value(at,(X,Y))).
rc(S) :- S = #count{ D : init(object(robot,D),value(at,(X,Y))) }.
finish(G,T,I):- rp(_,_,_,T,I,_), rp(D,X,Y,T,I,_), plan(D,G,I), order(G,X,Y).
final(T+2,I):- rp(_,_,_,T,I,_), not rp(_,_,_,T+1,_,_), rc(S), S=#count{ D : finish(D,_,_) }.
c(S) :- S = #count{ T : final(T,I) }.

%:-not static(_,_,_,_).
%:-maxmove(K), rp(D,X,Y,T,I,J), plan(D,G,I), maxplan(G,P), K<T+P-J. 
%:-rp(D,V,W,T,I,_), rp(D,X,Y,T+1,I,_), rp(Q,X,Y,T,I,_), rp(Q,V,W,T+1,I,_), D<Q.
:-wp(Q,D,T,I), wp(E,D,T,I), wp(E,Q,T,I), D<Q, Q<E. %D1,Q2,E3
:-wp(D,Q,T,I), wp(E,Q,T,I), wp(E,D,T,I), D<Q, Q<E.
:-wp(Q,D,T,I), wp(Q,E,T,I), wp(D,E,T,I), D<Q, Q<E.
:-wp(D,Q,T,I), wp(Q,E,T,I), wp(E,D,T,I).


t(T):-rp(_,_,_,T,_,_), not rp(_,_,_,T+1,_,_).
#minimize {T:t(T)}.