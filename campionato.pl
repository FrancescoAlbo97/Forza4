% Il campionato è una modalita' di sfide tra le diverse conoscenze create,
% funziona come un unico girone all'italiana con una classifica a punti
% una volta svoltosi il girone basterà ordinare la classifica per punti
% e restituire il vincitore.

campionato(L, Winner):-
    girone(L,Classifica),
    sort(Classifica, ClassificaOrdinata),
    last(ClassificaOrdinata,_-Winner).

% Data una lista di memorie, crea una classifica vuota e poi avvia
% un girone on le sfide di una giornata e poi unisce i punti con
% le classifiche successive
% girone(-ListadiMemorie, +ClassificaNuova)

girone([],[]).
girone([T|C],Classifica) :-
    girone(C,Classifica1),
    sfide(T,C,[T|C],Classifica2),
    unisci_classifiche(Classifica1,Classifica2,Classifica).

% Predicato che lancia sfida tra 2 memorie ed aggiorna la classifica
% sfide(-Sfidante, -RestodelleMemorie, -L, +Classifica)

sfide(_,[],L,Classifica):-
    crea_classifica(L,Classifica).
sfide(M,[T|C],L,Classifica):-
    sfide(M,C,L,NewClassifica),
    sfida_campionato(M, T, P1, P2),!,
    aggiungi_risultato(NewClassifica, M, P1, Classifica1),
    aggiungi_risultato(Classifica1, T, P2, Classifica).

% Crea una classifica vuota, assegnando uno zero accanto ad una memoria
% crea_classifica(-ListadiMemorie, +Classifica)

crea_classifica([],[]).
crea_classifica([T|C],Classifica):-
    crea_classifica(C,NewClassifica),
    append([0-T],NewClassifica,Classifica).

% aggiorna il risultato di una memoria
% aggiungi_risultato(-Classifica,-W,-Punti,+NuovaClassifica)

aggiungi_risultato([N-T|C], W, Punti, Classifica):-
    T \== W,
    aggiungi_risultato(C,W,Punti,NewClassifica),
    append([N-T],NewClassifica,Classifica);
    T == W,
    N1 is N + Punti,
    Classifica = [N1-W|C].

% funziona come sfida solo che assegna 0 punti al perdente o 3 punti al
% vincente mentre in caso di pareggio assegna 1 punto a chi iniziato per
% primo e 2 punti al secondo
% sfida_campionato(-MemoriaPrimoGiocatore, -MemoriaSecondoGiocatore,
% +Punti1, +Punti2)

sfida_campionato(M1, M2,P1,P2) :-
    retractall(on(_,_,a)),
    retractall(on(_,_,b)),
    retractall(on(_,_,h)),
    hole,
    partita_campionato(M1, M2, a,P1,P2).

partita_campionato(_,_, _,P1,P2) :-
    win(W),
    (
        W == a,
        P1 = 3,
        P2 = 0;
        W == b,
        P1 = 0,
        P2 = 3
    ).

partita_campionato(_, _, _,1,2) :-
    pareggio.

partita_campionato(M1, M2, a, P1,P2):-
    profondita(P),
    alpha_beta(a,C,P,M1,_),
    mossa(C,a,_),
    partita_campionato(M1, M2, b, P1,P2).

partita_campionato(M1, M2, b, P1,P2):-
    profondita(P),
    alpha_beta(b,C,P,M2,_),
    mossa(C,b,_),
    partita_campionato(M1, M2, a, P1,P2).

% Unisce i punteggi di 2 classifiche che si sono formate dai gironi
% unisci_classifiche( -ClassificaVecchia, -Classifica, +NuovaClassifica)

unisci_classifiche([],L,L).
unisci_classifiche([N-T|C],[N1-T1|C1],Classifica):-
    N >= N1,
    unisci_classifiche(C,C1,NewClassifica),
    append([N-T],NewClassifica,Classifica);
    N < N1,
    unisci_classifiche(C,C1,NewClassifica),
    append([N1-T1],NewClassifica,Classifica).
