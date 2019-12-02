singolo(G) :-
    on(X,Y,G),
   (
           estendibile(X,Y,1,0,L1),
           estendibile(X,Y,-1,0,L2);
           estendibile(X,Y,0,1,L1),
           estendibile(X,Y,0,-1,L2);
           estendibile(X,Y,1,1,L1),
           estendibile(X,Y,-1,-1,L2);
           estendibile(X,Y,1,-1,L1),
           estendibile(X,Y,-1,1,L2)
    ),
    L is L1+L2,
    L >= 3.
