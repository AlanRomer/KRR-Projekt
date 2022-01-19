%Start 
rp(D,X,Y,0,0):-wayswitch(D,0,_,-1,_,0), not wayswitch(D,0,_,0,_,_), init(object(robot,D),value(at,(X,Y))).
rp(D,X,Y,0,P):-wayswitch(D,0,_,-1,_,0), wayswitch(D,0,_,0,_,P), init(object(robot,D),value(at,(X,Y))).
plan(D,E,J):-wayswitch(D,J,_,_,E,_).
maxplan(G,J):- occurs(object(robot,G),action(move,(_,_)),J), not occurs(object(robot,G), action(move,(_,_)),J+1).
maxmove(K):- occurs(object(robot,_),action(move,(_,_)),J), not occurs(object(robot,_), action(move,(_,_)),J+1), K=70, rc(S).
maxit(U):- rc(S), U=S.
order(G,X,Y) :- init(object(shelf,G),value(at,(X,Y))).
rc(S) :- S = #count{ D : init(object(robot,D),value(at,(X,Y))) }.

% movement
rp(D,X+V,Y+W,1):- rp(D,X,Y,0,0), occurs(object(robot,G),action(move,(V,W)),1), plan(D,G,-1), not plan(D,B,0), init(object(robot,B),value(at,(_,_))).
rp(D,X+V,Y+W,1):- rp(D,X,Y,0,0), occurs(object(robot,G),action(move,(V,W)),1), plan(D,B,-1), plan(D,G,0).
rp(D,X+V,Y+W,T+1,J+1):- rp(D,X,Y,T,J), occurs(object(robot,G),action(move,(V,W)),J+1), plan(D,G,B), wayswitch(D,B,_,_,G,P), wayswitch(D,Z,G,P,_,_), J-P+1<Z-B, B<T+1, T<Z,T<K+1, maxmove(K).
rp(D,X+V,Y+W,T+1,F):- rp(D,X,Y,T,J), occurs(object(robot,G),action(move,(V,W)),J+1), plan(D,G,B), wayswitch(D,B,_,_,G,P), wayswitch(D,Z,G,P,_,F), J-P+1=Z-B, B<T+1, T<Z,T<K+1, maxmove(K).
rp(D,X+V,Y+W,T+1,J+1):- rp(D,X,Y,T,J), occurs(object(robot,G),action(move,(V,W)),J+1), plan(D,G,B), wayswitch(D,B,_,A,G,P), wayfinish(D,G,Z), B<T+1, T<Z+1,T<K, maxmove(K).

wp(D,X,Y,0,0):-rp(D,X,Y,0,P).
1{wp(D,V,W,T,J+1);wp(D,X,Y,T,J)}1:-rp(D,X,Y,T-J,_), wp(D,V,W,T-1,J), T<K+1, maxmove(K).
hit(D,V,W,T-1):-not rp(D,_,_,T-J,_), wp(D,V,W,T-1,J), T+J<K+1, maxmove(K).
:-wp(D,X,Y,T,_), wp(Q,X,Y,T,_), Q<D.
:-wp(D,X,Y,T,_), wp(D,V,W,T+1,_), wp(Q,V,W,T,_), wp(Q,X,Y,T+1,_), Q<D.
:-wp(D,X,Y,T,J), J>U, maxit(U).
:-hit(D,X,Y,T), wp(Q,X,Y,Z,_), T<Z, D!=Q.

t(T):-wp(_,_,_,T,_), not wp(_,_,_,T+1,_).
#minimize {T:t(T)}.

#show.
#show init/2.
#show hit/4.
#show wp/5.