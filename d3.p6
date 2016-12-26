use v6;

my $base = $*PROGRAM-NAME.split(/\./)[0];
my @lines = "$base.in".IO.lines;
my @try_triangles = "$base.in".IO.lines.split(/\s+/, :skip-empty);

my $count = 0;
for @try_triangles -> $a, $b, $c {
    if ($a + $b > $c && $a + $c > $b && $b + $c > $a) {
        $count++;
    }
}
say $count;


$count = 0;
for 0..@try_triangles.elems - 3 {

    if ($_ % 9 > 2) {
        next;
    }
    my $a = @try_triangles[$_];
    my $b = @try_triangles[$_+3];
    my $c = @try_triangles[$_+6];
    if ($a + $b > $c && $a + $c > $b && $b + $c > $a) {
        $count++;
    }
}
say $count;
