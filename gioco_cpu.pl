% Riceve in ingresso la conoscenza di due giocatori e restituisce il
% vincitore della partita fatta automatamente tra i due. Il termine Hypo
% contiene un insieme di ipotesi che vengono applicate singolarmente
% durante la partita, dentro History vengono riportati i dati raccolti
% durante la partita per conto di quelle ipotesi
% sfida(+Knowledge1, +Knowledge2, -Winner, +Hypo, -History)

sfida(Knowledge1, Knowledge2, Winner, Hypo, History) :-
    write('sfida'),nl,
    retractall(on(_,_,a)),
    retractall(on(_,_,b)),
    retractall(on(_,_,h)),
    hole(),
    partita(Knowledge1, Knowledge2, a, Winner, Hypo, History).

% Partita fa eseguire una mossa ad uno dei giocatori coinvolti in sfida,
% se il termine Player = a gioca Knowledge1, se Player = b gioca
% Knowledge2, se prima di fare la mossa uno dei giocatori ha vinto,
% viene restituito il vincitore. Per Hypo e History guardare sfida
% partita(+Knowledge1, +Knowledge2, +Player, -Winner, +Hypo, -History)

partita(_, Knowledge2, _, Knowledge2, Hypo, History) :-   %potrebbe vincere all'ultima mossa!!!!!!!
    pareggio(),
    length(Hypo, N),
    lista_omogenea(N, [b], History).

partita(Knowledge1, Knowledge2, _, Winner, Hypo, History) :-
    win(W),
    (
        W == a,
        Winner = Knowledge1;
        W == b,
        Winner = Knowledge2
    ),
    length(Hypo, N),
    lista_omogenea(N,[W], History).

partita(Knowledge1, Knowledge2, a, Winner, Hypo, History):-
    corrobora(Hypo, R),
    alpha_beta(a, C, 2, Knowledge1, _),
    mossa(C, a, _),
    partita(Knowledge1, Knowledge2, b, Winner, Hypo, NHistory),
    append2(NHistory, R, History).

partita(Knowledge1, Knowledge2, b, Winner, Hypo, History):-
    alpha_beta(b, C, 2, Knowledge2, _),
    mossa(C, b, _),
    partita(Knowledge1, Knowledge2, a, Winner, Hypo, History).
