use v6;

my @rooms = "aaaaa-bbb-z-y-x-123[abxyz]",
            "a-b-c-d-e-f-g-h-987[abcde]",
            "not-a-real-room-404[oarel]",
            "totally-real-room-200[decoy]"
          ;

my $sum_id = 0;
for @rooms -> $room {
    my ($a, $b, $c) = ($room ~~ /(<[a..z -]>+) (\d+) \[(\w+)\]/);
    my $id = $1;
    my $checksum = $2;
    my @chs = split("", $0.subst(/\-/, "", :g), :skip-empty);

    say "read string " ~ @chs.join ~ ", id: $id checksum: $checksum";

    my %chs;
    for @chs.sort -> $ch {
        %chs{$ch} = %chs{$ch} ?? %chs{$ch} + 1 !! 1;
    }
    my @sorted = %chs.keys.sort( { %chs{$^b} <=> %chs{$^a} || $^a cmp $^b } );

    if @sorted.join ~~ /^$checksum/ {
        $sum_id += $id;
    }
    else {
        say "room $room is a decoy: " ~ @sorted.join ~ " vs " ~ $checksum;
    }
}

say $sum_id;
