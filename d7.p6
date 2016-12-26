use v6;


my $base = $*PROGRAM-NAME.split(/\./)[0];
sub MAIN(Str :$inputfile = "$base.in")
{
  my @lines = $inputfile.IO.lines;

  for @lines -> $line {

    my @states = $line.split("", :skip-empty);

    my Bool $mode = True;
    my Bool $tls  = False;
    for @states.keys -> $index {

      if @states[$index] eq "[" {
        $mode = False;
      }
      if @states[$index] eq "]" {
        $mode = True;
      }

      if @states[$index+3] && 
         @states[$index]   ne @states[$index+1] && 
         @states[$index+1] eq @states[$index+2] &&
         @states[$index]   eq @states[$index+3] {

        $tls = $mode;
        if $mode == False {
            last;
        }

      }
    }

    say "$line is " ~ ($tls ?? "tls" !! "non tls"); 
  }
}
