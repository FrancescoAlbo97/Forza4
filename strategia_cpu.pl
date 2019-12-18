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

