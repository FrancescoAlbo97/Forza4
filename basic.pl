% Prende n-esimo elemento della lista
% take(+Number, +List, -Element)

take(Number, [_|C], Element) :-
    Number > 0,
    Number1 is Number - 1,
    take(Number1, C, Element).

take(1, [T|_], T).

% Restituisce il peso massimo di una lista di liste
% maxList(+LList, -MaxWeight)

maxList([[T|_]|C], Weight) :-
    C \== [],
    maxList(C, MAX),
    (
        T > MAX,
        Weight = T;
        Weight = MAX
    ).

maxList([[T|_]|[]], T).

% Restituisce il peso minimo di una lista di liste
% minList(+LList, -MinWeight)

minList([[T|_]|C], Weight) :-
    C \== [],
    minList(C, MIN),
    (
        T < MIN,
        Weight = T;
        Weight = MIN
    ).

minList([[T|_]|[]], T).

% Predicato che viene utilizzato simulare il cambio di giocatore
% scambia_giocatore(+G1,-G2)
scambia_giocatore(h,h).
scambia_giocatore(c,c).
scambia_giocatore(a,b).
scambia_giocatore(b,a).

% Append di una lista a una lista di liste
% append2(+LList, +List, -Result)

append2([T|C], [T1|C1], R) :-
    append2(C, C1, PR),
    append([T1], T, RR),
    append([RR], PR, R).

append2([] , [], []).

% Crea una lista L di N elementi A identici
% lista_omogenea(+N, +A, -L)

lista_omogenea(N, A, L) :-
    length(L, N),
    maplist(=(A), L).

% Confronta due liste e restituisce true se sono identiche
% confronta(+List1, +List2)

confronta([T|C1], [T|C2]) :-
    confronta(C1, C2).

confronta([], []).

% Restituisce una lista appartenente ad una lista di liste che
% corrisponde alla lista con variabili mute data in ingresso
% recupera(+List, +LList, -List)

recupera(PElement, [T|C], CElement) :-
    PElement = T,
    CElement = T;
    recupera(PElement, C, CElement).

recupera(_,[],[]).

% Restituisce una lista di N elementi con tutti gli interi da 1 a N
% listaN(N, List)

listaN(1, [1]).

listaN(N, L) :-
    N1 is N - 1,
    listaN(N1, PL),
    append(PL, [N], L),
    !.





