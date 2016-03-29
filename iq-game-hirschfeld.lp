% Joseph Hirschfeld March 25 2016
% ASP Definition for IQ game
% University of Cincinnati Programming Languages CS-4003
% Professor Schlipf

% Define board 
axis(1..5).
position(Row, Clmn) :-
    axis(Row), axis(Clmn), Row >= Clmn.

% Define valid jump moves

% Down each row
jump(R, FromC, R, OverC, R, ToC) :-
    position(R, FromC), position(R, OverC), position(R, ToC),
    |FromC - OverC| = 1, |OverC - ToC| = 1,
    FromC != ToC.

% Down each column
jump(FromR, C, OverR, C, ToR, C) :-
    position(FromR, C), position(OverR, C), position(ToR, C),
    |FromR - OverR| = 1, |OverR - ToR| = 1,
    FromR != ToR.

% Down each diagonal
jump(FromR, FromC, OverR, OverC, ToR, ToC) :-
    position(FromR, FromC), position(OverR, OverC), position(ToR, ToC),
    |OverR - FromR| = 1, |ToR - OverR| = 1,
    |OverC - FromC| = 1, |ToC - OverC| = 1,
    % Division is weird in clingo, and each factor can only be 1 or -1
    (OverR - FromR) * (OverC - FromC) = 1,
    (ToR - OverR) * (ToC - OverC) = 1,
    ToR != FromR.

% Define each movement step
time(1..13).

% Define the empty hole
emptyHole(1,1).

% First state is all occupied except for one empty hole
occupied(1, Row, Clmn) :-
    position(Row, Clmn),
    not emptyHole(Row, Clmn).

% Occupied if last move had a peg, and wasn't jumped from or over
occupied(Time, Row, Clmn) :-
    time(Time - 1),
    occupied(Time - 1, Row, Clmn),
    not nextJump(Time - 1, Row, Clmn, _, _, _, _),
    not nextJump(Time - 1, _, _, Row, Clmn, _, _).

% Occupied if we jumped to it last turn
occupied(Time, Row, Clmn) :-
    time(Time - 1),
    nextJump(Time - 1, _, _, _, _, Row, Clmn).

% Jump not valid if there is no peg where we jumped from
:- nextJump(Time, FromR, FromC, _, _, _, _),
    not occupied(Time, FromR, FromC).

% Jump not valid if there is no peg to jump over
:- nextJump(Time, _, _, OverR, OverC, _, _),
    not occupied(Time, OverR, OverC).

% Jump not valid if there is a peg where we jump to
:- nextJump(Time, _, _, _, _, ToR, ToC),
    occupied(Time, ToR, ToC).

% Each move must have one and only one movement that is a legal move
1 { nextJump(Time, FromR, FromC, OverR, OverC, ToR, ToC) :
        jump(FromR, FromC, OverR, OverC, ToR, ToC) } 1 :- time(Time).

% Spec compatibility
nextJump(Time, FromR, FromC, ToR, ToC) :-
    nextJump(Time, FromR, FromC, _, _, ToR, ToC).

#show occupied/3.
#show nextJump/5.
