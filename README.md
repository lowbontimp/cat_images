# cat_images.pl
Merging subfigures into one figure with labels, such as (a) and (b), using Generic Mapping Tools (6).

## Bounding the ps file
One might need to bound the ps (postscript) file into an eps (encapsulated postscript) file
```
gmt psconvert -Te -A2p a.ps #output: a.eps
```

## Example 1
```
./cat_images.pl 2 list.txt > fig.ps
#0              1 2          3
```
* 0: path to cat_images.pl
* 1: number of column
* 2: file defining input files and specifications
* 3: path to output file
```
./a.eps 6 10 0/0 0/0 (a)
./b.eps 6 10 0/0 0/0 (b)
./c.eps 6 10 0/0 0/0 (c)
./d.eps 6 10 0/0 0/0 (d)
./legend.eps 7 10 0/0 0/0 \notext \frame{0.6p}
#0           1 2  3   4   5       6
```
* 0: path to input files
* 1: width of file in cm
* 2: font size of label in points
* 3: shift of image in cm (x/y)
* 4: shift of label in cm (x/y)
* 5: label or options (such as, \notext, \frame{0.6p})
Subfigures are put to like this way.
```
a.eps       b.eps
c.eps       d.eps
legend.eps
```

## Example 2: Stepsize in x and y
```
my $dx = "6.2"; # in cm 
my $dy = "5.5"; # in cm
my ($x_i, $y_i)=("0","21"); # initial point
```
Change the `$dx` and `$dy` in the script. Also, `$x_i` and `$y_i` are the initial position in A4 paper.

## Options
* `\notext` : no label
* `\frame{0.6}` : draw a boundary by 0.6p width
* `\prev` : rewind order of subfigure by 1. It can be used to overlap two subfigures at the same position
* `\ysize` : Height instead of width in list.txt
