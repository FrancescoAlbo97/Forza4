rangeMin(-5).
rangeMax(5).
punteggio_osservazione1(25).
sogliaMin(-1).
sogliaMax(1).

inizio_allenamento(Memory,MemoryA) :-
    osserva([], Hypo1),
    osserva(Hypo1, Hypo2),
    osserva(Hypo2, Hypo3),
    osserva(Hypo3, Hypo4),
    osserva(Hypo4, Hypo5),
    osserva(Hypo5, Hypo6),
    osserva(Hypo6, Hypo7),
    osserva(Hypo7, Hypo8),
    componi(4,Memory, Hypo8, Hypo9),
    nl,nl,nl,write(Hypo9), write('Hypo9'), nl,nl,nl,
    componi(4,Memory, Hypo9, Hypo10),
    allena(Memory, Hypo10, MemoryA).

allena(Memory, Hypo, MemoryAA) :-
    write(Memory),nl,
    write('allora...   '),
    modifica(Memory, Memory1, 1),
    modifica(Memory, Memory2, 2),
    modifica(Memory, Memory3, 3),
    modifica(Memory, Memory4, 5),
   % nl, write(Memory1), nl,
   % nl, write(Memory2), nl,
   % nl, write(Memory3), nl,
  %  nl, write(Memory4), nl,
   % nl, write(Memory5), nl,
    %nl, write(Memory6), nl,
    %nl, write(Memory7), nl,
    %torneo(Memory, Memory1, Memory2, Memory3, Memory4, Memory5, Memory6, Memory7, Winner),
    campionato([Memory, Memory1, Memory2, Memory3, Memory4], Hypo, Winner),
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

%torneo(M0, M1, M2, M3, M4, M5, M6, M7, Winner) :-
%    sfida(M0, M1, W1),
%    sfida(M2, M3, W2),
%    sfida(M4, M5, W3),
%    sfida(M6, M7, W4),
%    sfida(W1, W2, WW1),
%    sfida(W3, W4, WW2),
%    sfida(WW1, WW2, Winner).

campionato(L, Hypo, NWinner):-
    gironi(L,L,Hypo,Classifica,HypoList, NMatches),
    %nl, write('HypoList = '), write(HypoList), nl,
    conta(L,Classifica, NewClassifica),
    nl, nl, write(' fine campionato, il numero di match è '), write(NMatches), nl, nl,
    %findall(C-X,(member(X,L),conta_occorrenze(X,Classifica,C)),Occorrenze),
    sort(NewClassifica, ClassificaOrdinata),
    last(ClassificaOrdinata,_-Winner),
    length(Hypo,NHypo),
    impara(Winner,NWinner,Hypo,HypoList,NHypo,NMatches).

conta([],_,[]).
conta([T|C], Classifica, NewClassifica):-
    conta(C, Classifica, Class),
    conta_occorrenze(T,Classifica,Occorrenze),
    append(Class,[Occorrenze-T],NewClassifica).

gironi([],_,_,[],[],0).
gironi(L,[T|C],Hypo,NewClassifica,HypoList,NMatches):-
    sfide(T,C,Hypo,Classifica,SHypoList,SfideNMatches),
    delete(L,T,L1),
    append(C,[T],L2),
    gironi(L1, L2, Hypo, Class, OldHypoList,OldNMatches), %corregere C
    append(Class, Classifica, NewClassifica),
    append(OldHypoList, SHypoList, HypoList),
    NMatches is OldNMatches + SfideNMatches.

sfide( _, [], _, [], [], 0).
sfide(M, [T|C], Hypo, NewClassifica, HypoList, SfideNMatches):-
    sfide(M, C, Hypo, Classifica, OldHypoList, OldNMatches),
    sfida(M, T, W, Hypo, H),
    SfideNMatches is OldNMatches + 1,
    append([H], OldHypoList, HypoList),
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

impara(Winner, NNWinner, [[Hypo1]|C1], Matches, Tot, NMatches) :-
    length(C1, L),
    NHypoOss is Tot - L,
    impara(Winner, NWinner, C1, Matches, Tot, NMatches),
    analizza(NHypoOss, Matches, R),
    %nl,write('analizza('),write(NHypoOss),write(','),write(Matches),write(','),write(R),nl,
    write(R),nl,
    (
        R > NMatches/2,
        append([Hypo1], NWinner, NNWinner);
        NNWinner = NWinner
    ).

impara(Winner, Winner, [], _, _, _).

analizza(N, [T|C], R) :-
    take(N, T, El),
    analizza(N, C, R1),
    analizza_mosse(El, R2, _),
    (
        R2 < 4,      %se in quella partita non hai sforato più di 4 volte
        R is R1 + 1;
        R = R1
    ).

analizza(_, [], 0).

analizza_mosse([T|C], R1, W) :-         %ok
    T \== 'a',
    T \== 'b',
    analizza_mosse(C, R, W),
    (
        W == 'a',
        T < (-10),
        R1 is R + 1;
        W == b,
        T > 10,
        R1 is R + 1;
        R1 = R
    ).

analizza_mosse([a], 0, a).

analizza_mosse([b], 0, b).

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

osserva( Memory, NNMemory) :-    %ok
    prendi_coordinate1(X1,Y1,G1),
    punteggio_osservazione1(P),
    append([P], [G1,0,0], Condition1), %costante inizio
    (
         prendi_coordinate2(X1,Y1,X2,Y2),
         X2m is X2*(-1),
         Y2m is Y2*(-1),
         plus(X1, X2m, DX),
         plus(Y1, Y2m, DY),
         on(X2, Y2, G2)
    ),
    append(Condition1, [G2, DX, DY], Condition2),
    append([[Condition2]], Memory, NMemory),
    Condition2 = [_|C],
    P2 is -1 * P,
    write(C),
    append([[[P2|C]]],NMemory,NNMemory).

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
    prendi_coordinate2(X1,Y1,X2,Y2),
    !.

% mantiene dentro un vettore la valutazione di un insieme di condizioni
% considerate singolarmente verificate su un dato stato

corrobora([T|C], RR) :-
    corrobora(C, NR),
    test(R1, a, T, _, _),
    test(R2, b, T, _, _),
    R is R1 - R2,
    append([R], NR, RR).

corrobora([], []).

%sceglie casualmente 2 osservazioni e le fonde creandone una nuova
%NOTA: le due osservazioni coinvolte non vengono eliminate

componi(0,_,Hypo,Hypo).
componi(Conta,Memory,Hypo,NHypo) :-      %ok
    length(Memory, Len),
    random_between(1, Len, N1),
    prendi_numero2(Len, N1, N2),
    take(N1, Memory, [_,G,_,_|C1]),
    take(N2, Memory, [_,G1,_,_,G2, X, Y|_]),
    G == G1,
    append_ordinato_lanciatore(C1,G2,X,Y,CO),
    append([0,G,0,0], CO, C),
    append([[C]], Hypo, NHypo);
    Conta > 0,
    Conta1 is Conta - 1,
    componi(Conta1, Memory, Hypo, NHypo),!.

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


