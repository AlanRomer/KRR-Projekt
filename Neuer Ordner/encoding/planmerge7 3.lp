%Start 
rp(D,X,Y,0,0):-wayswitch(D,0,_,-1,_,0), not wayswitch(D,0,_,0,_,_), init(object(robot,D),value(at,(X,Y))).
rp(D,X,Y,0,P):-wayswitch(D,0,_,-1,_,0), wayswitch(D,0,_,0,_,P), init(object(robot,D),value(at,(X,Y))).
plan(D,E,J):-wayswitch(D,J,_,_,E,_).
maxplan(G,J):- occurs(object(robot,G),action(move,(_,_)),J), not occurs(object(robot,G), action(move,(_,_)),J+1).
maxmove(K):- occurs(object(robot,_),action(move,(_,_)),J), not occurs(object(robot,_), action(move,(_,_)),J+1), K=70, rc(S).
maxit(U):- rc(S), U=S*2.
order(G,X,Y) :- init(object(shelf,G),value(at,(X,Y))).
rc(S) :- S = #count{ D : init(object(robot,D),value(at,(X,Y))) }.

% movement
rp(D,X+V,Y+W,1):- rp(D,X,Y,0,0), occurs(object(robot,G),action(move,(V,W)),1), plan(D,G,-1), not plan(D,B,0), init(object(robot,B),value(at,(_,_))).
rp(D,X+V,Y+W,1):- rp(D,X,Y,0,0), occurs(object(robot,G),action(move,(V,W)),1), plan(D,B,-1), plan(D,G,0).
rp(D,X+V,Y+W,T+1,J+1):- rp(D,X,Y,T,J), occurs(object(robot,G),action(move,(V,W)),J+1), plan(D,G,B), wayswitch(D,B,_,_,G,P), wayswitch(D,Z,G,P,_,_), J-P+1<Z-B, B<T+1, T<Z,T<K+1, maxmove(K).
rp(D,X+V,Y+W,T+1,F):- rp(D,X,Y,T,J), occurs(object(robot,G),action(move,(V,W)),J+1), plan(D,G,B), wayswitch(D,B,_,_,G,P), wayswitch(D,Z,G,P,_,F), J-P+1=Z-B, B<T+1, T<Z,T<K+1, maxmove(K).
rp(D,X+V,Y+W,T+1,J+1):- rp(D,X,Y,T,J), occurs(object(robot,G),action(move,(V,W)),J+1), plan(D,G,B), wayswitch(D,B,_,A,G,P), wayfinish(D,G,Z), B<T+1, T<Z+1,T<K, maxmove(K).

wp(D,X,Y,0,0):-rp(D,X,Y,0,P).
1{cp(D,V,W,T,J+1);wp(D,X,Y,T,J)}1:-rp(D,X,Y,T-J,_), cp(D,V,W,T-1,J), T+J<K+1, maxmove(K).
1{cp(D,V,W,T,J+1);wp(D,X,Y,T,J)}1:-rp(D,X,Y,T-J,_), wp(D,V,W,T-1,J), T+J<K+1, maxmove(K).
%:-cp(D,V,W,T,J), rp(D,X,Y,T+1-J,_), cp(D,V,W,T+1,J+1), not wp(Q,X,Y,T+1,_), not cp(Q,X,Y,T+1,_), init(object(robot,Q),value(at,(_,_))), D!=Q.
%:-wp(D,X,Y,T-1,J), rp(D,V,W,T-J,_), cp(D,X,Y,T,J+1), not wp(Q,V,W,T,_), not cp(Q,V,W,T,_), init(object(robot,Q),value(at,(_,_))), D!=Q.
:-wp(D,X,Y,T,_), wp(Q,X,Y,T,_), Q!=D.
:-cp(D,X,Y,T,_), wp(Q,X,Y,T,_), Q!=D.
:-not wp(D,X,Y,_,_), rp(D,X,Y,_,_).
% chain back
%back(D,T,I):-rp(D,X,Y,T,I,_,_), rp(E,X,Y,T,P,_,_), back(E,T,P-1),  E!=D, T<K, maxmove(K), I<U, maxit(U). 

% collision
%back(D,T,I):-wp(D,Q,T,I,P).
%wp(D,Q,T,I,P):-rp(D,X,Y,T,I,M,_), rp(Q,X,Y,T,P,N,_), not back(Q,T,P), Q!=D, plan(D,G,I,_), plan(Q,F,P,_), maxplan(G,H), maxplan(F,J), H-M<J-N+1, T<K, maxmove(K), I<U, maxit(U).
%wp(Q,D,T,P,I):-rp(D,X,Y,T,I,M,_), rp(Q,X,Y,T,P,N,_), not back(D,T,I), Q!=D, plan(D,G,I,_), plan(Q,F,P,_), maxplan(G,H), maxplan(F,J), H-M>J-N, T<K, maxmove(K), I<U, maxit(U).
%plan(D,G,I+1,A):-back(D,T,I), plan(D,G,I,A).