rangeMin(-5).
rangeMax(5).
punteggio_osservazione1(25).
sogliaMin(-5).
sogliaMax(5).

inizio_allenamento(Memory, NewMemory, Iterations) :-
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
    allena(Memory, Hypo14, NewMemory, Iterations),
    write('allora...   '),nl.

allena(Memory, Hypo, NWinner, Iterations) :-
    eliminaZeri(Memory, MemoryA),
    modifica(MemoryA, Memory1, 1),
    modifica(MemoryA, Memory2, 1),
    modifica(MemoryA, Memory3, 2),
    modifica(MemoryA, Memory4, 2),
    modifica(MemoryA, Memory5, 3),
    modifica(MemoryA, Memory6, 3),
    modifica(MemoryA, Memory7, 5),
    torneo(MemoryA, Memory1, Memory2, Memory3, Memory4, Memory5, Memory6, Memory7, Hypo, Ranking),
    (
        Iterations > 1,
        genetica(Ranking, Winner),
        NIterations is Iterations - 1,
        allena(Winner, [], NWinner, NIterations);
        Ranking = [NWinner|_],
        write('nuova memoria: '),write(NWinner),nl,
        write('"bene" '),nl
    ).

% modifica i pesi di tutte le condizioni di una data conoscenza in
% maniera casuale, con M si specifica un moltiplicatore che amplifica il
% range di variazione
% modifica(+Knowledge, -NKnowledge, +M)

modifica([[Weight|C]|CC], NKnowledge, M) :-
    abs(Weight, AbsWeight),
    rangeMin(Min),
    rangeMax(Max),
    random_between(Min, Max, N),
    modifica(CC, Memory, M),
    Weight2 is (Weight + ((N * (51 - AbsWeight)) / 50) * M),
    round(Weight2, NewWeight),
    append([NewWeight], C, NewCond),
    append([NewCond], Memory, NKnowledge).

modifica([], [], _).

% vengono dati in ingresso 8 conoscenze e viene simulato un torneo ad
% eliminazione diretta, i 4 migliori in classifica vengono poi
% arricchiti (con agg_class) di nuove condizioni (appartenenti ad Hypo)
% testate durante il torneo tramite corrobora, e poi valutate dentro
% impara. La classifica cosi ottenuta viene restituita
% torneo(+K0, +K1, +K2, +K3, +K4, +K5, +K6, +K7, +Hypo, -Ranking)

torneo(K0, K1, K2, K3, K4, K5, K6, K7, Hypo, NNRanking) :-
    sfida(K0, K1, W1, Hypo, H1),
    sfida(K2, K3, W2, Hypo, H2),
    sfida(K4, K5, W3, Hypo, H3),
    sfida(K6, K7, W4, Hypo, H4),
    sfida(W1, W2, WW1, Hypo, H5),
    sfida(W3, W4, WW2, Hypo, H6),
    sfida(WW1, WW2, Winner, Hypo, H7),
    classifica([W1, W2, W3, W4, WW1, WW2, Winner], Ranking),
    classifica4(Ranking, NRanking, Winner),
    length(Hypo, NHypo),
    impara([], NConds, Hypo, [H1, H2, H3, H4, H5, H6, H7], NHypo, 7),
    agg_class(NRanking, NConds, NNRanking).

% aggiunge le condizioni corroborate a tutti i giocatori in classifica
% agg_class(+Ranking, +Conditions, -Result)

agg_class([T|C], NConds, R) :-
    agg_class(C, NConds, PR),
    %append(T,NConds,NR),
    aggiungi_condizioni(NConds,T,NR),
    append(PR, [NR], R).

agg_class([], _, []).

% prende i vincitori delle sfide del torneo e genera la classifica dei
% primi 4
% classifica(+[W1, W2, ...], -Ranking)

classifica([T|C], Ranking) :-
    classifica(C, PRanking),
    (
        \+ member(T, PRanking),
        append(PRanking, [T], Ranking);
        Ranking = PRanking
    ).

classifica([], []).

% Assicura che la classifica ha 4 giocatori, in caso contrario aggiunge
% ripetutamente il vincirore della finale del torneo per raggiungere una
% classifica a 4
% classifica4(+Ranking, -NRanking, +Winner)

classifica4(Ranking, NRanking, Winner) :-
    \+ length(Ranking, 4),
    append([Winner], Ranking, PRanking),
    classifica4(PRanking, NRanking, Winner);
    NRanking = Ranking.

% Riceve in ingresso una serie di condizioni iniziali (IConds), le
% ipotesi testate durante il torneo (Hypo), le valutazioni fatte
% singolarmente da ciascuna ipotesi durante ogni stato incontrato in
% ogni partita del torneo (Rating), la quantita di ipotesi dentro Hypo
% (QHypo), la quantita di sfide fatte nel torneo, quindi il numero di
% sfide nelle quali sono state valutate le ipotesi (QMatches).
% Restituisce (NConds) l'insieme delle ipotesi iniziali a cui appende
% parte delle condizioni di Hypo che durante le sfide del
% torneo hanno mostrato valutazioni in linea con il risultato della
% partita
% impara(+IConds, -NConds, +Hypo, +Rating, +QHypo, +QMatches)

impara(IConds, NConds, [[[Weight|BodyCond]]|Conds], Rating, QHypo, QMatches) :-
    length(Conds, Len),
    NHypoOss is QHypo - Len,
    impara(IConds, PConds, Conds, Rating, QHypo, QMatches),
    analizza(NHypoOss, Rating, R),
    (
        R > QMatches*(3/5),
        (
            PConds = [],
            NConds = [[Weight|BodyCond]];
            PConds = [[Weight2|BodyCond2]|Cond2],
            (
                confronta(BodyCond2, BodyCond),
                NConds = [[0|BodyCond2]|Cond2];
                aggiungi_condizione([Weight|BodyCond], [[Weight2|BodyCond2]|Cond2], NConds)
            )
        );
        NConds = PConds
    ).

impara(IConds, IConds, [], _, _, _).

% Riceve in ingresso NHypoOss che definisce l'ipotesi dentro Hypo da
% analizzare, restituisce il numero di sfide in cui l'ipotesi
% specificata ha rispettato i margini imposti su analizza_mosse
% analizza(+NHypoOss, +Rating, -R)

analizza(NHypoOss, [History|Histories], R) :-
    take(NHypoOss, History, Elem),              %Elem contiene le valutazioni fatte da una specifica condizione in una data sfida
    analizza(NHypoOss, Histories, PR),
    analizza_mosse(Elem, Exceed, _),
    (
        Exceed < 1,      %se in quella partita non hai sforato piu di 1 volta
        R is PR + 1;
        R = PR
    ).

analizza(_, [], 0).

% Riceve le valutazioni fatte da una specifica condizione in una data
% sfida e restituisce il numero di volte in cui la valutazione di quella
% ipotesi non eccede i limiti imposti.
% Restituisce anche il vincitore di quella sfida (Winner).
% analizza_mosse(+Elem, -Exceed, -Winner)

analizza_mosse([T|C], Exceed, Winner) :-      %T contiene la valutazione di uno stato di una data sfida calcolata da una data ipotesi
    T \== 'a',
    T \== 'b',
    analizza_mosse(C, PExceed, Winner),
    (
        Winner == 'a',
        T < (-10),
        Exceed is PExceed + 1;
        Winner == b,
        T > 10,
        Exceed is PExceed + 1;
        Exceed = PExceed
    ).

analizza_mosse([a], 0, a).

analizza_mosse([b], 0, b).

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
    append([[P2|Cond]], NMemory, NNMemory).


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

% viene osservata una nuova condizione creando una nuova potenziale
% memoria. osserva(+Memory, -NNMemory)

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

%seleziona casualmente delle coordinate e la casella di riferimento
% (che dovrà essere una dei 2 giocatori). prendi_coordinate1(-X1, -X2,
% -G1)
prendi_coordinate1(X1,Y1,G1):-
    random_between(1, 7, X1),
    random_between(1, 6, Y1),
    on(X1,Y1,G1),
    G1 \= h,
    G1 \= c;
    prendi_coordinate1(X1,Y1,G1).

% seleziona casualmente delle coordinate in modo che rispettino le
% regole di ordinamento e prenda qualsiasi tipo di casella
% di riferimento (che dovrà essere una dei 2 giocatori).
% prendi_coordinate2(+X1, +Y1, -X2, -Y2)
prendi_coordinate2(X1,Y1,X2,Y2):-
    random_between(X1, 8, X2),
    random_between(0, 7, Y2),
    (
         X1 \= X2;
         Y1 \= Y2
    ),!;
    prendi_coordinate2(X1,Y1,X2,Y2),
    !.

% Restituisce come risultato una lista che contiene le valutazioni fatte
% sullo stato corrente du gioco dall'insieme di condizioni
% contenute su Hypo. L'ordine fra le due liste e consistente: [Cond1,
% Cond2, ...] e [ValCond1, ValCond2, ...]
% corrobora(+Hypo, -Result)

corrobora([T|C], Result) :-
    corrobora(C, PR),
    test(R1, a, T, _, _),
    test(R2, b, T, _, _),
    R is R1 - R2,
    append([R], PR, Result).

corrobora([], []).

%sceglie casualmente 2 osservazioni e le fonde creandone una nuova
%NOTA: le due osservazioni coinvolte non vengono eliminate
%componi(+Conta, +Memory, +Hypo, -NNHypo)

componi(0, _, Hypo, Hypo).

componi(Conta, Memory, Hypo, NNHypo) :-
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

% metodo utile per inserire le osservazioni in un ordine preciso, in
% modo che dopo sia semplice il confronto per trovare i doppioni
% ordine che non dipende da G ma solo da X e Y: le X in ordine
% crescente, in caso siano uguali, le Y in ordine crescente
% append_ordinato(+Condizione, +G1, +X1, +Y1, -R)
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

%sceglie il secondo numero casuale, escludendo il primo.
prendi_numero2(Len, N1, N2) :-
    random_between(1, Len, N2),
    N1 \= N2;
    prendi_numero2(Len, N1, N2),!.

% aggiunge condizioni alla potenziale memoria in maniera ordinata
% aggiungi_condizioni(+Conds, +Memory, -NewMemory)
aggiungi_condizioni([T|C], Memory, NewMemory) :-
    aggiungi_condizione(T,Memory,PMemory),
    aggiungi_condizioni(C,PMemory,NewMemory).
aggiungi_condizioni([],NewMemory,NewMemory).

%metodo per aggiungere una condizione ad una memoria
aggiungi_condizione([T,G,_,_|Cond], Memory, NNMemory):-
    relativo(G, Cond, Cond, Memory),
    inverti_punto_di_vista(G,Cond, Memory),
    add_cond([T,G,0,0|Cond], Memory, NNMemory).

aggiungi_condizione(_,Memory,Memory).

% controllo che non esista la condizione con posizione relativa diversa
% ma stesso significato logico
% relativo(+G, +Condizione, +Condizione, -Memory)
relativo(_,[],_,_).
relativo(G, [G1, DX, DY|C], Cond, Memory):-
    DX \= 0,
    relativo(G,C,Cond,Memory);
    delete(Cond,[G1,DX,DY], Cond1),
    cambia_condizione(DY, Cond1, R),!,
    Y is DY*(-1),
    append_ordinato(R,G,0,Y,R1),!,
    append([G1,0,0], R1, NewCond),
    \+ member([_|NewCond],Memory),
    relativo(G,C,Cond,Memory).

%funzione ausiliaria per relativo
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

%inverte il punto di vista di una condizione per un giocatore.
% quando simula valuta la mossa del proprio avversario avra una sola
% condizione che restituira un peso nella sommatoria e non due.
% inverti_punto_di_vista(+G, +Condizione, +Memory)
inverti_punto_di_vista(G,Cond,Memory):-
    scambia_giocatore(G,G1),
    inverti_punto_di_vista2(Cond,Cond1),
    append([G1,0,0], Cond1, NewCond),
    \+ member([_|NewCond],Memory),
    relativo(G1,NewCond,NewCond,Memory).
inverti_punto_di_vista2([],[]).
inverti_punto_di_vista2([G,X,Y|Cond],NewCond):-
    inverti_punto_di_vista2(Cond,Cond1),
    scambia_giocatore(G,G1),
    append([G1,X,Y],Cond1,NewCond).






















