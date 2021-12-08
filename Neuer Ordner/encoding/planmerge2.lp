%Start
it_Ti(1,1).
order(G,X,Y) :- init(object(shelf,G),value(at,(X,Y))).
plan(D,D,1) :- init(object(robot,D),value(at,(_,_))). %plan(robot, plan, iteration)
rp(D,X,Y,0,1,0) :- init(object(robot,D),value(at,(X,Y))). %robot_position(iD,X,Y,time, iteration, time in plan)
rc(S) :- S = #count{ D : init(object(robot,D),value(at,(X,Y))) }.
%translate occurs to positions time step at a time
rp(D,X+V,Y+W,T,I,J):- rp(D,X,Y,T-1,I,J-1), occurs(object(robot,G),action(move,(V,W)),J), plan(D,G,I), it_Ti(T,I), T<25, not final(T,I).
rp(D,X,Y,T+1,I,J):- rp(D,X,Y,T,I,J), rp(_,_,_,T+1,I,_), not stop(T,I), finish(D,T,I), not final(T-1,I), T<25.
rp(D,X,Y,T,I+1,J):-rp(D,X,Y,T,I,J), it_Ti(T,I+1), rp(E,_,_,T,I+1,_), not rp(E,X,Y,T,I+1,_), not wp(D,_,T,I+1), not back(D,T,I+1) , E!=D.

rp(D,V,W,T,I+1,J):-rp(D,X,Y,T,I,_), it_Ti(T,I+1), rp(D,V,W,T-1,I,J), rp(E,X,Y,T,I+1,_), not wp(D,_,T,I+1), back(E,T,I+1), E!=D.
back(D,T,I+1):-rp(D,X,Y,T,I,_), it_Ti(T,I+1), rp(D,V,W,T-1,I,J), rp(E,X,Y,T,I+1,_), not wp(D,_,T,I+1), E!=D.

plan(D,G,I+1):-rp(D,X,Y,T,I,J), it_Ti(T,I+1), rp(Q,_,_,T,I+1,_), plan(D,G,I), not switch(D,_,X,Y,T,I), not static(D,Q,T,I).

%vertex conflict no movement after
%static(D,Q,T,I):-waitposs(D,Q,T,I), finish(D,T,I), not finish(Q,T,I), not wp(Q,_,T,I+1).
%static(Q,D,T,I):-waitposs(D,Q,T,I), finish(Q,T,I), not finish(D,T,I), not wp(D,_,T,I+1).
%plan(D,G,I+1):-static(D,Q,T,I), plan(Q,G,I).
%plan(Q,G,I+1):-static(D,Q,T,I), plan(D,G,I).
%rp(D,X+V,Y+W,T,I+1,J):-static(D,Q,T,I), rp(D,X,Y,T,I,_), occurs(object(robot,G),action(move,(V,W)),J), plan(Q,G,I), rp(Q,X,Y,T,I,J-1), not rp(E,X+V,Y+W,T,I+1,_), rp(E,_,_,_,_,_), E!=D. 
%rp(D,X,Y,T,I+1,J-1):-static(D,Q,T,I), rp(D,X,Y,T,I,_), occurs(object(robot,G),action(move,(V,W)),J), plan(Q,G,I), rp(Q,X,Y,T,I,J-1), rp(E,X+V,Y+W,T,I+1,_), E!=D. 
%back(Q,T,I+1):-static(D,Q,T,I), rp(D,X,Y,T,I,_), occurs(object(robot,G),action(move,(V,W)),J), plan(Q,G,I), rp(Q,X,Y,T,I,J-1), rp(E,X+V,Y+W,T,I+1,_), E!=D. 
%wp(Q,D,T,I+1):-back(Q,T,I+1), static(D,Q,T,I).


%vertex conflict move same direction
waitposs(D,Q,T,I):- rp(D,X,Y,T,I,K), rp(Q,X,Y,T,I,L), D<Q. 
1{wp(D,Q,T,I+1); wp(Q,D,T,I+1)}1:- waitposs(D,Q,T,I), not finish(D,T,I), not finish(Q,T,I).
plan(D,D,I+1):-waitposs(D,Q,T,I).
plan(Q,Q,I+1):-waitposs(D,Q,T,I).
it_Ti(T,I+1):-waitposs(D,Q,T,I).
stop(T,I):-waitposs(_,_,T,I).
back(Q,T,I+1):-wp(Q,D,T,I+1).
rp(Q,V2,W2,T,I+1,L-1):-wp(Q,D,T,I+1), rp(Q,V2,W2,T-1,I,L-1).
it_Ti(T+1,I) :- it_Ti(T,I), not stop(T,I), rc(X), X=S, S=#count{ D : rp(D,_,_,T,I,_); D: finish(D,T,I) }.

%Vertex  conflict switch 
%switch(D,Q,X,Y,T,I):- rp(D,X,Y,T,I,J), rp(Q,X,Y,T,I,_), occurs(object(robot,D),action(move,(V,W)),J+1), rp(Q,A,B,T-1,I,_), A=X+V, B=Y+W, D!=Q.



finish(D,T,I):- it_Ti(T,I), rp(D,X,Y,T,I,_), plan(D,G,I), order(G,X,Y).
final(T+2,I):- it_Ti(T,I), rc(S), S=#count{ D : finish(D,T,I) }.
c(S) :- S = #count{ T : final(T+1,I) }.
%vertex3 conflict same direction
:-wp(Q,D,T,I+1), wp(E,D,T,I+1), wp(E,Q,T,I+1), D<Q, Q<E. %D1,Q2,E3
:-wp(D,Q,T,I+1), wp(E,Q,T,I+1), wp(E,D,T,I+1), D<Q, Q<E.
:-wp(Q,D,T,I+1), wp(Q,E,T,I+1), wp(D,E,T,I+1), D<Q, Q<E.
:-wp(D,Q,T,I+1), wp(Q,E,T,I+1), wp(E,D,T,I+1).
%:- c(0).

t(T):-rp(_,_,_,T,_,_), not rp(_,_,_,T+1,_,_).
#minimize {T:t(T)}.
%waitpos not activate on 
%#show.
%#show init/2.
%#show rp/5.
%#show stop/2.