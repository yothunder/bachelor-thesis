'reinit'

*Setting parea=========================================================
sxx=1; exx=10.5; ddxx=1.2; dxx=((exx-sxx)/3)-ddxx;
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
ptextmarksize = '-t RA RB RC RD -m 3 3 3 3 -z 0.05 0.05 0.05 0.05'
prangesst = '-r 26 30'; prangesshf = '-r -20 0'; prangeslhf = '-r -70 0'
xlint = '4'; ylintsst = '0.5'; ylintsshf = '5'; ylintslhf = '10'
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
    'set xaxis 'timelaglab
    'set xlint 'xlint
    'set strsiz 0.18 0.2'
    'set string 1 l 5 0'
    'draw string 'x1.ic' 'y2.ir+0.2' 'label.ic.ir

    'set xlopts 'xycfg; 'set ylopts 'xycfg
    if ic = 1
      'set ylint 'ylintsst
      if ir = 1
        'plot -v sstcsmeanra-273.15 sstcsmeanrb-273.15 sstcsmeanrc-273.15 sstcsmeanrd-273.15 'prangesst' 'ptextmarksize
        'draw xlab jeda waktu'
        'draw ylab (`ao`nC)'
	  else
        'plot -v sstcensmeanra-273.15 sstcensmeanrb-273.15 sstcensmeanrc-273.15 sstcensmeanrd-273.15 'prangesst' 'ptextmarksize
        'draw xlab jeda waktu'
        'draw ylab (`ao`nC)'
      endif
    endif

    if ic = 2
      'set ylint 'ylintsshf
      if ir = 1
        'plot -v sshfcsmeanra/(4*3600) sshfcsmeanrb/(4*3600) sshfcsmeanrc/(4*3600) sshfcsmeanrd/(4*3600) 'prangesshf' 'ptextmarksize
        'draw xlab jeda waktu'
        'draw ylab (Watt/m`a2`n)'
      else
        'plot -v sshfcensmeanra/(4*3600) sshfcensmeanrb/(4*3600) sshfcensmeanrc/(4*3600) sshfcensmeanrd/(4*3600) 'prangesshf' 'ptextmarksize
        'draw xlab jeda waktu'
        'draw ylab (Watt/m`a2`n)'
      endif
    endif

    if ic = 3
      'set ylint 'ylintslhf
      if ir = 1
        'plot -v slhfcsmeanra/(4*3600) slhfcsmeanrb/(4*3600) slhfcsmeanrc/(4*3600) slhfcsmeanrd/(4*3600) 'prangeslhf' 'ptextmarksize
        'draw xlab jeda waktu'
        'draw ylab (Watt/m`a2`n)'
      else
        'plot -v slhfcensmeanra/(4*3600) slhfcensmeanrb/(4*3600) slhfcensmeanrc/(4*3600) slhfcensmeanrd/(4*3600) 'prangeslhf' 'ptextmarksize
        'draw xlab jeda waktu'
        'draw ylab (Watt/m`a2`n)'
        'legend -orient v -xo 2.2 -yo 1 -scale 5'
      endif
    endif

    ir = ir+1
  endwhile

  ic = ic+1
endwhile

'printim D:\Sem8\Skripsi\#1_OLAH\vis\2_1_sst_hf.pdf white'
'printim D:\Sem8\Skripsi\#1_OLAH\vis\2_1_sst_hf.png white'

*'subplot 6 1 3'
*'set grid off'
*'set grads off'
*'set timelab off'
*'set xaxis -10 10'
*'plot -v sst'cs'meanra-273.15 sst'cs'meanrb-273.15 sst'cs'meanrc-273.15 sstcsmeanrd-273.15 -r 26 30 -t sst_cs_ra sst_cs_rb sst_cs_rc sst_cs_rd -m 1 1 1 1 -z 0.02 0.02 0.02 0.02'
*'legend -scale 5'
