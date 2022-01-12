%Start 
rp(D,X,Y,0,1,0,0) :- init(object(robot,D),value(at,(X,Y))).
plan(D,D,1,0) :- init(object(robot,D),value(at,(_,_))).
maxplan(G,J):- occurs(object(robot,G),action(move,(_,_)),J), not occurs(object(robot,G), action(move,(_,_)),J+1).
maxmove(K):- occurs(object(robot,_),action(move,(_,_)),J), not occurs(object(robot,_), action(move,(_,_)),J+1), K=50, rc(S).
maxit(U):- rc(S), U=S*2.
order(G,X,Y) :- init(object(shelf,G),value(at,(X,Y))).
rc(S) :- S = #count{ D : init(object(robot,D),value(at,(X,Y))) }.

% movement
rp(D,X+V,Y+W,T+1,I,J+1,A):- rp(D,X,Y,T,I,J,A), occurs(object(robot,G),action(move,(V,W)),J+1), not back(D,T,I), plan(D,G,I,A), not wayswitch(D,Z,G,P,N,M),T<K, maxmove(K), I<U, maxit(U).
rp(D,V,W,T,I+1,J,A):-rp(D,X,Y,T,I,_,_), rp(D,V,W,T-1,I,J,A), back(D,T,I), T<K, maxmove(K), I<U, maxit(U).

bp(D,X,Y,T,1,P,J):-rp(D,X,Y,T,I,K+J-U,U), wayswitch(D,J,A,K,E,P), wayswitch(D,U,_,_,A,K), not  back(D,T,I).
blan(D,E,1,J):-wayswitch(D,J,_,_,E,_).

% chain back
back(D,T,I):-rp(D,X,Y,T,I,_,_), rp(E,X,Y,T,P,_,_), back(E,T,P-1),  E!=D, T<K, maxmove(K), I<U, maxit(U). 

% collision
%back(D,T,I):-wp(D,Q,T,I,P).
%wp(D,Q,T,I,P):-rp(D,X,Y,T,I,M,_), rp(Q,X,Y,T,P,N,_), not back(Q,T,P), Q!=D, plan(D,G,I,_), plan(Q,F,P,_), maxplan(G,H), maxplan(F,J), H-M<J-N+1, T<K, maxmove(K), I<U, maxit(U).
%wp(Q,D,T,P,I):-rp(D,X,Y,T,I,M,_), rp(Q,X,Y,T,P,N,_), not back(D,T,I), Q!=D, plan(D,G,I,_), plan(Q,F,P,_), maxplan(G,H), maxplan(F,J), H-M>J-N, T<K, maxmove(K), I<U, maxit(U).
%plan(D,G,I+1,A):-back(D,T,I), plan(D,G,I,A).

%
finish(G,T):- not back(D,T,I), rp(D,X,Y,T,I,_,A), plan(D,G,I,A), order(G,X,Y).
final(T,I):- rp(_,_,_,T,I,_,_), not rp(_,_,_,T+1,_,_,_), rc(S), S=#count{ D : finish(D,_) }.
c(S) :- S = #count{ T : final(T,I) }.
