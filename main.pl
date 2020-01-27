:- dynamic on/3.
:- dynamic storedMemory/1.
:- dynamic memory/1.
:- [bordi].
:- [training].
:- [basic].
:- [campionato].
:- [regole].
:- [print].
:- [albero].
:- [gioco_cpu].
:- [strategia_cpu].
:- [genetica].
:- [impara_da_solo].
:- [correction].

% Profondità usata dalla potatura alfa-beta per scegliere la mossa
profondita(2).

inizializza():-
    assert(storedMemory([])),
    assert(memory([])),
    retractall(storedMemory(_)),
    retractall(memory(_)),
    assert(storedMemory([])),
    assert(memory([])).

forza4():-
    inizializza(),
    write('Inserisci la memoria di partenza: '),nl,
    read(M),
    retractall(memory(_)),
    assert(memory(M)),
    giochiamo_con_memoria().

giochiamo_con_memoria():-
    memory(M),
    giochiamo_insieme(M, Quit),
    (
        Quit == 1;
        giochiamo_con_memoria()
    ).

giochiamo_insieme(Knowledge, Quit):-
    storedMemory(SM),
    append(SM,[Knowledge],NKnowledge),
    assert(storedMemory(NKnowledge)),
    retract(storedMemory(SM)),
    retractall(on(_,_,a)),
    retractall(on(_,_,b)),
    retractall(on(_,_,h)),
    hole(),
    writeln('Selezionare tra le seguenti opzioni:'),
    writeln('- si per cominciare una partita giocando per primo'),
    writeln('- no per cominciare una partita giocando per secondo'),
    writeln('- g per mostrare i grafici relativi allo storico per la memoria'),
    writeln('- m per stampare a schermo la memoria della cpu'),
    writeln('- s per salvare la memoria su un file (memoria.txt)'),
    writeln('- q per uscire dal programma'),
    read(A),
    inizio(A, Knowledge, Quit).

inizio(A, Knowledge, Quit):-
    A == 'si', nl,
    partita_umano(Knowledge,4);
    A == 'no', nl,
    partita_cpu(Knowledge);
    A == 'm', nl,
    write(Knowledge),nl,
    giochiamo_insieme(Knowledge, Quit);
    A == 'g',
    grafico_allenamento,
    giochiamo_insieme(Knowledge, Quit);
    A == 's',
    memory(M),
    open('memoria.txt',write,OutMemoria),
    write(OutMemoria,M),
    close(OutMemoria),
    writeln('Memoria salvata nel file memoria.txt'),
    giochiamo_insieme(Knowledge, Quit);
    A == 'q', Quit = 1;
    giochiamo_insieme(Knowledge, Quit).

partita_cpu(Knowledge) :-
    win(_),
    print,
    nl, write('Game over in cpu'),nl,
    write('Quante generazioni creo?'),
    read(A),
    inizio_allenamento(Knowledge, NKnowledge, A),
    retractall(memory(_)),
    assert(memory(NKnowledge)).

partita_cpu(_) :-
    pareggio(),
    print,
    nl, write('Partita patta'),nl.

partita_cpu(Knowledge):-
    profondita(P),
    alpha_beta(b, Mossa, P, Knowledge, _),
    mossa(Mossa, b, _),
    print,
    partita_umano(Knowledge,Mossa).

partita_umano(Knowledge,_):-
    win(_),
    print,
    nl, write('Game over in umano'),nl,
    write('Quante generazioni produco? '),
    read(A),
    inizio_allenamento(Knowledge, NKnowledge, A),
    retractall(memory(_)),
    assert(memory(NKnowledge)).

partita_umano(_,_) :-
    pareggio(),
    print,
    nl, write('Partita patta'),nl.

partita_umano(Knowledge,Mossa):-
    nl, write('Scegli colonna:'),
    read(X),
    correggi_mossa(Knowledge,Mossa,X).

correggi_mossa(Knowledge,Mossa,X):-
    X < 10,
    prova_mossa(X, Knowledge,Mossa),
    !,
    partita_cpu(Knowledge);
    C is floor(X/10),
    correggi(Knowledge, NKnowledge, C, Mossa),
    writeln('Correzione applicata!'),
    X1 is (X - (C*10)),
    correggi_mossa(NKnowledge,Mossa,X1);
    writeln('Mossa inserita non valida, riprova'),
    read(NX),
    correggi_mossa(Knowledge,Mossa,NX).


prova_mossa(X, Knowledge,Mossa):-
    mossa(X,a,E),
    E \= 1;
    nl, write('Colonna piena, riprova'),
    partita_umano(Knowledge,Mossa).











