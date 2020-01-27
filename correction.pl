% Funzione che modifica i pesi di una data conoscenza a partire dalla board attuale, favorendo la scelta di una data mossa indicata (Right_column)
% rispetto ad un'altra mossa indicata (Wrong_column)
% (+Knowledge, -NKnowledge, +Right_column, +Wrong_column)

correggi(Knowledge, NKnowledge, Right_column, Wrong_column) :-
    anti_mossa(Wrong_column),
    simula(Right_column, Value1, Knowledge, b),
    simula(Wrong_column, Value2, Knowledge, b),
    Diff is Value2 - Value1,
    nl,
    (
         Diff \== 0,
         simula2(Right_column, Right_rating, Knowledge),
         simula2(Wrong_column, Wrong_rating, Knowledge),
         correzione(Knowledge, NKnowledge, Diff, Right_rating, Wrong_rating);
         NKnowledge = Knowledge
    ),
    mossa(Wrong_column,b,_).

% Funzione che valuta una data mossa attraverso una data conoscenza restituendo una lista di lunghezza pari al numero di osservazioni:
% ad ogni elemento corrisponde alla valutazione data dall'osservazione i-esima
% (+Mossa, -Lista_valutazione, +Conoscenza)

simula2(C, L, Knowledge) :-
    mossa(C, b, 0),
    test2(L, Knowledge),
    anti_mossa(C).

% Funzione che valuta la board attuale attraverso una data conoscenza restituendo una lista di lunghezza pari al numero di osservazioni:
% ad ogni elemento corrisponde alla valutazione data dall'osservazione i-esima 
% (-Lista_valutazione, +Knowledge)

test2([], []).

test2(L, [[T|C]|CC]) :-
    findall(_, condizione(C, _, _, b), L1),
    length(L1, RR1),
    R1 is RR1 * T,
    findall(_, condizione(C, _, _, a), L2),
    length(L2, RR2),
    R2 is RR2 * T,
    R3 is R1 - R2,
    test2(PL, CC),
    append([R3], PL, L).

% Funzione che corregge i pesi di una data conoscenza attraverso modificaPesi
%(+Knowledge, -NKnowledge, +Diff, +Right_rating, +Wrong_rating)

correzione(Knowledge, NKnowledge, Diff, Right_rating, Wrong_rating) :-
    delta(Right_rating, Wrong_rating, Delta_list),
    abs_sum(Delta_list, Somma),
    (
        Somma \== 0,
        Density is Diff/Somma,
        modificaPesi(Knowledge, NKnowledge, Right_rating, Wrong_rating, Density);
        NKnowledge = Knowledge
    ).

modificaPesi([], [], _, _, _).

% Funzione che corregge i pesi di una data conoscenza secondo la formula descritta nella relazione (paragrafo corroborazione)
%(+Knowledge, -NKnowledge, +Diff, +Right_rating, +Wrong_rating, +Density)

modificaPesi([[Weight|Condition]|CKnowledge], NKnowledge, [T1|C1], [T2|C2], Density) :-
    modificaPesi(CKnowledge, PNKnowledge, C1, C2, Density),
    Diff is T2 - T1,
   (                                             
    Weight >= 0,
    NWeight is Weight -(Density*Diff*1.2);
    NWeight is Weight +(Density*Diff*1.2)
   ),                                        
    round(NWeight, NNWeight),
    append([[NNWeight|Condition]], PNKnowledge, NKnowledge).