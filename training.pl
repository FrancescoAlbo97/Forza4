rangeMin(-5).
rangeMax(5).
punteggio_osservazione1(0).
sogliaMin(-1).
sogliaMax(1).


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
   % nl, write(Memory1), nl,
   % nl, write(Memory2), nl,
   % nl, write(Memory3), nl,
  %  nl, write(Memory4), nl,
   % nl, write(Memory5), nl,
    %nl, write(Memory6), nl,
    %nl, write(Memory7), nl,
    %torneo(Memory, Memory1, Memory2, Memory3, Memory4, Memory5, Memory6, Memory7, Winner),
    campionato([Memory, Memory1, Memory2, Memory3, Memory4, Memory5, Memory6, Memory7], Winner),
    %normalizza(Winner, MemoryA),
    eliminaZeri(Winner, MemoryAA),
    write('"bene" '),nl.

% modifica i pesi di tutte le osservazioni in maniera casuale, con M si
% specifica un moltiplicatore che amplifica il range di variazione

modifica([[T|C]|CC], NMemory, M) :-   %ok
    abs(T,TA),
    rangeMin(Min),
    rangeMax(Max),
    random_between(Min, Max, N),
    modifica(CC, Memory, M),
    T2 is (T + ((N*(51-TA))/50)*M),
    round(T2,T1),
    append([T1], C, NT),
    append([NT], Memory, NMemory).
    %normalizza(MemoryA,NMemory).

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

campionato(L, Winner):-
    gironi(L,L,Classifica),
    conta(L,Classifica, NewClassifica),
    %findall(C-X,(member(X,L),conta_occorrenze(X,Classifica,C)),Occorrenze),
    sort(NewClassifica, ClassificaOrdinata),
    last(ClassificaOrdinata,_-Winner).

conta([],_,[]).
conta([T|C], Classifica, NewClassifica):-
    conta(C, Classifica, Class),
    conta_occorrenze(T,Classifica,Occorrenze),
    append(Class,[Occorrenze-T],NewClassifica).

gironi([],_, []).
gironi(L,[T|C], NewClassifica):-
    sfide(T,C,Classifica),
    delete(L,T,L1),
    append(C,[T],L2),
    gironi(L1, L2, Class), %corregere C
    append(Class, Classifica, NewClassifica).

scambia([T|C], [T|L2]):-
        append([],C,L2).

sfide( _, [], []).
sfide(M, [T|C], NewClassifica):-
    sfide(M, C, Classifica),
    sfida(M, T, W),
    %nl, write(M), nl,
    %write( ' VS '),
    %nl, write(T), nl,
    append(Classifica, W, NewClassifica).

conta_occorrenze(_,[],0).
conta_occorrenze(X,[T|C],Occorrenze) :-
    conta_occorrenze(X,C,OldOccorrenze),
    conta_in_lista(X,T,Cont),
    !,
    Occorrenze is OldOccorrenze + Cont.

conta_in_lista(_,[],0).
conta_in_lista(X,[X|C],Cont) :-
    conta_in_lista(X,C,O),
    Cont is O + 1.
conta_in_lista(X,[T|C],Cont) :-
    C \= T,
    conta_in_lista(X,C,Cont).

% vengono normalizzati i pesi di tutte le osservazioni in modo che il
% peso maggiore sia pari a 100

normalizza(Winner, MemoryA) :-    %ok
    maxList(Winner, Nmax),
    minList(Winner, Nmin),
    M is 100/(Nmax - Nmin + 1),
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
    sogliaMin(Min),
    sogliaMax(Max),
    (
        (
            T > Max;
            T < Min
        ),
        append([[T|C]], Memory, NMemory);
        NMemory = Memory
    ).

eliminaZeri([], []).                %mmm

% viene osservata una nuova condizione

osserva(0, Memory, Memory).
osserva(Conta, Memory, NMemory) :-    %ok
    prendi_coordinate1(X1,Y1,G1),
    punteggio_osservazione1(P),
    append([P], [G1,0,0], Condition1), %costante inizio
    (
         prendi_coordinate2(X1,Y1,X2,Y2),
         X2m is X2*(-1),
         Y2m is Y2*(-1),
         plus(X1, X2m, DX),
         plus(Y1, Y2m, DY),
         on(X2, Y2, G2),
         G2 \= h
    ),
    append(Condition1, [G2, DX, DY], Condition2),
    %controllo_ripetizione(Memory, Condition2),
    append([Condition2], Memory, NMemory);
    Conta > 0,
    Conta1 is Conta - 1,
    osserva(Conta1,Memory, NMemory),!.

%controllo_ripetizione([T|C],L):-
    %findall(_,(member(a,T),member(a,L)

prendi_coordinate1(X1,Y1,G1):-
    random_between(1, 7, X1),
    random_between(1, 6, Y1),
    on(X1,Y1,G1),
    G1 \= h;
    prendi_coordinate1(X1,Y1,G1).

prendi_coordinate2(X1,Y1,X2,Y2):-
    random_between(0, X1, X2),
    random_between(0, 7, Y2),
    (
         X1 \= X2;
         Y1 \= Y2
    ),!;
    prendi_coordinate2(X1,Y1,X2,Y2).


%sceglie casualmente 2 osservazioni e le fonde creandone una nuova
%NOTA: le due osservazioni coinvolte non vengono eliminate

componi(0, Memory, Memory).
componi(Conta,Memory, NMemory) :-      %ok
    length(Memory, Len),
    random_between(1, Len, N1),
    prendi_numero2(Len, N1, N2),
    take(N1, Memory, [_,G,_,_|C1]),
    take(N2, Memory, [_,G1,_,_,G2, X, Y|_]),
    G == G1,
    append_ordinato_lanciatore(C1,G2,X,Y,CO),
    append([0,G,0,0], CO, C),
    append([C], Memory, NMemory);
    Conta > 0,
    Conta1 is Conta - 1,
    componi(Conta1, Memory, NMemory),!.

append_ordinato_lanciatore(C1,G2,X,Y,CO):-
    append_ordinato(C1,G2,X,Y,[],CO).

append_ordinato([],G1,X1,Y1,CS,CO):-
    append(CS,[G1,X1,Y1],CO).
append_ordinato([G,X,Y|C],G1,X1,Y1,CS,CO):-
    X1 < X,
    append([G1,X1,Y1,G,X,Y],C,CO);
    X1 == X,
    Y1 < Y,
    append([G1,X1,Y1,G,X,Y],C,CO);
    X1 == X,
    Y1 == Y,
    CO = [];
    append(CS,[G,X,Y],CO),
    append_ordinato(C,G1,X1,Y1,CS,CO).

prendi_numero2(Len, N1, N2):-
    random_between(1, Len, N2),
    N1 \= N2;
    prendi_numero2(Len, N1, N2).


