:- dynamic on/3.
:- dynamic storedMemory/1.
:- [bordi].
:- [training].
:- [basic].
:- [win].
:- [print].

mossa(X,_,1) :-
    altezza_colonna(X,6).
mossa(X,G,0) :-
    altezza_colonna(X,H),
    H1 is H + 1,
    retract(on(X,H1,h)),
    assert(on(X,H1,G)).

anti_mossa(X) :-
    altezza_colonna(X,H),
    retract(on(X,H,_)),
    assert(on(X,H,h)).

giochiamoC():-
    retractall(storedMemory(_)),
    assert(storedMemory([])),
    %giochiamo([[20,a,0,0,a,1,0]]).
    giochiamo([[10,a,0,0,a,0,1],[10,a,0,0,a,1,0],[-20,b,0,0,b,0,1,b,0,2,h,0,3],[-50,b,0,0,b,0,1,b,0,2,b,0,3],[-50,b,0,0,b,1,0,b,2,0,b,3,0],[50,a,0,0,a,0,1,a,0,2,a,0,3]],1).

giochiamo():-
    retractall(storedMemory(_)),
    assert(storedMemory([])),
    giochiamo([],1).

giochiamo(Memory):-
    retractall(storedMemory(_)),
    assert(storedMemory([])),
    giochiamo(Memory,1).

gioca_senza_apprendimento(Memory) :-
    giochiamo(Memory,0).

giochiamo(Memory,0):-
    retractall(on(_,_,a)),
    retractall(on(_,_,b)),
    retractall(on(_,_,h)),
    hole(),
    write('Vuoi iniziare tu? si o no '),
    read(A),
    inizio(A, Memory, 0).
giochiamo(Memory,1):-
    storedMemory(SM),
    append(SM,[Memory],NewMemory),
    assert(storedMemory(NewMemory)),
    retract(storedMemory(SM)),
    retractall(on(_,_,a)),
    retractall(on(_,_,b)),
    retractall(on(_,_,h)),
    hole(),
    write('Vuoi iniziare tu? si o no '),
    read(A),
    inizio(A, Memory, 1).

sfida(M1, M2, W, Hypo, History) :-
    retractall(on(_,_,a)),
    retractall(on(_,_,b)),
    retractall(on(_,_,h)),
    hole(),
    partita(M1, M2, a, W, Hypo, History).

gioca(C, Memory, G) :-
   simula(1, [], L1, Memory, G),
   simula(2, L1, L2, Memory, G),
   simula(3, L2, L3, Memory, G),
   simula(4, L3, L4, Memory, G),
   simula(5, L4, L5, Memory, G),
   simula(6, L5, L6, Memory, G),
   simula(7, L6, L7, Memory, G),
   sort(L7, L),
   last(L, _-C),
   mossa(C, G, 0).

punteggio_stato(Memory,R,a) :-
   test(R1, b, Memory, _, _),
   test(R2, a, Memory, _, _),
   R is R1 - R2.
punteggio_stato(Memory,R,b) :-
   test(R1, a, Memory, _, _),
   test(R2, b, Memory, _, _),
   R is R1 - R2.


simula(C, L, NL, Memory, a) :-
   mossa(C, a, 0),
   test(R1, a, Memory, _, _),
   test(R2, b, Memory, _, _),
   R is R1 - R2,
   anti_mossa(C),
   append([R-C], L, NL).

simula(_,L,L,_,a).

simula(C, L, NL, Memory, b) :-
   mossa(C, b, 0),
   test(R1, b, Memory, _, _),
   test(R2, a, Memory, _, _),
   R is R1 - R2,
   anti_mossa(C),
   append([R-C], L, NL).

simula(_,L,L,_,b).

test(R, G, [[T|C]|CC], X, Y) :-            % [[P1, b, 0, 0, a, 3, 2], ...]
   findall(_, condizione(C, X, Y, G), L1),
   length(L1, RR),
   R1 is RR * T,
   test(NR, G, CC, _, _),
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
    X1 is X + DX,
    Y1 is Y + DY,
    member(X1, [0,1,2,3,4,5,6,7,8]),
    member(Y1, [0,1,2,3,4,5,6,7]),
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
    X1 is X + DX,
    Y1 is Y + DY,
    member(X1, [0,1,2,3,4,5,6,7,8]), %inserire il bordo
    member(Y1, [0,1,2,3,4,5,6,7]),
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


inizio(A, Memory, Allena):-
    A == 'si', nl,
    partita_human(Memory,Allena);
    A == 'no', nl,
    partita_cpu(Memory, Allena);
    A == 'm', nl,
    write(Memory),nl,
    giochiamo(Memory, Allena);
    A == 'g',
    Allena == 1, nl,
    storedMemory(SM),
    open('grafici_condizioni/output.txt',write,Out),
    write(Out,SM),
    close(Out),
    process_create(path(python3), ['grafici_condizioni/main.py', '--input', 'grafici_condizioni/output.txt'], []),
    write(SM),nl,
    giochiamo(Memory, Allena);
    giochiamo(Memory, Allena).

partita(_, M2, _, M2, Hypo, History) :-   %potrebbe vincere all'ultima mossa
    pareggio(),
    length(Hypo, N),
    lista_omogenea(N,[b],History).

partita(M1,M2, _, WW, Hypo, History) :-
    win(W),
    (
        W == a,
        WW = M1;
        W == b,
        WW = M2
    ),
    length(Hypo, N),
    lista_omogenea(N,[W],History).


partita(M1, M2, a, W, Hypo, History):-
    corrobora(Hypo,R),
    gioca(_, M1, a),
    %print,
    partita(M1, M2, b, W, Hypo, NHistory),
    append2(NHistory, R, History).

partita(M1, M2, b, W, Hypo, History):-
    gioca(_, M2, b),
    partita(M1, M2, a, W, Hypo, History).

partita_cpu(Memory,0) :-
    win(_),
    nl, write('game over'),nl,
    giochiamo(Memory,0).
partita_cpu(Memory,1) :-
    win(_),
    inizio_allenamento(Memory,NewMemory),
    giochiamo(NewMemory,1).
partita_cpu(Memory,Allena):-
    gioca(_, Memory, b), !, nl,
    print,
    partita_human(Memory,Allena).

partita_human(Memory,0):-
    win(_),
    nl, write('game over'),
    giochiamo(Memory,0).
partita_human(Memory,1):-
    win(_),
    nl, write('game over'),
    inizio_allenamento(Memory,NewMemory),
    giochiamo(NewMemory,1).
partita_human(Memory,Allena):-
    nl, write('scegli colonna:'),
    read(X),
    prova_mossa(X,Memory,Allena),
    !,
    print,
    partita_cpu(Memory,Allena).

prova_mossa(X, Memory, Allena):-
    mossa(X,a,E),
    E \= 1;
    nl, write('colonna piena, riprova'),
    partita_human(Memory, Allena).











