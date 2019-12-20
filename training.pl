rangeMin(-5).
rangeMax(5).
punteggio_osservazione1(25).
sogliaMin(-5).
sogliaMax(5).

inizio_allenamento(Memory, NewMemory) :-
    osserva([], Hypo1),
    osserva(Hypo1, Hypo2),
    osserva(Hypo2, Hypo3),
    osserva(Hypo3, Hypo4),
    osserva(Hypo4, Hypo5),
    osserva(Hypo5, Hypo6),
    osserva(Hypo6, Hypo7),
    osserva(Hypo7, Hypo8),
    osserva(Hypo8, Hypo9),
    osserva(Hypo9, Hypo10),
    componi(4,Memory, Hypo10, Hypo11),
    componi(4,Memory, Hypo11, Hypo12),
    componi(4,Memory, Hypo12, Hypo13),
    componi(4,Memory, Hypo13, Hypo14),
    allena(Memory, Hypo14, NewMemory).

allena(Memory, Hypo, Winner) :-
    write('allora...   '),nl,
    eliminaZeri(Memory, MemoryA),
    modifica(MemoryA, Memory1, 1),
    modifica(MemoryA, Memory2, 1),
    modifica(MemoryA, Memory3, 2),
    modifica(MemoryA, Memory4, 2),
    modifica(MemoryA, Memory5, 3),
    modifica(MemoryA, Memory6, 3),
    modifica(MemoryA, Memory7, 5),
    torneo(MemoryA, Memory1, Memory2, Memory3, Memory4, Memory5, Memory6, Memory7, Hypo, Winner),
    write('nuova memoria: '),write(Winner),nl,
    write('"bene" '),nl.

% modifica i pesi di tutte le osservazioni in maniera casuale, con M si
% specifica un moltiplicatore che amplifica il range di variazione

% T è il peso della condizione, C è il corpo della condizione, CC
% contiene il resto delle condizioni. NMemory è la nuova memoria in
% uscita e M è il moltiplicatore che amplifica il range di variazione
% DA VEDERE: Nome della variabile Memory in modifica(CC, Memory, M).

modifica([[Weight|C]|CC], NMemory, M) :-
    abs(Weight, AbsWeight),
    rangeMin(Min),
    rangeMax(Max),
    random_between(Min, Max, N),
    modifica(CC, Memory, M),
    Weight2 is (Weight + ((N * (51 - AbsWeight)) / 50) * M),
    round(Weight2, NewWeight),
    append([NewWeight], C, NewCond),
    append([NewCond], Memory, NMemory).

modifica([], [], _).

% vengono dai in ingresso 8 giocatori, e viene simulato un torneo ad
% eliminazione diretta, e viene restituito il vincitore

% H1, ..., H7 array di array che presentano la forma [n1i, n2i, n3i,
% ..., w]

torneo(M0, M1, M2, M3, M4, M5, M6, M7, Hypo, NWinner) :-
    sfida(M0, M1, W1, Hypo, H1),
    sfida(M2, M3, W2, Hypo, H2),
    sfida(M4, M5, W3, Hypo, H3),
    sfida(M6, M7, W4, Hypo, H4),
    sfida(W1, W2, WW1, Hypo, H5),
    sfida(W3, W4, WW2, Hypo, H6),
    sfida(WW1, WW2, Winner, Hypo, H7),
    length(Hypo, NHypo),
    impara(Winner, NWinner, Hypo, [H1, H2, H3, H4, H5, H6, H7], NHypo, 7).

% DA VEDERE CON ALBO
% NHypoOss indica quale ipotesi stai valutando (distanza rispetto al
% totale), Matches contiene i dati relativi a tutte le ipotesi nelle
% varie partite del torneo

impara(Winner, NNWinner, [[[Weight|CC]]|C1], Matches, Tot, NMatches) :-
    length(C1, L),
    NHypoOss is Tot - L,
    impara(Winner, NWinner, C1, Matches, Tot, NMatches),
    analizza(NHypoOss, Matches, R),
    (
        R > NMatches*(3/5),
        (
            NWinner = [],
            NNWinner = [[Weight|CC]];
            NWinner = [[P2|CC1]|CCC],
            (
                confronta(CC1, CC),
                NNWinner = [[0|CC1]|CCC];
                aggiungi_condizione([Weight|CC], [[P2|CC1]|CCC], NNWinner)
            )
        );
        NNWinner = NWinner
    ).
impara(Winner, Winner, [], _, _, _).

add_cond([T|Cond], Memory, NNMemory) :-
    \+ member([_|Cond], Memory),
    append([[T|Cond]], Memory, NNMemory);
    recupera([_|Cond], Memory, [P|Cond]),
    delete(Memory, [P|Cond], NMemory),
    abs(P,PA),
    (
        T == 25,
        P1 is (P + (5*(51-PA))/50);
        T == -25,
        P1 is (P + ((-5)*(51-PA))/50);
        T == 0,
        P1 = P
    ),
    round(P1, P2),
    append([[P2|Cond]], NMemory, NNMemory),
    write('NNMemory = '),writeln(NNMemory),
    write('NMemory = '),writeln(NMemory),
    write('Memory = '),writeln(Memory).

analizza(N, [T|C], R) :-
    take(N, T, El),
    analizza(N, C, R1),
    analizza_mosse(El, R2, _),
    (
        R2 < 1,      %se in quella partita non hai sforato piu di 1 volta
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

eliminaZeri([], []).

% viene osservata una nuova condizione

osserva( Memory, NNMemory) :-
    prendi_coordinate1(X1,Y1,G1),
    punteggio_osservazione1(P),
    append([P], [G1,0,0], Condition1), %costante inizio
    (
         prendi_coordinate2(X1,Y1,X2,Y2),
         X1m is X1*(-1),
         Y1m is Y1*(-1),
         plus(X2, X1m, DX),
         plus(Y2, Y1m, DY),
         on(X2, Y2, G2)
    ),
    append(Condition1, [G2, DX, DY], Condition2),
    append([[Condition2]], Memory, NMemory),
    Condition2 = [_|C],
    P2 is -1 * P,
    append([[[P2|C]]],NMemory,NNMemory).

prendi_coordinate1(X1,Y1,G1):-
    random_between(1, 7, X1),
    random_between(1, 6, Y1),
    on(X1,Y1,G1),
    G1 \= h;
    prendi_coordinate1(X1,Y1,G1).

prendi_coordinate2(X1,Y1,X2,Y2):-
    random_between(X1, 8, X2),
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

componi(0, _, Hypo, Hypo).

componi(Conta,Memory,Hypo,NNHypo) :-      %ok
%   write('componi'),nl,
    Conta > 0,
    (
        length(Memory, Len),
        Len > 1,             %per comporre devo avere almeno 2 elementi
        random_between(1, Len, N1),
        prendi_numero2(Len, N1, N2),
        take(N1, Memory, [_,G,_,_|C]),
        take(N2, Memory, [_,G1,_,_,G2,X,Y|_]),
        G == G1,
        append_ordinato(C,G2,X,Y,R),
        punteggio_osservazione1(P),
        P2 is -1 * P,
        append([P,G,0,0], R, C1),
        append([P2,G,0,0], R, C2),
        append([[C1]], Hypo, NHypo),
        append([[C2]], NHypo, NNHypo);
        Conta1 is Conta - 1,
        componi(Conta1, Memory, Hypo, NNHypo)
    ).

append_ordinato([G,X,Y|C],G1,X1,Y1,R) :-
    X1 < X,
    append([G1,X1,Y1,G,X,Y],C,R);
    X1 == X,
    Y1 < Y,
    append([G1,X1,Y1,G,X,Y],C,R);
    X1 == X,
    Y1 == Y,
    R = [];
    append_ordinato(C,G1,X1,Y1,NR),
    append([G,X,Y],NR,R).

append_ordinato([], G1, X1, Y1, [G1, X1, Y1]).

prendi_numero2(Len, N1, N2) :-
    random_between(1, Len, N2),
    N1 \= N2;
    prendi_numero2(Len, N1, N2),!.

aggiungi_condizione([T,G,_,_|Cond], Memory, NNMemory):-
    relativo(G, Cond, Cond, Memory),
    inverti_punto_di_vista(G,Cond,Memory),
    add_cond([T,G,0,0|Cond], Memory, NNMemory).
aggiungi_condizione(_,Memory,Memory).

relativo(_,[],_,_).
relativo(G, [G1, DX, DY|C], Cond, Memory):-
    DX \= 0,
    relativo(G,C,Cond,Memory);
    delete(Cond,[G1,DX,DY], Cond1),
    cambia_condizione(DY, Cond1, R),!,
    Y is DY*(-1),
    append_ordinato(R,G,0,Y,R1),
    append([G1,0,0], R1, NewCond),
    \+ member([_|NewCond],Memory),
    relativo(G,C,Cond,Memory).

cambia_condizione(DY,L, R):-
    Y is DY*(-1),
    cambia_condizione2(Y,L,[],R),!.

cambia_condizione2(_,[],A,A).
cambia_condizione2(DY, [G1, X1, Y1|C], A,R):-
   Y is Y1 + DY,
   Y \= 0,
   append_ordinato(A, G1,X1,Y, NR),
   cambia_condizione2(DY, C, NR, R);
   cambia_condizione2(DY, C, A, R).

inverti_punto_di_vista(G,Cond,Memory):-
    scambia_giocatore(G,G1),
    inverti_punto_di_vista2(Cond,Cond1),
    append([G1,0,0], Cond1, NewCond),
    \+ member([_|NewCond],Memory).
inverti_punto_di_vista2([],[]).
inverti_punto_di_vista2([G,X,Y|Cond],NewCond):-
    inverti_punto_di_vista2(Cond,Cond1),
    scambia_giocatore(G,G1),
    append([G1,X,Y],Cond1,NewCond).
























