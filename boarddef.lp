axis(1..5).
position(Row, Clmn) :-
    axis(Row), axis(Clmn), Row >= Clmn.

jump(R, FromC, R, OverC, R, ToC) :-
    position(R, FromC), position(R, OverC), position(R, ToC),
    |FromC - OverC| = 1, |OverC - ToC| = 1,
    FromC != ToC.

jump(FromR, C, OverR, C, ToR, C) :-
    position(FromR, C), position(OverR, C), position(ToR, C),
    |FromR - OverR| = 1, |OverR - ToR| = 1,
    FromR != ToR.

jump(FromR, FromC, OverR, OverC, ToR, ToC) :-
    position(FromR, FromC), position(OverR, OverC), position(ToR, ToC),
    |OverR - FromR| = 1, |ToR - OverR| = 1,
    |OverC - FromC| = 1, |ToC - OverC| = 1,
    (OverR - FromR) * (OverC - FromC) = 1,
    (ToR - OverR) * (ToC - OverC) = 1,
    ToR != FromR.

time(1..13).

emptyHole(1,1).

occupied(1, Row, Clmn) :-
    position(Row, Clmn),
    not emptyHole(Row, Clmn).

occupied(Time, Row, Clmn) :-
    time(Time - 1),
    occupied(Time - 1, Row, Clmn),
    not nextJump(Time - 1, Row, Clmn, _, _, _, _),
    not nextJump(Time - 1, _, _, Row, Clmn, _, _).

occupied(Time, Row, Clmn) :-
    time(Time - 1),
    nextJump(Time - 1, _, _, _, _, Row, Clmn).

:- nextJump(Time, FromR, FromC, _, _, _, _),
    not occupied(Time, FromR, FromC).

:- nextJump(Time, _, _, OverR, OverC, _, _),
    not occupied(Time, OverR, OverC).

:- nextJump(Time, _, _, _, _, ToR, ToC),
    occupied(Time, ToR, ToC).

1 { nextJump(Time, FromR, FromC, OverR, OverC, ToR, ToC) :
        jump(FromR, FromC, OverR, OverC, ToR, ToC) } 1 :- time(Time).

nextJump(Time, FromR, FromC, ToR, ToC) :-
    nextJump(Time, FromR, FromC, _, _, ToR, ToC).

#show nextJump/5.
#show occupied/3.
