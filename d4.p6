# 
# find invalid rooms (decoys)
#
# checksum has to contain 5 chars from string sorted by frequency first, then alphabetically
#
# part 2: find valid room that contains something with "North Pole" in it
#
use v6;

sub decrypt_room(Str $encrypted, Int $shifts)
{
    my $charspace = 26;
    my $realshifts = $shifts % $charspace;

    (for $encrypted.subst(/\-/, " ", :g).split(/""/, :skip_empty) -> $ch {
        if !$ch {
            next;
        }

        if $ch eq " " {
            $ch
        }
        else {
        ($ch.ord + $realshifts < "a".ord + $charspace ??
                $ch.ord + $realshifts !! $ch.ord + $realshifts - $charspace)
            .chr;
        }
    }).join;
}

my $base = $*PROGRAM-NAME.split(/\./)[0];
sub MAIN(Str :$inputfile = "$base.in")
{
    my $sum_id = 0;
    my @decoys;

    for $inputfile.IO.lines -> $room {

        $room ~~ /(<[a..z -]>+) (\d+) \[(\w+)\]/;
        my $room_string = $0;
        my ($id, $checksum, @chs)  = ($1, $2, |split("", $0.subst(/\-/, "", :g), :skip-empty));

        #say "read string " ~ @chs.join ~ ", id: $id checksum: $checksum";

        my %chs;
        for @chs.sort -> $ch {
            %chs{$ch} = %chs{$ch} ?? %chs{$ch} + 1 !! 1;
        }
        my @sorted = %chs.keys.sort( { %chs{$^b} <=> %chs{$^a} || $^a cmp $^b } );

        if @sorted.join ~~ /^$checksum/ {
            $sum_id += $id;
            my $realname = decrypt_room($room_string.Str, $id.abs);
            if $realname ~~ /north\s*pole/ {
                say "$realname has id $id";
            }
        }
        else {
            @decoys.push(@sorted.join);
        }
    }

    say $sum_id;
    say "Decoys: " ~ @decoys.elems;

}
