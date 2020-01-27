% Predicato che simula una mossa della cpu in una determinata colonna e 
% ne calcola il punteggio.
% simula(+Column, -Result, +Knowledge, +Player)

simula(C, R, Knowledge, a) :-
   mossa(C, a, 0),
   test(R1, a, Knowledge),
   test(R2, b, Knowledge),
   R is R1 - R2,
   anti_mossa(C).

simula(C, R, Knowledge, b) :-
   mossa(C, b, 0),
   test(R1, b, Knowledge),
   test(R2, a, Knowledge),
   R is R1 - R2,
   anti_mossa(C).

% Predicato che, data una conoscenza composta da condizioni, 
% calcola il punteggio dello stato corrente per il giocatore G.
% test(-Result, +Player, +Knowledge) 

test(R, G, [[T|C]|CC]) :-            % [[P1, b, 0, 0, a, 3, 2], ...]
   findall(_, condizione(C, _, _, G), L1),
   length(L1, RR),
   R1 is RR * T,
   test(NR, G, CC),
   R is R1 + NR.
test(0, _, []).

% Predicato che viene utilizzato per verificare se la condizione 
% specificata si verifica nella scacchiera per il giocatore G.
% condizione(+Condition, +X, +Y, +G)

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
    member(X1, [0,1,2,3,4,5,6,7,8]),
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

