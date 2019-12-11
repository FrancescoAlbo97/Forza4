allena(Memory, MemoryAA) :-
    write(Memory),nl,
    write('allora...   '),
    modifica(Memory, Memory1, 1),
    modifica(Memory, Memory2, 1),
    modifica(Memory, Memory3, 2),
    modifica(Memory, Memory4, 2),
    modifica(Memory, Memory5, 3),
    modifica(Memory, Memory6, 3),
    modifica(Memory, Memory7, 5),
    torneo(Memory, Memory1, Memory2, Memory3, Memory4, Memory5, Memory6, Memory7, Winner),
    normalizza(Winner, MemoryA),
    eliminaZeri(MemoryA, MemoryAA),
    write('"bene" '),nl.

% modifica i pesi di tutte le osservazioni in maniera casuale, con M si
% specifica un moltiplicatore che amplifica il range di variazione

modifica([[T|C]|CC], NMemory, M) :-   %ok
    random_between(-5, 5, N),
    modifica(CC, Memory, M),
    T1 is T + (N*M),
    append([T1], C, NT),
    append([NT], Memory, NMemory).

modifica([], [], _).

% vengono dai in ingresso 8 giocatori, e viene simulato un torneo ad
% eliminazione diretta, e viene restituito il vincitore

torneo(M0, M1, M2, M3, M4, M5, M6, M7, Winner) :-
    sfida(M0, M1, W1),
    sfida(M2, M3, W2),
    sfida(M4, M5, W3),
    sfida(M6, M7, W4),
    sfida(W1, W2, WW1),
    sfida(W3, W4, WW2),
    sfida(WW1, WW2, Winner).

% vengono normalizzati i pesi di tutte le osservazioni in modo che il
% peso maggiore sia pari a 100

normalizza(Winner, MemoryA) :-    %ok
    maxList(Winner, Nmax),
    minList(Winner, Nmin),
    M is 100/(Nmax - Nmin),
    ricalcola(Winner, M, Nmin, MemoryA).

ricalcola([[T|C]|CC], M, Nmin, MemoryA) :-     %ok
    ricalcola(CC, M,Nmin, Memory),
    T1 is (T - Nmin)*M,
    T2 is round(T1),
    append([[T2|C]], Memory, MemoryA).

ricalcola([],_, _ , []). %ok

% tutte le osservazioni con un peso inferiore di 4 vengono
% dimenticate

eliminaZeri([[T|C]|CC], NMemory) :-    %se si fa fallire trova altre soluzioni
   % T \== [[]],
    eliminaZeri(CC, Memory),
    (
        (
            T > 53;
            T < 46
        ),
        append([[T|C]], Memory, NMemory);
        NMemory = Memory
    ).

eliminaZeri([], []).                %mmm

% viene osservata una nuova condizione

osserva(Memory, NMemory) :-    %ok
    random_between(1, 7, X1),
    random_between(1, 6, Y1),
    (
        on(X1, Y1, G),
        append([50], [G,0,0], Condition1) %costante 50 inizio
    ),
    prendi_coordinate2(X1,Y1,X2,Y2),
    X2m is X2*(-1),
    Y2m is Y2*(-1),
    plus(X1, X2m, DX),
    plus(Y1, Y2m, DY),
    (
        on(X2, Y2, G2),
        append(Condition1, [G2, DX, DY], Condition2)
    ),
    append([Condition2], Memory, NMemory).

prendi_coordinate2(X1,Y1,X2,Y2):-
    random_between(0, 8, X2),
    random_between(0, 7, Y2),
    (
         X1 \= X2;
         Y1 \= Y2
    ),!;
    prendi_coordinate2(X1,Y1,X2,Y2).


%sceglie casualmente 2 osservazioni e le fonde creandone una nuova
%NOTA: le due osservazioni coinvolte non vengono eliminate

componi(Memory, NMemory) :-      %ok
    length(Memory, Len),
    random_between(1, Len, N1),
    prendi_numero2(Len, N1, N2),
    take(N1, Memory, [T1|C1]),
    take(N2, Memory, [T2,_,_,_,G, X, Y|_]),
    T is (T1 + T2)/2,
    append([T], C1, C),
    append(C, [G, X, Y], C3),
    append([C3], Memory, NMemory).

prendi_numero2(Len, N1, N2):-
    random_between(1, Len, N2),
    N1 \= N2;
    prendi_numero2(Len, N1, N2).







