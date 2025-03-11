#!/usr/bin/env perl

use strict ;
use warnings ;
my $re = "(?:(?i)(?:[-+]?)(?:(?=[.]?[0123456789])(?:[0123456789]*)(?:(?:[.])(?:[0123456789]{0,}))?)(?:(?:[E])(?:(?:[-+]?)(?:[0123456789]+))|))" ;
#my $gmt4 = "~/gmt4/bin" ;

if ($#ARGV != 1){
	print STDERR "usage: cat_image.pl num_col list.txt\n" ;
	exit ;
}

my $col = $ARGV[0] ;
my @filelist = &read($ARGV[1]);
@filelist = &remove_skipped_lines(@filelist) ;

#my @filelist=&read("./list05.txt");

my $dx = "6.4"; # in cm 
my $dy = "4.2"; # in cm
my ($x_i, $y_i)=("-1.5","15"); # initial point

######################
# internal variables #
######################
my $ps ;
my $i = 0 ;
my $j = 0 ;

$ps .= `gmt psxy -R0/1/0/1 -JX20c -P -K -T`;

my $prev = 0 ;

for (my $n=0; $n<=$#filelist; $n++){
	chomp($filelist[$n]) ;
	if ($filelist[$n]=~m{^\s*#}){
		next ;
	}
	if (my ($file, $width, $fontsize, $dx2, $dy2, $dxl, $dyl, $label_and_opts)=$filelist[$n]=~m{^\s*(.+)\s+($re)\s+($re)\s+($re)/($re)\s+($re)/($re)\s+(.+)\s*$}){
		my @line = split(" ", $filelist[$n]);
		my $image_opt = "" ;
		#my ($j,$i) = &int_divider($n, $col);
		if ($filelist[$n] =~ m[\\prev]){
			$prev++ ;
		}
		if ($filelist[$n] =~ m[\\ysize]){
			my ($wx,$wy) = &wxwy($file) ;
			my $width2 = $width/$wy*$wx ;
			print STDERR "$width -> $width2\n" ;
			$width = $width2 ;			
		}
		if ($filelist[$n] =~ m[\\frame\{(.+)\}]){
			$image_opt = " -F$1" ;
		}
		$label_and_opts =~ s/\\\w+//g ;
		my $label = $label_and_opts ;
		#print STDERR "label: $label\n" ;
		my ($j,$i) = &int_divider($n - $prev, $col) ;
		my ($x,$y) = ($x_i+$i*$dx+$dx2,$y_i-$j*$dy+$dy2) ;

		#$ps .= `gmt psimage $file -Xa${x}c -Ya${y}c -W${width}c -C0/0/TL -P -K -O $image_opt`;
		$ps .= `gmt psimage $file -Xa${x}c -Ya${y}c -D+w${width}c+jTL -P -K -O $image_opt`;
		if (not $filelist[$n] =~ m[\\notext]){
			#$ps .= `echo "0 0 $fontsize 0 1 BL $label" | gmt pstext -R0/1/0/1 -J -O -K -N -Xa${x}c -Ya${y}c -D${dxl}c/${dyl}c`;
			$ps .= `echo "0 0 $fontsize,Helvetica-Bold,black 0 BL $label" | gmt pstext -R0/1/0/1 -J -O -K -N -Xa${x}c -Ya${y}c -D${dxl}c/${dyl}c -F+f+a+j`;
		}
	}else{
		print STDERR "skipped: $filelist[$n]\n" ;
	}
}
$ps .= `gmt psxy -R -J -P -O -T`;

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

sub remove_skipped_lines {
	my (@inputs)=@_ ;
	my @output ;
	foreach my $input (@inputs){
		if (not $input =~ m{^\s*\#}){
			push(@output,$input) ;
		}
	}
	return @output ;
}

sub wxwy {
	my ($file)=@_ ;
#%%HiResBoundingBox: 0 0 244.7500 249.5174
#0                   1 2 3        4
	my $wx = 1.0 ;
	my $wy = 1.0 ;
	open(my $f,"<$file") ;
	while(my $l=<$f>){
		if ($l =~ m{%%HiResBoundingBox:}){
			#print STDERR "%%HiResBoundingBox used\n" ;
			my @c = split(" ",$l) ;
			my $x1 = $c[1] ;
			my $y1 = $c[2] ;
			my $x2 = $c[3] ;
			my $y2 = $c[4] ;
			$wx = $x2-$x1 ;
			$wy = $y2-$y1 ;
		}elsif($l =~ m{%%BoundingBox:}){
			#print STDERR "%%BoundingBox used\n" ;
			my @c = split(" ",$l) ;
			my $x1 = $c[1] ;
			my $y1 = $c[2] ;
			my $x2 = $c[3] ;
			my $y2 = $c[4] ;
			$wx = $x2-$x1 ;
			$wy = $y2-$y1 ;
		}
	}
	close($f) ;
	return ($wx,$wy) ;
}
