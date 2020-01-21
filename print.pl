%:- [test2]

print :-
    print_board(1,6),
    nl,write('//////////////////////'),nl.

print_board(8,1) :-
    nl, !.

print_board(8,Y) :-
    nl,
    NY is Y-1,
    print_board(1,NY), !.

print_board(X,Y) :-
    X < 8,
    Y < 7,
    (
      on(X,Y,a),
      write('O'),
      tab(2);
      on(X,Y,b),
      write('X'),
      tab(2);
      write('_'),
      tab(2)
    ),
    !,
    NX is X + 1,
    print_board(NX,Y).
