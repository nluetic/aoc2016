use v6;

my @rooms = "aaaaa-bbb-z-y-x-123[abxyz]",
            "a-b-c-d-e-f-g-h-987[abcde]",
            "not-a-real-room-404[oarel]",
            "totally-real-room-200[decoy]"
          ;

my $sum_id = 0;
for @rooms -> $room {
    $room ~~ /(<[a..z -]>+) (\d+) \[(\w+)\]/;
    say "first: $0, id: $1 checksum: $2";
    my @chs = split("-", $0).join.split("", :skip-empty);

    # TODO sort
    
    my $id = $1;
    my $checksum = $2;
    if $chs ~~ /^$checksum/ {
        #if $chs ~~ /^abxyz/ {
        $sum_id += $id;
    }
    else {
        say "room $room is a decoy: $chs vs $checksum";
    }
}

say $sum_id;
