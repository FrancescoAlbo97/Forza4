campionato(L, Hypo, NWinner):-
    gironi(L,L,Hypo,Classifica,HypoList, NMatches),
    %nl, write('HypoList = '), write(HypoList), nl,
    conta(L,Classifica, NewClassifica),
    nl, nl, write(' fine campionato, il numero di match è '), write(NMatches), nl, nl,
    %findall(C-X,(member(X,L),conta_occorrenze(X,Classifica,C)),Occorrenze),
    sort(NewClassifica, ClassificaOrdinata),
    last(ClassificaOrdinata,_-Winner),
    length(Hypo,NHypo),
    impara(Winner,NWinner,Hypo,HypoList,NHypo,NMatches).

conta([],_,[]).
conta([T|C], Classifica, NewClassifica):-
    conta(C, Classifica, Class),
    conta_occorrenze(T,Classifica,Occorrenze),
    append(Class,[Occorrenze-T],NewClassifica).

gironi([],_,_,[],[],0).
gironi(L,[T|C],Hypo,NewClassifica,HypoList,NMatches):-
    sfide(T,C,Hypo,Classifica,SHypoList,SfideNMatches),
    delete(L,T,L1),
    append(C,[T],L2),
    gironi(L1, L2, Hypo, Class, OldHypoList,OldNMatches), %corregere C
    append(Class, Classifica, NewClassifica),
    append(OldHypoList, SHypoList, HypoList),
    NMatches is OldNMatches + SfideNMatches.

sfide( _, [], _, [], [], 0).
sfide(M, [T|C], Hypo, NewClassifica, HypoList, SfideNMatches):-
    sfide(M, C, Hypo, Classifica, OldHypoList, OldNMatches),
    sfida(M, T, W, Hypo, H),
    SfideNMatches is OldNMatches + 1,
    append([H], OldHypoList, HypoList),
    %nl, write(M), nl,
    %write( ' VS '),
    %nl, write(T), nl,
    append(Classifica, W, NewClassifica).

conta_occorrenze(_,[],0).
conta_occorrenze(X,[T|C],Occorrenze) :-
    conta_occorrenze(X,C,OldOccorrenze),
    conta_in_lista(X,T,Cont),
    !,
    Occorrenze is OldOccorrenze + Cont.

conta_in_lista(_,[],0).
conta_in_lista(X,[X|C],Cont) :-
    conta_in_lista(X,C,O),
    Cont is O + 1.
conta_in_lista(X,[T|C],Cont) :-
    C \= T,
    conta_in_lista(X,C,Cont).