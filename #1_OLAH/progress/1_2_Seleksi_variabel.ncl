;===========================================================================================;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;                                                                                           ;
; Start code => Monday, 7 Mar 2022 - 13.49 WIB (20.44 UTC)                                  ;
; Last time saved => Friday, 22 April 2022 - 20.30 WIB
;                                                                                           ;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;===========================================================================================;
                                                                                            ;
begin                                                                                       ;

  start = systemfunc("date")
  print(start)                                                                                            ;
  start_read_time = get_cpu_time()                                                          ;
                                                                                            ;
  ;===========================================================================================;
  ;;------------------------------------------------------------------------------------------:
  ;           Variable selection : use function for conveniece                                ;
  ;;------------------------------------------------------------------------------------------:
  ;===========================================================================================;

  ;;------------------------------------------------------------------------------------------;
  ;               FUNCTION 1 : FOR TIMELAG SELECTION                                          ;
  ;;------------------------------------------------------------------------------------------;
                                                                                              ;
  undef("timesel")                                                                            ;
  function timesel(date,var:string)                                                           ;
  begin                                                                                       ;
                                                                                              ;
    print("========================")                                                         ;
    print("Starting function timesel")                                                        ;
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
    
    if var .eq. "sst" then
      unitsm10 = "seconds since 1980-12-22 00:00:00.0"
      unitsm9  = "seconds since 1980-12-23 00:00:00.0"
      unitsm8  = "seconds since 1980-12-24 00:00:00.0"
      unitsm7  = "seconds since 1980-12-25 00:00:00.0"
      unitsm6  = "seconds since 1980-12-26 00:00:00.0"
      unitsm5  = "seconds since 1980-12-27 00:00:00.0"
      unitsm4  = "seconds since 1980-12-28 00:00:00.0"
      unitsm3  = "seconds since 1980-12-29 00:00:00.0"
      unitsm2  = "seconds since 1980-12-30 00:00:00.0"
      unitsm1  = "seconds since 1980-12-31 00:00:00.0"
      units0   = "seconds since 1981-01-01 00:00:00.0"
      unitsp1  = "seconds since 1981-01-02 00:00:00.0"
      unitsp2  = "seconds since 1981-01-03 00:00:00.0"
      unitsp3  = "seconds since 1981-01-04 00:00:00.0"
      unitsp4  = "seconds since 1981-01-05 00:00:00.0"
      unitsp5  = "seconds since 1981-01-06 00:00:00.0"
      unitsp6  = "seconds since 1981-01-07 00:00:00.0"
      unitsp7  = "seconds since 1981-01-08 00:00:00.0"
      unitsp8  = "seconds since 1981-01-09 00:00:00.0"
      unitsp9  = "seconds since 1981-01-10 00:00:00.0"
      unitsp10 = "seconds since 1981-01-11 00:00:00.0"  
    else
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
    end if

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
                                                                                              ;
    return ([/ lagm10, lagm9, lagm8, lagm7, lagm6, lagm5, lagm4, lagm3, lagm2, lagm1, \       ;
             lag0, \                                                                          ;
         lagp1, lagp2, lagp3, lagp4, lagp5, lagp6, lagp7, lagp8, lagp9, lagp10 /])            ;
                                                                                              ;
  end                                                                                         ;
                                                                                              ;
  ;;------------------------------------------------------------------------------------------;
  ;;------------------------------------------------------------------------------------------;


  ;;------------------------------------------------------------------------------------------;
  ;               FUNCTION 2 : FOR VARIABLE SELECTION                                         ;
  ;;------------------------------------------------------------------------------------------;
                                                                                              ;
  ; Note : This function perhaps is a bad code, but it still works well                       ;
                                                                                              ;
  undef ("varsel")                                                                            ;
  function varsel(f, var:string, varsample, date, lag, nlag, nlev, nlat, nlon)                ;
  begin                                                                                       ;
    print("========================")
    print("Starting function varsel for variable  "+ var)
    print("")
    
    ntime    = dimsizes(date)
    
    ;========================================================================================
    ;--> Merge all lead-lag time
    ;mergebeforeavg   = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)
    ;mergebeforeavgcp = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)  ;--> cp = copy
    ;vnames = getfilevarnames(fin)  
    ;do nv=0,dimsizes(vnames)-1
    ;  do i = 0, nlag-1
    ;    variabel                        = f->$vnames(nv)$({lag[i]},:,:,:)
    ;    mergebeforeavgcp(0:0,:,:,:,:)   = (/ variabel /)
    ;    variabel                       := mergebeforeavgcp(0:0,:,:,:,:)
    ;    mergebeforeavg(i,:,:,:,:)       = variabel
    ;  end do
    ;end do
    ;--> Merge after averaging the second dimension (date for cs or cens)-------------------
    ;mergeafteravg    = new((/ntime, nlev, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
    ;merge        = new((/ 21,27,141,121 /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
    ;tratacppp      = tratacpp(:,0,:,:,:)
    ;do i = 0, nlag-1
    ;  mean           = dim_avg_n(mergebeforeavg(i,:,:,:,:), 0)
    ;  mergeafteravg(0:0,:,:,:) = (/ mean /)
    ;  mean           := mergeafteravg(0:0,:,:,:)
    ;  merge(i,:,:,:)     = mean
    ;end do
    ;=========================================================================================
    
    
    if var .eq. "u" then  ;--------------------------------------------------------------
      ;--> Merge all lead-lag time
      mergebeforeavg                    = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)
      mergebeforeavgcp                  = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)  ;--> cp = copy
      do i = 0, nlag-1
        variabel                        = f->u({lag[i]},:,:,:)              ;-> dimsizesnya 32 x 27 x 141 x 121
        mergebeforeavgcp(0:0,:,:,:,:)   = (/ variabel /)                    ;-> dimsizesnya 32 x 27 x 141 x 121
        variabel                       := mergebeforeavgcp(0:0,:,:,:,:)     ;-> dimsizesnya 1 x 32 x 27 x 141 x 121
        mergebeforeavg(i,:,:,:,:)       = variabel
      end do
      ;--> Merge after averaging the second dimension (date for cs or cens)-------------------
      ;mergeafteravg                     = new((/ntime, nlev, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
          ;-> array baru untuk menyimpan variabel yg diproses -> time (date cs atau cens), level, lat, lon -> dimsizesnya 32 x 27 x 141 x 121
      ;merge                             = new((/ 21,27,141,121 /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
          ;-> array baru untuk menyimpan variabel output -> timelag, level, lat, lon
      ;tratacppp                        = tratacpp(:,0,:,:,:)
          ;-> reduksi dimensi, dimensi kedua nggak dipake karena ini yang dirata-ratakan [depreciated]
      
      mergeafteravg                     = new((/ ntime, nlev, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergeaftervar                     = new((/ ntime, nlev, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergemean                         = new((/ nlag, nlev, nlat, nlon /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergevari                         = new((/ nlag, nlev, nlat, nlon /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      do i = 0, nlag-1
        ;-> looping untuk memasukkan variabel yang sudah dirata-rata
        mean                            = dim_avg_n(mergebeforeavg(i,:,:,:,:), 0)
            ;-> rata-ratakan tiap jeda waktu -> dimsizesnya 27 x 141 x 121
        mergeafteravg(0:0,:,:,:)        = (/ mean /)
            ;-> masukkan ke mergeafteravg kecuali untuk dimensi 0 (waktu) karena sudah dirata-ratakan semua
        mean                           := mergeafteravg(0:0,:,:,:)
            ;-> ubah mean menjadi mergeafteravg untuk mendapatkan satu dimensi di dimensi 0 agar bisa dikumpulkan ke array terakhir -> dimsizesnya 1 x 27 x 144 x 121
        mergemean(i,:,:,:)              = mean

        vari                            = dim_variance_n(mergebeforeavg(i,:,:,:,:), 0)
        mergeaftervar(0:0,:,:,:)        = (/ vari /)
        vari                           := mergeaftervar(0:0,:,:,:)
        mergevari(i,:,:,:)              = vari
      end do
    
    else if var .eq. "v" then  ;--------------------------------------------------------------
      ;--> Merge all lead-lag time
      mergebeforeavg                    = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)
      mergebeforeavgcp                  = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue) 
      do i = 0, nlag-1
        variabel                        = f->v({lag[i]},:,:,:)
        mergebeforeavgcp(0:0,:,:,:,:)   = (/ variabel /)
        variabel                       := mergebeforeavgcp(0:0,:,:,:,:)
        mergebeforeavg(i,:,:,:,:)       = variabel
      end do
      ;--> Merge after averaging the second dimension (date for cs or cens)-------------------
      mergeafteravg                     = new((/ ntime, nlev, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergeaftervar                     = new((/ ntime, nlev, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergemean                         = new((/ nlag, nlev, nlat, nlon /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergevari                         = new((/ nlag, nlev, nlat, nlon /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      do i = 0, nlag-1
        mean                            = dim_avg_n(mergebeforeavg(i,:,:,:,:), 0)
        mergeafteravg(0:0,:,:,:)        = (/ mean /)
        mean                           := mergeafteravg(0:0,:,:,:)
        mergemean(i,:,:,:)              = mean

        vari                            = dim_variance_n(mergebeforeavg(i,:,:,:,:), 0)
        mergeaftervar(0:0,:,:,:)        = (/ vari /)
        vari                           := mergeaftervar(0:0,:,:,:)
        mergevari(i,:,:,:)              = vari
      end do
    
    else if var .eq. "t" then ;----------------------------------------------------------------
      ;--> Merge all lead-lag time
      mergebeforeavg                    = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)
      mergebeforeavgcp                  = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)  
      do i = 0, nlag-1
        variabel                        = f->t({lag[i]},:,:,:)            ;-> dimsizesnya 32 x 27 x 141 x 121
        mergebeforeavgcp(0:0,:,:,:,:)   = (/ variabel /)                  ;-> dimsizesnya 32 x 27 x 141 x 121
        variabel                       := mergebeforeavgcp(0:0,:,:,:,:)     ;-> dimsizesnya 1 x 32 x 27 x 141 x 121
        mergebeforeavg(i,:,:,:,:)       = variabel
      end do
      ;--> Merge after averaging the second dimension (date for cs or cens)-------------------
      mergeafteravg                     = new((/ ntime, nlev, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergeaftervar                     = new((/ ntime, nlev, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergemean                         = new((/ nlag, nlev, nlat, nlon /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergevari                         = new((/ nlag, nlev, nlat, nlon /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      do i = 0, nlag-1
        mean                            = dim_avg_n(mergebeforeavg(i,:,:,:,:), 0)
        mergeafteravg(0:0,:,:,:)        = (/ mean /)
        mean                           := mergeafteravg(0:0,:,:,:)
        mergemean(i,:,:,:)              = mean

        vari                            = dim_variance_n(mergebeforeavg(i,:,:,:,:), 0)
        mergeaftervar(0:0,:,:,:)        = (/ vari /)
        vari                           := mergeaftervar(0:0,:,:,:)
        mergevari(i,:,:,:)              = vari
      end do
    
    else if var .eq. "q" then  ;--------------------------------------------------------------
      ;--> Merge all lead-lag time
      mergebeforeavg                    = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)
      mergebeforeavgcp                  = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)
      do i = 0, nlag-1
        variabel                        = f->q({lag[i]},:,:,:)
        mergebeforeavgcp(0:0,:,:,:,:)   = (/ variabel /)
        variabel                       := mergebeforeavgcp(0:0,:,:,:,:)
        mergebeforeavg(i,:,:,:,:)       = variabel
      end do
      ;--> Merge after averaging the second dimension (date for cs or cens)-------------------
      mergeafteravg                     = new((/ ntime, nlev, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergeaftervar                     = new((/ ntime, nlev, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergemean                         = new((/ nlag, nlev, nlat, nlon /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergevari                         = new((/ nlag, nlev, nlat, nlon /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      do i = 0, nlag-1
        mean                            = dim_avg_n(mergebeforeavg(i,:,:,:,:), 0)
        mergeafteravg(0:0,:,:,:)        = (/ mean /)
        mean                           := mergeafteravg(0:0,:,:,:)
        mergemean(i,:,:,:)              = mean

        vari                            = dim_variance_n(mergebeforeavg(i,:,:,:,:), 0)
        mergeaftervar(0:0,:,:,:)        = (/ vari /)
        vari                           := mergeaftervar(0:0,:,:,:)
        mergevari(i,:,:,:)              = vari
      end do
      
    else if var .eq. "w" then  ;--------------------------------------------------------------
      ;--> Merge all lead-lag time
      mergebeforeavg                    = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)
      mergebeforeavgcp                  = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)
      do i = 0, nlag-1
        variabel                        = f->w({lag[i]},:,:,:)
        mergebeforeavgcp(0:0,:,:,:,:)   = (/ variabel /)
        variabel                       := mergebeforeavgcp(0:0,:,:,:,:)
        mergebeforeavg(i,:,:,:,:)       = variabel
      end do
      ;--> Merge after averaging the second dimension (date for cs or cens)-------------------
      mergeafteravg                     = new((/ ntime, nlev, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergeaftervar                     = new((/ ntime, nlev, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergemean                         = new((/ nlag, nlev, nlat, nlon /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergevari                         = new((/ nlag, nlev, nlat, nlon /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      do i = 0, nlag-1
        mean                            = dim_avg_n(mergebeforeavg(i,:,:,:,:), 0)
        mergeafteravg(0:0,:,:,:)        = (/ mean /)
        mean                           := mergeafteravg(0:0,:,:,:)
        mergemean(i,:,:,:)              = mean

        vari                            = dim_variance_n(mergebeforeavg(i,:,:,:,:), 0)
        mergeaftervar(0:0,:,:,:)        = (/ vari /)
        vari                           := mergeaftervar(0:0,:,:,:)
        mergevari(i,:,:,:)              = vari
      end do

    else if var .eq. "e" then  ;--------------------------------------------------------------
      ;--> Merge all lead-lag time
      mergebeforeavg                    = new((/nlag, ntime, nlat, nlon/), typeof(varsample), varsample@_FillValue)
      mergebeforeavgcp                  = new((/nlag, ntime, nlat, nlon/), typeof(varsample), varsample@_FillValue)
      do i = 0, nlag-1
        variabel                        = short2flt(f->e({lag[i]},:,:))
        mergebeforeavgcp(0:0,:,:,:)     = (/ variabel /)
        variabel                       := mergebeforeavgcp(0:0,:,:,:)
        mergebeforeavg(i,:,:,:)         = variabel
      end do
      ;--> Merge after averaging the second dimension (date for cs or cens)-------------------
      mergeafteravg                     = new((/ntime, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergeaftervar                     = new((/ntime, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergemean                         = new((/ nlag,nlat,nlon /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergevari                         = new((/ nlag,nlat,nlon /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      do i = 0, nlag-1
        mean                            = dim_avg_n(mergebeforeavg(i,:,:,:), 0)
        mergeafteravg(0:0,:,:)          = (/ mean /)
        mean                           := mergeafteravg(0:0,:,:)
        mergemean(i,:,:)                = mean

        vari                            = dim_variance_n(mergebeforeavg(i,:,:,:), 0)
        mergeaftervar(0:0,:,:)          = (/ vari /)
        vari                           := mergeaftervar(0:0,:,:)
        mergevari(i,:,:)                = vari
      end do

    else if var .eq. "tp" then  ;--------------------------------------------------------------
      ;--> Merge all lead-lag time
      mergebeforeavg                    = new((/nlag, ntime, nlat, nlon/), typeof(varsample), varsample@_FillValue)
      mergebeforeavgcp                  = new((/nlag, ntime, nlat, nlon/), typeof(varsample), varsample@_FillValue)
      do i = 0, nlag-1
        variabel                        = short2flt(f->tp({lag[i]},:,:))        ;-> dimsizesnya 32 x 141 x 121
        mergebeforeavgcp(0:0,:,:,:)     = (/ variabel /)                        ;-> dimsizesnya 32 x 141 x 121
        variabel                       := mergebeforeavgcp(0:0,:,:,:)           ;-> dimsizesnya 1 x 32 x 141 x 121
        mergebeforeavg(i,:,:,:)         = variabel
      end do
      ;--> Merge after averaging the second dimension (date for cs or cens)-------------------
      mergeafteravg                     = new((/ntime, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergeaftervar                     = new((/ntime, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergemean                         = new((/ nlag,nlat,nlon /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergevari                         = new((/ nlag,nlat,nlon /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      do i = 0, nlag-1
        mean                            = dim_avg_n(mergebeforeavg(i,:,:,:), 0)
        mergeafteravg(0:0,:,:)          = (/ mean /)
        mean                           := mergeafteravg(0:0,:,:)
        mergemean(i,:,:)                = mean

        vari                            = dim_variance_n(mergebeforeavg(i,:,:,:), 0)
        mergeaftervar(0:0,:,:)          = (/ vari /)
        vari                           := mergeaftervar(0:0,:,:)
        mergevari(i,:,:)                = vari
      end do

    else if var .eq. "slhf" then  ;--------------------------------------------------------------
      ;--> Merge all lead-lag time
      mergebeforeavg                    = new((/nlag, ntime, nlat, nlon/), typeof(varsample), varsample@_FillValue)
      mergebeforeavgcp                  = new((/nlag, ntime, nlat, nlon/), typeof(varsample), varsample@_FillValue)
      do i = 0, nlag-1
        variabel                        = short2flt(f->slhf({lag[i]},:,:) )
        mergebeforeavgcp(0:0,:,:,:)     = (/ variabel /)
        variabel                       := mergebeforeavgcp(0:0,:,:,:)
        mergebeforeavg(i,:,:,:)         = variabel
      end do
      ;--> Merge after averaging the second dimension (date for cs or cens)-------------------
      mergeafteravg                     = new((/ntime, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergeaftervar                     = new((/ntime, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergemean                         = new((/ nlag,nlat,nlon /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergevari                         = new((/ nlag,nlat,nlon /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      do i = 0, nlag-1
        mean                            = dim_avg_n(mergebeforeavg(i,:,:,:), 0)
        mergeafteravg(0:0,:,:)          = (/ mean /)
        mean                           := mergeafteravg(0:0,:,:)
        mergemean(i,:,:)                = mean

        vari                            = dim_variance_n(mergebeforeavg(i,:,:,:), 0)
        mergeaftervar(0:0,:,:)          = (/ vari /)
        vari                           := mergeaftervar(0:0,:,:)
        mergevari(i,:,:)                = vari
      end do 

    else if var .eq. "sshf" then  ;--------------------------------------------------------------
      ;--> Merge all lead-lag time
      mergebeforeavg                    = new((/nlag, ntime, nlat, nlon/), typeof(varsample), varsample@_FillValue)
      mergebeforeavgcp                  = new((/nlag, ntime, nlat, nlon/), typeof(varsample), varsample@_FillValue)  ;--> cp = copy
      do i = 0, nlag-1
        variabel                        = short2flt(f->sshf({lag[i]},:,:))
        mergebeforeavgcp(0:0,:,:,:)     = (/ variabel /)
        variabel                       := mergebeforeavgcp(0:0,:,:,:)
        mergebeforeavg(i,:,:,:)         = variabel
      end do
      ;--> Merge after averaging the second dimension (date for cs or cens)-------------------
      mergeafteravg                     = new((/ntime, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergeaftervar                     = new((/ntime, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergemean                         = new((/ nlag,nlat,nlon /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergevari                         = new((/ nlag,nlat,nlon /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      do i = 0, nlag-1
        mean                            = dim_avg_n(mergebeforeavg(i,:,:,:), 0)
        mergeafteravg(0:0,:,:)          = (/ mean /)
        mean                           := mergeafteravg(0:0,:,:)
        mergemean(i,:,:)                = mean

        vari                            = dim_variance_n(mergebeforeavg(i,:,:,:), 0)
        mergeaftervar(0:0,:,:)          = (/ vari /)
        vari                           := mergeaftervar(0:0,:,:)
        mergevari(i,:,:)                = vari
      end do

    else if var .eq. "sst" then  ;--------------------------------------------------------------
      ;--> Merge all lead-lag time
      mergebeforeavg                    = new((/nlag, ntime, nlat, nlon/), typeof(varsample), varsample@_FillValue)
      mergebeforeavgcp                  = new((/nlag, ntime, nlat, nlon/), typeof(varsample), varsample@_FillValue)  ;--> cp = copy
      do i = 0, nlag-1
        variabel                        = short2flt(f->analysed_sst({lag[i]},:,:))
        mergebeforeavgcp(0:0,:,:,:)     = (/ variabel /)
        variabel                       := mergebeforeavgcp(0:0,:,:,:)
        mergebeforeavg(i,:,:,:)         = variabel
      end do
      printMinMax(mergebeforeavg,0)
      ;--> Merge after averaging the second dimension (date for cs or cens)-------------------
      mergeafteravg                     = new((/ntime, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergeaftervar                     = new((/ntime, nlat, nlon/), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergemean                         = new((/ nlag,nlat,nlon /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      mergevari                         = new((/ nlag,nlat,nlon /), typeof(mergebeforeavg), mergebeforeavg@_FillValue)
      do i = 0, nlag-1
        mean                            = dim_avg_n(mergebeforeavg(i,:,:,:), 0)
        mergeafteravg(0:0,:,:)          = (/ mean /)
        mean                           := mergeafteravg(0:0,:,:)
        mergemean(i,:,:)                = mean

        vari                            = dim_variance_n(mergebeforeavg(i,:,:,:), 0)
        mergeaftervar(0:0,:,:)          = (/ vari /)
        vari                           := mergeaftervar(0:0,:,:)
        mergevari(i,:,:)                = vari
      end do

    end if
    end if
    end if
    end if
    end if
    end if
    end if
    end if
    end if
    end if
    
    print("")
    print("Function varsel for variable "+ var +" is done")
    print("========================")
                                                                                              ;
    return ([/ mergemean, mergevari /])                                                                            ;
  end                                                                                         ;
                                                                                              ;
  ;;------------------------------------------------------------------------------------------;
  ;;------------------------------------------------------------------------------------------;


  ;;------------------------------------------------------------------------------------------;
  ;               FUNCTION 3 : FOR CLIMATOLOGICAL MEAN                                        ;
  ;;------------------------------------------------------------------------------------------;

  ;-> NOTE : This function is not used, too expensive computational resource. Use CDO instead

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
  ;                                         MAIN CODE                                         ;
  ;;------------------------------------------------------------------------------------------;
  ;===========================================================================================;
                                                                                              ;
  ;-> cs stands for cold surge                                                                ;
  ;-> cens stands for cross equatorial northerly surge                                        ;
                                                                                              ;
  ;;------------------------------------------------------------------------------------------;
  ;                                      DATE ADJUSTMENT                                      ;
  ;;------------------------------------------------------------------------------------------;
                                                                                              ;
  ;---Manual input for date CS and CENS                                                       ;
                                                                                              ;
    datecs     = (/ 20101208, 20101217, 20101226, 20110129, 20110328, \                       ;
                    20111224, 20120107, \                                                     ;
                    20130104, 20130113, \                                                     ;
                    20131130, 20131224, 20140114, \                                           ; 
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

    lagcs         = timesel(datecs, "era5")
    lagcens       = timesel(datecens, "era5")
    lagcssst      = timesel(datecs, "sst")
    lagcenssst    = timesel(datecens, "sst")
    timelag       = ispan(0,20,1)
    timelag@units = "days since 2010-01-01 00:00:0.0"
    nlag          = dimsizes(timelag) 
    print(nlag)
    ;print(lagcs)
    ;print(lagcssst)
    
  ;;------------------------------------------------------------------------------------------;
  ;                                      READ DATA FROM FILE                                  ;
  ;;------------------------------------------------------------------------------------------;

  pressurelevel = True
  singlelevel   = False

  ;---Pressure level
    if (pressurelevel)

      fpressurelevel  = addfile("../data/daymean_pressurelevel.nc","r" )  ; import file
      usample     = fpressurelevel->u(1:2,1:2,:,:)          ; "r" means just
      vsample     = fpressurelevel->v(1:2,1:2,:,:)          ; for "read"
      tsample     = fpressurelevel->t(1:2,1:2,:,:)
      qsample     = fpressurelevel->q(1:2,1:2,:,:)
      wsample     = fpressurelevel->w(1:2,1:2,:,:)
      level     = fpressurelevel->level
      lat       = fpressurelevel->latitude
      lon       = fpressurelevel->longitude
      nlev      = dimsizes(level)           ;->27
      nlat      = dimsizes(lat)             ;->144
      nlon      = dimsizes(lon)             ;->121
    
      ;=================================================================
      ; Not used, too expensive computational resource. Use CDO instead=
      ;=========================================;=======================
      ;uclim    = mean_clim(f, "u")       ;
      ;vclim    = mean_clim(f, "v")       ;
      ;tclim    = mean_clim(f, "t")       ;
      ;qclim    = mean_clim(f, "q")       ;
      ;wclim    = mean_clim(f, "w")       ;
      ;printVarSummary(uclim)         ;
      ;printVarSummary(vclim)         ;
      ;printVarSummary(tclim)         ;
      ;printVarSummary(qclim)         ;
      ;printVarSummary(wclim)         ;
      ;=========================================;
    
      ucs     = varsel(fpressurelevel, "u", usample, datecs, lagcs, nlag, nlev, nlat, nlon)
      vcs     = varsel(fpressurelevel, "v", vsample, datecs, lagcs, nlag, nlev, nlat, nlon)
      tcs     = varsel(fpressurelevel, "t", tsample, datecs, lagcs, nlag, nlev, nlat, nlon)
      qcs     = varsel(fpressurelevel, "q", qsample, datecs, lagcs, nlag, nlev, nlat, nlon)
      wcs     = varsel(fpressurelevel, "w", wsample, datecs, lagcs, nlag, nlev, nlat, nlon)
    
      ucsmean = ucs[0]
      ucsvari = ucs[1]
      vcsmean = vcs[0]
      vcsvari = vcs[1]
      tcsmean = tcs[0]
      tcsvari = tcs[1]
      qcsmean = qcs[0]
      qcsvari = qcs[1]
      wcsmean = wcs[0]
      wcsvari = wcs[1]

      ucsmean!0   = "timelag"
      ucsmean!1   = "lev"
      ucsmean!2   = "lat"
      ucsmean!3   = "lon"
      ucsmean&timelag = timelag
      ucsmean&lev   = level
      ucsmean&lat   = lat
      ucsmean&lon   = lon

      ucsvari!0   = "timelag"
      ucsvari!1   = "lev"
      ucsvari!2   = "lat"
      ucsvari!3   = "lon"
      ucsvari&timelag = timelag
      ucsvari&lev   = level
      ucsvari&lat   = lat
      ucsvari&lon   = lon
     
      copy_VarAtts(usample,ucsmean)
      copy_VarAtts(vsample,vcsmean)
      copy_VarAtts(tsample,tcsmean)
      copy_VarAtts(qsample,qcsmean)
      copy_VarAtts(wsample,wcsmean)
      copy_VarCoords(ucsmean, vcsmean)
      copy_VarCoords(ucsmean, tcsmean)
      copy_VarCoords(ucsmean, qcsmean)
      copy_VarCoords(ucsmean, wcsmean)
      printVarSummary(ucsmean)
      printVarSummary(vcsmean)
      printVarSummary(tcsmean)
      printVarSummary(qcsmean)
      printVarSummary(wcsmean)

      copy_VarAtts(usample,ucsvari)
      copy_VarAtts(vsample,vcsvari)
      copy_VarAtts(tsample,tcsvari)
      copy_VarAtts(qsample,qcsvari)
      copy_VarAtts(wsample,wcsvari)
      copy_VarCoords(ucsvari, vcsvari)
      copy_VarCoords(ucsvari, tcsvari)
      copy_VarCoords(ucsvari, qcsvari)
      copy_VarCoords(ucsvari, wcsvari)
      printVarSummary(ucsvari)
      printVarSummary(vcsvari)
      printVarSummary(tcsvari)
      printVarSummary(qcsvari)
      printVarSummary(wcsvari)

      ;===

      ucens   = varsel(fpressurelevel, "u", usample, datecens, lagcens, nlag, nlev, nlat, nlon)
      vcens   = varsel(fpressurelevel, "v", vsample, datecens, lagcens, nlag, nlev, nlat, nlon)
      tcens   = varsel(fpressurelevel, "t", tsample, datecens, lagcens, nlag, nlev, nlat, nlon)
      qcens   = varsel(fpressurelevel, "q", qsample, datecens, lagcens, nlag, nlev, nlat, nlon)
      wcens   = varsel(fpressurelevel, "w", wsample, datecens, lagcens, nlag, nlev, nlat, nlon)

      ucensmean = ucens[0]
      ucensvari = ucens[1]
      vcensmean = vcens[0]
      vcensvari = vcens[1]
      tcensmean = tcens[0]
      tcensvari = tcens[1]
      qcensmean = qcens[0]
      qcensvari = qcens[1]
      wcensmean = wcens[0]
      wcensvari = wcens[1]

      copy_VarMeta(ucsmean,ucensmean)
      copy_VarMeta(vcsmean,vcensmean)
      copy_VarMeta(tcsmean,tcensmean)
      copy_VarMeta(qcsmean,qcensmean)
      copy_VarMeta(wcsmean,wcensmean)
      printVarSummary(ucensmean)
      printVarSummary(vcensmean)
      printVarSummary(tcensmean)
      printVarSummary(qcensmean)
      printVarSummary(wcensmean)

      copy_VarMeta(ucsvari,ucensvari)
      copy_VarMeta(vcsvari,vcensvari)
      copy_VarMeta(tcsvari,tcensvari)
      copy_VarMeta(qcsvari,qcensvari)
      copy_VarMeta(wcsvari,wcensvari)
      printVarSummary(ucensvari)
      printVarSummary(vcensvari)
      printVarSummary(tcensvari)
      printVarSummary(qcensvari)
      printVarSummary(wcensvari)
    
    end if


  ;---Single level

    if (singlelevel)

      fsinglelevel   = addfile("../data/daymean_singlelevel.nc","r" )
      fsst           = addfile("../data/daymean_sst.nc","r")
      esample     = short2flt(fsinglelevel->e(1:2,:,:))
      tpsample    = short2flt(fsinglelevel->tp(1:2,:,:))
      slhfsample  = short2flt(fsinglelevel->slhf(1:2,:,:))
      sshfsample  = short2flt(fsinglelevel->sshf(1:2,:,:))
      sstsample   = short2flt(fsst->analysed_sst(1:2,:,:))
      level     = 1
      lat       = fsinglelevel->latitude
      lon       = fsinglelevel->longitude
      nlev      = dimsizes(level)           ;->1
      nlat      = dimsizes(lat)             ;->144
      nlon      = dimsizes(lon)             ;->121
      latsst    = fsst->lat
      lonsst    = fsst->lon
      nlatsst   = dimsizes(latsst)
      nlonsst   = dimsizes(lonsst)
      print(nlatsst)
      print(nlonsst)
      printMinMax(sstsample,0)

      ecs       = varsel(fsinglelevel, "e", esample, datecs, lagcs, nlag, nlev, nlat, nlon)
      tpcs      = varsel(fsinglelevel, "tp", tpsample, datecs, lagcs, nlag, nlev, nlat, nlon)
      slhfcs    = varsel(fsinglelevel, "slhf", slhfsample, datecs, lagcs, nlag, nlev, nlat, nlon)
      sshfcs    = varsel(fsinglelevel, "sshf", sshfsample, datecs, lagcs, nlag, nlev, nlat, nlon)
      sstcs     = varsel(fsst, "sst", sstsample, datecs, lagcssst, nlag, nlev, nlatsst, nlonsst)

      ecsmean    = ecs[0]
      ecsvari    = ecs[1]
      tpcsmean   = tpcs[0]
      tpcsvari   = tpcs[1]
      slhfcsmean = slhfcs[0]
      slhfcsvari = slhfcs[1]
      sshfcsmean = sshfcs[0]
      sshfcsvari = sshfcs[1]
      sstcsmean  = sstcs[0]
      sstcsvari  = sstcs[1]

      ecsmean!0       = "timelag"
      ecsmean!1       = "lat"
      ecsmean!2       = "lon"
      ecsmean&timelag = timelag
      ecsmean&lat     = lat
      ecsmean&lon     = lon

      sstcsmean!0       = "timelag"
      sstcsmean!1       = "lat"
      sstcsmean!2       = "lon"
      sstcsmean&timelag = timelag
      sstcsmean&lat     = latsst
      sstcsmean&lon     = lonsst

      ecsvari!0       = "timelag"
      ecsvari!1       = "lat"
      ecsvari!2       = "lon"
      ecsvari&timelag = timelag
      ecsvari&lat     = lat
      ecsvari&lon     = lon

      sstcsvari!0       = "timelag"
      sstcsvari!1       = "lat"
      sstcsvari!2       = "lon"
      sstcsvari&timelag = timelag
      sstcsvari&lat     = latsst
      sstcsvari&lon     = lonsst

      copy_VarAtts(esample,ecsmean)
      copy_VarAtts(tpsample,tpcsmean)
      copy_VarAtts(slhfsample,slhfcsmean)
      copy_VarAtts(sshfsample,sshfcsmean)
      copy_VarAtts(sstsample,sstcsmean)
      copy_VarCoords(ecsmean, tpcsmean)
      copy_VarCoords(ecsmean, slhfcsmean)
      copy_VarCoords(ecsmean, sshfcsmean)
      printVarSummary(ecsmean)
      printVarSummary(tpcsmean)
      printVarSummary(slhfcsmean)
      printVarSummary(sshfcsmean)
      printVarSummary(sstcsmean)

      copy_VarAtts(esample,ecsvari)
      copy_VarAtts(tpsample,tpcsvari)
      copy_VarAtts(slhfsample,slhfcsvari)
      copy_VarAtts(sshfsample,sshfcsvari)
      copy_VarAtts(sstsample,sstcsvari)
      copy_VarCoords(ecsvari, tpcsvari)
      copy_VarCoords(ecsvari, slhfcsvari)
      copy_VarCoords(ecsvari, sshfcsvari)
      printVarSummary(ecsvari)
      printVarSummary(tpcsvari)
      printVarSummary(slhfcsvari)
      printVarSummary(sshfcsvari)
      printVarSummary(sstcsvari)

      ;=======

      ecens     = varsel(fsinglelevel, "e", esample, datecens, lagcens, nlag, nlev, nlat, nlon)
      tpcens    = varsel(fsinglelevel, "tp", tpsample, datecens, lagcens, nlag, nlev, nlat, nlon)
      slhfcens  = varsel(fsinglelevel, "slhf", slhfsample, datecens, lagcens, nlag, nlev, nlat, nlon)
      sshfcens  = varsel(fsinglelevel, "sshf", sshfsample, datecens, lagcens, nlag, nlev, nlat, nlon)
      sstcens   = varsel(fsst, "sst", sstsample, datecens, lagcenssst, nlag, nlev, nlatsst, nlonsst)

      ecensmean    = ecens[0]
      ecensvari    = ecens[1]
      tpcensmean   = tpcens[0]
      tpcensvari   = tpcens[1]
      slhfcensmean = slhfcens[0]
      slhfcensvari = slhfcens[1]
      sshfcensmean = sshfcens[0]
      sshfcensvari = sshfcens[1]
      sstcensmean  = sstcens[0]
      sstcensvari  = sstcens[1]

      copy_VarMeta(ecsmean,ecensmean)
      copy_VarMeta(tpcsmean,tpcensmean)
      copy_VarMeta(slhfcsmean,slhfcensmean)
      copy_VarMeta(sshfcsmean,sshfcensmean)
      copy_VarMeta(sstcsmean,sstcensmean)
      printVarSummary(ecensmean)
      printVarSummary(tpcensmean)
      printVarSummary(slhfcensmean)
      printVarSummary(sshfcensmean)
      printVarSummary(sstcensmean)

      copy_VarMeta(ecsvari,ecensvari)
      copy_VarMeta(tpcsvari,tpcensvari)
      copy_VarMeta(slhfcsvari,slhfcensvari)
      copy_VarMeta(sshfcsvari,sshfcensvari)
      copy_VarMeta(sstcsvari,sstcensvari)
      printVarSummary(ecensvari)
      printVarSummary(tpcensvari)
      printVarSummary(slhfcensvari)
      printVarSummary(sshfcensvari)
      printVarSummary(sstcensvari)  

    end if    

  ;;------------------------------------------------------------------------------------------;  
    
    end_read_time = get_cpu_time()
    
  ;;------------------------------------------------------------------------------------------;
  ;                                      WRITE DATA TO NETCDF                                 ;
  ;;------------------------------------------------------------------------------------------;

  start_write_time = get_cpu_time()

  netCDF        = True                                       ; Write netCDF 

  ;---Pressure level
   
    if (netCDF) .and. (pressurelevel)
        diro    = "./"
        filo    = "varsel_pressurelevel.nc"
        ptho    = diro+filo
        system("/bin/rm -f "+ptho)  ;-> delete the existing file
        ncdf    = addfile(ptho,"c")
      
        fAtt                = True
        fAtt@title          = "Pressure Level - Variable selection, ready for compute the main process"
        fAtt@source_name    = "ECMWF Reanalysis v5 (ERA5)"
        fAtt@source_URL     = "https://climate.copernicus.eu/climate-reanalysis"
        fAtt@source         = "ECMWF"
        fAtt@Conventions    = "None"
        fAtt@creation_date = systemfunc("date")
        fileattdef(ncdf,fAtt)            ; copy file attributes
       
        filedimdef(ncdf,"time",-1,True) ; make time an UNLIMITED dimension
        ;ncdf->time = timelag
        ;ncdf->level  = level
        ;ncdf->lat  = lat
        ;ncdf->lon  = lon
        ncdf->ucsmean   = ucsmean    ;-> cs stands for cold surge
        ncdf->vcsmean   = vcsmean
        ncdf->tcsmean   = tcsmean
        ncdf->qcsmean   = qcsmean
        ncdf->wcsmean   = wcsmean
        ncdf->ucensmean = ucensmean ;-> cens stands for cross equatorial northerly surge
        ncdf->vcensmean = vcensmean
        ncdf->tcensmean = tcensmean
        ncdf->qcensmean = qcensmean
        ncdf->wcensmean = wcensmean

        ncdf->ucsvari   = ucsvari    ;-> cs stands for cold surge
        ncdf->vcsvari   = vcsvari
        ncdf->tcsvari   = tcsvari
        ncdf->qcsvari   = qcsvari
        ncdf->wcsvari   = wcsvari
        ncdf->ucensvari = ucensvari ;-> cens stands for cross equatorial northerly surge
        ncdf->vcensvari = vcensvari
        ncdf->tcensvari = tcensvari
        ncdf->qcensvari = qcensvari
        ncdf->wcensvari = wcensvari
    end if  

  ;---Single level

    if (netCDF) .and. (singlelevel)
        diro    = "./"
        filo    = "varsel_singlelevel.nc"
        ptho    = diro+filo
        system("/bin/rm -f "+ptho)  ;-> delete the existing file
        ncdf    = addfile(ptho,"c")
      
        fAtt                = True
        fAtt@title          = "Single Pressure - Variable selection, ready for compute the main process"
        fAtt@source_name    = "ECMWF Reanalysis v5 (ERA5)"
        fAtt@source_URL     = "https://climate.copernicus.eu/climate-reanalysis"
        fAtt@source         = "ECMWF"
        fAtt@Conventions    = "None"
        fAtt@creation_date = systemfunc("date")
        fileattdef(ncdf,fAtt)            ; copy file attributes
       
        filedimdef(ncdf,"time",-1,True) ; make time an UNLIMITED dimension
        ;ncdf->time = timelag
        ;ncdf->level  = level
        ;ncdf->lat  = lat
        ;ncdf->lon  = lon
        ncdf->ecsmean     = ecsmean    ;-> cs stands for cold surge
        ncdf->tpcsmean    = tpcsmean
        ncdf->slhfcsmean   = slhfcsmean
        ncdf->sshfcsmean   = sshfcsmean
        ncdf->ecensmean    = ecensmean ;-> cens stands for cross equatorial northerly surge
        ncdf->tpcensmean   = tpcensmean
        ncdf->slhfcensmean = slhfcensmean
        ncdf->sshfcensmean = sshfcensmean

        ncdf->ecsvari     = ecsvari    ;-> cs stands for cold surge
        ncdf->tpcsvari    = tpcsvari
        ncdf->slhfcsvari   = slhfcsvari
        ncdf->sshfcsvari   = sshfcsvari
        ncdf->ecensvari    = ecensvari ;-> cens stands for cross equatorial northerly surge
        ncdf->tpcensvari   = tpcensvari
        ncdf->slhfcensvari = slhfcensvari
        ncdf->sshfcensvari = sshfcensvari
    end if  

  ;---Single level : SST

    if (netCDF) .and. (singlelevel)
        diro    = "./"
        filo    = "varsel_singlelevel_sst.nc"
        ptho    = diro+filo
        system("/bin/rm -f "+ptho)  ;-> delete the existing file
        ncdf    = addfile(ptho,"c")
      
        fAtt                = True
        fAtt@title          = "Sea Surface Temperature - Variable selection, ready for compute the main process"
        fAtt@source_name    = "Sea surface temperature daily data from 1981 to present derived from satellite observations"
        fAtt@source_URL     = "https://cds.climate.copernicus.eu/cdsapp#!/dataset/satellite-sea-surface-temperature"
        fAtt@source         = "ATSR<1,2>-ESACCI-L3U-v2.0, AATSR-ESACCI-L3U-v2.0, AVHRR<07,09,11,12,14,15,16,17,18,19>_G-ESACCI-L3U-v2.0, AVHRRMTA_G-ESACCI-L3U-v2.0"
        fAtt@Conventions    = "None"
        fAtt@creation_date = systemfunc("date")
        fileattdef(ncdf,fAtt)            ; copy file attributes
       
        filedimdef(ncdf,"time",-1,True) ; make time an UNLIMITED dimension
        ncdf->sstcsmean    = sstcsmean
        ncdf->sstcensmean  = sstcensmean
        ncdf->sstcsvari    = sstcsvari
        ncdf->sstcensvari  = sstcensvari
    end if  

    end_write_time = get_cpu_time()


  ;;------------------------------------------------------------------------------------------;
  ;                                  Print the timing results                                 ;
  ;;------------------------------------------------------------------------------------------;
    print("==================================================")
    print(get_script_prefix_name() + ".ncl timings")
    print("   Writing file: " + (end_write_time-start_write_time))
    print("   Reading file: " + (end_read_time-start_read_time))
    print("==================================================")

  ;;------------------------------------------------------------------------------------------;
  ;;------------------------------------------------------------------------------------------;
  
  finish = systemfunc("date")
  
  print("Program start : "+ start +" ")
  print("Program end   : "+ finish +" ")

end