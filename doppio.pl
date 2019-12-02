doppio(G) :-
    on(X,Y,G),
    X1 is X+1,
    Y1 is Y+1,
    Ym1 is Y-1,
    (
           on(X1,Y,G),
           estendibile(X1,Y,1,0,L1),
           estendibile(X,Y,-1,0,L2);
           on(X,Y1,G),
           estendibile(X,Y1,0,1,L1),
           estendibile(X,Y,0,-1,L2);
           on(X1,Y1,G),
           estendibile(X1,Y1,1,1,L1),
           estendibile(X,Y,-1,-1,L2);
           on(X1,Ym1,G),
           estendibile(X,Ym1,1,-1,L1),
           estendibile(X,Y,-1,1,L2)
    ),
    L is L1+L2,
    L >= 2.











