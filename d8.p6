#
# grammar example code adapted from 
# https://perl6advent.wordpress.com/2009/12/21/day-21-grammars-and-actions/
#
# algorithm from:
# https://stackoverflow.com/questions/876293/fastest-algorithm-for-circle-shift-n-sized-array-for-m-position ("Optimal solution")
#
# grammar, multidimensional arrays
#
use v6;

class display::Actions {
    has Int $!max_columns = 50;
    has Int $!max_rows = 6;
    # TODO: why does this not work?
    #has @!screen[$!max_rows;$!max_columns];
    has @!screen[50;6];

    submethod TWEAK() {
        @!screen = ( for 0..^$!max_columns { (for 0..^$!max_rows { 0 }) } );
    }

    method rect($/) {
        for 0..^~$<x> -> $column {
            for 0..^~$<y> -> $row {
                @!screen[$column;$row] = 1;
            }
        }
    }

    method !rotate(Str $what, Int $which, Int $count) {

        my $max = ($what eq "column") ?? $!max_rows !! $!max_columns;

        if $count == 0 || $count == $max {
            return;
        }

        for 0..^($count gcd $max) -> $dimension {

            my $tmp;
            my ($x1, $x2);
            my ($y1, $y2);

            my ($i, $j);
            loop ($i = $dimension; 1; $i = $j) {

                $j = $i + $count;
                if $j >= $max {
                   $j -= $max;
                }

                if $j == $dimension {
                    last;
                }

                ($x1, $x2) = ($which, $which);
                ($y1, $y2) = ($i, $j);
                if $what eq "row" {
                    ($x2, $y2) = ($y2, $x2);
                    ($x1, $y1) = ($y1, $x1);
                }

                if ($what eq "row" && $x1 == $dimension  || 
                    $what eq "column" && $y1 == $dimension ) {
                    $tmp = @!screen[$x1;$y1];
                }

                @!screen[$x1;$y1] = @!screen[$x2;$y2];
            } 

            if $x2.defined {
                @!screen[$x2;$y2] = $tmp;
            }
        }
    }

    method rotate_column($/) {
        self!rotate("column", +(~$<which>), $!max_rows - +(~$<count>));
    }
    method rotate_row($/) {
        self!rotate("row", +(~$<which>), $!max_columns - +(~$<count>));
    }

    method show() {
        say "current screen:";
        for 0..^$!max_rows -> $row {
            for 0..^$!max_columns -> $column {
                print @!screen[$column;$row];
            }
            say "";
        }
    }
    method count() {
        say @!screen.sum();
    }
}

grammar display::Grammar {
    token   TOP {
        \n*
        [<action>\n]+
        \n*
    }
    token   action {
        <rect>|<rotate>
    }
    token   rect {  
        $<type>=[rect]\s+ $<x>=[\d+]x$<y>=[\d+]
    }
    token   rotate {  
        <rotate_column>|<rotate_row>
    }
    token   rotate_column {
        rotate\s $<type>=[column]\s+x\= $<which>=[\d+]\s+by\s+ $<count>=[\d+]
    }
    token   rotate_row {
        rotate\s $<type>=[row]\s+y\= $<which>=[\d+]\s+by\s+ $<count>=[\d+]
    }
}

my $input = slurp $*PROGRAM-NAME.split(/\./)[0] ~ ".in";
my $actions     = display::Actions.new();

my $matchobject = display::Grammar.parse($input, :actions($actions));

$actions.show();
$actions.count();
