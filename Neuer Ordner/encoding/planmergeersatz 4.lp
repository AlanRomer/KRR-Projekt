%Start 
rp(D,X,Y,0) :- init(object(robot,D),value(at,(X,Y))).
switch(D,0,-1,-1,D,0) :- init(object(robot,D),value(at,(X,Y))).
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
finishhit(D,Q,X,Y,T,Z):-rp(Q,X,Y,T), order(D,X,Y), finish(D,Z), D!=Q.
switch(D,0,Q,0,G,U):-switch(D,0,_,-1,Q,0), inithit(Q,G,X,Y,0,U).
switch(D,T+Z-P,Q,P,G,U):-switch(D,T,_,_,Q,P), inithit(Q,G,X,Y,Z,U), P<Z, T+Z-P<K, end(K).
binish(Q,Q,U):-finish(Q,U).
binish(D,Q,T+U-P):-switch(D,T,_,_,Q,P), finish(Q,U), not binish(Q,Q,T+U-P), T+U-P<K, end(K).
%:-not binish(D,Q,_), switch(D,T,_,_,Q,P), finish(Q,U), not binish(Q,Q,T+U-P), T+U-P<K, end(K).
%:-binish(D,Q,T), binish(D,Q,Z), T<Z.
1{ cinish(X,Y,Z) : binish(X,Y,Z) }1:- binish(X,_,_). 
:-cinish(X,Y,Z),binish(X,Y,W), W<Z.
:-cinish(X,Y,_),cinish(Z,Y,_),Z!=X.
:-cinish(X,Y,_),cinish(X,Z,_), Z!=Y.
ciel(X,Y,Z):-cinish(X,Y,Z), cinish(_,_,T),not ciel(_,_,T), Z<T.
diel(Z):-cinish(X,Y,Z), not ciel(X,Y,Z).
#minimize {T:diel(T)}.

wayswitch(D,0,-1,-1,D,0):-switch(D,0,-1,-1,D,0).
wayswitch(D,Z,A,B,E,W):-wayswitch(D,T,_,_,A,B), switch(D,Z,A,B,E,W), T<Z+1, cinish(D,E,_), not wayswitch(D,T,_,_,E,_).
{wayswitch(D,0,A,B,E,W)}:-wayswitch(D,0,_,_,A,B), switch(D,0,A,B,E,W).
{wayswitch(D,Z,A,B,E,W)}:-wayswitch(D,T,_,_,A,B), switch(D,Z,A,B,E,W), T<Z.
:-wayswitch(D,Z,A,B,_,_),wayswitch(D,T,A,B,_,_), Z!=T.
:-wayswitch(D,Z,A,B,C,_),wayswitch(D,Z,A,B,E,_), C!=E.
:-wayswitch(D,Z,A,B,C,E),wayswitch(D,Z,A,B,C,F), F!=E.
:-wayswitch(D,_,A,_,_,_), cinish(D,A,_).
wayfinishhit(D,Q,Z+T-W):-wayswitch(D,Z,A,B,E,W), finishhit(Q,E,X,Y,T,O), wayswitch(D,P,E,W,_,_), P+1-Z>T-W.
wayfinishhit(D,Q,Z+T-W):-wayswitch(D,Z,A,B,E,W), finishhit(Q,E,X,Y,T,O), wayfinish(D,E,K), K+1-Z>T-W.
:-cinish(D,Q,K), wayfinishhit(E,Q,T), T>K.
wayfinish(D,Q,K):-cinish(D,Q,K), finish(Q,U), wayswitch(D,T,_,_,Q,P), K=T+U-P.
:-cinish(D,Y,Z), not wayfinish(D,Y,Z).

%
finish(D,T):- rp(D,X,Y,T), order(D,X,Y).
final(T):- rp(_,_,_,T), not rp(_,_,_,T+1), rc(S), S=#count{ D : finish(D,_) }.
c(S) :- S = #count{ T : final(T) }.

end(T+1):-rp(_,_,_,T), not rp(_,_,_,T+1).

#show.
#show init/2.
#show occurs/3.
#show wayswitch/6.
#show wayfinish/3.