#!/usr/bin/env perl
# H. Lim (hbim76@gmail.com)
my $gmt4 = "/home/hbim/gmt/build/bin";
use strict;
use Regexp::Common;
my $re = $RE{num}{real};

my $col = 3 ;
my @filelist=&read("./list05.txt");
#my @filelist=&read("$ARGV[0]");
# filename, width, label, fontsize

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
	#my ($file, $width, $label, $fontsize)=split(" ", $filelist[$n]);
	#my ($dx2,$dy2)=(0,0) ;
#figure/03.Qs/120.eps 6 10 0/0 0/0.0 (f)
#0                    1 2  3   4     5
#legend/06/legend01.eps 7 10 -0.35/0.2 0/0.0 \notext \frame{1p}
#0                      1 2  3         4     5       6
	if (my ($file, $width, $fontsize, $dx2, $dy2, $dxl, $dyl, $label)=$filelist[$n]=~m{^\s*(.+)\s+($re)\s+($re)\s+($re)/($re)\s+($re)/($re)\s+(.+)\s*$}){
		my @line = split(" ", $filelist[$n]);
		my ($j,$i)=&int_divider($n, $col);
		#my ($x,$y)=($x_i+$i*$dx,$y_i-$j*$dy);
		my ($x,$y)=($x_i+$i*$dx+$dx2,$y_i-$j*$dy+$dy2);
		my $image_opt = "" ;
		if ($filelist[$n] =~ m[\\frame{(.+)}]){
			$image_opt = " -F$1" ;
		}		
		$ps .= `$gmt4/psimage $file -Xa${x}c -Ya${y}c -W${width}c -C0/0/TL -P -K -O $image_opt`;
		#if (defined $label){
		if (not $filelist[$n] =~ m[\\notext]){
			$ps .= `echo "0 0 $fontsize 0 1 BL $label" | $gmt4/pstext -R0/1/0/1 -J -O -K -N -Xa${x}c -Ya${y}c -D${dxl}c/${dyl}c`;
		}
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

