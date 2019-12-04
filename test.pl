:- dynamic on/3.
:- [bordi].
:- [singolo].
:- [doppio].
:- [triplo].

mossa(X, G, E) :-
    number(X),
    X > 0,
    X < 8,
    (
          on(X, 6, _),
          E = 1;
          \+ on(X, 6, _),
          on(X, 5, _),
          assert(on(X, 6, G)),
          E = 0;
          \+ on(X, 5, _),
          on(X, 4, _),
          assert(on(X, 5, G)),
          E = 0;
          \+ on(X, 4, _),
          on(X, 3, _),
          assert(on(X, 4, G)),
          E = 0;
          \+ on(X, 3, _),
          on(X, 2, _),
          assert(on(X, 3, G)),
          E = 0;
          \+ on(X, 2, _),
          on(X, 1, _),
          assert(on(X, 2, G)),
          E = 0;
          \+ on(X, 1, _),
          assert(on(X, 1, G)),
          E = 0
     ).


anti_mossa(X) :-
    on(X, 6, _),
    retract(on(X, 6, _));
    on(X, 5, _),
    retract(on(X, 5, _));
    on(X, 4, _),
    retract(on(X, 4, _));
    on(X, 3, _),
    retract(on(X, 3, _));
    on(X, 2, _),
    retract(on(X, 2, _));
    on(X, 1, _),
    retract(on(X, 1, _)).

win() :-
    on(X, Y, A),
    A \== 'c',       %non considero i bordi
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
     ).

gioca(C) :-
   simula(1, [], L1),
   simula(2, L1, L2),
   simula(3, L2, L3),
   simula(4, L3, L4),
   simula(5, L4, L5),
   simula(6, L5, L6),
   simula(7, L6, L7),
   sort(L7, L),
   last(L, _-C),
   mossa(C, b, 0).

simula(C, L, NL) :-
   mossa(C, b, E),
   E = 0,
   test(R1, b),
   test_avv(R2, a),
   R is R1 - R2,
   anti_mossa(C),
   append([R-C], L, NL);
   NL = L.

estendibile(X,Y,DX,DY,L) :-
    X1 is X + DX,
    Y1 is Y + DY,
    (
          \+ on(X1,Y1,_),
          estendibile(X1,Y1,DX,DY,L1),
          L is L1 + 1;
          on(X1,Y1,_),
          L = 0
     ).

test(R,G) :-
   findall(1, singolo(G), L1),
   length(L1, R1),
   findall(1, doppio(G), L2),
   length(L2, R2),
   findall(1, triplo(G), L3),
   length(L3, R3),
   R = (R1*1)+(R2*3)+(R3*50).

test_avv(R,G) :-
   findall(1, singolo(G), L1),
   length(L1, R1),
   findall(1, doppio(G), L2),
   length(L2, R2),
   findall(1, triplo(G), L3),
   length(L3, R3),
   R = (R1*1)+(R2*5)+(R3*100).

giochiamo():-
    retractall(on(_,_,a)),
    retractall(on(_,_,b)),
    write('Vuoi iniziare tu? si o no '),
    read(A),
    inizio(A).

inizio(A):-
    A == 'si', nl,
    write('scegli colonna:'),
    read(X),
    mossa(X,a,_),
    print,
    partita();
    partita().

partita():-
    win(),
    nl, write('game over').
partita():-
    gioca(C), !, nl,
    write('ho inserito in colonna:'),
    write(C), nl,
    print,
    partita_avv().

partita_avv():-
    win(),
    nl, write('game over').

partita_avv():-
    nl, write('scegli colonna:'),
    read(X),
    prova_mossa(X),
    !,
    print,
    partita().

prova_mossa(X):-
    mossa(X,a,E),
    E \= 1;
    nl, write('colonna piena, riprova'),
    partita_avv().

print :-
    print_board(1,6).

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



