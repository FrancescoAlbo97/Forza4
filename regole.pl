% Dato lo stato corrente, determina se c'è stato un vincitore, e in caso
% positivo resistuisce il giocatore che ha vinto.
% win(-Giocatore)
win(A) :-
   orizzontale(A);
   verticale(A);
   diagonale(A).

% Dato lo stato corrente, determina se c'è stata una vittoria data da
% quattro gettoni in orizzontale. Restituisce il giocatore che ha vinto.
% orizzontale(-Giocatore)
orizzontale(A) :-
    on(X, Y, A),
    A \== 'c',
    A \== 'h',
    X1 is X + 1,
    X2 is X + 2,
    X3 is X + 3,
    on(X1, Y, A),
    on(X2, Y, A),
    on(X3, Y, A).

% Dato lo stato corrente, determina se c'è stata una vittoria data da
% quattro gettoni in verticale. Restituisce il giocatore che ha vinto.
% verticale(-Giocatore)
verticale(A) :-
    on(X, Y, A),
    A \== 'c',
    A \== 'h',
    Y1 is Y + 1,
    Y2 is Y + 2,
    Y3 is Y + 3,
    on(X, Y1, A),
    on(X, Y2, A),
    on(X, Y3, A).

% Dato lo stato corrente, determina se c'è stata una vittoria data da
% quattro gettoni in diagonale. Restituisce il giocatore che ha vinto.
% diagonale(-Giocatore)
diagonale(A) :-
    on(X, Y, A),
    A \== 'c',
    A \== 'h',
    X1 is X + 1,
    X2 is X + 2,
    X3 is X + 3,
    Y1 is Y + 1,
    Y2 is Y + 2,
    Y3 is Y + 3,
    Xm1 is X - 1,
    Xm2 is X - 2,
    Xm3 is X - 3,
    (
        on(X1, Y1, A),
        on(X2, Y2, A),
        on(X3, Y3, A);
        on(Xm1, Y1, A),
        on(Xm2, Y2, A),
        on(Xm3, Y3, A)
    ).

% Esegue una mossa per conto di un giocatore. Se la colonna è piena, il
% gettone non verrà inserito, e sarà segnalata la presenza della colonna
% piena.
% mossa(+X,+G,-E)
mossa(X,_,1) :-
    altezza_colonna(X,6).
mossa(X,G,0) :-
    altezza_colonna(X,H),
    H1 is H + 1,
    retract(on(X,H1,h)),
    assert(on(X,H1,G)).

anti_mossa(X) :-
    altezza_colonna(X,H),
    retract(on(X,H,_)),
    assert(on(X,H,h)).

% Determina l'altezza corrente della colonna, data da tutti i gettoni
% che sono stati inseriti in essa.
% altezza_colonna(+X,-H)
altezza_colonna(X,H) :-
    findall(Y,(on(X,Y,G),G\=c,G\=h),Col),
    sort(Col,ColOrd),
    last(ColOrd,H),
    !.
altezza_colonna(_,0).

% Determina se c'è stata una condizione di pareggio. Ciò avviene quando
% tutti gli spazi della riga più alta sono occupati.
pareggio() :-
    \+ on(1,6,h),
    \+ on(2,6,h),
    \+ on(3,6,h),
    \+ on(4,6,h),
    \+ on(5,6,h),
    \+ on(6,6,h),
    \+ on(7,6,h).
