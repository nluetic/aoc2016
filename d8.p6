#
# grammar example code adapted from 
# https://perl6advent.wordpress.com/2009/12/21/day-21-grammars-and-actions/
#
use v6;

class display {
    has Int $!max_rows = 6;
    has Int $!max_columns = 8;
    # TODO: why does this not work?
    #has @!screen[$!max_rows;$!max_columns];
    has @!screen[6;8];

    method create_rectangle(Int $rows, Int $columns) {
        for 0..^$rows -> $row {
            for 0..^$columns -> $column {
                @!screen[$row;$column] = 1;
            }
        }
    }

    method !rotate(Str $what, Int $start, Int $count) {
        my $max;
        given $what {
            when "column" { $max = $!max_rows; }
            when "row" { $max = $!max_columns; }
            default: { say "invalid dimension $what given"; }
        }
        for 0..^$max -> $dimension {
            if ($dimension == $count) {
                last;
            }

            my $overflow = $max - $dimension - $count;
            #say "max " ~ $!max_rows ~ " row $row count $count o $overflow";
            my ($x, $y);
            my ($old_x, $old_y) = ($dimension, $start);
            if $what eq "column" {
                if $overflow > 0  {
                    $x = $dimension + $count;
                    $y = $start;
                }
                else {
                    $x = $dimension - $max + $count;
                    $y = $start + 1;
                }
            }
            elsif $what eq "row" {
                if $overflow > 0  {
                    $y = $dimension + $count;
                    $x = $start;
                }
                else {
                    $y = $dimension - $max + $count;
                    $x = $start + 1;
                }
            }
            @!screen[$x;$y] = @!screen[$old_x;$old_y];
            @!screen[$old_x;$old_y] = Nil;
        }
    }

    method rotate_column(Int $column, Int $count) {
        self!rotate("column", $column, $count);
    }
    method rotate_row(Int $row, Int $count) {
        self!rotate("row", $row, $count);
    }

    method show() {
        say "current screen:";
        for 0..^$!max_rows -> $row {
            for 0..^$!max_columns -> $column {
                print (@!screen[$row;$column] ?? @!screen[$row;$column] !! 0);
            }
            say "";
        }
    }
}

my $d = display.new();

#$d.create_rectangle(2,3);
#$d.show();
#$d.rotate_column(2,2);
##$d.create_rectangle(3,4);
##$d.create_rectangle(2,5);
#$d.show();

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
        $<type>=[rect]\s+ $<y>=[\d+]x$<x>=[\d+]
    }
    token   rotate {  
        <rotate_column>|<rotate_row>
    }
    token   rotate_column {
        rotate\s $<type>=[column]\s+x\= $<offset>=[\d+]\s+by\s+ $<count>=[\d+]
    }
    token   rotate_row {
        rotate\s $<type>=[row]\s+y\= $<offset>=[\d+]\s+by\s+ $<count>=[\d+]
    }
}

class display::Actions {
    method TOP($/) {
    }
    method rect($/) {
        say ~$<type> ~ " " ~ ~$<y> ~ " x " ~ ~$<x>;
    }
    method rotate_row($/) {
        say ~$<type> ~ " off " ~ ~$<offset> ~ " by " ~ ~$<count>;
    }
    method rotate_column($/) {
        say ~$<type> ~ " off " ~ ~$<offset> ~ " by " ~ ~$<count>;
    }
}

my $inputfile = $*PROGRAM-NAME.split(/\./)[0] ~ ".in";
#my $input = $inputfile.IO;

my $input = Q {
rect 1x1
rotate column x=25 by 1
rotate row y=0 by 2
};

my $actions     = display::Actions.new();
my $matchobject = display::Grammar.parse($input, :actions($actions));
