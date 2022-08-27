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
ptextmarksize = '-t E P E_sig@95% P_sig@95% -m 0 0 1 1 -z 0.05 0.05 0.09 0.09 -c 1 2 1 2'
*ptextmarksize = '-t E P E_sig@95% P_sig@95%  -m 6 1 6 1 -z 0.05 0.05 0.1 0.1 -c 1 15 1 15 -k 5 5 10 10'
prange = '-r -6 8'
xlint = '4'; ylint = '2'
xycfg = '1 3 0.15'


label.1.1 = '(a)RA (CS)'; label.2.1 = '(b)RB (CS)'
label.3.1 = '(c)RC (CS)'; label.4.1 = '(d)RD (CS)'
label.1.2 = '(e)RA (CENS)'; label.2.2 = '(f)RB (CENS)'
label.3.2 = '(g)RC (CENS)'; label.4.2 = '(h)RD (CENS)'


var.1.1 = '-v ecsdiffra*24*1000 tpcsdiffra*24*1000 maskout(ecsdiffra*24*1000,0.05-ecspvalra) maskout(tpcsdiffra*24*1000,0.05-tpcspvalra)'; 
var.2.1 = '-v ecsdiffrb*24*1000 tpcsdiffrb*24*1000 maskout(ecsdiffrb*24*1000,0.05-ecspvalrb) maskout(tpcsdiffrb*24*1000,0.05-tpcspvalrb)'; 
var.3.1 = '-v ecsdiffrc*24*1000 tpcsdiffrc*24*1000 maskout(ecsdiffrc*24*1000,0.05-ecspvalrc) maskout(tpcsdiffrc*24*1000,0.05-tpcspvalrc)'; 
var.4.1 = '-v ecsdiffrd*24*1000 tpcsdiffrd*24*1000 maskout(ecsdiffrd*24*1000,0.05-ecspvalrd) maskout(tpcsdiffrd*24*1000,0.05-tpcspvalrd)'; 
var.1.2 = '-v ecensdiffra*24*1000 tpcensdiffra*24*1000 maskout(ecensdiffra*24*1000,0.05-ecenspvalra) maskout(tpcensdiffra*24*1000,0.05-tpcenspvalra)'; 
var.2.2 = '-v ecensdiffrb*24*1000 tpcensdiffrb*24*1000 maskout(ecensdiffrb*24*1000,0.05-ecenspvalrb) maskout(tpcensdiffrb*24*1000,0.05-tpcenspvalrb)'; 
var.3.2 = '-v ecensdiffrc*24*1000 tpcensdiffrc*24*1000 maskout(ecensdiffrc*24*1000,0.05-ecenspvalrc) maskout(tpcensdiffrc*24*1000,0.05-tpcenspvalrc)'; 
var.4.2 = '-v ecensdiffrd*24*1000 tpcensdiffrd*24*1000 maskout(ecensdiffrd*24*1000,0.05-ecenspvalrd) maskout(tpcensdiffrd*24*1000,0.05-tpcenspvalrd)'; 

ir = 1
while (ir<=2)
  say 'ROW KE 'ir
  ic = 1
  while (ic<=4)
    'set parea 'p.ic.ir
    say 'parea 'p.ic.ir
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
      'set t 'timelag
      'set ylint 'ylint
      'plot 'var.ic.ir' 'prange' 'ptextmarksize
      'draw xlab jeda waktu'
      'draw ylab (mm/day)'
    else
      'set t 'timelag
      'set ylab off'
      'plot 'var.ic.ir' 'prange' 'ptextmarksize
      'draw xlab jeda waktu'
    endif
    'set ylab on'
    
    ic = ic+1
  endwhile

  ir = ir+1
endwhile

'legend -orient h -xo -7 -yo -3 -scale 5'

'printim D:\Sem8\Skripsi\#1_OLAH\vis\rev\3_1_mb_diff.pdf white'
*'printim D:\Sem8\Skripsi\#1_OLAH\vis\3_1_mb_diff.png white'
'printim D:\Sem8\Skripsi\#1_OLAH\vis\rev\3_1_mb_diff.svg white'

;*Write data list

'set t 1 21'

'set prnopts %g 1 1'
var.1 = 'ecsdiffra'; var.2 = 'ecsdiffrb'; var.3 = 'ecsdiffrc'; var.4 = 'ecsdiffrd'; 
var.5 = 'ecensdiffra'; var.6 = 'ecensdiffrb'; var.7 = 'ecensdiffrc'; var.8 = 'ecensdiffrd'; 
var.9 = 'tpcsdiffra'; var.10 = 'tpcsdiffrb'; var.11 = 'tpcsdiffrc'; var.12 = 'tpcsdiffrd'; 
var.13 = 'tpcensdiffra'; var.14 = 'tpcensdiffrb'; var.15 = 'tpcensdiffrc'; var.16 = 'tpcensdiffrd'; 

il = 1
while il <= 16
  'fprintf 'var.il'*24*1000 D:\Sem8\Skripsi\#1_OLAH\vis\rev\txt\mb\ep\'var.il'.txt'
  il = il + 1
endwhile

