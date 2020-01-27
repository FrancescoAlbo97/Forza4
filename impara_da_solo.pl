:- dynamic on/3.
:- dynamic storedKnowledge/1.
:- dynamic knowledge/1.
:- dynamic vinte/1.
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

memoria_dojo([[50,a,0,0,a,1,1,a,2,2,a,3,3],[50,a,0,0,a,1,0,a,2,0,a,3,0],[50,a,0,0,a,0,1,a,0,2,a,0,3],[50,a,0,0,a,-1,1,a,-2,2,a,-3,3],[20,a,0,0,h,1,0,a,2,0,h,3,0],[20,a,0,0,a,1,0,h,2,0,h,3,0],[20,a,0,0,h,1,0,h,2,0,a,3,0],[20,h,0,0,h,1,0,a,2,0,a,3,0],[20,h,0,0,a,1,0,h,2,0,a,3,0],[20,h,0,0,a,1,0,a,2,0,h,3,0],[20,a,0,0,h,1,1,a,2,2,h,3,3],[20,a,0,0,h,1,-1,a,2,-2,h,3,-3],[20,a,0,0,a,1,1,h,2,2,h,3,3],[20,a,0,0,a,1,-1,h,2,-2,h,3,-3],[20,a,0,0,h,1,1,h,2,2,a,3,3],[20,a,0,0,h,1,-1,h,2,-2,a,3,-3],[20,h,0,0,h,1,1,a,2,2,a,3,3],[20,h,0,0,h,1,-1,a,2,-2,a,3,-3],[20,h,0,0,a,1,1,h,2,2,a,3,3],[20,h,0,0,a,1,-1,h,2,-2,a,3,-3],[20,h,0,0,a,1,1,a,2,2,h,3,3],[20,h,0,0,a,1,-1,a,2,-2,h,3,-3],[-20,a,0,0,a,1,0,a,2,0,h,3,0,h,3,-1],[-20,h,0,0,h,0,-1,a,1,0,a,2,0,a,3,0],[-20,a,0,0,h,1,0,h,1,-1,a,2,0,a,3,0],[-20,a,0,0,a,1,0,h,2,0,h,2,-1,a,3,0],[-20,a,0,0,a,1,1,a,2,2,h,3,3,h,3,2],[-20,a,0,0,a,1,-1,a,2,-2,h,3,-3,h,3,-4],[-20,h,0,0,h,0,-1,a,1,1,a,2,2,a,3,3],[-20,h,0,0,h,0,-1,a,1,-1,a,2,-2,a,3,-3],[-20,a,0,0,h,1,1,h,1,0,a,2,2,a,3,3],[-20,a,0,0,h,1,-1,h,1,-2,a,2,-2,a,3,-3],[-20,a,0,0,a,1,1,h,2,2,h,2,1,a,3,3],[-20,a,0,0,a,1,-1,h,2,-2,h,2,-3,a,3,-3],[30,a,0,0,a,1,0,a,2,0,h,3,0],[30,h,0,0,a,1,0,a,2,0,a,3,0],[30,a,0,0,h,1,0,a,2,0,a,3,0],[30,a,0,0,a,1,0,h,2,0,a,3,0],[30,a,0,0,a,1,1,a,2,2,h,3,3],[30,a,0,0,a,1,-1,a,2,-2,h,3,-3],[30,h,0,0,a,1,1,a,2,2,a,3,3],[30,h,0,0,a,1,-1,a,2,-2,a,3,-3],[30,a,0,0,h,1,1,a,2,2,a,3,3],[30,a,0,0,h,1,-1,a,2,-2,a,3,-3],[30,a,0,0,a,1,1,h,2,2,a,3,3],[30,a,0,0,a,1,-1,h,2,-2,a,3,-3]]).
profondita_cpu(2).
profondita_dojo(2).
generazioni(3).

inizializza_da_solo:-
    assert(vinte(0)),
    assert(storedKnowledge([])),
    assert(knowledge([])),
    retractall(vinte(_)),
    retractall(storedKnowledge(_)),
    retractall(knowledge(_)),
    assert(vinte(0)),
    assert(storedKnowledge([])),
    assert(knowledge([])).

impara_da_solo(N):-
    inizializza_da_solo,
    gioca_con_memoria(N).

gioca_con_memoria(0):-
    vinte(V),
    nl, write('Scrappy ha vinto '),
    write(V), nl.
gioca_con_memoria(N):-
    knowledge(M),
    N1 is N -1,
    gioca_da_solo(M),
    gioca_con_memoria(N1).

gioca_da_solo(Knowledge):-
    storedKnowledge(SM),
    append(SM,[Knowledge],NKnowledge),
    retractall(storedKnowledge(_)),
    assert(storedKnowledge(NKnowledge)),
    retractall(on(_,_,a)),
    retractall(on(_,_,b)),
    retractall(on(_,_,h)),
    hole,
    partita_dojo(Knowledge).

grafico_allenamento:-
    storedKnowledge(SM),
    open('grafici_condizioni/output.txt',write,Out),
    write(Out,SM),
    close(Out),
    process_create(path(python3), ['grafici_condizioni/main.py', '--input', 'grafici_condizioni/output.txt'], []),
    write(SM),nl.


partita_cpu_sola(Knowledge) :-
    win(_),
    nl, write('Game over, ha vinto dojo'),nl,
    generazioni(G),
    inizio_allenamento(Knowledge, NKnowledge, G),
    retractall(knowledge(_)),
    assert(knowledge(NKnowledge)).


partita_cpu_sola(Knowledge) :-
    pareggio,
    nl, write('Partita patta'),nl,
    generazioni(G),
    inizio_allenamento(Knowledge, NKnowledge, G),
    retractall(knowledge(_)),
    assert(knowledge(NKnowledge)).

partita_cpu_sola(Knowledge):-
    profondita_cpu(P),
    alpha_beta(b, Mossa, P, Knowledge, _),
    mossa(Mossa, b, _),
    partita_dojo(Knowledge).


partita_dojo(Knowledge):-
    win(_),
    nl, write('Game over, ha vinto scrappy'),nl,
    vinte(V),
    V1 is V + 1,
    retractall(vinte(_)),
    assert(vinte(V1)),
    generazioni(G),
    inizio_allenamento(Knowledge, NKnowledge, G),
    retractall(knowledge(_)),
    assert(knowledge(NKnowledge)).


partita_dojo(Knowledge) :-
    pareggio,
    nl, write('Partita patta'),nl,
    generazioni(G),
    inizio_allenamento(Knowledge, NKnowledge, G),
    retractall(knowledge(_)),
    assert(knowledge(NKnowledge)).

partita_dojo(Knowledge):-
    memoria_dojo(M),
    profondita_dojo(P),
    alpha_beta(a, Mossa, P, M, _),
    mossa(Mossa, a, _),
    partita_cpu_sola(Knowledge).
