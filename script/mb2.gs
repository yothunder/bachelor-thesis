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

'sdfopen D:\Sem8\Skripsi\#1_OLAH\vis\#graphic_mb.nc'

timelag = '1 21'
timelaglab = '-10 10'
ptextmarksize = '-t E-P `36`1<q>/`36`1t `371`1<qV> `36`1<q>/`36`1t_sig@95% `371`1<qV>_sig@95% -m 0 0 0 1 1 -z 0.05 0.05 0.05 0.09 0.09 -c 1 2 3 2 3'
prange = '-r -12 8'
xlint = '4'; ylint = '4'
xycfg = '1 3 0.15'

label.1.1 = '(a)RA (CS)'; label.2.1 = '(b)RB (CS)'
label.3.1 = '(c)RC (CS)'; label.4.1 = '(d)RD (CS)'
label.1.2 = '(e)RA (CENS)'; label.2.2 = '(f)RB (CENS)'
label.3.2 = '(g)RC (CENS)'; label.4.2 = '(h)RD (CENS)'

var.1.1 = '-v (-1*ecsmeanra-tpcsmeanra)*24*1000 pwdtcsmeanra*24*3600 vimfdcsmeanra*24*3600 maskout(pwdtcsmeanra*24*3600,0.05-pwdtcspvalra) maskout(vimfdcsmeanra*24*3600,0.05-vimfdcspvalra)'; 
var.2.1 = '-v (-1*ecsmeanrb-tpcsmeanrb)*24*1000 pwdtcsmeanrb*24*3600 vimfdcsmeanrb*24*3600 maskout(pwdtcsmeanrb*24*3600,0.05-pwdtcspvalrb) maskout(vimfdcsmeanrb*24*3600,0.05-vimfdcspvalrb)'; 
var.3.1 = '-v (-1*ecsmeanrc-tpcsmeanrc)*24*1000 pwdtcsmeanrc*24*3600 vimfdcsmeanrc*24*3600 maskout(pwdtcsmeanrc*24*3600,0.05-pwdtcspvalrc) maskout(vimfdcsmeanrc*24*3600,0.05-vimfdcspvalrc)'; 
var.4.1 = '-v (-1*ecsmeanrd-tpcsmeanrd)*24*1000 pwdtcsmeanrd*24*3600 vimfdcsmeanrd*24*3600 maskout(pwdtcsmeanrd*24*3600,0.05-pwdtcspvalrd) maskout(vimfdcsmeanrd*24*3600,0.05-vimfdcspvalrd)'; 
var.1.2 = '-v (-1*ecensmeanra-tpcensmeanra)*24*1000 pwdtcensmeanra*24*3600 vimfdcensmeanra*24*3600 maskout(pwdtcensmeanra*24*3600,0.05-pwdtcenspvalra) maskout(vimfdcensmeanra*24*3600,0.05-vimfdcenspvalra)'; 
var.2.2 = '-v (-1*ecensmeanrb-tpcensmeanrb)*24*1000 pwdtcensmeanrb*24*3600 vimfdcensmeanrb*24*3600 maskout(pwdtcensmeanrb*24*3600,0.05-pwdtcenspvalrb) maskout(vimfdcensmeanrb*24*3600,0.05-vimfdcenspvalrb)'; 
var.3.2 = '-v (-1*ecensmeanrc-tpcensmeanrc)*24*1000 pwdtcensmeanrc*24*3600 vimfdcensmeanrc*24*3600 maskout(pwdtcensmeanrc*24*3600,0.05-pwdtcenspvalrc) maskout(vimfdcensmeanrc*24*3600,0.05-vimfdcenspvalrc)'; 
var.4.2 = '-v (-1*ecensmeanrd-tpcensmeanrd)*24*1000 pwdtcensmeanrd*24*3600 vimfdcensmeanrd*24*3600 maskout(pwdtcensmeanrd*24*3600,0.05-pwdtcenspvalrd) maskout(vimfdcensmeanrd*24*3600,0.05-vimfdcenspvalrd)'; 

;*var.1.1 = '-v (ecsmeanra-tpcsmeanra)*24*1000 pwdtcsmeanra*24*3600 vimfdcsmeanra*24*3600 maskout(pwdtcsmeanra*24*3600,0.05-pwdtcspvalra) maskout(vimfdcsmeanra*24*3600,0.05-vimfdcspvalra)'; 
;*var.2.1 = '-v (ecsmeanrb-tpcsmeanrb)*24*1000 pwdtcsmeanrb*24*3600 vimfdcsmeanrb*24*3600 maskout(pwdtcsmeanrb*24*3600,0.05-pwdtcspvalrb) maskout(vimfdcsmeanrb*24*3600,0.05-vimfdcspvalrb)'; 
;*var.3.1 = '-v (ecsmeanrc-tpcsmeanrc)*24*1000 pwdtcsmeanrc*24*3600 vimfdcsmeanrc*24*3600 maskout(pwdtcsmeanrc*24*3600,0.05-pwdtcspvalrc) maskout(vimfdcsmeanrc*24*3600,0.05-vimfdcspvalrc)'; 
;*var.4.1 = '-v (ecsmeanrd-tpcsmeanrd)*24*1000 pwdtcsmeanrd*24*3600 vimfdcsmeanrd*24*3600 maskout(pwdtcsmeanrd*24*3600,0.05-pwdtcspvalrd) maskout(vimfdcsmeanrd*24*3600,0.05-vimfdcspvalrd)'; 
;*var.1.2 = '-v (ecensmeanra-tpcensmeanra)*24*1000 pwdtcensmeanra*24*3600 vimfdcensmeanra*24*3600 maskout(pwdtcensmeanra*24*3600,0.05-pwdtcenspvalra) maskout(vimfdcensmeanra*24*3600,0.05-vimfdcenspvalra)'; 
;*var.2.2 = '-v (ecensmeanrb-tpcensmeanrb)*24*1000 pwdtcensmeanrb*24*3600 vimfdcensmeanrb*24*3600 maskout(pwdtcensmeanrb*24*3600,0.05-pwdtcenspvalrb) maskout(vimfdcensmeanrb*24*3600,0.05-vimfdcenspvalrb)'; 
;*var.3.2 = '-v (ecensmeanrc-tpcensmeanrc)*24*1000 pwdtcensmeanrc*24*3600 vimfdcensmeanrc*24*3600 maskout(pwdtcensmeanrc*24*3600,0.05-pwdtcenspvalrc) maskout(vimfdcensmeanrc*24*3600,0.05-vimfdcenspvalrc)'; 
;*var.4.2 = '-v (ecensmeanrd-tpcensmeanrd)*24*1000 pwdtcensmeanrd*24*3600 vimfdcensmeanrd*24*3600 maskout(pwdtcensmeanrd*24*3600,0.05-pwdtcenspvalrd) maskout(vimfdcensmeanrd*24*3600,0.05-vimfdcenspvalrd)'; 

;*var.1.1 = '-v (ecsmeanra-tpcsmeanra)*24*1000 pwdtcsmeanra*86400 vimfdcsmeanra*86400 maskout(pwdtcsmeanra*86400,0.05-pwdtcspvalra) maskout(vimfdcsmeanra*86400,0.05-vimfdcspvalra)'; 
;*var.2.1 = '-v (ecsmeanrb-tpcsmeanrb)*24*1000 pwdtcsmeanrb*86400 vimfdcsmeanrb*86400 maskout(pwdtcsmeanrb*86400,0.05-pwdtcspvalrb) maskout(vimfdcsmeanrb*86400,0.05-vimfdcspvalrb)'; 
;*var.3.1 = '-v (ecsmeanrc-tpcsmeanrc)*24*1000 pwdtcsmeanrc*86400 vimfdcsmeanrc*86400 maskout(pwdtcsmeanrc*86400,0.05-pwdtcspvalrc) maskout(vimfdcsmeanrc*86400,0.05-vimfdcspvalrc)'; 
;*var.4.1 = '-v (ecsmeanrd-tpcsmeanrd)*24*1000 pwdtcsmeanrd*86400 vimfdcsmeanrd*86400 maskout(pwdtcsmeanrd*86400,0.05-pwdtcspvalrd) maskout(vimfdcsmeanrd*86400,0.05-vimfdcspvalrd)'; 
;*var.1.2 = '-v (ecensmeanra-tpcensmeanra)*24*1000 pwdtcensmeanra*86400 vimfdcensmeanra*86400 maskout(pwdtcensmeanra*86400,0.05-pwdtcenspvalra) maskout(vimfdcensmeanra*86400,0.05-vimfdcenspvalra)'; 
;*var.2.2 = '-v (ecensmeanrb-tpcensmeanrb)*24*1000 pwdtcensmeanrb*86400 vimfdcensmeanrb*86400 maskout(pwdtcensmeanrb*86400,0.05-pwdtcenspvalrb) maskout(vimfdcensmeanrb*86400,0.05-vimfdcenspvalrb)'; 
;*var.3.2 = '-v (ecensmeanrc-tpcensmeanrc)*24*1000 pwdtcensmeanrc*86400 vimfdcensmeanrc*86400 maskout(pwdtcensmeanrc*86400,0.05-pwdtcenspvalrc) maskout(vimfdcensmeanrc*86400,0.05-vimfdcenspvalrc)'; 
;*var.4.2 = '-v (ecensmeanrd-tpcensmeanrd)*24*1000 pwdtcensmeanrd*86400 vimfdcensmeanrd*86400 maskout(pwdtcensmeanrd*86400,0.05-pwdtcenspvalrd) maskout(vimfdcensmeanrd*86400,0.05-vimfdcenspvalrd)'; 

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
    'set datawarn off'
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
      'draw ylab (mm/day)'
      'define mask = const(maskout(vimfdcspvalra,0.05-vimfdcspvalra),1)'
      ;*'set t 1 21'
      ;*'d mask'
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

'legend -orient h -xo -8 -yo -3.2 -scale 0.4'

'printim D:\Sem8\Skripsi\#1_OLAH\vis\rev\3_2_mb_mean.pdf white'
'printim D:\Sem8\Skripsi\#1_OLAH\vis\rev\3_2_mb_mean.svg white'

'set prnopts %g 1 1'
var.1 = '(-1*ecsmeanra-tpcsmeanra)'; var.2 = '(-1*ecsmeanrb-tpcsmeanrb)'; var.3 = '(-1*ecsmeanrc-tpcsmeanrc)'; var.4 = '(-1*ecsmeanrd-tpcsmeanrd)'; 
var.5 = '(-1*ecensmeanra-tpcensmeanra)'; var.6 = '(-1*ecensmeanrb-tpcensmeanrb)'; var.7 = '(-1*ecensmeanrc-tpcensmeanrc)'; var.8 = '(-1*ecensmeanrd-tpcensmeanrd)'; 
var.9 = 'pwdtcsmeanra'; var.10 = 'pwdtcsmeanrb'; var.11 = 'pwdtcsmeanrc'; var.12 = 'pwdtcsmeanrd'; 
var.13 = 'pwdtcensmeanra'; var.14 = 'pwdtcensmeanrb'; var.15 = 'pwdtcensmeanrc'; var.16 = 'pwdtcensmeanrd'; 
var.17 = 'vimfdcsmeanra'; var.18 = 'vimfdcsmeanrb'; var.19 = 'vimfdcsmeanrc'; var.20 = 'vimfdcsmeanrd'; 
var.21 = 'vimfdcensmeanra'; var.22 = 'vimfdcensmeanrb'; var.23 = 'vimfdcensmeanrc'; var.24 = 'vimfdcensmeanrd'; 


il = 1
while il <= 24
  if il <= 8
    'fprintf 'var.il'*24*1000 D:\Sem8\Skripsi\#1_OLAH\vis\\rev\txt\mb\eq\'var.il'.txt'
  else
    'fprintf 'var.il'*24*3600 D:\Sem8\Skripsi\#1_OLAH\vis\\rev\txt\mb\eq\'var.il'.txt'
  endif
  il = il + 1
endwhile

