%Start
%it_Ti(1,1)  %iteration_time( time, iteration)
plan(D,D,1) :- init(object(robot,D),value(at,(_,_))). %plan(robot, plan, iteration)
order(G,X,Y) :- init(object(shelf,G),value(at,(X,Y))).
rp(D,X,Y,0,1,0) :- init(object(robot,D),value(at,(X,Y))). %robot_position(iD,X,Y,time, iteration, time in plan)
%rc(S) :- S = #count{ D : init(object(robot,D),value(at,(X,Y))) }. %robotcount(number)

%translate occurs to positions time step at a time
rp(D,X+V,Y+W,T,I,J):- rp(D,X,Y,T-1,I,J-1), occurs(object(robot,G),action(move,(V,W)),J), plan(D,G,I), not stop(T-1,I).
rp(D,X,Y,T,I,J):- rp(D,X,Y,T-1,I,J), rp(E,_,_,T,I,_), not rp(_,_,_,T,I+1,_), not occurs(object(_,G),_,J+1), plan(D,G,I).
rp(D,X,Y,T,I+1,J):- rp(D,X,Y,T,I,J), rp(E,_,_,T,I+1,_), not rp(D,_,_,T+1,I,_),plan(D,G,I), stop(T-1,I).
%rp(D,X+V,Y+W,T,I):- rp(D,X,Y,T-1,I),rp(D,X,Y,T-1,I), not occurs(object(robot,G),action(move,(V,W)),T), plan(D,G,I), not stop(T-1,I).

%time_s(S,T,I):- it_Ti(T,I), rc(X), X=S, S = #count{   D : rp(D,_,_,T,I) }.
%it_Ti(T+1,I) :- it_Ti(T,I), stop(O,P,T,I), O!=P, rc(X), X=S, S=#count{ D : rp(D,_,_,T,I)}.
%finish(D,T,I):- it_Ti(T,I), rp(D,X,Y,T,I), plan(D,G,I), order(G,X,Y).
%stop(X,S,T,I):- it_Ti(T,I), rc(X), S=#count{ D : finish(D,T,I) }.

%vertex conflict no movement after
staticswitch(D,Q,X,Y,T,I):- rp(D,X,Y,T,I,J), rp(Q,X,Y,T,I,_), occurs(object(robot,D),action(move,(V,W)),J+1), rp(Q,A,B,T-1,I,_), A=X+V, B=Y+W, D!=Q.


%vertex conflict move same direction
switch(D,Q,X,Y,T,I):- rp(D,X,Y,T,I,J), rp(Q,X,Y,T,I,_), occurs(object(robot,D),action(move,(V,W)),J+1), rp(Q,A,B,T-1,I,_), A=X+V, B=Y+W, D!=Q.

%circle  switch
planum2(D,Q,T,I):- switch(D,Q,X,Y,T,I), switch(Q,D,X,Y,T,I), D<Q.
planum3(D,Q,E,T,I):- switch(D,Q,X,Y,T,I), switch(Q,E,X,Y,T,I), switch(E,D,X,Y,T,I), D<Q, D<E.
planum4(D,Q,E,R,T,I):- switch(D,Q,X,Y,T,I), switch(Q,E,X,Y,T,I), switch(E,R,X,Y,T,I), switch(R,D,X,Y,T,I), D<Q, D<E, D<R.

%incomplet circle switch
incplanum2(D,Q,T,I):- switch(D,Q,X,Y,T,I), not switch(Q,_,X,Y,T,I), not switch(_,D,X,Y,T,I).
incplanum3(D,Q,E,T,I):- switch(D,Q,X,Y,T,I), switch(Q,E,X,Y,T,I), not switch(E,_,X,Y,T,I), not switch(_,D,X,Y,T,I).

%Plan switching
plan(D,G,I+1):-planum2(D,Q,T,I), plan(Q,G,I).
plan(Q,G,I+1):-planum2(D,Q,T,I), plan(D,G,I).
plan(D,G,I+1):-planum3(D,Q,E,T,I), plan(E,G,I).
plan(Q,G,I+1):-planum3(D,Q,E,T,I), plan(D,G,I).
plan(E,G,I+1):-planum3(D,Q,E,T,I), plan(Q,G,I).
plan(D,G,I+1):-planum4(D,Q,E,R,T,I), plan(R,G,I).
plan(Q,G,I+1):-planum4(D,Q,E,R,T,I), plan(D,G,I).
plan(E,G,I+1):-planum4(D,Q,E,R,T,I), plan(Q,G,I).
plan(R,G,I+1):-planum4(D,Q,E,R,T,I), plan(E,G,I).
plan(D,G,I+1):-incplanum2(D,Q,T,I), plan(Q,G,I).
plan(Q,G,I+1):-incplanum2(D,Q,T,I), plan(D,G,I).
plan(D,G,I+1):-incplanum3(D,Q,E,T,I), plan(E,G,I).
plan(Q,G,I+1):-incplanum3(D,Q,E,T,I), plan(D,G,I).
plan(E,G,I+1):-incplanum3(D,Q,E,T,I), plan(Q,G,I).

%position next plan
rp(D,X,Y,T-1,I+1,K+1):-rp(D,X,Y,T-1,I,_), rp(Q,_,_,T,I,K), planum2(D,Q,T,I).
rp(Q,X,Y,T-1,I+1,K+1):-rp(Q,X,Y,T-1,I,_), rp(D,_,_,T,I,K), planum2(D,Q,T,I).
rp(D,X,Y,T-1,I+1,K+1):-rp(D,X,Y,T-1,I,_), rp(Q,_,_,T,I,K), planum3(D,Q,E,T,I).
rp(Q,X,Y,T-1,I+1,K+1):-rp(Q,X,Y,T-1,I,_), rp(E,_,_,T,I,K), planum3(D,Q,E,T,I).
rp(E,X,Y,T-1,I+1,K+1):-rp(E,X,Y,T-1,I,_), rp(D,_,_,T,I,K), planum3(D,Q,E,T,I).
rp(D,X,Y,T-1,I+1,K+1):-rp(D,X,Y,T-1,I,_), rp(Q,_,_,T,I,K), planum4(D,Q,E,R,T,I).
rp(Q,X,Y,T-1,I+1,K+1):-rp(Q,X,Y,T-1,I,_), rp(E,_,_,T,I,K), planum4(D,Q,E,R,T,I).
rp(E,X,Y,T-1,I+1,K+1):-rp(E,X,Y,T-1,I,_), rp(R,_,_,T,I,K), planum4(D,Q,E,R,T,I).
rp(R,X,Y,T-1,I+1,K+1):-rp(R,X,Y,T-1,I,_), rp(D,_,_,T,I,K), planum4(D,Q,E,R,T,I).
rp(D,X+V,Y+W,T+1,I+1,K+1):-rp(D,X,Y,T,I,_), rp(G,_,_,T,I,K), incplanum2(D,G,T,I), occurs(object(robot,G),action(move,(V,W)),K), plan(G,_,I+1).
rp(Q,X,Y,T-1,I+1,K+1):-rp(Q,X,Y,T-1,I,_), rp(D,_,_,T,I,K), incplanum2(D,Q,T,I).
rp(D,X+V,Y+W,T+1,I+1,K+1):-rp(D,X,Y,T,I,_), rp(G,_,_,T,I,K), incplanum3(D,G,E,T,I), occurs(object(robot,G),action(move,(V,W)),K), plan(G,_,I+1).
rp(Q,X,Y,T-1,I+1,K+1):-rp(Q,X,Y,T-1,I,_), rp(E,_,_,T,I,K), incplanum3(D,Q,E,T,I).
rp(E,X,Y,T-1,I+1,K+1):-rp(E,X,Y,T-1,I,_), rp(D,_,_,T,I,K), incplanum3(D,Q,E,T,I).
%new iteration starter
stop(T,I):-switch(_,_,_,_,T,I).

waitposs(D,Q,X,Y,T,I):- rp(D,X,Y,T,I,_), rp(Q,X,Y,T,I,_).  
%waitpos not activate on 
%1{rp(D,X,Y,T,I+1,K-1);rp(D,X,Y,T,I+1,K-1)}1:-waitposs(D,Q,X,Y,T,I), rp(D,X,Y,T-1,I+1,K+1),not planum2(D,Q,T,I).

%active position iteration increase
%#show.
%#show init/2.
%#show rp/5.
%#show stop/2.
