:- dynamic on/3.
:- [bordi].
:- [training].
:- [basic].
:- [win].
:- [print].

mossa(X, G, E) :-
    member(X, [1,2,3,4,5,6,7]),
    (
          \+ on(X, 6, h),
          E = 1;
          on(X, 6, h),
          \+ on(X, 5, h),
          retract(on(X, 6, h)),
          assert(on(X, 6, G)),
          E = 0;
          on(X, 5, h),
          \+ on(X, 4, h),
          retract(on(X, 5, h)),
          assert(on(X, 5, G)),
          E = 0;
          on(X, 4, h),
          \+ on(X, 3, h),
          retract(on(X, 4, h)),
          assert(on(X, 4, G)),
          E = 0;
          on(X, 3, h),
          \+ on(X, 2, h),
          retract(on(X, 3, h)),
          assert(on(X, 3, G)),
          E = 0;
          on(X, 2, h),
          \+ on(X, 1, h),
          retract(on(X, 2, h)),
          assert(on(X, 2, G)),
          E = 0;
          on(X, 1, h),
          retract(on(X, 1, h)),
          assert(on(X, 1, G)),
          E = 0
     ).

anti_mossa(X) :-
    \+ on(X, 6, h),
    retract(on(X, 6, _)),
    assert(on(X, 6, h));
    \+ on(X, 5, h),
    retract(on(X, 5, _)),
    assert(on(X, 5, h));
    \+ on(X, 4, h),
    retract(on(X, 4, _)),
    assert(on(X, 4, h));
    \+ on(X, 3, h),
    retract(on(X, 3, _)),
    assert(on(X, 3, h));
    \+ on(X, 2, h),
    retract(on(X, 2, _)),
    assert(on(X, 2, h));
    \+ on(X, 1, h),
    retract(on(X, 1, _)),
    assert(on(X, 1, h)).

estendibile(X,Y,DX,DY,L) :-
    X1 is X + DX,
    Y1 is Y + DY,
    (
          on(X1,Y1,h),
          estendibile(X1,Y1,DX,DY,L1),
          L is L1 + 1;
          \+ on(X1,Y1,h),
          L = 0
     ).

giochiamo(Memory):-
    retractall(on(_,_,a)),
    retractall(on(_,_,b)),
    retractall(on(_,_,h)),
    hole(),
    write('Vuoi iniziare tu? si o no '),
    read(A),
    inizio(A, Memory).

sfida(M1, M2, W) :-
    retractall(on(_,_,a)),
    retractall(on(_,_,b)),
    retractall(on(_,_,h)),
    hole(),
    partita(M1, M2, a, W).


gioca(C, Memory, G) :-
   simula(1, [], L1, Memory, G),
   simula(2, L1, L2, Memory, G),
   simula(3, L2, L3, Memory, G),
   simula(4, L3, L4, Memory, G),
   simula(5, L4, L5, Memory, G),
   simula(6, L5, L6, Memory, G),
   simula(7, L6, L7, Memory, G),
   sort(L7, L),
   write(L7),
   last(L, _-C),
   mossa(C, b, 0).

simula(C, L, NL, Memory, a) :-
   mossa(C, a, E),
   E == 0,
   test(R1, a, Memory, _, _),
   test(R2, b, Memory, _, _),
   R is R1 - R2,
   anti_mossa(C),
   %write(R),nl,
   append([R-C], L, NL).
simula(_,L,L,_,a).

simula(C, L, NL, Memory, b) :-
   mossa(C, b, E),
   E == 0,
   test(R1, b, Memory, _, _),
   test(R2, a, Memory, _, _),
   R is R1 - R2,
   anti_mossa(C),
   %write(R),nl,
   append([R-C], L, NL).
simula(_,L,L,_,b).


test(R, G, [[T|C]|CC], X, Y) :-            % [[P1, b, 0, 0, a, 3, 2], ...]
   findall(1, condizione(C, X, Y, G), L1),
   %write(L1),nl,
   length(L1, RR),
   R1 is RR * T,
   test(NR, G, CC, _, _),
   %write(R),nl,
   R is R1 + NR.

test(0, _, [], _, _).

condizione([S, 0, 0|C], X, Y, a) :-
    member(X, [1,2,3,4,5,6,7]),
    member(Y, [1,2,3,4,5,6]),
    on(X, Y, S),
    condizione(C, X, Y, a).

condizione([S, DX, DY|C], X, Y, a) :-
    (
        DX \== 0;
        DY \== 0
    ),!,
    plus(X, DX, X1),
    plus(Y, DY, Y1),
    member(X1, [1,2,3,4,5,6,7]),
    member(Y1, [1,2,3,4,5,6]),
    on(X1, Y1, S),
    condizione(C, X, Y, a).

condizione([S, 0, 0|C], X, Y, b) :-
    member(X, [1,2,3,4,5,6,7]),
    member(Y, [1,2,3,4,5,6]),
       (
        S == 'a',
        on(X, Y, b);
        S == 'b',
        on(X, Y, a);
        S == 'c',
        on(X, Y, c);
        S == 'h',
        on(X, Y, h)
     ),
    condizione(C, X, Y, b).

condizione([S, DX, DY|C], X, Y, b) :-
    (
        DX \== 0;
        DY \== 0
    ),!,
    plus(X, DX, X1),
    plus(Y, DY, Y1),
    member(X1, [1,2,3,4,5,6,7]), %inserire il bordo
    member(Y1, [1,2,3,4,5,6]),
    (
        S == 'a',
        on(X1, Y1, b);
        S == 'b',
        on(X1, Y1, a);
        S == 'c',
        on(X1, Y1, c);
        S == 'h',
        on(X1, Y1, h)
     ),
    condizione(C, X, Y, b).

condizione([], _, _, _).


inizio(A, Memory):-
    A == 'si', nl,
    write('scegli colonna:'),
    read(X),
    mossa(X,a,_),
    print,
    partita_cpu(Memory);
    A == 'm', nl,
    write(Memory);
    partita_cpu(Memory).

partita(_, M2, _, M2) :-   %potrebbe vincere all'ultima mossa
    pareggio().

partita(M1,M2, _, WW) :-
    win_cpu(W),
    (
        W == a,
        WW = M1;
        W == b,
        WW = M2
    ).


partita(M1, M2, a, W):-
    gioca(_, M1, a), %!,
    partita(M1, M2, b, W).

partita(M1, M2, b, W):-
    gioca(_, M2, b), %!,
    partita(M1, M2, a, W).

partita_cpu(Memory):-
    win(Memory, NMemory),
    nl, write('game over'),
    giochiamo(NMemory).

partita_cpu(Memory):-
    gioca(_, Memory, b), !, nl,
    print,
    partita_human(Memory).

partita_human(Memory):-
    win(Memory, NMemory),       %forse evitare di lanciare questo win
    nl, write('game over'),
    giochiamo(NMemory).

partita_human(Memory):-
    nl, write('scegli colonna:'),
    read(X),
    prova_mossa(X, Memory),
    !,
    print,
    partita_cpu(Memory).

prova_mossa(X, Memory):-
    mossa(X,a,E),
    E \= 1;
    nl, write('colonna piena, riprova'),
    partita_human(Memory).











