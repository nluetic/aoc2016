
use v6;

my @movements = <R4, R5, L5, L5, L3, R2, R1, R1, L5, R5, R2, L1, L3, L4, R3, L1, L1, R2, R3, R3, R1, L3, L5, R3, R1, L1, R1, R2, L1, L4, L5, R4, R2, L192, R5, L2, R53, R1, L5, R73, R5, L5, R186, L3, L2, R1, R3, L3, L3, R1, L4, L2, R3, L5, R4, R3, R1, L1, R5, R2, R1, R1, R1, R3, R2, L1, R5, R1, L5, R2, L2, L4, R3, L1, R4, L5, R4, R3, L5, L3, R4, R2, L5, L5, R2, R3, R5, R4, R2, R1, L1, L5, L2, L3, L4, L5, L4, L5, L1, R3, R4, R5, R3, L5, L4, L3, L1, L4, R2, R5, R5, R4, L2, L4, R3, R1, L2, R5, L5, R1, R1, L1, L5, L5, L2, L1, R5, R2, L4, L1, R4, R3, L3, R1, R5, L1, L4, R2, L3, R5, R3, R1, L3>;

my @position[2] = 0,0;

my %visited;
my $hq;

subset Axis of Int where { 0 | 1 };
my Axis $axis = 0;

my $direction = 1;

for @movements.kv -> $index, $movement {

    $movement ~~ /$<relative_direction>=<[RL]> $<steps>=\d+/;

    # only turning to right on axis 1 or left on axis 0 changes the direction
    if ( $<relative_direction> eq "R" && $axis == 1  ||
         $<relative_direction> eq "L" && $axis == 0  )  {
        $direction *= -1;
    }

    # part II. - find already visited position
    if !$hq {
        my @visit = (@position[$axis]...@position[$axis] + ($direction * $<steps>));
        # starting point overlaps with end of last move - throw it away
        @visit.shift;

        for @visit -> $pos {
            my $key = $axis == 0 ?? "$pos|@position[1]" !! "@position[0]|$pos";
            if !$hq && %visited{$key} {
                $hq = $key;
                last;
            }
            %visited{$key} = 1;
        }
    }

    @position[$axis] += $direction * $<steps>;

    # any move is a turn
    $axis = $axis ?? 0 !! 1;
}

say "last position " ~ @position;
say "distance: " ~ @position.map( { .abs } ).sum;
if $hq {
    say "hq is at " ~ $hq.split("|");
    say "first position visited twice is "
            ~ $hq.split("|").map( {.abs} ).sum ~ " blocks away";
}
