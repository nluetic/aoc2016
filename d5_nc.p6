# 
# simple password: first index after any md5 starting with 5 x 0 is the character
# not so simple password: first index after any md5 starting with 5 x 0 gives index, if valid,
# next one gives character
#
# 8 characters required
#
use v6;
use NativeCall;

sub md5_get(Str) returns Str is native("./d5_md5") {};

my Str $door_id = "ojvtpuvg";
my Str $pw_simple = "";
my @pw_notsosimple = "";

for 0..Inf -> $suffix {

  my $hvalue = md5_get($door_id ~ $suffix);

  if $hvalue ~~ /^00000(<[0..9a..f]>)(<[0..9a..f]>)/ {

    my ($first, $second) = ( $0, $1 );

    say "Hvalue $hvalue, Suffix $suffix";

    if $pw_simple.chars < 8 {
      $pw_simple = $pw_simple ~ $first; 
      say "added $first to simple pw: $pw_simple";
    }

    if $first ~~ /<[0..7]>/ && !@pw_notsosimple[$first] {
      @pw_notsosimple[$first] = $second;
      say "added $second to index $first of notsosimple pw:" ~ @pw_notsosimple.join;
    }

    if $pw_simple.chars == 8 && @pw_notsosimple.join.chars == 8 {
      last;
    }
  }
}
say "simple: $pw_simple, not so simple " ~ @pw_notsosimple.join;

