correggi(Memory, NMemory, Right_column, Wrong_column) :-
%    write(Right_column), nl, write(Wrong_column), nl,
%    print,
%    write(Memory),nl,
    anti_mossa(Wrong_column),
    simula(Right_column, Value1, Memory, b),
    simula(Wrong_column, Value2, Memory, b),
%    write('valutazione mossa sbagliata: '),write(Value2),nl,
%    write('valutazione mossa giusta: '),write(Value1),nl,
    Diff is Value2 - Value1,
    nl,
    (
         Diff \== 0,
         simula2(Right_column, Right_rating, Memory),
         simula2(Wrong_column, Wrong_rating, Memory),
         correzione(Memory, NMemory, Diff, Right_rating, Wrong_rating);
         NMemory = Memory
    ),
    mossa(Wrong_column,b,_).
%    simula(Right_column, Value3, NMemory, b),
%    simula(Wrong_column, Value4, NMemory, b),
%    simula2(Right_column, Right_rating2, NMemory),
%    simula2(Wrong_column, Wrong_rating2, NMemory),
%    write('new valutazione mossa sbagliata: '),write(Value4),nl,
%    write('new valutazione mossa giusta: '),write(Value3),nl,
%    write('new Right rating: '),write(Right_rating2),nl,
%    write('new Wrong rating: '),write(Wrong_rating2),nl.

simula2(C, L, Memory) :-
    mossa(C, b, 0),
    test2(L, Memory, _, _),
    anti_mossa(C).

test2([], [], _, _).

test2(L, [[T|C]|CC], X, Y) :-
    findall(_, condizione(C, X, Y, b), L1),
    length(L1, RR1),
    R1 is RR1 * T,
    findall(_, condizione(C, X, Y, a), L2),
    length(L2, RR2),
    R2 is RR2 * T,
    R3 is R1 - R2,
    test2(PL, CC, _, _),
    append([R3], PL, L).


correzione(Memory, NMemory, Diff, Right_rating, Wrong_rating) :-
    write('RightRating = '), write(Right_rating), nl,
    write('WrongRating = '), write(Wrong_rating), nl,
    delta(Right_rating, Wrong_rating, Delta_list),
    abs_sum(Delta_list, Somma),
    (
        Somma \== 0,
        Density is Diff/Somma,
        write('density'),write(Density),nl,
        modificaPesi(Memory, NMemory, Right_rating, Wrong_rating, Density);
        NMemory = Memory
    ).

modificaPesi([], [], _, _, _).


modificaPesi([[Weight|Condition]|CMemory], NMemory, [T1|C1], [T2|C2], Density) :-
    modificaPesi(CMemory, PNMemory, C1, C2, Density),
    Diff is T2 - T1,
   % write(Diff),nl,
   % write('weight'),write(Weight),nl,
  % (                                                   %
  %      Diff \== 0,                                    %
   (                                              %
    Weight >= 0,
    NWeight is Weight -(Density*Diff*1.2);
    NWeight is Weight +(Density*Diff*1.2)
   ),                                             %
   %     (                                              %
   %          Weight > 0,                               %
   %          NWeight is Weight - 2;                    %
   %          NWeight is Weight + 2                     %
   %     )                                              %
   % ),                                                 %
    round(NWeight, NNWeight),
    append([[NNWeight|Condition]], PNMemory, NMemory).

delta([], [], []).

delta([T1|C1], [T2|C2], Delta_list) :-
    Diff is T2 - T1,
    delta(C1, C2, PDelta_list),
    append([Diff], PDelta_list, Delta_list).

abs_sum([], 0).

abs_sum([T|C], Somma) :-
    abs_sum(C, PSomma),
    abs(T, AbsT),
    Somma is PSomma + AbsT.

