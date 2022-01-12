%Start 
rp(D,X,Y,0) :- init(object(robot,D),value(at,(X,Y))).
switch(D,0,D,0,D,0) :- init(object(robot,D),value(at,(X,Y))).
maxplan(G,0):- init(object(robot,G),value(at,(_,_))), not occurs(object(robot,G), action(move,(_,_)),_).
maxplan(G,J):- occurs(object(robot,G),action(move,(_,_)),J), not occurs(object(robot,G), action(move,(_,_)),J+1).
maxmove(K):- occurs(object(robot,_),action(move,(_,_)),J), not occurs(object(robot,_), action(move,(_,_)),J+1), K=S+J+1, rc(S).

order(G,X,Y) :- init(object(shelf,G),value(at,(X,Y))).
rc(S) :- S = #count{ D : init(object(robot,D),value(at,(X,Y))) }.

% movement
rp(D,X+V,Y+W,T+1):- rp(D,X,Y,T), occurs(object(robot,D),action(move,(V,W)),T+1), T<K, maxmove(K).

% final in the way into mover must increase iteration.... Doesn't happen if switch plans accurate 
inithit(D,Q,X,Y,T,Z):-rp(D,X,Y,T), rp(Q,X,Y,Z), rp(D,V,W,T-1), not rp(Q,V,W,Z-1), not rp(Q,V,W,Z+1).
inithit(D,Q,X,Y,0,Z):-rp(D,X,Y,0), rp(Q,X,Y,Z), D!=Q.
endhit(D,Q,X,Y,T,Z):-rp(D,X,Y,T), rp(Q,X,Y,Z), rp(D,V,W,T+1), not rp(Q,V,W,Z+1).
finishhit(D,Q,X,Y,T,Z):-rp(Q,X,Y,T), order(D,X,Y), finish(D,Z), D!=Q.
%switch(D,0,G,U) :- switch(D,0,D,0), finishhit(D,G,X,Y,U,0).
switch(D,T+Z-P,Q,P,G,U):- switch(D,T,_,_,Q,P), inithit(Q,G,X,Y,Z,U), P<Z+1, T<K, maxmove(K).
binish(D,Q,T+U-P,T,E):-switch(D,T,E,_,Q,P), finish(Q,U), T<K, maxmove(K).
%1{ cinish(X,Y,Z) : binish(X,Y,Z) }1:- binish(X,_,_).
%:-cinish(X,Y,Z),binish(X,Y,W), W<Z.
%:-cinish(X,Y,_),cinish(Z,Y,_),Z!=X.
%ciel(X,Y,Z):-cinish(X,Y,Z), cinish(_,_,T),not ciel(_,_,T), Z<T.
%diel(Z):-cinish(X,Y,Z), not ciel(X,Y,Z).
%#minimize {T:diel(T)}.

%
finish(D,T):- rp(D,X,Y,T), order(D,X,Y).
final(T):- rp(_,_,_,T), not rp(_,_,_,T+1), rc(S), S=#count{ D : finish(D,_) }.
c(S) :- S = #count{ T : final(T) }.
