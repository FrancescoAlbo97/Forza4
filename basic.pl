%unisce due insiemi restituendo al terzo argomento l'insieme risultante

%union([],[],[]).
%union(List1,[],List1).
%union(List1, [Head2|Tail2], [Head2|Output]):-
%    \+(member(Head2,List1)),
%    union(List1,Tail2,Output).
%union(List1, [Head2|Tail2], Output):-
%    member(Head2,List1),
%    union(List1,Tail2,Output).

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








