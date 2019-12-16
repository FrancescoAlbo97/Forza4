win(A) :-
   orizzontale(A);
   verticale(A);
   diagonale(A).

orizzontale(A) :-
    on(X, Y, A),
    A \== 'c',
    A \== 'h',
    X1 is X + 1,
    X2 is X + 2,
    X3 is X + 3,
    on(X1, Y, A),
    on(X2, Y, A),
    on(X3, Y, A).

verticale(A) :-
    on(X, Y, A),
    A \== 'c',
    A \== 'h',
    Y1 is Y + 1,
    Y2 is Y + 2,
    Y3 is Y + 3,
    on(X, Y1, A),
    on(X, Y2, A),
    on(X, Y3, A).

diagonale(A) :-
    on(X, Y, A),
    A \== 'c',
    A \== 'h',
    X1 is X + 1,
    X2 is X + 2,
    X3 is X + 3,
    Y1 is Y + 1,
    Y2 is Y + 2,
    Y3 is Y + 3,
    Xm1 is X - 1,
    Xm2 is X - 2,
    Xm3 is X - 3,
    (
        on(X1, Y1, A),
        on(X2, Y2, A),
        on(X3, Y3, A);
        on(Xm1, Y1, A),
        on(Xm2, Y2, A),
        on(Xm3, Y3, A)
    ).

altezza_colonna(X,H) :-
    findall(Y,(on(X,Y,G),G\=c,G\=h),Col),
    sort(Col,ColOrd),
    last(ColOrd,H),
    !.
altezza_colonna(_,0).

pareggio() :-
    \+ on(1,6,h),
    \+ on(2,6,h),
    \+ on(3,6,h),
    \+ on(4,6,h),
    \+ on(5,6,h),
    \+ on(6,6,h).
