% Determina il punteggio assegnato a un determinato stato del gioco in
% base alla conoscenza del giocatore
% punteggio_stato(+Knowledge,-Risultato)
punteggio_stato(Knowledge,R) :-
   test(R1, b, Knowledge),
   test(R2, a, Knowledge),
   R is R1 - R2.

% Dato lo stato attuale, trova tutte le azioni che un giocatore può fare
% (colonne non piene su cui è possibile posizionare un altro gettone)
% azioni_successori(-PosAzioni)
azioni_successori(PosAzioni) :-
    findall(X,(
                member(X,[1,2,3,4,5,6,7]),
                altezza_colonna(X,H),
                H < 6
            ),PosAzioni).

% Predicato che verifica se lo stato considerato è una foglia
% dell'albero, assegnandogli di conseguenza un punteggio basato sulla
% conoscenza del giocatore. Si è in una foglia dell'albero quando:
% 1) ha vinto uno dei due giocatori (e si assegna un punteggio positivo
% basato sulla profondità dell'albero in cui avviene se il giocatore b
% ha vinto, mentre un punteggio negativose il vincitore è a)
% 2) si è giunti alla profondità massima, in questo caso si valuta lo
% stato secondo la funzione di valutazione denotata dalla conoscenza del
% giocatore.
% check_foglia(+Knowledge,-Punteggio,+Depth,+MaxDepth)
check_foglia(_,Punteggio,Depth,MaxDepth) :-
    win(b),
    Punteggio is 1000000 / (MaxDepth - Depth + 1).
check_foglia(_,Punteggio,Depth,MaxDepth) :-
    win(a),
    Punteggio is -1000000 / (MaxDepth - Depth + 1).
check_foglia(_,0,_,_) :-
    pareggio.
check_foglia(Knowledge,Punteggio,0,_) :-
    punteggio_stato(Knowledge,Punteggio).

% Determina il punto di potatura dell'albero (avviene quando beta è
% minore o uguale ad alpha).
% cutoff(+Alpha,+Beta)
cutoff(Alpha,Beta) :-
   Beta =< Alpha.

% Aggiorna i valori di Alpha e Beta in base al valore ottenuto
% e al giocatore stesso, considerando che b massimizza e a minimizza.
% aggiorna_alpha_beta(+Giocatore,+Alpha,+Beta,+Value,+NewAlpha,+NewBeta)
aggiorna_alpha_beta(a,Alpha,Beta,Value,Alpha,Value) :-
   Value =< Beta, !.
aggiorna_alpha_beta(a,Alpha,Beta,Value,Alpha,Beta) :-
   Value > Beta.
aggiorna_alpha_beta(b,Alpha,Beta,Value,Value,Beta) :-
   Value >= Alpha, !.
aggiorna_alpha_beta(b,Alpha,Beta,Value,Alpha,Beta) :-
   Value < Beta.


% Predicato che da inizio alla potatura alfa-beta, inizializzandola con
% i dovuti parametri
% alpha_beta(+Giocatore,-Mossa,+Depth,+Knowledge,-Value)
alpha_beta(G,Mossa,Depth,Knowledge,Value) :-
    azioni_successori(Azioni),
    StartingDepth is Depth - 1,
    alpha_beta(G,Knowledge,Mossa,Azioni,StartingDepth,Value,-10000000,10000000,_,1,Depth),
    !.

% Predicato che, se chiamato, avvia l'algoritmo di potatura alfa-beta
% per determinare in quale colonna il giocatore deve posizionare il
% gettone. La variabile ValueAcc è un accumulatore usato per
% memorizzare, tra tutte le opzioni, qquella migliore, mentre Start è
% usata per inizializzarla propriamente.
% alpha_beta(+Giocatore,+Knowledge,-Mossa,+Azioni,+Depth,-Value,+Alpha,+Beta
% ,+ValueAcc,+Start,+MaxDepth)
alpha_beta(_,_,Mossa,[],_,Value,_,_,Value-Mossa,_,_).
alpha_beta(_,_,Mossa,_,_,Value,Alpha,Beta,Value-Mossa,_,_) :-
   cutoff(Alpha,Beta).
alpha_beta(G,Knowledge,Mossa,[T|C],Depth,Value,Alpha,Beta,ValueAcc,Start,MaxDepth) :-
    mossa(T,G,_),
    !,
    azioni_successori(NewActions),
    (
        check_foglia(Knowledge,NValue,Depth,MaxDepth),
        aggiorna_alpha_beta(G,Alpha,Beta,NValue,NewAlpha,NewBeta);
        NewDepth is Depth - 1,
        scambia_giocatore(G,G1),
        alpha_beta(G1,Knowledge,_,NewActions,NewDepth,NValue,Alpha,Beta,_,1,MaxDepth),
        aggiorna_alpha_beta(G,Alpha,Beta,NValue,NewAlpha,NewBeta)
    ),
    (
        Start == 1,
        NewValueAcc = NValue-T;
        Start == 0,
        migliore(NValue-T,ValueAcc,G,NewValueAcc)
    ),
    anti_mossa(T),
    alpha_beta(G,Knowledge,Mossa,C,Depth,Value,NewAlpha,NewBeta,NewValueAcc,0,MaxDepth).

% Predicato che da inizio al minimax, inizializzandolo con
% i dovuti parametri
% minimax(+Giocatore,-Mossa,+Depth,+Knowledge,-Value)
minimax(G,Mossa,Depth,Knowledge,Value) :-
    azioni_successori(Azioni),
    StartingDepth is Depth - 1,
    minimax(G,Knowledge,Mossa,Azioni,StartingDepth,Value,_,1,Depth),
    !.

% Predicato che, se chiamato, avvia l'algoritmo minimax
% per determinare in quale colonna il giocatore deve posizionare il
% gettone. La variabile ValueAcc è un accumulatore usato per
% memorizzare, tra tutte le opzioni, qquella migliore, mentre Start è
% usata per inizializzarla propriamente.
% minimax(+Giocatore,+Knowledge,-Mossa,+Azioni,+Depth,-Value,+ValueAcc,+Start
% ,+MaxDepth)
minimax(_,_,Mossa,[],_,Value,Value-Mossa,_,_).
minimax(G,Knowledge,Mossa,[T|C],Depth,Value,ValueAcc,Start,MaxDepth) :-
    mossa(T,G,_),
    azioni_successori(NewActions),
    (
        check_foglia(Knowledge,NValue,Depth,MaxDepth);
        NewDepth is Depth - 1,
        scambia_giocatore(G,G1),
        minimax(G1,Knowledge,_,NewActions,NewDepth,NValue,_,1,MaxDepth)
    ),
    (
        Start == 1,
        NewValueAcc = NValue-T;
        Start == 0,
        migliore(NValue-T,ValueAcc,G,NewValueAcc)
    ),
    anti_mossa(T),
    minimax(G,Knowledge,Mossa,C,Depth,Value,NewValueAcc,0,MaxDepth).

% Restituisce tra i due punteggi alternativi quello migliore per il
% giocatore. Si ricorda, a tal fine,
% che a è il giocatore minimizzante,
% mentre b è il giocatore massimizzante.
% migliore(+Value1,+Value2,+G,-Result)
migliore(Value1-Action1,Value2-_,a,Value1-Action1) :-
    Value1 < Value2, !.
migliore(Value1-_,Value2-Action2,a,Value2-Action2) :-
    Value1 >= Value2.
migliore(Value1-Action1,Value2-_,b,Value1-Action1) :-
    Value1 > Value2, !.
migliore(Value1-_,Value2-Action2,b,Value2-Action2) :-
    Value1 =< Value2.
