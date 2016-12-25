use v6;

my $base = $*PROGRAM-NAME.split(/\./)[0];
sub MAIN(Str :$inputfile = "$base.in")
{
    my $sum_id = 0;
    my @decoys;

    for $inputfile.IO.lines -> $room {

        $room ~~ /(<[a..z -]>+) (\d+) \[(\w+)\]/;
        my ($id, $checksum, @chs)  = ($1, $2, |split("", $0.subst(/\-/, "", :g), :skip-empty));

        #say "read string " ~ @chs.join ~ ", id: $id checksum: $checksum";

        my %chs;
        for @chs.sort -> $ch {
            %chs{$ch} = %chs{$ch} ?? %chs{$ch} + 1 !! 1;
        }
        my @sorted = %chs.keys.sort( { %chs{$^b} <=> %chs{$^a} || $^a cmp $^b } );

        if @sorted.join ~~ /^$checksum/ {
            $sum_id += $id;
        }
        else {
            @decoys.push(@sorted.join);
        }
    }

    say $sum_id;
    say "Decoys: " ~ @decoys.elems;
}
