change_player(a,b).
change_player(b,a).

punteggio_stato(Memory,R,a) :-
   test(R1, b, Memory, _, _),
   test(R2, a, Memory, _, _),
   R is R1 - R2.
punteggio_stato(Memory,R,b) :-
   test(R1, a, Memory, _, _),
   test(R2, b, Memory, _, _),
   R is R1 - R2.

azioni_successori(PosAzioni) :-
    findall(X,(
                member(X,[1,2,3,4,5,6,7]),
                altezza_colonna(X,H),
                H < 6
            ),PosAzioni).

check_foglia(_,_,1000,_) :-
    win(b).
check_foglia(_,_,-1000,_) :-
    win(a).
check_foglia(_,_,0,_) :-
    pareggio().
check_foglia(G,Memory,Punteggio,0) :-
    punteggio_stato(Memory,Punteggio,G).

cutoff(Alpha,Beta) :-
   Beta =< Alpha.
   %writeln('CUTOFF!!').

aggiorna_alpha_beta(a,Alpha,Beta,Value,Alpha,Value) :-
   Value =< Beta, !.
aggiorna_alpha_beta(a,Alpha,Beta,Value,Alpha,Beta) :-
   Value > Beta.
aggiorna_alpha_beta(b,Alpha,Beta,Value,Value,Beta) :-
   Value >= Alpha, !.
aggiorna_alpha_beta(b,Alpha,Beta,Value,Alpha,Beta) :-
   Value < Beta.


% RIVEDERE IMPLEMENTAZIONE ALFA BETA
% PER ORA ASSUMO CHE b = giocatore MAX e a = giocatore MIN
% SE FA IL CUTOFF IL VALORE NON VA AGGIORNATO

alpha_beta(G,Mossa,Depth,Memory,Value) :-
    azioni_successori(Azioni),
    StartingDepth is Depth - 1,
    alpha_beta(G,Memory,Mossa,Azioni,StartingDepth,Value,-100000,100000,_,1),
    !.

alpha_beta(_,_,Mossa,[],_,Value,_,_,Value-Mossa,_).
alpha_beta(_,_,Mossa,_,_,Value,Alpha,Beta,Value-Mossa,_) :-
   cutoff(Alpha,Beta).
   %nl,write(Mossa),nl,write(Value),nl,write(Alpha),nl,write(Beta),nl.
alpha_beta(G,Memory,Mossa,[T|C],Depth,Value,Alpha,Beta,ValueAcc,Start) :-
    mossa(T,G,_),
    !,
    azioni_successori(NewActions),
    (
        check_foglia(G,Memory,NValue,Depth),
        %NewAlpha = Alpha,
        %NewBeta = Beta;
        aggiorna_alpha_beta(G,Alpha,Beta,NValue,NewAlpha,NewBeta);
        NewDepth is Depth - 1,
        change_player(G,G1),
        alpha_beta(G1,Memory,_,NewActions,NewDepth,NValue,Alpha,Beta,_,1),
        aggiorna_alpha_beta(G,Alpha,Beta,NValue,NewAlpha,NewBeta)
    ),
    (
        Start == 1,
        NewValueAcc = NValue-T;
        Start == 0,
        migliore(NValue-T,ValueAcc,G,NewValueAcc)
    ),
    anti_mossa(T),
    %nl, write('Giocatore '), write(G), write(', Profondità '), write(Depth), write(', Mossa '), write(T), write(', Alpha|Beta '), write(Alpha), write('|'), write(Beta), nl, write(', Current Best '), write(NewValueAcc), nl,
    alpha_beta(G,Memory,Mossa,C,Depth,Value,NewAlpha,NewBeta,NewValueAcc,0).


minimax(G,Mossa,Depth,Memory,Value) :-
    azioni_successori(Azioni),
    StartingDepth is Depth - 1,
    minimax(G,Memory,Mossa,Azioni,StartingDepth,Value,_,1),
    !.

minimax(_,_,Mossa,[],_,Value,Value-Mossa,_).
minimax(G,Memory,Mossa,[T|C],Depth,Value,ValueAcc,Start) :-
    mossa(T,G,_),
    azioni_successori(NewActions),
    (
        check_foglia(G,Memory,NValue,Depth);
        NewDepth is Depth - 1,
        change_player(G,G1),
        minimax(G1,Memory,_,NewActions,NewDepth,NValue,_,1)
    ),
    (
        Start == 1,
        NewValueAcc = NValue-T;
        Start == 0,
        migliore(NValue-T,ValueAcc,G,NewValueAcc)
    ),
    anti_mossa(T),
    minimax(G,Memory,Mossa,C,Depth,Value,NewValueAcc,0).

% migliore(+Value1,+Value2,+G,-Result) restituisce tra le due
% alternative il punteggio migliore per il giocatore

migliore(Value1-Action1,Value2-_,a,Value1-Action1) :-
    Value1 < Value2, !.
migliore(Value1-_,Value2-Action2,a,Value2-Action2) :-
    Value1 >= Value2.
migliore(Value1-Action1,Value2-_,b,Value1-Action1) :-
    Value1 > Value2, !.
migliore(Value1-_,Value2-Action2,b,Value2-Action2) :-
    Value1 =< Value2.

