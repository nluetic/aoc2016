use v6;

my $base = $*PROGRAM-NAME.split(/\./)[0];
sub MAIN(Str :$inputfile = "$base.in")
{
    my @lines = $inputfile.IO.lines;

    my @matrix[@lines.elems;@lines[0].chars];
    for @lines.kv -> $index, $line {
        for $line.split("", :skip-empty).kv -> $col, $ch {
            @matrix[$index;$col] = $ch;
        }
    }

    my $string = "";
    for 0..^@lines[0].chars -> $column {
        my %chs;
        for 0..^@lines.elems -> $line {
            my $ch = @matrix[$line;$column];
            %chs{$ch} = %chs{$ch} ?? %chs{$ch} + 1 !! 1;
        }
        my @sorted = %chs.keys.sort( { %chs{$^b} <=> %chs{$^a} } );
        $string = $string ~ @sorted[0];
    }
    say $string;
}

