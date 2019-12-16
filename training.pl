rangeMin(-5).
rangeMax(5).
punteggio_osservazione1(25).
sogliaMin(-5).
sogliaMax(5).

inizio_allenamento(Memory, MemoryA) :-
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
    allena(Memory, Hypo14, MemoryA).

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

modifica([], [], _).

% vengono dai in ingresso 8 giocatori, e viene simulato un torneo ad
% eliminazione diretta, e viene restituito il vincitore

torneo(M0, M1, M2, M3, M4, M5, M6, M7, Hypo, NWinner) :-
    sfida(M0, M1, W1, Hypo, H1),
    sfida(M2, M3, W2, Hypo, H2),
    sfida(M4, M5, W3, Hypo, H3),
    sfida(M6, M7, W4, Hypo, H4),
    sfida(W1, W2, WW1, Hypo, H5),
    sfida(W3, W4, WW2, Hypo, H6),
    sfida(WW1, WW2, Winner, Hypo, H7),
    length(Hypo, NHypo),
    NMatches = 7,
    nl,nl,write([H1,H2,H3,H4,H5,H6,H7]),nl,nl,
    impara(Winner, NWinner, Hypo, [H1, H2, H3, H4, H5, H6, H7], NHypo, NMatches).

impara(Winner, NNWinner, [[[P|CC]]|C1], Matches, Tot, NMatches) :-
%   write('impara'),nl,
    length(C1, L),
    NHypoOss is Tot - L,
    impara(Winner, NWinner, C1, Matches, Tot, NMatches),
    analizza(NHypoOss, Matches, R),
    (
        R > NMatches*(3/5),
        (
            NWinner = [],
            NNWinner = [[P|CC]];
            NWinner = [[P2|CC1]|CCC],
            (
                confronta(CC1, CC),
                NNWinner = [[0|CC1]|CCC];
                add_cond([P|CC], [[P2|CC1]|CCC], NNWinner)
             %  append([[P|CC]], [[P2|CC1]|CCC], NNWinner)
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
%   write('analizza'),nl,
    take(N, T, El),
    analizza(N, C, R1),
    analizza_mosse(El, R2, _),
    (
        R2 < 1,      %se in quella partita non hai sforato piu di 4 volte
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

eliminaZeri([], []).                %mmm

% viene osservata una nuova condizione

osserva( Memory, NNMemory) :-    %ok
%   write('osserva'),nl,
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

componi(0, _, Hypo, Hypo).

componi(Conta,Memory,Hypo,NNHypo) :-      %ok
%   write('componi'),nl,
    Conta > 0,
    (
        length(Memory, Len),
        Len > 1,             %per comporre devo avere almeno 2 elementi
        random_between(1, Len, N1),
        prendi_numero2(Len, N1, N2),!,
        take(N1, Memory, [_,G,_,_|C1]),
        take(N2, Memory, [_,G1,_,_,G2,X,Y|_]),
        G == G1,
        append_ordinato(C1,G2,X,Y,R),
        punteggio_osservazione1(P),
        P2 is -1 * P,
        append([P,G,0,0], R, C),
        append([P2,G,0,0], R, C2),
        append([[C]], Hypo, NHypo),
        append([[C2]], NHypo, NNHypo);
        Conta1 is Conta - 1,
        componi(Conta1, Memory, Hypo, NNHypo)
    ).

append_ordinato([G,X,Y|C],G1,X1,Y1,R) :-
%   write('append'),nl,
    X1 < X,
    append([G1,X1,Y1,G,X,Y],C,R);
    X1 == X,
    Y1 < Y,
    append([G1,X1,Y1,G,X,Y],C,R);
    X1 == X,
    Y1 == Y,
    append([G,X,Y],C,R);
    append_ordinato(C,G1,X1,Y1,NR),
    append(NR,[G,X,Y],R).

append_ordinato([], G1, X1, Y1, [G1, X1, Y1]).

prendi_numero2(Len, N1, N2) :-
%   write(prendi_numero2),nl,
    random_between(1, Len, N2),
    N1 \= N2;
    prendi_numero2(Len, N1, N2).













