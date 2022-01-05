
occurs(object(robot,D),action(move,(V-X,W-Y)),T+1):-rp(D,X,Y,T,I,_), rp(D,V,W,T+1,I,_), not back(D,T+1,I).
#show.
#show init/2.



#show occurs/3.