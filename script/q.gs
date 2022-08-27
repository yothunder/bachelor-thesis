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

'sdfopen D:\Sem8\Skripsi\#1_OLAH\vis\#graphic_q.nc'

timelag = '1 21'
timelaglab = '-10 10'
xlint = '4'; ylint = '200'
xycfg = '1 3 0.15'
cl = '-0.9 -0.6 -0.3 0 0.3 0.6 0.9'

label.1.1 = '(a)q_CS(RA)'; label.2.1 = '(b)q_CS(RB)'
label.3.1 = '(c)q_CS(RC)'; label.4.1 = '(d)q_CS(RD)'
label.1.2 = '(e)q_CENS(RA)'; label.2.2 = '(f)q_CENS(RB)'
label.3.2 = '(g)q_CENS(RC)'; label.4.2 = '(h)q_CENS(RD)'

var.1.1 = 'qcsdiffra*1000'; var.2.1 = 'qcsdiffrb*1000'
var.3.1 = 'qcsdiffrc*1000'; var.4.1 = 'qcsdiffrd*1000'
var.1.2 = 'qcensdiffra*1000'; var.2.2 = 'qcensdiffrb*1000'
var.3.2 = 'qcensdiffrc*1000'; var.4.2 = 'qcensdiffrd*1000'

pvar.1.1 = 'qcspvalra'; pvar.2.1 = 'qcspvalrb'
pvar.3.1 = 'qcspvalrc'; pvar.4.1 = 'qcspvalrd'
pvar.1.2 = 'qcenspvalra'; pvar.2.2 = 'qcenspvalrb'
pvar.3.2 = 'qcenspvalrc'; pvar.4.2 = 'qcenspvalrd'

tileopt = '0 0.05 -type 2 -int 5 -color 0'
*colopt  = '0 20 2 -kind purple->blue->skyblue->white->gold->red->maroon'
colopt  = '0 20 1 -kind white-(0)->grainbow'
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
    'set csmooth on'
    'set xlopts 'xycfg; 'set ylopts 'xycfg

    if ic = 1
      'set gxout contour'
      'set ccolor 1'
      'set clopts 1 -1 0.09'
      'set cthick 1'
      'set clevs 'cl
      'set clab forced'
      'set clab masked'
      'd 'var.ic.ir
      'draw xlab jeda waktu'
      'draw ylab (milibar)'
	else
      'set ylab off'
      if ir=2
        if ic=4
          'set gxout contour'
          'set ccolor 1'
          'set clopts 1 -1 0.09'
          'set cthick 1'
          'set clevs 'cl
          'set clab forced'
          'set clab masked'
          'set clab on'
          'd 'var.ic.ir
          'draw xlab jeda waktu'
        endif
      endif
      'set gxout contour'
      'set ccolor 1'
      'set clopts 1 -1 0.09'
      'set cthick 1'
      'set clevs 'cl
      'set clab forced'
      'set clab masked'
      'set clab on'
      'd 'var.ic.ir
      'draw xlab jeda waktu'
    endif

    'set ylab on'

    ic = ic+1
  endwhile

  ir = ir+1
endwhile

*'printim D:\Sem8\Skripsi\#1_OLAH\vis\2_2_0_q_diff_s.pdf white'
*'printim D:\Sem8\Skripsi\#1_OLAH\vis\2_2_0_q_c.png white'
'printim D:\Sem8\Skripsi\#1_OLAH\vis\rev\2_2_0_q_c.svg white'
