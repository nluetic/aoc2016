use v6;

use Digest::MD5;

my $door_id = "abc";

my $md5 = Digest::MD5.new;

my $pw = "";

for 0..Inf -> $suffix {

    my $hvalue = $md5.md5_hex($door_id ~ $suffix);
    #say "Hvalue $hvalue, Suffix $suffix";
    if $hvalue ~~ /^00000(<[0..9a..f]>)/ {
        $pw = $pw ~ $0;    
        say "Hvalue $hvalue, Suffix $suffix, Pw $pw";
        if $pw.len == 8 {
            last;
        }
    }
}
say $pw;
