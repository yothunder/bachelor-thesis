'reinit'

*Setting parea=========================================================
sxx=1; exx=10.8; ddxx=0.2; dxx=((exx-sxx)/4)-ddxx;
x1.1=sxx;      x2.1=x1.1+dxx; xr1=x1.1' 'x2.1
x1.2=x2.1+ddxx; x2.2=x1.2+dxx; xr2=x1.2' 'x2.2
x1.3=x2.2+ddxx; x2.3=x1.3+dxx; xr3=x1.3' 'x2.3
x1.4=x2.3+ddxx; x2.4=x1.4+dxx; xr4=x1.4' 'x2.4

syy=7.8; eyy=1; ddyy=1.2; dyy=((syy-eyy)/2)-ddyy;
y2.1=syy;       y1.1=y2.1-dyy; yr1=y1.1' 'y2.1
y2.2=y1.1-ddyy; y1.2=y2.2-dyy; yr2=y1.2' 'y2.2
y2.3=y1.2-ddyy; y1.3=y2.3-dyy; yr3=y1.3' 'y2.3
y2.4=y1.3-ddyy; y1.4=y2.4-dyy; yr4=y1.4' 'y2.4

p.1.1=xr1' 'yr1; p.2.1=xr2' 'yr1; p.3.1=xr3' 'yr1; p.4.1=xr4' 'yr1;
p.1.2=xr1' 'yr2; p.2.2=xr2' 'yr2; p.3.2=xr3' 'yr2; p.4.2=xr4' 'yr2;
p.1.3=xr1' 'yr3; p.2.3=xr2' 'yr3; p.3.3=xr3' 'yr3; p.4.3=xr4' 'yr3;
p.1.4=xr1' 'yr4; p.2.4=xr2' 'yr4; p.3.4=xr3' 'yr4; p.4.4=xr4' 'yr4;

'sdfopen D:\Sem8\Skripsi\#1_OLAH\vis\#graphic_q1q2.nc'

timelag = '1 21'
timelaglab = '-10 10'
ptextmarksize = '-t <Q`b1`n> <Q`b2`n> -m 3 3 -z 0.05 0.05'
prange = '-r -200 500'
xlint = '4'; ylint = '100'
xycfg = '1 3 0.15'

label.1.1 = '(a)RA (CS)'; label.2.1 = '(b)RB (CS)'
label.3.1 = '(c)RC (CS)'; label.4.1 = '(d)RD (CS)'
label.1.2 = '(e)RA (CENS)'; label.2.2 = '(f)RB (CENS)'
label.3.2 = '(g)RC (CENS)'; label.4.2 = '(h)RD (CENS)'

var.1.1 = '-v q1intcsmeanra q2intcsmeanra'; var.2.1 = '-v q1intcsmeanrb q2intcsmeanrb'
var.3.1 = '-v q1intcsmeanrc q2intcsmeanrc'; var.4.1 = '-v q1intcsmeanrd q2intcsmeanrd'
var.1.2 = '-v q1intcensmeanra q2intcensmeanra'; var.2.2 = '-v q1intcensmeanrb q2intcensmeanrb'
var.3.2 = '-v q1intcensmeanrc q2intcensmeanrc'; var.4.2 = '-v q1intcensmeanrd q2intcensmeanrd'

ir = 1
while (ir<=2)
  say 'ROW KE 'ir
  ic = 1
  while (ic<=4)
    'set parea 'p.ic.ir
    say 'parea 'p.ic.ir
    'set t 'timelag
    'set grads off'
    'set grid off'
    'set timelab off'
    'set xaxis 'timelaglab
    'set xlint 'xlint
    'set strsiz 0.18 0.2'
    'set string 1 l 5 0'
    'draw string 'x1.ic' 'y2.ir+0.2' 'label.ic.ir
    'set xlopts 'xycfg; 'set ylopts 'xycfg

    if ic = 1
      'set ylint 'ylint
      'plot 'var.ic.ir' 'prange' 'ptextmarksize
      'draw xlab jeda waktu'
      'draw ylab (Watt/m`a2`n)'
    else
      'set ylab off'
      'plot 'var.ic.ir' 'prange' 'ptextmarksize
      'draw xlab jeda waktu'
    endif
    'set ylab on'
    
    ic = ic+1
  endwhile

  ir = ir+1
endwhile

'legend -orient h -xo -4.5 -yo -3 -scale 5'

'printim D:\Sem8\Skripsi\#1_OLAH\vis\2_3qint.pdf white'
'printim D:\Sem8\Skripsi\#1_OLAH\vis\2_3qint.png white'
