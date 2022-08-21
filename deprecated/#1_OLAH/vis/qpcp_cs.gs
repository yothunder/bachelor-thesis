'reinit'

*Setting parea=========================================================
sxx=1; exx=10.5; ddxx=0.2; dxx=((exx-sxx)/4)-ddxx;
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
xlint = '4'; ylint = '200'
xycfg = '1 3 0.15'
cl = '-4 -2 0 2 4 6 8'

label.1.1 = '(a)Q`b1`n/cp (RA)'; label.1.2 = '(b)Q`b2`n/cp (RA)'
label.2.1 = '(c)Q`b1`n/cp (RB)'; label.2.2 = '(d)Q`b2`n/cp (RB)'
label.3.1 = '(e)Q`b1`n/cp (RC)'; label.3.2 = '(f)Q`b2`n/cp (RC)'
label.4.1 = '(g)Q`b1`n/cp (RD)'; label.4.2 = '(h)Q`b2`n/cp (RD)'

var.1.1 = 'q1pcpcsmeanra'; var.1.2 = 'q1pcpcsmeanrb'
var.1.3 = 'q1pcpcsmeanrc'; var.1.4 = 'q1pcpcsmeanrd'
var.2.1 = 'q2pcpcsmeanra'; var.2.2 = 'q2pcpcsmeanrb'
var.2.3 = 'q2pcpcsmeanrc'; var.2.4 = 'q2pcpcsmeanrd'

ic = 1
while (ic<=4)
  ir = 1
  while (ir<=2)
    'set parea 'p.ic.ir
    say 'parea 'p.ic.ir
    'set t 'timelag
    'set z 1 27'
    'set grads off'
    'set grid off'
    'set timelab off'
    'set xaxis 'timelaglab
    'set xlint 'xlint
    'set strsiz 0.18 0.2'
    'set string 1 l 5 0'
    'draw string 'x1.ic' 'y2.ir+0.2' 'label.ic.ir
    'set gxout shaded'
    'set csmooth on'
    'set xlopts 'xycfg; 'set ylopts 'xycfg

    if ic = 1
      'set ylint '200
      'color -5 8 1 -kind grainbow'
      'd 'var.ir.ic
      'set gxout contour'
      'set ccolor 1'
      'set clopts 1 -1 0.07'
      'set cthick 1'
      'set clevs 'cl
      'set clab forced'
      'set clab masked'
      'd 'var.ir.ic
      'draw xlab jeda waktu'
      'draw ylab (milibar)'
	else
      'set ylab off'
      'color -5 8 1 -kind grainbow'
      'd 'var.ir.ic
      'set gxout contour'
      'set ccolor 1'
      'set clopts 1 -1 0.07'
      'set cthick 1'
      'set clevs 'cl
      'set clab forced'
      'set clab masked'
      'd 'var.ir.ic
      'draw xlab jeda waktu'
    endif

    'set ylab on'

    ir = ir+1
  endwhile

  ic = ic+1
endwhile

'xcbar'

'printim D:\Sem8\Skripsi\#1_OLAH\vis\2_2_1_qpcp_cs.pdf white'
'printim D:\Sem8\Skripsi\#1_OLAH\vis\2_2_1_qpcp_cs.png white'
