triplo(G) :-
    on(X,Y,G),
    X1 is X+1,
    X2 is X+2,
    Y1 is Y+1,
    Y2 is Y+2,
    Ym1 is Y-1,
    Ym2 is Y-2,
    (
           on(X1,Y,G),
           on(X2,Y,G),
           estendibile(X2,Y,1,0,L1),
           estendibile(X,Y,-1,0,L2);
           on(X,Y1,G),
           on(X,Y2,G),
           estendibile(X,Y2,0,1,L1),
           estendibile(X,Y,0,-1,L2);
           on(X1,Y1,G),
           on(X2,Y2,G),
           estendibile(X2,Y2,1,1,L1),
           estendibile(X,Y,-1,-1,L2);
           on(X1,Ym1,G),
           on(X2,Ym2,G),
           estendibile(X2,Ym2,1,-1,L1),
           estendibile(X,Y,-1,1,L2)
    ),
    L is L1+L2,
    L >= 1.
