% Prende in ingresso una lista di 4 conoscenze con le stesse
% condizioni, a meno dei pesi, ordinate ugualmente, le incrocia
% attraverso un algoritmo genetico, le conoscenze cosi prodotte vengono
% poi confrontate e viene restituita la migliore (Winner)
% genetica(+[K1, K2, K3, K4], -Winner)

genetica([K1, K2, K3, K4], Winner) :-
    accoppia(K1, K2, NK1),
    accoppia(K1, K3, NK2),
    accoppia(K1, K4, NK3),
    accoppia(K2, K3, NK4),
    %accoppia(K2, K4, NK5),
    campionato([K1, NK1, NK2, NK3, NK4], Winner).

% Assume in ingresso due conoscenze e restituisce una nuova conscenza
% tramite un loro incrocio
% accoppia(+Knowledge1, +Knowledge2, - NKnowledge)

accoppia(Knowledge1, Knowledge2, NKnowledge) :-
    length(Knowledge1, N),
    listaN(N, L),
    N1 is (N/2),
    round(N1, N2),
    (
       %  N2 > 23,
       %  scegli_geni(Knowledge1, L, NL, Selected1, 23),
       %  scegli_geni(Knowledge2, NL, _, Selected2, 23);
         scegli_geni(Knowledge1, L, NL, Selected1, N2),
         N3 is N - N2,
         scegli_geni(Knowledge2, NL, _, Selected2, N3)
    ),
    append(Selected1, Selected2, NKnowledge).

% Riceve in ingresso una conoscenza, una lista di interi [1,2,5,7...]
% (L) che contiene i geni (le condizioni) che possono essere
% selezionate, ed infine la quantita di geni da scegliere (Limit), e
% restituisce i geni effettivamente selezionati (Selected)
% scegli_geni(+Knowledge, +L, -NL, -Selected, +Limit)

scegli_geni(_, L, L, [], 0).

scegli_geni(Knowledge, L, NL, Selected, Limit) :-
    Limit1 is Limit - 1,
    scegli_geni(Knowledge, L, PNL, PSelected, Limit1),
    length(PNL, Len),
    random_between(1, Len, N),
    take(N, PNL, Elem),
    take(Elem, Knowledge, Cond),
    delete(PNL, Elem, NL),
    append(PSelected, [Cond], Selected).
