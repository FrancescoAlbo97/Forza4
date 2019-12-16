%prende n-esimo elemento della lista
%take(+Number,+List,-Element)

take(Number, [_|C], Element) :-
    Number > 0,
    Number1 is Number - 1,
    take(Number1, C, Element).

take(1, [T|_], T).

%restituisce il peso massimo di una lista di liste

maxList([[T|_]|C], Peso) :-
    C \== [],
    maxList(C, MAX),
    (
        T > MAX,
        Peso = T;
        Peso = MAX
    ).

maxList([[T|_]|[]], T).

% restituisce il peso massimo di una lista di liste

minList([[T|_]|C], Peso) :-
    C \== [],
    minList(C, MIN),
    (
        T < MIN,
        Peso = T;
        Peso = MIN
    ).

minList([[T|_]|[]], T).

scambia_giocatore(h,h).
scambia_giocatore(c,c).
scambia_giocatore(G,G1):-
    G == a,
    G1 = b.
scambia_giocatore(G,G1):-
    G == b,
    G1 = a.

%append a due dimensioni  append2(AArray, Array, Result)

append2([T|C], [T1|C1], R) :-
    append2(C, C1, PR),
    append([T1], T, RR),
    append([RR], PR, R).

append2([] , [], []).

%crea una lista L di N elementi A identici

lista_omogenea(N, A, L) :-
    length(L, N),
    maplist(=(A), L).

%confronta due liste e restituisce true se sono identiche

confronta([T|C1], [T|C2]) :-
    confronta(C1, C2).

confronta([], []).

% restituisce l'elemento completo (lista) di una lista di liste
% descritto con variabili mute

recupera(PElement, [T|C], CElement) :-
    PElement = T,
    CElement = T;
    recupera(PElement, C, CElement).

recupera(_,[],[]).





