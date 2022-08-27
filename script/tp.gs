'reinit'

*Setting parea=========================================================
sxx=1; exx=11; ddxx=0; dxx=((exx-sxx)/5)-ddxx;
x1.1=sxx;      x2.1=x1.1+dxx; xr1=x1.1' 'x2.1
x1.2=x2.1+ddxx; x2.2=x1.2+dxx; xr2=x1.2' 'x2.2
x1.3=x2.2+ddxx; x2.3=x1.3+dxx; xr3=x1.3' 'x2.3
x1.4=x2.3+ddxx; x2.4=x1.4+dxx; xr4=x1.4' 'x2.4
x1.5=x2.4+ddxx; x2.5=x1.5+dxx; xr5=x1.5' 'x2.5

syy=7.8; eyy=1; ddyy=1.2; dyy=((syy-eyy)/2)-ddyy;
y2.1=syy;       y1.1=y2.1-dyy; yr1=y1.1' 'y2.1
y2.2=y1.1-ddyy; y1.2=y2.2-dyy; yr2=y1.2' 'y2.2
y2.3=y1.2-ddyy; y1.3=y2.3-dyy; yr3=y1.3' 'y2.3
y2.4=y1.3-ddyy; y1.4=y2.4-dyy; yr4=y1.4' 'y2.4

p.1.1=xr1' 'yr1; p.2.1=xr2' 'yr1; p.3.1=xr3' 'yr1; p.4.1=xr4' 'yr1; p.5.1=xr5' 'yr1;
p.1.2=xr1' 'yr2; p.2.2=xr2' 'yr2; p.3.2=xr3' 'yr2; p.4.2=xr4' 'yr2; p.5.2=xr5' 'yr2;
p.1.3=xr1' 'yr3; p.2.3=xr2' 'yr3; p.3.3=xr3' 'yr3; p.4.3=xr4' 'yr3; p.5.3=xr5' 'yr3;
p.1.4=xr1' 'yr4; p.2.4=xr2' 'yr4; p.3.4=xr3' 'yr4; p.4.4=xr4' 'yr4; p.5.4=xr5' 'yr4;


'sdfopen D:\Sem8\Skripsi\#1_OLAH\vis\datalawas\#mb.nc'

timelag = '1 21'
timelaglab = '-10 10'
xlint = '10'; ylint = '5'
xycfg = '1 3 0.15'
cl = '-4 -2 0 2 4 6 8'

'set map 1 1 1'

label.1.1 = '(a)H-2 (CS)';
label.1.2 = '(b)H-1 (CS)'
label.1.3 = '(c)H_0 (CS)'; 
label.1.4 = '(d)H+1 (CS)'
label.1.5 = '(e)H+2 (CS)'; 
label.2.1 = '(f)H-2 (CENS)'
label.2.2 = '(g)H-1 (CENS)'; 
label.2.3 = '(h)H_0 (CENS)'
label.2.4 = '(g)H+1 (CENS)'; 
label.2.5 = '(h)H+2 (CENS)'

day0 = 11
lag.1=-2; lags.1='0'
lag.2=-1; lags.2='+2'
lag.3=0; lags.3='+4'
lag.4=1
lag.5=2
len=0.5; vskip='10'; scale=700
tileopt = '0 0.05 -type 2 -int 6 -color 0'
colopt = '-0.0001 0.0001 -kind rainbow'
colopt = '0 20 1 -kind white-(0)->grainbow'
xcbaropt = '0.5 9 1 1.2 -fs 2 -fh 0.18 -fw 0.15 -ft 5 -line on -edge triangle'

arrowloc='104 -26'
arrlabloc='105 -30'

ir = 1
while (ir<=2)
  ic = 1
  while (ic<=5)
    tt = day0+lag.ic
	say 'time 'tt
    'set parea 'p.ic.ir
    say 'parea 'p.ic.ir
    'set t 'tt
    'set grads off'
    'set grid off'
    'set timelab off'
    'set datawarn off'
    'set xlint 'xlint
    'set strsiz 0.15 0.18'
    'set string 1 l 5 0'
    'draw string 'x1.ic' 'y2.ir+0.2' 'label.ir.ic
    'set gxout shaded'
    'set csmooth on'
    'set xlopts 'xycfg; 'set ylopts 'xycfg

    if ir=1
    'define mags=iuqcspval+ivqcspval'; minvals=0.1
    if ic = 1
      'set ylint 'ylint
      'color 'colopt
      ;*'d maskout(tpcsmean*24*1000,0.05-tpcspval)'
      'd tpcsmean*24*1000'
      'tile tpcspval 'tileopt

      ;*'set gxout vector'; 'set ccolor 1'; 'set cthick 2';
      ;*'set arrlab off'; 'set arrscl 'len' 'scale; 'set arrowhead 0.05'
      ;*'d skip(iuqcsmean,'vskip');maskout(ivqcsmean,0.05-ivqcspval)'
      'draw xlab longitude'
      'draw ylab latitude'
	else
      'set ylab off'
      'color 'colopt
      ;*'d maskout(tpcsmean*24*1000,0.05-tpcspval)'
      'd tpcsmean*24*1000'
      'tile tpcspval 'tileopt

      ;*'set gxout vector'; 'set ccolor 1'; 'set cthick 2';
      ;*'set arrlab off'; 'set arrscl 'len' 'scale; 'set arrowhead 0.05'
      ;*'d skip(iuqcsmean,'vskip');maskout(ivqcsmean,0.05-ivqcspval)'
      'draw xlab longitude'
    endif
    endif


    if ir=2
    'define mags=iuqcenspval+ivqcenspval'; minvals=0.1
    if ic = 1
      'set ylint 'ylint
      'color 'colopt
      'd tpcensmean*24*1000'
      'tile tpcenspval 'tileopt
      'draw xlab longitude'
      'draw ylab latitude'
	else
      'set ylab off'
      'color 'colopt
      'd tpcensmean*24*1000'
      'xcbar 'xcbaropt
      'tile tpcenspval 'tileopt
      'draw xlab longitude'
    endif
    endif
    'set ylab on'

    ic = ic+1
  endwhile

  ir = ir+1
endwhile
'set strsiz 0.18 0.2'
'set string 1 l 5 0'
'draw string 9.2 0.85 mm/day'

*'printim D:\Sem8\Skripsi\#1_OLAH\vis\rev\tp.svg white'
'printim D:\Sem8\Skripsi\#1_OLAH\vis\rev\tp_.pdf white'


