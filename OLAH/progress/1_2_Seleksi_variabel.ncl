;===========================================================================================;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;																							;
; Progres_v1.2 - first time writing code => Tuesday, 01 Mar 2022 - 10.44 WIB (17.44 UTC)    ;
;																							;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;===========================================================================================;
																							;
;===========================================================================================;
;;------------------------------------------------------------------------------------------:
;	  Cold surge and cross equatorial surge identification : use function for conveniece	;
;;------------------------------------------------------------------------------------------:
;===========================================================================================;

begin

;loadscript ("C:/cygwin/home/yothu/#OLAH/func/timesel.ncl")
;loadscript ("C:/cygwin/home/yothu/#OLAH/func/varave.ncl")

undef("timesel")
function timesel(date)
begin
  
  print("Starting function timesel")
  
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
  
  ;--> Variable selection - tidak jadi karena ternyata tidak bisa
  ;--> variabel var tidak ada di file f katanya
  
  ;varm10  = f->var({lagm10},:,:,:)
  ;varm9   = f->var({lagm9},:,:,:)
  ;varm8   = f->var({lagm8},:,:,:)
  ;varm7   = f->var({lagm7},:,:,:)
  ;varm6   = f->var({lagm6},:,:,:)
  ;varm5   = f->var({lagm5},:,:,:)
  ;varm4   = f->var({lagm4},:,:,:)
  ;varm3   = f->var({lagm3},:,:,:)
  ;varm2   = f->var({lagm2},:,:,:)
  ;varm1   = f->var({lagm1},:,:,:)
  ;var0    = f->var({lag0},:,:,:)
  ;varp1   = f->var({lagp1},:,:,:)
  ;varp2   = f->var({lagp2},:,:,:)
  ;varp3   = f->var({lagp3},:,:,:)
  ;varp4   = f->var({lagp4},:,:,:)
  ;varp5   = f->var({lagp5},:,:,:)
  ;varp6   = f->var({lagp6},:,:,:)
  ;varp7   = f->var({lagp7},:,:,:)
  ;varp8   = f->var({lagp8},:,:,:)
  ;varp9   = f->var({lagp9},:,:,:)
  ;varp10  = f->var({lagp10},:,:,:)
  
  print("Function timesel is done")
  
  return ([/ lagm10, lagm9, lagm8, lagm7, lagm6, lagm5, lagm4, lagm3, lagm2, lagm1, \
           lag0, \
		   lagp1, lagp2, lagp3, lagp4, lagp5, lagp6, lagp7, lagp8, lagp9, lagp10 /])

end

undef ("t_merge")
function t_merge(f, var, date, lag, nlag, nlev, nlat, nlon)
begin
  print("Starting function t_merge")
  
  ntime    = dimsizes(date)
  merge    = new((/nlag, ntime, nlev, nlat, nlon/), typeof(var), var@_FillValue)
  tmergecp = new((/nlag, ntime, nlev, nlat, nlon/), typeof(var), var@_FillValue)
  
  do i = 0, nlag-1
    tmerge                = f->t({lag[i]},:,:,:) ;-> dimsizesnya 32 x 27 x 141 x 121
	tmergecp(0:0,:,:,:,:) = (/ tmerge /)         ;-> dimsizesnya 32 x 27 x 141 x 121
	tmerge               := tmergecp(0:0,:,:,:,:)  ;-> dimsizesnya 1 x 32 x 27 x 141 x 121
	merge(i,:,:,:,:)      = tmerge
  end do
  
  tratacp              = new((/ntime, nlev, nlat, nlon/), typeof(var), var@_FillValue)          ;-> dimsizesnya 32 x 27 x 141 x 121
  tratacpp             = new(dimsizes(merge),typeof(merge)) ;-> buat array baru untuk seleksi variabel
  tratacppp            = tratacpp(:,0,:,:,:)                                     ;-> reduksi dimensi, dimensi kedua nggak dipake
  ;printVarSummary(tratacppp)
  ;printMinMax(tratacppp,0)
  
  do i = 0, nlag-1 ;->looping untuk memasukkan variabel yang sudah dirata-rata
	trata                = dim_avg_n(merge(i,:,:,:,:), 0) ;-> rata-ratakan tiap jeda waktu dimsizesnya 27 x 141 x 121
	tratacp(0:0,:,:,:)   = (/ trata /)                      ;-> masukkan ke ratacp kecuali untuk dimensi 0 (waktu) karena sudah dirata-ratakan semua
	trata               := tratacp(0:0,:,:,:)               ;-> ucah rata menjadi ratacp untuk mendapatkan satu dimensi di dimensi 0 agar bisa dikumpulkan ke array terakhir dimsizesnya 1 x 27 x 144 x 121
	tratacppp(i,:,:,:)   = trata
	;print(i)
  end do
  
  delete(merge)
  delete(tmerge)
  delete(tmergecp)
  delete(trata)
  delete(tratacp)
  delete(tratacpp)
  
  print("Function t_merge is done")
  
  return (tratacppp)
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

  f        = addfile("daymean_20102020.nc","r" ) ; import file, "r" means just for "read"
  var      = f->t(1,1,1,1)
  nlag     = 21
  ;nlev     = dimsizes(f->level)     ;->27
  ;nlat     = dimsizes(f->latitude)  ;->144
  ;nlon     = dimsizes(f->longitude) ;->121
  lagcs    = timesel(datecs)
  tcsall   = t_merge(f, var, datecs, lagcs, nlag, 27, 141, 121)
  printVarSummary(tcsall)
  printMinMax(tcsall,0)
  printVarSummary(tcsall(0,:,:,:))
  printMinMax(tcsall(0,:,:,:),0)
  printVarSummary(tcsall(1,:,:,:))
  printMinMax(tcsall(1,:,:,:),0)
  
end

;===============================================================================================================
;===============================================================================================================
;===============================================================================================================
;===============================================================================================================

  ;do i = 0, nlag-1
  ;  tcs = f->t({lagcs[i]},:,:,:)
	
  ;ratacp              = new(dimsizes(tcs0),typeof(tcs0),tcs0@_FillValue)  ;-> 23 x 27 x 144 x 121
  ;ratacpp             = new(dimsizes(tcsall),typeof(tcsall),tcsall@_FillValue) ;-> buat array baru untuk seleksi variabel
  ;ratacppp            = ratacpp(:,0,:,:,:)  	
  ;do i = 0, n-1
	;rata                = dim_avg_n(tcsall(i,:,:,:,:), 0) ;-> rata-ratakan tiap jeda waktu
	;ratacp(0:0,:,:,:)   = (/ rata /)                      ;-> masukkan ke ratacp kecuali untuk dimensi 0 (waktu) karena sudah dirata-ratakan semua
	;rata               := ratacp(0:0,:,:,:)               ;-> ucah rata menjadi ratacp untuk mendapatkan satu dimensi di dimensi 0 agar bisa dikumpulkan ke array terakhir
	;ratacppp(i,:,:,:)   = rata
	;printVarSummary(rata)
  ;end do
  
  ;lagcs  = timesel(datecs)
  ;tcsm10  = f->t({lagcs[0]},:,:,:) ;-> dimensinya = 32 x 27 x 
  ;tcsm9   = f->t({lagcs[1]},:,:,:)
  ;tcsm8   = f->t({lagcs[2]},:,:,:)
  ;tcsm7   = f->t({lagcs[3]},:,:,:)
  ;tcsm6   = f->t({lagcs[4]},:,:,:)
  ;tcsm5   = f->t({lagcs[5]},:,:,:)
  ;tcsm4   = f->t({lagcs[6]},:,:,:)
  ;tcsm3   = f->t({lagcs[7]},:,:,:)
  ;tcsm2   = f->t({lagcs[8]},:,:,:)
  ;tcsm1   = f->t({lagcs[9]},:,:,:)
  ;tcs0    = f->t({lagcs[10]},:,:,:)
  ;tcsp1   = f->t({lagcs[11]},:,:,:)
  ;tcsp2   = f->t({lagcs[12]},:,:,:)
  ;tcsp3   = f->t({lagcs[13]},:,:,:)
  ;tcsp4   = f->t({lagcs[14]},:,:,:)
  ;tcsp5   = f->t({lagcs[15]},:,:,:)
  ;tcsp6   = f->t({lagcs[16]},:,:,:)
  ;tcsp7   = f->t({lagcs[17]},:,:,:)
  ;tcsp8   = f->t({lagcs[18]},:,:,:)
  ;tcsp9   = f->t({lagcs[19]},:,:,:)
  ;tcsp10  = f->t({lagcs[20]},:,:,:)
  ;tcsall  = (/ tcsm10, tcsm9, tcsm8, tcsm7, tcsm6, tcsm5, tcsm4, tcsm3, tcsm2, tcsm1, \
  ;           tcs0, \
  ;			 tcsp1, tcsp2, tcsp3, tcsp4, tcsp5, tcsp6, tcsp7, tcsp8, tcsp9, tcsp10 /)
  ;delete (tcsm10, tcsm9, tcsm8, tcsm7, tcsm6, tcsm5, tcsm4, tcsm3, tcsm2, tcsm1, \
  ;          tcs0, \
  ;			 tcsp1, tcsp2, tcsp3, tcsp4, tcsp5, tcsp6, tcsp7, tcsp8, tcsp9, tcsp10)
  
  ;tcs0!0    = "time"
  ;tcs0&time = tcs0 
  
  ;tcsall  = (/ tcsm1, tcs0, tcsp1 /)
  
  ;copy_VarCoords(tcsall, tcs0)
  ;tcsall!0 = "lag"
  ;tcsall!1 = "time"
  ;tcsall!2 = "level"
  ;tcsall!3 = "latitude"
  ;tcsall!4 = "longitude"
  
  ;printVarSummary(tcs0)
  ;printVarSummary(tcsall)
  ;print("" +"indeks"+  "   " +"lead1"+ "     " +"h0" + "        " +"lag1"+ " ")
  ;print(" " +tcsall(0,:,0:0,0:0,0:0)+ "   " +tcsall(1,:,0:0,0:0,0:0)+ "   " +tcsall(2,:,0:0,0:0,0:0)+ " ")
  
  ;tcs     = varave(tcsall)
  ;printVarSummary(tcs)

  
  ;h0 = dim_avg_n(tcsall(0,:,:,:,:),0)
  ;printVarSummary(h0)
  
  ;printVarSummary(tcsall)
  ;printVarSummary(tcsall(0,:,:,:,:))
  
  ;timeall  = ind(f->time)
  ;time2  = cd_calendar(time1,-2) ;-2 for integer, positif for double
  ;print("" +time1+ "  " +time2+ "")
  ;ntime  = dimsizes(time2)
  ;yrfrac = yyyymmdd_to_yyyyfrac(time(:),0) ; masih jadi masalah karena datanya periodik november-maret aja
  ;printVarSummary(timeall)
  ;print(timeall)
  
  ;timedatacs   = f->time({timecs})
  ;timedatacsut = cd_calendar(timedatacs,-3)
  ;timeindex = ind(timecsut)
  ;print(timeindex)
  ;print(" " +timeindex+ " " +timedatacs+ " " +timedatacsut+ " ")
  
  ;tcs    = f->t({timecs},:,:,:)
  ;printVarSummary(tcs)
    
  ;printVarSummary(time)
  ;print(" " +time1+ " " +time+ " " +yrfrac+ " ")
  ;print(ntime)
  
  ;cs   = f->v(:,{925},{8:15},{110:116})
  ;cens = f->v(:,{925},{-5:0},{105:110})

  ;indekscs   = index(time,ntime,cs,-8,1)
  ;indekscens = index(time,ntime,cens,-5,0)