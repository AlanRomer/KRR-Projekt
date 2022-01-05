%Start 
back(7,20,1).
rp(D,X,Y,0,1,0) :- init(object(robot,D),value(at,(X,Y))).
plan(D,D,1) :- init(object(robot,D),value(at,(_,_))).
maxplan(G,J):- occurs(object(robot,G),action(move,(_,_)),J), not occurs(object(robot,G), action(move,(_,_)),J+1).
maxmove(K):- occurs(object(robot,_),action(move,(_,_)),J), not occurs(object(robot,_), action(move,(_,_)),J+1), K=50, rc(S).
maxit(U):- rc(S), U=S*2.
order(G,X,Y) :- init(object(shelf,G),value(at,(X,Y))).
rc(S) :- S = #count{ D : init(object(robot,D),value(at,(X,Y))) }.

% movement
rp(D,X+V,Y+W,T+1,I,J+1):- rp(D,X,Y,T,I,J), occurs(object(robot,G),action(move,(V,W)),J+1), not back(D,T,I), plan(D,G,I), not bb(D,X+V,Y+W,T+1,I,J+1), T<K, maxmove(K), I<U, maxit(U).
rp(D,V,W,T,I+1,J):-rp(D,X,Y,T,I,_), rp(D,V,W,T-1,I,J), back(D,T,I), T<K, maxmove(K), I<U, maxit(U).

% chain back
back(D,T,I):-rp(D,X,Y,T,I,_), rp(E,X,Y,T,P,_), back(E,T,P-1),  E!=D. 

% collision, have to add to not execute on swap
back(D,T,I):-wp(D,Q,T,I,P).
wp(D,Q,T,I,P):-rp(D,X,Y,T,I,M), rp(Q,X,Y,T,P,N), not back(Q,T,P), Q!=D, plan(D,G,I), plan(Q,F,P), maxplan(G,H), maxplan(F,J), H-M<J-N+1, T<K, maxmove(K), I<U, maxit(U).
wp(Q,D,T,P,I):-rp(D,X,Y,T,I,M), rp(Q,X,Y,T,P,N), not back(D,T,I), Q!=D, plan(D,G,I), plan(Q,F,P), maxplan(G,H), maxplan(F,J), H-M>J-N, T<K, maxmove(K), I<U, maxit(U).
plan(D,G,I+1):-back(D,T,I), plan(D,G,I).

% final in the way into mover must increase iteration and switch plan if out mover not back else back and out mover 
switch(D,Q,T,I):-bb(D,X,Y,T,I,J), order(Q,X,Y).
bb(D,X+V,Y+W,T+1,I,J+1):- rp(D,X,Y,T,I,J), plan(D,G,I), order(O,X+V,Y+W), occurs(object(robot,G),action(move,(V,W)),J+1), finish(O,P), P<T+1, T<K, maxmove(K), I<U, maxit(U).
bb(D,X+V,Y+W,T,I,J+1):- bb(D,X,Y,T,I,J), plan(D,G,I), order(O,X,Y), occurs(object(robot,G),action(move,(V,W)),J+1), finish(O,P), P<T, T<K, maxmove(K), I<U, maxit(U).
rp(D,X,Y,T,I,J):- bb(D,X,Y,T,I,J), not bb(D,_,_,T,I,J+1), T<K, maxmove(K), I<U, maxit(U).

%
finish(G,T):- not back(D,T,I), rp(D,X,Y,T,I,_), plan(D,G,I), order(G,X,Y).
final(T,I):- rp(_,_,_,T,I,_), not rp(_,_,_,T+1,_,_), rc(S), S=#count{ D : finish(D,_) }.
c(S) :- S = #count{ T : final(T,I) }.

t(T):-rp(_,_,_,T,_,_), not rp(_,_,_,T+1,_,_).
#minimize {T:t(T)}.