:- dynamic on/3.
:- dynamic storedMemory/1.
:- [bordi].
:- [training].
:- [basic].
:- [regole].
:- [print].
:- [albero].
:- [gioco_cpu].
:- [strategia_cpu].

giochiamo():-
    retractall(storedMemory(_)),
    assert(storedMemory([])),
    giochiamo([],1).

giochiamo(Memory):-
    retractall(storedMemory(_)),
    assert(storedMemory([])),
    giochiamo(Memory,1).

gioca_senza_apprendimento(Memory) :-
    giochiamo(Memory,0).

giochiamo(Memory,0):-
    retractall(on(_,_,a)),
    retractall(on(_,_,b)),
    retractall(on(_,_,h)),
    hole(),
    write('Vuoi iniziare tu? si o no '),
    read(A),
    inizio(A, Memory, 0).
giochiamo(Memory,1):-
    storedMemory(SM),
    append(SM,[Memory],NewMemory),
    assert(storedMemory(NewMemory)),
    retract(storedMemory(SM)),
    retractall(on(_,_,a)),
    retractall(on(_,_,b)),
    retractall(on(_,_,h)),
    hole(),
    write('Vuoi iniziare tu? si o no '),
    read(A),
    inizio(A, Memory, 1).

inizio(A, Memory, Allena):-
    A == 'si', nl,
    partita_human(Memory,Allena);
    A == 'no', nl,
    partita_cpu(Memory, Allena);
    A == 'm', nl,
    write(Memory),nl,
    giochiamo(Memory, Allena);
    A == 'g',
    Allena == 1, nl,
    storedMemory(SM),
    open('grafici_condizioni/output.txt',write,Out),
    write(Out,SM),
    close(Out),
    process_create(path(python3), ['grafici_condizioni/main.py', '--input', 'grafici_condizioni/output.txt'], []),
    write(SM),nl,
    giochiamo(Memory, Allena);
    giochiamo(Memory, Allena).

partita_cpu(Memory,0) :-
    win(_),
    nl, write('game over'),nl,
    giochiamo(Memory,0).
partita_cpu(Memory,1) :-
    win(_),
    inizio_allenamento(Memory,NewMemory),
    giochiamo(NewMemory,1).
partita_cpu(Memory,Allena):-
    %gioca(_, Memory, b), !, nl,
    minimax(b,Mossa,2,Memory,_),
    mossa(Mossa,b,_),
    print,
    partita_human(Memory,Allena).

partita_human(Memory,0):-
    win(_),
    nl, write('game over'),
    giochiamo(Memory,0).
partita_human(Memory,1):-
    win(_),
    nl, write('game over'),
    inizio_allenamento(Memory,NewMemory),
    giochiamo(NewMemory,1).
partita_human(Memory,Allena):-
    nl, write('scegli colonna:'),
    read(X),
    prova_mossa(X,Memory,Allena),
    !,
    print,
    partita_cpu(Memory,Allena).

prova_mossa(X, Memory, Allena):-
    mossa(X,a,E),
    E \= 1;
    nl, write('colonna piena, riprova'),
    partita_human(Memory, Allena).











