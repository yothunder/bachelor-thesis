'reinit'

*Setting parea=========================================================
sxx=1; exx=12; ddxx=1.2; dxx=((exx-sxx)/3)-ddxx;
x1.1=sxx;      x2.1=x1.1+dxx; xr1=x1.1' 'x2.1
x1.2=x2.1+ddxx; x2.2=x1.2+dxx; xr2=x1.2' 'x2.2
x1.3=x2.2+ddxx; x2.3=x1.3+dxx; xr3=x1.3' 'x2.3

syy=7.8; eyy=1; ddyy=1.2; dyy=((syy-eyy)/2)-ddyy;
y2.1=syy;       y1.1=y2.1-dyy; yr1=y1.1' 'y2.1
y2.2=y1.1-ddyy; y1.2=y2.2-dyy; yr2=y1.2' 'y2.2
y2.3=y1.2-ddyy; y1.3=y2.3-dyy; yr3=y1.3' 'y2.3
y2.4=y1.3-ddyy; y1.4=y2.4-dyy; yr4=y1.4' 'y2.4

p.1.1=xr1' 'yr1; p.2.1=xr2' 'yr1; p.3.1=xr3' 'yr1;
p.1.2=xr1' 'yr2; p.2.2=xr2' 'yr2; p.3.2=xr3' 'yr2;
p.1.3=xr1' 'yr3; p.2.3=xr2' 'yr3; p.3.3=xr3' 'yr3;
p.1.4=xr1' 'yr4; p.2.4=xr2' 'yr4; p.3.4=xr3' 'yr4;

'sdfopen D:\Sem8\Skripsi\#1_OLAH\vis\#graphic_hf_sst.nc'

timelag = '1 21'
timelaglab = '-10 10'
ptextmarksize = '-t RA RB RC RD RAsig@95% RBsig@95% RCsig@95% RDsig@95% -m 0 0 0 0 1 1 1 1 -z 0.05 0.05 0.05 0.05 -c 1 2 3 4 1 2 3 4'
*prangesst = '-r -1.201 0.2'; prangesshf = '-r -6 2'; prangeslhf = '-r -40 10'
*xlint = '4'; ylintsst = '0.2'; ylintsshf = '2'; ylintslhf = '10'

prangesst = '-r 26 29.5'; prangesshf = '-r -10 0'; prangeslhf = '-r -80 0'
xlint = '4'; ylintsst = '1'; ylintsshf = '2'; ylintslhf = '10'

xycfg = '1 3 0.15'
label.1.1 = '(a)SST-CS'; label.1.2 = '(b)SST-CENS'
label.2.1 = '(c)SSHF-CS'; label.2.2 = '(d)SSHF-CENS'
label.3.1 = '(e)SLHF-CS'; label.3.2 = '(f)SLHF-CENS'

ic = 1
while (ic<=3)
  ir = 1
  while (ir<=2)
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
      'set ylint 'ylintsst
      if ir = 1
        'plot -v sstcsmeanra sstcsmeanrb sstcsmeanrc sstcsmeanrd maskout(sstcsmeanra,0.05-sstcspvalra) maskout(sstcsmeanrb,0.05-sstcspvalrb) maskout(sstcsmeanrc,0.05-sstcspvalrc) maskout(sstcsmeanrd,0.05-sstcspvalrd) 'prangesst' 'ptextmarksize
        'draw xlab jeda waktu'
        'draw ylab (`ao`nC)'
	  else
        'plot -v sstcensmeanra sstcensmeanrb sstcensmeanrc sstcensmeanrd maskout(sstcensmeanra,0.05-sstcenspvalra) maskout(sstcensmeanrb,0.05-sstcenspvalrb) maskout(sstcensmeanrc,0.05-sstcenspvalrc) maskout(sstcensmeanrd,0.05-sstcenspvalrd) 'prangesst' 'ptextmarksize
        'draw xlab jeda waktu'
        'draw ylab (`ao`nC)'
      endif
    endif

    if ic = 1
      'set ylint 'ylintsst
      if ir = 1
        'plot -v sstcsmeanra-273.15 sstcsmeanrb-273.15 sstcsmeanrc-273.15 sstcsmeanrd-273.15 maskout(sstcsmeanra-273.15,0.05-sstcspvalra) maskout(sstcsmeanrb-273.15,0.05-sstcspvalrb) maskout(sstcsmeanrc-273.15,0.05-sstcspvalrc) maskout(sstcsmeanrd-273.15,0.05-sstcspvalrd) 'prangesst' 'ptextmarksize
        'draw xlab jeda waktu'
        'draw ylab (`ao`nC)'
    else
        'plot -v sstcensmeanra-273.15 sstcensmeanrb-273.15 sstcensmeanrc-273.15 sstcensmeanrd-273.15 maskout(sstcensmeanra-273.15,0.05-sstcenspvalra) maskout(sstcensmeanrb-273.15,0.05-sstcenspvalrb) maskout(sstcensmeanrc-273.15,0.05-sstcenspvalrc) maskout(sstcensmeanrd-273.15,0.05-sstcenspvalrd) 'prangesst' 'ptextmarksize
        'draw xlab jeda waktu'
        'draw ylab (`ao`nC)'
      endif
    endif

    if ic = 2
      'set ylint 'ylintsshf
      if ir = 1
        'plot -v sshfcsmeanra/(4*3600) sshfcsmeanrb/(4*3600) sshfcsmeanrc/(4*3600) sshfcsmeanrd/(4*3600) maskout(sshfcsmeanra/(4*3600),0.05-sshfcspvalra) maskout(sshfcsmeanrb/(4*3600),0.05-sshfcspvalrb) maskout(sshfcsmeanrc/(4*3600),0.05-sshfcspvalrc) maskout(sshfcsmeanrd/(4*3600),0.05-sshfcspvalrd) 'prangesshf' 'ptextmarksize
        'draw xlab jeda waktu'
        'draw ylab (Watt/m`a2`n)'
      else
        'plot -v sshfcensmeanra/(4*3600) sshfcensmeanrb/(4*3600) sshfcensmeanrc/(4*3600) sshfcensmeanrd/(4*3600) maskout(sshfcensmeanra/(4*3600),0.05-sshfcenspvalra) maskout(sshfcensmeanrb/(4*3600),0.05-sshfcenspvalrb) maskout(sshfcensmeanrc/(4*3600),0.05-sshfcenspvalrc) maskout(sshfcensmeanrd/(4*3600),0.05-sshfcenspvalrd) 'prangesshf' 'ptextmarksize
        'draw xlab jeda waktu'
        'draw ylab (Watt/m`a2`n)'
      endif
    endif

    if ic = 3
      'set ylint 'ylintslhf
      if ir = 1
        'plot -v slhfcsmeanra/(4*3600) slhfcsmeanrb/(4*3600) slhfcsmeanrc/(4*3600) slhfcsmeanrd/(4*3600) maskout(slhfcsmeanra/(4*3600),0.05-slhfcspvalra) maskout(slhfcsmeanrb/(4*3600),0.05-slhfcspvalrb) maskout(slhfcsmeanrc/(4*3600),0.05-slhfcspvalrc) maskout(slhfcsmeanrd/(4*3600),0.05-slhfcspvalrd) 'prangeslhf' 'ptextmarksize
        'draw xlab jeda waktu'
        'draw ylab (Watt/m`a2`n)'
      else
        'plot -v slhfcensmeanra/(4*3600) slhfcensmeanrb/(4*3600) slhfcensmeanrc/(4*3600) slhfcensmeanrd/(4*3600) maskout(slhfcensmeanra/(4*3600),0.05-slhfcenspvalra) maskout(slhfcensmeanrb/(4*3600),0.05-slhfcenspvalrb) maskout(slhfcensmeanrc/(4*3600),0.05-slhfcenspvalrc) maskout(slhfcensmeanrd/(4*3600),0.05-slhfcenspvalrd) 'prangeslhf' 'ptextmarksize
        'draw xlab jeda waktu'
        'draw ylab (Watt/m`a2`n)'
        'set strsiz 0.15 0.18'
        'legend -orient h -xo -8.2 -yo -3.1 -scale 0.5'
      endif
    endif

    ir = ir+1
  endwhile

  ic = ic+1
endwhile

'printim D:\Sem8\Skripsi\#1_OLAH\vis\rev\2_1_sst_hf_mean.pdf white'
'printim D:\Sem8\Skripsi\#1_OLAH\vis\rev\2_1_sst_hf_mean.svg white'

;*Write data list

'set t 1 21'

'set prnopts %g 1 1'
var.1 = 'sstcsmeanra'; var.2 = 'sstcsmeanrb'; var.3 = 'sstcsmeanrc'; var.4 = 'sstcsmeanrd'; 
var.5 = 'sstcensmeanra'; var.6 = 'sstcensmeanrb'; var.7 = 'sstcensmeanrc'; var.8 = 'sstcensmeanrd'; 
var.9 = 'sshfcsmeanra'; var.10 = 'sshfcsmeanrb'; var.11 = 'sshfcsmeanrc'; var.12 = 'sshfcsmeanrd'; 
var.13 = 'sshfcensmeanra'; var.14 = 'sshfcensmeanrb'; var.15 = 'sshfcensmeanrc'; var.16 = 'sshfcensmeanrd'; 
var.17 = 'slhfcsmeanra'; var.18 = 'slhfcsmeanrb'; var.19 = 'slhfcsmeanrc'; var.20 = 'slhfcsmeanrd'; 
var.21 = 'slhfcensmeanra'; var.22 = 'slhfcensmeanrb'; var.23 = 'slhfcensmeanrc'; var.24 = 'slhfcensmeanrd'; 

il = 1
while il <= 24
  if il <= 8
    'fprintf 'var.il' D:\Sem8\Skripsi\#1_OLAH\vis\rev\txt\sst_hf\mean\'var.il'.txt'
  else
    'fprintf 'var.il'/(4*3600) D:\Sem8\Skripsi\#1_OLAH\vis\rev\txt\sst_hf\mean\'var.il'.txt'
  endif
  il = il + 1
endwhile

