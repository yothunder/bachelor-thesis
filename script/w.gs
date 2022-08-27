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

'sdfopen D:\Sem8\Skripsi\#1_OLAH\vis\#graphic_w.nc'

timelag = '1 21'
timelaglab = '-10 10'
xlint = '4'; ylint = '200'
xycfg = '1 3 0.15'
cl = '-0.05 -0.03 -0.01 0 0.01 0.03 0.05'

label.1.1 = '(i)`3w`1_CS(RA)'; label.2.1 = '(j)`3w`1_CS(RB)'
label.3.1 = '(k)`3w`1_CS(RC)'; label.4.1 = '(l)`3w`1_CS(RD)'
label.1.2 = '(m)`3w`1_CENS(RA)'; label.2.2 = '(n)`3w`1_CENS(RB)'
label.3.2 = '(o)`3w`1_CENS(RC)'; label.4.2 = '(p)`3w`1_CENS(RD)'

var.1.1 = 'wcsdiffra'; var.2.1 = 'wcsdiffrb'
var.3.1 = 'wcsdiffrc'; var.4.1 = 'wcsdiffrd'
var.1.2 = 'wcensdiffra'; var.2.2 = 'wcensdiffrb'
var.3.2 = 'wcensdiffrc'; var.4.2 = 'wcensdiffrd'

pvar.1.1 = 'wcspvalra'; pvar.2.1 = 'wcspvalrb'
pvar.3.1 = 'wcspvalrc'; pvar.4.1 = 'wcspvalrd'
pvar.1.2 = 'wcenspvalra'; pvar.2.2 = 'wcenspvalrb'
pvar.3.2 = 'wcenspvalrc'; pvar.4.2 = 'wcenspvalrd'

tileopt = '0 0.05 -type 2 -int 5 -color 0'
colopt  = '-0.15 0.1 -kind purple->blue->skyblue->white->gold->red->maroon'
xcbaropt = '1 9 1 1.2 -fw 0.15 -fh 0.18 -fskip 2 -line on -edge triangle'

ir = 1
while (ir<=2)
  ic = 1
  while (ic<=4)
    'set parea 'p.ic.ir
    say 'parea 'p.ic.ir
    'set t 'timelag
    'set z 1 27'
    ;*'set zlog on'
    'set grads off'
    'set grid off'
    'set timelab off'
    'set datawarn off'
    'set xaxis 'timelaglab
    'set xlint 'xlint
    'set strsiz 0.18 0.2'
    'set string 1 l 5 0'
    'draw string 'x1.ic' 'y2.ir+0.2' 'label.ic.ir
    'set gxout contour'
    'set csmooth on'
    'set xlopts 'xycfg; 'set ylopts 'xycfg
    'set clab off'

    if ic = 1
      'set gxout contour'
      'set clopts 1 -1 0.09'
      'set cthick 1'
      'set clevs 'cl
      'set clab on'
      'set ccolor 1'
      'd 'var.ic.ir
      'draw xlab jeda waktu'
      'draw ylab (milibar)'
	else
      'set ylab off'
      if ir=2
        if ic=4
          'set gxout contour'
          'set clopts 1 -1 0.09'
          'set cthick 1'
          'set clevs 'cl
          'set clab on'
          'set clab on'
          'set ccolor 1'
          'd 'var.ic.ir
          'draw xlab jeda waktu'
        endif
      endif
      'set gxout contour'
      'set clopts 1 -1 0.09'
      'set cthick 1'
      'set clevs 'cl
      'set clab on'
      'set clab on'
      'set ccolor 1'
      'd 'var.ic.ir
      'draw xlab jeda waktu'
    endif

    'set ylab on'

    ic = ic+1
  endwhile

  ir = ir+1
endwhile

*'printim D:\Sem8\Skripsi\#1_OLAH\vis\2_2_0_w_diff_s.pdf white'
*'printim D:\Sem8\Skripsi\#1_OLAH\vis\2_2_0_w_c.png white'
'printim D:\Sem8\Skripsi\#1_OLAH\vis\rev\2_2_0_w_c.svg white'
