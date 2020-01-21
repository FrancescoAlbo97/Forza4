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
    write('inserisci la memoria di partenza: '),nl,
    read(M),
    assert(memory(M)),
    giochiamo_con_memoria().

giochiamo_con_memoria():-
    memory(M),
    giochiamo_insieme(M),
    giochiamo_con_memoria().

giochiamo_insieme(Knowledge):-
    storedMemory(SM),
    append(SM,[Knowledge],NKnowledge),
    assert(storedMemory(NKnowledge)),
    retract(storedMemory(SM)),
    retractall(on(_,_,a)),
    retractall(on(_,_,b)),
    retractall(on(_,_,h)),
    hole(),
    write('Vuoi iniziare tu? si o no '),
    read(A),
    inizio(A, Knowledge).

inizio(A, Knowledge):-
    A == 'si', nl,
    partita_umano(Knowledge);
    A == 'no', nl,
    partita_cpu(Knowledge);
    A == 'm', nl,
    write(Knowledge),nl,
    giochiamo_insieme(Knowledge);
    A == 'g',
    storedMemory(SM),
    open('grafici_condizioni/output.txt',write,Out),
    write(Out,SM),
    close(Out),
    process_create(path(python3), ['grafici_condizioni/main.py', '--input', 'grafici_condizioni/output.txt'], []),
    write(SM),nl,
    giochiamo_insieme(Knowledge);
    giochiamo_insieme(Knowledge).

partita_cpu(Knowledge) :-
    win(_),
    print,
    nl, write('game over'),nl,
    write('quante generazioni creo?'),
    read(A),
    inizio_allenamento(Knowledge, NKnowledge, A),
    retractall(memory(_)),
    assert(memory(NKnowledge)).

partita_cpu(_) :-
    pareggio(),
    print,
    nl, write('partita patta'),nl.

partita_cpu(Knowledge):-
    profondita(P),
    alpha_beta(b, Mossa, P, Knowledge, _),
    mossa(Mossa, b, _),
    print,
    partita_umano(Knowledge).

partita_umano(Knowledge):-
    win(_),
    print,
    nl, write('game over'),nl,
    write('quante generazioni produco? '),
    read(A),
    inizio_allenamento(Knowledge, NKnowledge, A),
    retractall(memory(_)),
    assert(memory(NKnowledge)).

partita_umano(_) :-
    pareggio(),
    print,
    nl, write('partita patta'),nl.

partita_umano(Knowledge):-
    nl, write('scegli colonna:'),
    read(X),
    prova_mossa(X, Knowledge),
    !,
    partita_cpu(Knowledge).

prova_mossa(X, Knowledge):-
    mossa(X,a,E),
    E \= 1;
    nl, write('colonna piena, riprova'),
    partita_umano(Knowledge).











