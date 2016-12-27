use v6;

# use example input with: perl6 d7.p6 --inputfile=./d7_example.in
my $base = $*PROGRAM-NAME.split(/\./)[0];
sub MAIN(Str :$inputfile = "$base.in")
{
    my @lines = $inputfile.IO.lines;

    my $count_tls = 0;
    my $count_ssl = 0;
    for @lines -> $line {

        my @states = $line.split("", :skip-empty);

        my Bool $mode = True;
        my Bool $tls  = False;
        my Bool $tls_done  = False;
        my Bool $ssl  = False;
        my Bool $ssl_done  = False;
        my %ssl_babs;

        for @states.keys -> $index {

            if @states[$index] eq "[" {
                $mode = False;
            }
            if @states[$index] eq "]" {
                $mode = True;
            }

            # brackets cannot be part of the string
            if @states[$index] ~~ /<[\][]>/ ||
               (@states[$index+1] && @states[$index+1] ~~ /<[\][]>/) ||
               (@states[$index+2] && @states[$index+2] ~~ /<[\][]>/) {
                   next;
            }

            # part 1: ABBA
            if !$tls_done {
                if @states[$index+3] && 
                 @states[$index]   ne @states[$index+1] && 
                 @states[$index+1] eq @states[$index+2] &&
                 @states[$index]   eq @states[$index+3] {

                    $tls = $mode;
                    if $mode == False {
                        $tls_done = True;
                    }
                }
            }

            if !$ssl_done {
                # part 2: BAB
                if @states[$index+2] && 
                 @states[$index]   ne @states[$index+1] && 
                 @states[$index]   eq @states[$index+2] {
     
                    my $key;
                    my $value;
                    if $mode == True {
                        $key = (@states[$index], @states[$index+1], @states[$index+2]).join;
                        $value = 1;
                    }
                    else {
                        $key = (@states[$index+1], @states[$index], @states[$index+1]).join;
                        $value = -1;
                    }

                    if !%ssl_babs{$key} {
                        %ssl_babs{$key} = $value;
                     }
                     elsif %ssl_babs{$key} == $value * -1 {
                        $ssl = True;
                        $ssl_done = True;
                    }
                }
            }
        }

        $count_tls += $tls;
        $count_ssl += $ssl;
    }
    say $count_tls;
    say $count_ssl;
}
