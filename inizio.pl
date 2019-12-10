mossa(X, G, Effetto, Richiesto) :-
    member(X, [1,2,3,4,5,6,7]),
    Effetto = [on(X, 6, G)],
    Richiesto = [ \+ on(X, 6, _), on(X, 5, _)].

mossa(X, G, Effetto, Richiesto) :-
    member(X, [1,2,3,4,5,6,7]),
    Effetto = [on(X, 5, G)],
    Richiesto = [ \+ on(X, 5, _), on(X, 4, _)].

mossa(X, G, Effetto, Richiesto) :-
    member(X, [1,2,3,4,5,6,7]),
    Effetto = [on(X, 4, G)],
    Richiesto = [ \+ on(X, 4, _), on(X, 3, _)].

mossa(X, G, Effetto, Richiesto) :-
    member(X, [1,2,3,4,5,6,7]),
    Effetto = [on(X, 3, G)],
    Richiesto = [ \+ on(X, 3, _), on(X, 2, _)].

mossa(X, G, Effetto, Richiesto) :-
    member(X, [1,2,3,4,5,6,7]),
    Effetto = [on(X, 2, G)],
    Richiesto = [ \+ on(X, 2, _), on(X, 1, _)].

mossa(X, G, Effetto, Richiesto) :-
    member(X, [1,2,3,4,5,6,7]),
    Effetto = [on(X, 1, G)],
    Richiesto = [ \+ on(X, 1, _)].

win(G) :-
    on(X, Y, G),
    plus(X, 1, X1),
    plus(X, 2, X2),
    plus(X, 3, X3),
    plus(Y, 1, Y1),
    plus(Y, 2, Y2),
    plus(Y, 3, Y3),
    plus(X,-1, Xm1),
    plus(X,-2, Xm2),
    plus(X,-3, Xm3),
    (
          on(X1, Y, G),
          on(X2, Y, G),
          on(X3, Y, G),
          write('vinto');
          on(X, Y1, G),
          on(X, Y2, G),
          on(X, Y3, G),
          write('vinto');
          on(X1, Y1, G),
          on(X2, Y2, G),
          on(X3, Y3, G),
          write('vinto');
          on(Xm1, Y1, G),
          on(Xm2, Y2, G),
          on(Xm3, Y3, G)
     ).

% [on(X, Y, G), plus(X, 1, X1), plus(X, 2, X2), plus(X, 3, X3), on(X1,
% Y, G), on(X2, Y, G), on(X3, Y, G),]




% INIZIO rappresenta la base che voglio raggiungere
% CONDITIONS è una lista di liste dove si va ad accumulare l'insieme
% delle osservazioni rilevanti
% GOALS include la lista di condizioni che voglio raggiungere


pensa(GOALS, CONDITIONS, INIZIO) :-
    \+ uguale(GOALS, INIZIO),
    appartiene(Result, GOALS),
    mossa(_, _, Result, Need),
    rimuovi(Result, GOALS, NGOALS),
    append(NGOALS, Need, NNGOALS),
    append([NNGOALS], CONDITIONS, NCONDITIONS),
    pensa(NNGOALS, NCONDITIONS, INIZIO).

uguale([], []).

uguale([T|C], L) :-
    T \== [],
    delete(L, T, NL),
    uguale(C, NL).

appartiene([], _).

appartiene([T|C], L) :-
    T \== [],
    delete(L, T, NL),
    appartiene(C, NL).

rimuovi([], L, L).

rimuovi([T|C], L, R) :-
    T \== [],
    delete(L, T, NL),
    rimuovi(C, NL, R).


%GOAL : METTERE PEZZO,
%PRECONDIZIONE: FARE MOSSA,



































