sfida(M1, M2, W, Hypo, History) :-
    retractall(on(_,_,a)),
    retractall(on(_,_,b)),
    retractall(on(_,_,h)),
    hole(),
    partita(M1, M2, a, W, Hypo, History).

partita(_, M2, _, M2, Hypo, History) :-   %potrebbe vincere all'ultima mossa
    pareggio(),
    length(Hypo, N),
    lista_omogenea(N,[b],History).

partita(M1,M2, _, WW, Hypo, History) :-
    win(W),
    (
        W == a,
        WW = M1;
        W == b,
        WW = M2
    ),
    length(Hypo, N),
    lista_omogenea(N,[W],History).


partita(M1, M2, a, W, Hypo, History):-
    corrobora(Hypo,R),
    %minimax(a,C,2,M1,_),
    alpha_beta(a,C,2,M1,_),
    mossa(C,a,_),
    %gioca(_, M1, a),
    print,
    partita(M1, M2, b, W, Hypo, NHistory),
    append2(NHistory, R, History).

partita(M1, M2, b, W, Hypo, History):-
    %gioca(_, M2, b),
    %minimax(b,C,2,M2,_),
    alpha_beta(b,C,2,M2,_),
    mossa(C,b,_),
    partita(M1, M2, a, W, Hypo, History).
