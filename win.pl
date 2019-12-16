win(Memory, MemoryA) :-
    on(X, Y, A),
    A \== 'c',       %non considero i bordi
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
          on(X1, Y, A),
          on(X2, Y, A),
          on(X3, Y, A),
          nl, write('vinto '), write(A), nl;
          on(X, Y1, A),
          on(X, Y2, A),
          on(X, Y3, A),
          nl, write('vinto '), write(A), nl;
          on(X1, Y1, A),
          on(X2, Y2, A),
          on(X3, Y3, A),
          nl, write('vinto '), write(A), nl;
          on(Xm1, Y1, A),
          on(Xm2, Y2, A),
          on(Xm3, Y3, A)
     ),
    osserva([], Hypo1),
    osserva(Hypo1, Hypo2),
    osserva(Hypo2, Hypo3),
    osserva(Hypo3, Hypo4),
    osserva(Hypo4, Hypo5),
    osserva(Hypo5, Hypo6),
    osserva(Hypo6, Hypo7),
    osserva(Hypo7, Hypo8),
    osserva(Hypo8, Hypo9),
    osserva(Hypo9, Hypo10),
    componi(4,Memory, Hypo10, Hypo11),
    componi(4,Memory, Hypo11, Hypo12),
    componi(4,Memory, Hypo12, Hypo13),
    componi(4,Memory, Hypo13, Hypo14),
    allena(Memory, Hypo14, MemoryA).

win_cpu(A) :-
    on(X, Y, A),
    A \== 'c',       %non considero i bordi
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
          on(X1, Y, A),
          on(X2, Y, A),
          on(X3, Y, A);
          on(X, Y1, A),
          on(X, Y2, A),
          on(X, Y3, A);
          on(X1, Y1, A),
          on(X2, Y2, A),
          on(X3, Y3, A);
          on(Xm1, Y1, A),
          on(Xm2, Y2, A),
          on(Xm3, Y3, A)
     ).

pareggio() :-
    \+ on(1,6,h),
    \+ on(2,6,h),
    \+ on(3,6,h),
    \+ on(4,6,h),
    \+ on(5,6,h),
    \+ on(6,6,h).
