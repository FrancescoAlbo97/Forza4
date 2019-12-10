allena(Memory, MemoryAA) :-
    write('allena'),
    write(Memory),
    modifica(Memory, Memory1, 1),
    modifica(Memory, Memory2, 1),
    modifica(Memory, Memory3, 2),
    modifica(Memory, Memory4, 2),
    modifica(Memory, Memory5, 3),
    modifica(Memory, Memory6, 3),
    modifica(Memory, Memory7, 5),
    torneo(Memory, Memory1, Memory2, Memory3, Memory4, Memory5, Memory6, Memory7, Winner),
    normalizza(Winner, MemoryA),
    eliminaZeri(MemoryA, MemoryAA).

% modifica i pesi di tutte le osservazioni in maniera casuale, con M si
% specifica un moltiplicatore che amplifica il range di variazione

modifica([[T|C]|CC], NMemory, M) :-   %ok
    random_between(0, 20, N),
    modifica(CC, Memory, M),
    T1 is T + (N*M),
    append([T1], C, NT),
    append([NT], Memory, NMemory).

modifica([], [], _).

% vengono dai in ingresso 8 giocatori, e viene simulato un torneo ad
% eliminazione diretta, e viene restituito il vincitore

torneo(M0, M1, M2, M3, M4, M5, M6, M7, Winner) :-
    write('torneo, inizio'),nl,
    sfida(M0, M1, W1),
    write('torneo, tra sfide'),nl,
    sfida(M2, M3, W2),
    sfida(M4, M5, W3),
    sfida(M6, M7, W4),
    sfida(W1, W2, WW1),
    sfida(W3, W4, WW2),
    sfida(WW1, WW2, Winner),
    write('torneo, fine'),nl.

% vengono normalizzati i pesi di tutte le osservazioni in modo che il
% peso maggiore sia pari a 100

normalizza(Winner, MemoryA) :-    %ok
    maxList(Winner, N),
    M is 100/N,
    ricalcola(Winner, M, MemoryA).

ricalcola([[T|C]|CC], M, MemoryA) :-     %ok
    ricalcola(CC, M, Memory),
    T1 is M*T,
    append([[T1|C]], Memory, MemoryA).

ricalcola([[T|C]|[]],M , L) :-        %ok
    T1 is M*T,
    L = [[T1|C]].

% tutte le osservazioni con un peso inferiore di 4 vengono
% dimenticate

eliminaZeri([[T|C]|CC], NMemory) :-    %se si fa fallire trova altre soluzioni
   % T \== [[]],
    eliminaZeri(CC, Memory),
    (
        T > 4,
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
        append([0], [G,0,0], Condition1)
    ),
    random_between(1, 7, X2),
    random_between(1, 6, Y2),
    X2m is X2*(-1),
    Y2m is Y2*(-1),
    plus(X1, X2m, DX),
    plus(Y1, Y2m, DY),
    (
        on(X2, Y2, G2),
        append(Condition1, [G2, DX, DY], Condition2)
    ),
    append([Condition2], Memory, NMemory).

%sceglie casualmente 2 osservazioni e le fonde creandone una nuova
%NOTA: le due osservazioni coinvolte non vengono eliminate

componi(Memory, NMemory) :-      %ok
    length(Memory, Len),
    random_between(1, Len, N1),
    random_between(1, Len, N2),
    take(N1, Memory, [T1|C1]),
    take(N2, Memory, [T2,_,_,_,G, X, Y|_]),
    T is (T1 + T2)/2,
    append([T], C1, C),
    append(C, [G, X, Y], C3),
    append([C3], Memory, NMemory).








