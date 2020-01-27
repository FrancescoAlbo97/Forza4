% Definizione di tutti i bordi della scacchiera, 
% necessari per il funzionamento del gioco
% e per la corretta definizione delle osservazioni

on(0,0,c).
on(1,0,c).
on(2,0,c).
on(3,0,c).
on(4,0,c).
on(5,0,c).
on(6,0,c).
on(7,0,c).
on(8,0,c).
on(0,1,c).
on(0,2,c).
on(0,3,c).
on(0,4,c).
on(0,5,c).
on(0,6,c).
on(0,7,c).
on(8,1,c).
on(8,2,c).
on(8,3,c).
on(8,4,c).
on(8,5,c).
on(8,6,c).
on(8,7,c).
on(1,7,c).
on(2,7,c).
on(3,7,c).
on(4,7,c).
on(5,7,c).
on(6,7,c).
on(7,7,c).

% Predicato che, all'inizio della partita, inizializza 
% la scacchiera con i buchi (che denotano l'assenza di 
% gettoni).

hole :-
    assert(on(1,1,h)),
    assert(on(2,1,h)),
    assert(on(3,1,h)),
    assert(on(4,1,h)),
    assert(on(5,1,h)),
    assert(on(6,1,h)),
    assert(on(7,1,h)),
    assert(on(1,2,h)),
    assert(on(2,2,h)),
    assert(on(3,2,h)),
    assert(on(4,2,h)),
    assert(on(5,2,h)),
    assert(on(6,2,h)),
    assert(on(7,2,h)),
    assert(on(1,3,h)),
    assert(on(2,3,h)),
    assert(on(3,3,h)),
    assert(on(4,3,h)),
    assert(on(5,3,h)),
    assert(on(6,3,h)),
    assert(on(7,3,h)),
    assert(on(1,4,h)),
    assert(on(2,4,h)),
    assert(on(3,4,h)),
    assert(on(4,4,h)),
    assert(on(5,4,h)),
    assert(on(6,4,h)),
    assert(on(7,4,h)),
    assert(on(1,5,h)),
    assert(on(2,5,h)),
    assert(on(3,5,h)),
    assert(on(4,5,h)),
    assert(on(5,5,h)),
    assert(on(6,5,h)),
    assert(on(7,5,h)),
    assert(on(1,6,h)),
    assert(on(2,6,h)),
    assert(on(3,6,h)),
    assert(on(4,6,h)),
    assert(on(5,6,h)),
    assert(on(6,6,h)),
    assert(on(7,6,h)).
