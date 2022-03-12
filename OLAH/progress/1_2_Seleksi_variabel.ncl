;===========================================================================================;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;																							;
; Progres_v1.2 - first time writing code => Monday, 7 Mar 2022 - 13.49 WIB (20.44 UTC)		;
;																							;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;===========================================================================================;
																							;
;===========================================================================================;
;;------------------------------------------------------------------------------------------:
;	  				Variable selection : use function for conveniece						;
;;------------------------------------------------------------------------------------------:
;===========================================================================================;

begin

;----Function 1 : for timelag selection

undef("timesel")
function timesel(date)
begin
  
  print("========================")
  print("Starting function timesel")
  print("")
  
  yyyy  = date/10000 
  mmdd  = date-yyyy*10000
  mm    = mmdd/100
  dd    = mmdd-mm*100
  hh    = dd
  mn    = dd
  sc    = dd
  hh    = 0
  mn    = 0
  sc    = 0
  optdate         = 0
  optdate@return_type = "int"
  optdate@calendar    = "gregorian"
  
  unitsm10 = "hours since 1899-12-21 15:00:00.0"
  unitsm9  = "hours since 1899-12-22 15:00:00.0"
  unitsm8  = "hours since 1899-12-23 15:00:00.0"
  unitsm7  = "hours since 1899-12-24 15:00:00.0"
  unitsm6  = "hours since 1899-12-25 15:00:00.0"
  unitsm5  = "hours since 1899-12-26 15:00:00.0"
  unitsm4  = "hours since 1899-12-27 15:00:00.0"
  unitsm3  = "hours since 1899-12-28 15:00:00.0"
  unitsm2  = "hours since 1899-12-29 15:00:00.0"
  unitsm1  = "hours since 1899-12-30 15:00:00.0"
  units0   = "hours since 1899-12-31 15:00:00.0"
  unitsp1  = "hours since 1900-01-01 15:00:00.0"
  unitsp2  = "hours since 1900-01-02 15:00:00.0"
  unitsp3  = "hours since 1900-01-03 15:00:00.0"
  unitsp4  = "hours since 1900-01-04 15:00:00.0"
  unitsp5  = "hours since 1900-01-05 15:00:00.0"
  unitsp6  = "hours since 1900-01-06 15:00:00.0"
  unitsp7  = "hours since 1900-01-07 15:00:00.0"
  unitsp8  = "hours since 1900-01-08 15:00:00.0"
  unitsp9  = "hours since 1900-01-09 15:00:00.0"
  unitsp10 = "hours since 1900-01-10 15:00:00.0"  
  
  undef ("datesel")
  function datesel(date, yyyy, mm, dd, hh, sc, units, opt)
  begin 
  
	datelag = cd_inv_calendar(yyyy,mm,dd,hh,mn,sc,units, opt)
	
	return (datelag)
  end
  
  print("Starting nested-function timesel-datesel")
  lagm10  = datesel(date, yyyy, mm, dd, hh, sc, unitsm10, optdate)
  lagm9   = datesel(date, yyyy, mm, dd, hh, sc, unitsm9, optdate)
  lagm8   = datesel(date, yyyy, mm, dd, hh, sc, unitsm8, optdate)
  lagm7   = datesel(date, yyyy, mm, dd, hh, sc, unitsm7, optdate)
  lagm6   = datesel(date, yyyy, mm, dd, hh, sc, unitsm6, optdate)
  lagm5   = datesel(date, yyyy, mm, dd, hh, sc, unitsm5, optdate)
  lagm4   = datesel(date, yyyy, mm, dd, hh, sc, unitsm4, optdate)
  lagm3   = datesel(date, yyyy, mm, dd, hh, sc, unitsm3, optdate)
  lagm2   = datesel(date, yyyy, mm, dd, hh, sc, unitsm2, optdate)
  lagm1   = datesel(date, yyyy, mm, dd, hh, sc, unitsm1, optdate)
  lag0    = datesel(date, yyyy, mm, dd, hh, sc, units0, optdate)
  lagp1   = datesel(date, yyyy, mm, dd, hh, sc, unitsp1, optdate)
  lagp2   = datesel(date, yyyy, mm, dd, hh, sc, unitsp2, optdate)
  lagp3   = datesel(date, yyyy, mm, dd, hh, sc, unitsp3, optdate)
  lagp4   = datesel(date, yyyy, mm, dd, hh, sc, unitsp4, optdate)
  lagp5   = datesel(date, yyyy, mm, dd, hh, sc, unitsp5, optdate)
  lagp6   = datesel(date, yyyy, mm, dd, hh, sc, unitsp6, optdate)
  lagp7   = datesel(date, yyyy, mm, dd, hh, sc, unitsp7, optdate)
  lagp8   = datesel(date, yyyy, mm, dd, hh, sc, unitsp8, optdate)
  lagp9   = datesel(date, yyyy, mm, dd, hh, sc, unitsp9, optdate)
  lagp10  = datesel(date, yyyy, mm, dd, hh, sc, unitsp10, optdate)
  print("Nested-function timesel-datesel is done")	
  

  print("")
  print("Function timesel is done")
  print("========================")
  
  return ([/ lagm10, lagm9, lagm8, lagm7, lagm6, lagm5, lagm4, lagm3, lagm2, lagm1, \
           lag0, \
		   lagp1, lagp2, lagp3, lagp4, lagp5, lagp6, lagp7, lagp8, lagp9, lagp10 /])

end


;----Function 2 : for variable selection

undef ("mergelag")
function mergelag(f, var:string, varsample, date, lag, nlag, nlev, nlat, nlon)
begin
  print("========================")
  print("Starting function mergelag")
  print("")
  
  ntime    = dimsizes(date)

  if var .eq. "u" then  ;--------------------------------------------------------------
    ;--> Merge all lead-lag time
    mergebeforeavg		= new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)
    mergebeforeavgcp	= new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)  ;--> cp = copy
    do i = 0, nlag-1
      variabel                        = f->v({lag[i]},:,:,:) 				;-> dimsizesnya 32 x 27 x 141 x 121
   	  mergebeforeavgcp(0:0,:,:,:,:)   = (/ variabel /)         				;-> dimsizesnya 32 x 27 x 141 x 121
	  variabel                       := mergebeforeavgcp(0:0,:,:,:,:)  		;-> dimsizesnya 1 x 32 x 27 x 141 x 121
	  mergebeforeavg(i,:,:,:,:)       = variabel
    end do
    ;--> Merge after averaging the second dimension (date for cs or cens)-------------------
    mergeafteravg		= new((/ntime, nlev, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)		;-> array baru untuk menyimpan variabel yg diproses -> time (date cs atau cens), level, lat, lon -> dimsizesnya 32 x 27 x 141 x 121
    merge				= new((/ 21,27,141,121 /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)			;-> array baru untuk menyimpan variabel output -> timelag, level, lat, lon
    ;tratacppp			= tratacpp(:,0,:,:,:)												;-> reduksi dimensi, dimensi kedua nggak dipake karena ini yang dirata-ratakan [depreciated]
    do i = 0, nlag-1 																		;-> looping untuk memasukkan variabel yang sudah dirata-rata
	  mean						= dim_avg_n(mergebeforeavg(i,:,:,:,:), 0)   				;-> rata-ratakan tiap jeda waktu -> dimsizesnya 27 x 141 x 121
	  mergeafteravg(0:0,:,:,:)	= (/ mean /)                     						 	;-> masukkan ke mergeafteravg kecuali untuk dimensi 0 (waktu) karena sudah dirata-ratakan semua
	  mean						:= mergeafteravg(0:0,:,:,:)               					;-> ubah mean menjadi mergeafteravg untuk mendapatkan satu dimensi di dimensi 0 agar bisa dikumpulkan ke array terakhir -> dimsizesnya 1 x 27 x 144 x 121
	  merge(i,:,:,:)			= mean
    end do
	
  else if var .eq. "v" then  ;--------------------------------------------------------------
    ;--> Merge all lead-lag time
    mergebeforeavg		= new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)
    mergebeforeavgcp	= new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)  ;--> cp = copy
    do i = 0, nlag-1
      variabel                        = f->v({lag[i]},:,:,:) 				;-> dimsizesnya 32 x 27 x 141 x 121
   	  mergebeforeavgcp(0:0,:,:,:,:)   = (/ variabel /)         				;-> dimsizesnya 32 x 27 x 141 x 121
	  variabel                       := mergebeforeavgcp(0:0,:,:,:,:)  		;-> dimsizesnya 1 x 32 x 27 x 141 x 121
	  mergebeforeavg(i,:,:,:,:)       = variabel
    end do
    ;--> Merge after averaging the second dimension (date for cs or cens)-------------------
    mergeafteravg		= new((/ntime, nlev, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)		;-> array baru untuk menyimpan variabel yg diproses -> time (date cs atau cens), level, lat, lon -> dimsizesnya 32 x 27 x 141 x 121
    merge				= new((/ 21,27,141,121 /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)			;-> array baru untuk menyimpan variabel output -> timelag, level, lat, lon
    ;tratacppp			= tratacpp(:,0,:,:,:)												;-> reduksi dimensi, dimensi kedua nggak dipake karena ini yang dirata-ratakan [depreciated]
    do i = 0, nlag-1 																		;-> looping untuk memasukkan variabel yang sudah dirata-rata
	  mean						= dim_avg_n(mergebeforeavg(i,:,:,:,:), 0)   				;-> rata-ratakan tiap jeda waktu -> dimsizesnya 27 x 141 x 121
	  mergeafteravg(0:0,:,:,:)	= (/ mean /)                     						 	;-> masukkan ke mergeafteravg kecuali untuk dimensi 0 (waktu) karena sudah dirata-ratakan semua
	  mean						:= mergeafteravg(0:0,:,:,:)               					;-> ubah mean menjadi mergeafteravg untuk mendapatkan satu dimensi di dimensi 0 agar bisa dikumpulkan ke array terakhir -> dimsizesnya 1 x 27 x 144 x 121
	  merge(i,:,:,:)			= mean
    end do
  
  else if var .eq. "t" then ;----------------------------------------------------------------
    ;--> Merge all lead-lag time
    mergebeforeavg		= new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)
    mergebeforeavgcp	= new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)  ;--> cp = copy
    do i = 0, nlag-1
      variabel                        = f->t({lag[i]},:,:,:) 				;-> dimsizesnya 32 x 27 x 141 x 121
   	  mergebeforeavgcp(0:0,:,:,:,:)   = (/ variabel /)         				;-> dimsizesnya 32 x 27 x 141 x 121
	  variabel                       := mergebeforeavgcp(0:0,:,:,:,:)  		;-> dimsizesnya 1 x 32 x 27 x 141 x 121
	  mergebeforeavg(i,:,:,:,:)       = variabel
    end do
    ;--> Merge after averaging the second dimension (date for cs or cens)-------------------
    mergeafteravg		= new((/ntime, nlev, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)		;-> array baru untuk menyimpan variabel yg diproses -> time (date cs atau cens), level, lat, lon -> dimsizesnya 32 x 27 x 141 x 121
    merge				= new((/ 21,27,141,121 /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)			;-> array baru untuk menyimpan variabel output -> timelag, level, lat, lon
    ;tratacppp			= tratacpp(:,0,:,:,:)												;-> reduksi dimensi, dimensi kedua nggak dipake karena ini yang dirata-ratakan [depreciated]
    do i = 0, nlag-1 																		;-> looping untuk memasukkan variabel yang sudah dirata-rata
	  mean						= dim_avg_n(mergebeforeavg(i,:,:,:,:), 0)   				;-> rata-ratakan tiap jeda waktu -> dimsizesnya 27 x 141 x 121
	  mergeafteravg(0:0,:,:,:)	= (/ mean /)                     						 	;-> masukkan ke mergeafteravg kecuali untuk dimensi 0 (waktu) karena sudah dirata-ratakan semua
	  mean						:= mergeafteravg(0:0,:,:,:)               					;-> ubah mean menjadi mergeafteravg untuk mendapatkan satu dimensi di dimensi 0 agar bisa dikumpulkan ke array terakhir -> dimsizesnya 1 x 27 x 144 x 121
	  merge(i,:,:,:)			= mean
    end do
  
  else if var .eq. "q" then  ;--------------------------------------------------------------
    ;--> Merge all lead-lag time
    mergebeforeavg		= new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)
    mergebeforeavgcp	= new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)  ;--> cp = copy
    do i = 0, nlag-1
      variabel                        = f->q({lag[i]},:,:,:) 				;-> dimsizesnya 32 x 27 x 141 x 121
   	  mergebeforeavgcp(0:0,:,:,:,:)   = (/ variabel /)         				;-> dimsizesnya 32 x 27 x 141 x 121
	  variabel                       := mergebeforeavgcp(0:0,:,:,:,:)  		;-> dimsizesnya 1 x 32 x 27 x 141 x 121
	  mergebeforeavg(i,:,:,:,:)       = variabel
    end do
    ;--> Merge after averaging the second dimension (date for cs or cens)-------------------
    mergeafteravg		= new((/ntime, nlev, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)		;-> array baru untuk menyimpan variabel yg diproses -> time (date cs atau cens), level, lat, lon -> dimsizesnya 32 x 27 x 141 x 121
    merge				= new((/ 21,27,141,121 /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)			;-> array baru untuk menyimpan variabel output -> timelag, level, lat, lon
    ;tratacppp			= tratacpp(:,0,:,:,:)												;-> reduksi dimensi, dimensi kedua nggak dipake karena ini yang dirata-ratakan [depreciated]
    do i = 0, nlag-1 																		;-> looping untuk memasukkan variabel yang sudah dirata-rata
	  mean						= dim_avg_n(mergebeforeavg(i,:,:,:,:), 0)   				;-> rata-ratakan tiap jeda waktu -> dimsizesnya 27 x 141 x 121
	  mergeafteravg(0:0,:,:,:)	= (/ mean /)                     						 	;-> masukkan ke mergeafteravg kecuali untuk dimensi 0 (waktu) karena sudah dirata-ratakan semua
	  mean						:= mergeafteravg(0:0,:,:,:)               					;-> ubah mean menjadi mergeafteravg untuk mendapatkan satu dimensi di dimensi 0 agar bisa dikumpulkan ke array terakhir -> dimsizesnya 1 x 27 x 144 x 121
	  merge(i,:,:,:)			= mean
    end do
    
  else if var .eq. "w" then  ;--------------------------------------------------------------
    ;--> Merge all lead-lag time
    mergebeforeavg		= new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)
    mergebeforeavgcp	= new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)  ;--> cp = copy
    do i = 0, nlag-1
      variabel                        = f->w({lag[i]},:,:,:) 				;-> dimsizesnya 32 x 27 x 141 x 121
   	  mergebeforeavgcp(0:0,:,:,:,:)   = (/ variabel /)         				;-> dimsizesnya 32 x 27 x 141 x 121
	  variabel                       := mergebeforeavgcp(0:0,:,:,:,:)  		;-> dimsizesnya 1 x 32 x 27 x 141 x 121
	  mergebeforeavg(i,:,:,:,:)       = variabel
    end do
    ;--> Merge after averaging the second dimension (date for cs or cens)-------------------
    mergeafteravg		= new((/ntime, nlev, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)		;-> array baru untuk menyimpan variabel yg diproses -> time (date cs atau cens), level, lat, lon -> dimsizesnya 32 x 27 x 141 x 121
    merge				= new((/ 21,27,141,121 /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)			;-> array baru untuk menyimpan variabel output -> timelag, level, lat, lon
    ;tratacppp			= tratacpp(:,0,:,:,:)												;-> reduksi dimensi, dimensi kedua nggak dipake karena ini yang dirata-ratakan [depreciated]
    do i = 0, nlag-1 																		;-> looping untuk memasukkan variabel yang sudah dirata-rata
	  mean						= dim_avg_n(mergebeforeavg(i,:,:,:,:), 0)   				;-> rata-ratakan tiap jeda waktu -> dimsizesnya 27 x 141 x 121
	  mergeafteravg(0:0,:,:,:)	= (/ mean /)                     						 	;-> masukkan ke mergeafteravg kecuali untuk dimensi 0 (waktu) karena sudah dirata-ratakan semua
	  mean						:= mergeafteravg(0:0,:,:,:)               					;-> ubah mean menjadi mergeafteravg untuk mendapatkan satu dimensi di dimensi 0 agar bisa dikumpulkan ke array terakhir -> dimsizesnya 1 x 27 x 144 x 121
	  merge(i,:,:,:)			= mean
    end do
  
  end if
  end if
  end if
  end if
  end if
  
  print("")
  print("Function mergelag is done")
  print("========================")
  
  return (merge)
end


undef("mean_clim")
function mean_clim(f, var:string)
begin
  
  if var .eq. "u" then
    variabel = f->u
	meanclim = dim_avg_n(variabel,0)
  else if var .eq. "v" then
    variable = f->v
    meanclim = dim_avg_n(variabel,0)
  else if var .eq. "t" then
    variable = f->v
    meanclim = dim_avg_n(variabel,0)
  else if var .eq. "q" then
    variable = f->v
    meanclim = dim_avg_n(variabel,0)
  else if var .eq. "w" then
    variable = f->v
    meanclim = dim_avg_n(variabel,0)
  end if
  end if
  end if
  end if
  end if
  
  return (meanclim)
  
end
  
;===========================================================================================;
;;------------------------------------------------------------------------------------------;
;                                         MAIN CODE											;
;;------------------------------------------------------------------------------------------;
;===========================================================================================;
  
  datecs     = (/ 20101208, 20101217, 20101226, 20110129, 20110328, \
                  20111224, 20120107, \
				  20130104, 20130113, \
				  20131130, 20131224, 20140114, \
				  20141217, 20150101, 20150114, 20150209, \
				  20151217, 20160206, 20160229, \
				  20170126, 20170211, \
				  20171208, 20171218, 20171231, 20180111, 20180205, \
				  20190122, \
				  20191203, 20200104, 20200131, 20200209, 20200218 /)
  datecens   = (/ 20110111, 20110203, 20110219, \
                  20111226, 20120107, 20120125, 20120315, \
				  20130114, 20130222, \
				  20131230, 20140121, 20140209, 20140222, 20140310, \
				  20150102, 20150116, 20150209, 20150312, \
				  20151218, 20160201, 20160207, 20160229, \
				  20170128, 20170210, \
				  20171220, 20180113, 20180205, \
				  20190122, \
				  20200105, 20200202, 20200220 /)

;---Import file---

  f        = addfile("../data/daymean_20102020.nc","r" ) ; import file, "r" means just for "read"
  
  usample  = f->u(1,1,1,1)
  vsample  = f->v(1,1,1,1)
  tsample  = f->t(1,1,1,1)
  qsample  = f->q(1,1,1,1)
  wsample  = f->w(1,1,1,1)
  nlag     = 21
  nlev     = dimsizes(f->level)     ;->27
  nlat     = dimsizes(f->latitude)  ;->144
  nlon     = dimsizes(f->longitude) ;->121
  lagcs    = timesel(datecs)
  lagcens  = timesel(datecens)
  
  ;uclim    = mean_clim(f, "u")
  ;vclim    = mean_clim(f, "v")
  ;tclim    = mean_clim(f, "t")
  ;qclim    = mean_clim(f, "q")
  ;wclim    = mean_clim(f, "w")
  ;printVarSummary(uclim)
  ;printVarSummary(vclim)
  ;printVarSummary(tclim)
  ;printVarSummary(qclim)
  ;printVarSummary(wclim)
  
  ucs      = mergelag(f, "u", usample, datecs, lagcs, nlag, nlev, nlat, nlon)
  vcs      = mergelag(f, "v", vsample, datecs, lagcs, nlag, nlev, nlat, nlon)
  tcs      = mergelag(f, "t", tsample, datecs, lagcs, nlag, nlev, nlat, nlon)
  qcs      = mergelag(f, "q", qsample, datecs, lagcs, nlag, nlev, nlat, nlon)
  wcs      = mergelag(f, "w", wsample, datecs, lagcs, nlag, nlev, nlat, nlon)
  printVarSummary(ucs)
  printVarSummary(vcs)
  printVarSummary(tcs)
  printVarSummary(qcs)
  printVarSummary(wcs)
  
  ucens      = mergelag(f, "u", usample, datecens, lagcens, nlag, nlev, nlat, nlon)
  vcens      = mergelag(f, "v", vsample, datecens, lagcens, nlag, nlev, nlat, nlon)
  tcens      = mergelag(f, "t", tsample, datecens, lagcens, nlag, nlev, nlat, nlon)
  qcens      = mergelag(f, "q", qsample, datecens, lagcens, nlag, nlev, nlat, nlon)
  wcens      = mergelag(f, "w", wsample, datecens, lagcens, nlag, nlev, nlat, nlon)
  printVarSummary(ucens)
  printVarSummary(vcens)
  printVarSummary(tcens)
  printVarSummary(qcens)
  printVarSummary(wcens)
  
end
