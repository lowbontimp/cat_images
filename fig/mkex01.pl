#!/usr/bin/env perl

use strict ;
use warnings ;

my $rop = "0/2/0/1" ;
my $jop = "X5c/3c" ;

`gmt gmtset FORMAT_GEO_MAP D` ;
`gmt gmtset MAP_FRAME_TYPE plain` ;

`mkdir -p fig` ;

&mkfig("a.ps","A") ;
&mkfig("b.ps","B") ;
&mkfig("c.ps","C") ;
&mkfig("d.ps","D") ;
&mkfig("e.ps","E") ;
&mkfig("f.ps","F") ;

sub mkfig {
	my ($output,$letter)=@_ ;
	open(my $o,">$output") ;
	#my $letter = "A" ;
	my $ps ;
	$ps .= `gmt psxy -R$rop -J$jop -K -P -T -Xc -Yc` ;
	$ps .= `echo \"1 0.5 $letter\" | gmt pstext -R$rop -J$jop -O -K -P -F+f70p` ;
	$ps .= `gmt psbasemap -R$rop -J$jop -O -K -P -Baf -BnWSe` ;
	$ps .= `gmt psxy -R$rop -J$jop -O -P -T` ;
	print $o $ps ;
	close($o) ;
}
