#!/usr/bin/env perl

use strict ;
use warnings ;
use Regexp::Common ;
my $re = $RE{num}{real} ;
my $gmt4 = "/home/hbim/gmt/build/bin" ;

if ($#ARGV != 1){
	print STDERR "usage: cat_image.pl num_col list.txt\n" ;
	exit ;
}

my $col = $ARGV[0] ;
my @filelist=&read($ARGV[1]);

#my @filelist=&read("./list05.txt");

my $dx = "6.2"; # in cm 
my $dy = "5.5"; # in cm
my ($x_i, $y_i)=("0","21"); # initial point

######################
# internal variables #
######################
my $ps;
my $i=0;
my $j=0;

$ps .= `$gmt4/psxy -R0/1/0/1 -JX20c -P -K -T`;
for (my $n=0; $n<=$#filelist; $n++){
	chomp($filelist[$n]);
	if ($filelist[$n] =~ m{^\s*\#}){
		next ;
	}
	if (my ($file, $width, $fontsize, $dx2, $dy2, $dxl, $dyl, $label)=$filelist[$n]=~m{^\s*(.+)\s+($re)\s+($re)\s+($re)/($re)\s+($re)/($re)\s+(.+)\s*$}){
		my @line = split(" ", $filelist[$n]);
		my ($j,$i)=&int_divider($n, $col);
		my ($x,$y)=($x_i+$i*$dx+$dx2,$y_i-$j*$dy+$dy2);
		my $image_opt = "" ;
		if ($filelist[$n] =~ m[\\frame{(.+)}]){
			$image_opt = " -F$1" ;
		}		
		$ps .= `$gmt4/psimage $file -Xa${x}c -Ya${y}c -W${width}c -C0/0/TL -P -K -O $image_opt`;
		if (not $filelist[$n] =~ m[\\notext]){
			$ps .= `echo "0 0 $fontsize 0 1 BL $label" | $gmt4/pstext -R0/1/0/1 -J -O -K -N -Xa${x}c -Ya${y}c -D${dxl}c/${dyl}c`;
		}
	}else{
		print STDERR "skipped: $filelist[$n]\n" ;
	}
}
$ps .= `$gmt4/psxy -R -J -P -O -T`;

print $ps;

sub read {
	my ($input)=@_;
	open(FID,"<$input");
	my @output=<FID>;
	return @output;
}

sub int_divider {
    my ($dividend,$divisor)=@_;
    my $remainder = $dividend%$divisor;
    my $quota = ($dividend-$remainder)/$divisor;
    return ($quota,$remainder);
}

