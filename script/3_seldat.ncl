;===========================================================================================;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;                                                                                           ;
; Start code => Friday, 13 May 2022 - 06.50 WIB
; Last time saved => Sunday, 14 May 2022 - 08.26 WIB
;                                                                                           ;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;===========================================================================================;

begin

  start = systemfunc("date")
  print(start)

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
  function varsel(f, var:string, varsample, date, lag, nlag, nlev, nlat, nlon, labcscens:string, timelag, timecscens, level, lat, lon)
  begin                                                                                       ;
    print("========================")
    print("Starting function varsel for variable  "+ var)
    print("")
    
    ntime    = dimsizes(date)
    
    if labcscens .eq. "cs"

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
        mergebeforeavg!0   = "timelag"
        mergebeforeavg!1   = "time"
        mergebeforeavg!2   = "lev"
        mergebeforeavg!3   = "lat"
        mergebeforeavg!4   = "lon"
        mergebeforeavg&timelag = timelag
        mergebeforeavg&time  = timecscens
        mergebeforeavg&lev   = level
        mergebeforeavg&lat   = lat
        mergebeforeavg&lon   = lon

      else if var .eq. "v" then  ;--------------------------------------------------------------
        ;--> Merge all lead-lag time
        mergebeforeavg                    = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)
        mergebeforeavgcp                  = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)  ;--> cp = copy
        do i = 0, nlag-1
          variabel                        = f->v({lag[i]},:,:,:)              ;-> dimsizesnya 32 x 27 x 141 x 121
          mergebeforeavgcp(0:0,:,:,:,:)   = (/ variabel /)                    ;-> dimsizesnya 32 x 27 x 141 x 121
          variabel                       := mergebeforeavgcp(0:0,:,:,:,:)     ;-> dimsizesnya 1 x 32 x 27 x 141 x 121
          mergebeforeavg(i,:,:,:,:)       = variabel
        end do
        mergebeforeavg!0   = "timelag"
        mergebeforeavg!1   = "time"
        mergebeforeavg!2   = "lev"
        mergebeforeavg!3   = "lat"
        mergebeforeavg!4   = "lon"
        mergebeforeavg&timelag = timelag
        mergebeforeavg&time  = timecscens
        mergebeforeavg&lev   = level
        mergebeforeavg&lat   = lat
        mergebeforeavg&lon   = lon

      else if var .eq. "t" then  ;--------------------------------------------------------------
        ;--> Merge all lead-lag time
        mergebeforeavg                    = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)
        mergebeforeavgcp                  = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)  ;--> cp = copy
        do i = 0, nlag-1
          variabel                        = f->t({lag[i]},:,:,:)              ;-> dimsizesnya 32 x 27 x 141 x 121
          mergebeforeavgcp(0:0,:,:,:,:)   = (/ variabel /)                    ;-> dimsizesnya 32 x 27 x 141 x 121
          variabel                       := mergebeforeavgcp(0:0,:,:,:,:)     ;-> dimsizesnya 1 x 32 x 27 x 141 x 121
          mergebeforeavg(i,:,:,:,:)       = variabel
        end do
        mergebeforeavg!0   = "timelag"
        mergebeforeavg!1   = "time"
        mergebeforeavg!2   = "lev"
        mergebeforeavg!3   = "lat"
        mergebeforeavg!4   = "lon"
        mergebeforeavg&timelag = timelag
        mergebeforeavg&time  = timecscens
        mergebeforeavg&lev   = level
        mergebeforeavg&lat   = lat
        mergebeforeavg&lon   = lon

      else if var .eq. "q" then  ;--------------------------------------------------------------
        ;--> Merge all lead-lag time
        mergebeforeavg                    = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)
        mergebeforeavgcp                  = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)  ;--> cp = copy
        do i = 0, nlag-1
          variabel                        = f->q({lag[i]},:,:,:)              ;-> dimsizesnya 32 x 27 x 141 x 121
          mergebeforeavgcp(0:0,:,:,:,:)   = (/ variabel /)                    ;-> dimsizesnya 32 x 27 x 141 x 121
          variabel                       := mergebeforeavgcp(0:0,:,:,:,:)     ;-> dimsizesnya 1 x 32 x 27 x 141 x 121
          mergebeforeavg(i,:,:,:,:)       = variabel
        end do
        mergebeforeavg!0   = "timelag"
        mergebeforeavg!1   = "time"
        mergebeforeavg!2   = "lev"
        mergebeforeavg!3   = "lat"
        mergebeforeavg!4   = "lon"
        mergebeforeavg&timelag = timelag
        mergebeforeavg&time  = timecscens
        mergebeforeavg&lev   = level
        mergebeforeavg&lat   = lat
        mergebeforeavg&lon   = lon

      else if var .eq. "w" then  ;--------------------------------------------------------------
        ;--> Merge all lead-lag time
        mergebeforeavg                    = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)
        mergebeforeavgcp                  = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)  ;--> cp = copy
        do i = 0, nlag-1
          variabel                        = f->w({lag[i]},:,:,:)              ;-> dimsizesnya 32 x 27 x 141 x 121
          mergebeforeavgcp(0:0,:,:,:,:)   = (/ variabel /)                    ;-> dimsizesnya 32 x 27 x 141 x 121
          variabel                       := mergebeforeavgcp(0:0,:,:,:,:)     ;-> dimsizesnya 1 x 32 x 27 x 141 x 121
          mergebeforeavg(i,:,:,:,:)       = variabel
        end do
        mergebeforeavg!0   = "timelag"
        mergebeforeavg!1   = "time"
        mergebeforeavg!2   = "lev"
        mergebeforeavg!3   = "lat"
        mergebeforeavg!4   = "lon"
        mergebeforeavg&timelag = timelag
        mergebeforeavg&time  = timecscens
        mergebeforeavg&lev   = level
        mergebeforeavg&lat   = lat
        mergebeforeavg&lon   = lon

      end if
      end if
      end if
      end if
      end if

    else if labcscens .eq. "cens"

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
        mergebeforeavg!0   = "timelag"
        mergebeforeavg!1   = "time"
        mergebeforeavg!2   = "lev"
        mergebeforeavg!3   = "lat"
        mergebeforeavg!4   = "lon"
        mergebeforeavg&timelag = timelag
        mergebeforeavg&time  = timecscens
        mergebeforeavg&lev   = level
        mergebeforeavg&lat   = lat
        mergebeforeavg&lon   = lon

      else if var .eq. "v" then  ;--------------------------------------------------------------
        ;--> Merge all lead-lag time
        mergebeforeavg                    = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)
        mergebeforeavgcp                  = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)  ;--> cp = copy
        do i = 0, nlag-1
          variabel                        = f->v({lag[i]},:,:,:)              ;-> dimsizesnya 32 x 27 x 141 x 121
          mergebeforeavgcp(0:0,:,:,:,:)   = (/ variabel /)                    ;-> dimsizesnya 32 x 27 x 141 x 121
          variabel                       := mergebeforeavgcp(0:0,:,:,:,:)     ;-> dimsizesnya 1 x 32 x 27 x 141 x 121
          mergebeforeavg(i,:,:,:,:)       = variabel
        end do
        mergebeforeavg!0   = "timelag"
        mergebeforeavg!1   = "time"
        mergebeforeavg!2   = "lev"
        mergebeforeavg!3   = "lat"
        mergebeforeavg!4   = "lon"
        mergebeforeavg&timelag = timelag
        mergebeforeavg&time  = timecscens
        mergebeforeavg&lev   = level
        mergebeforeavg&lat   = lat
        mergebeforeavg&lon   = lon

      else if var .eq. "t" then  ;--------------------------------------------------------------
        ;--> Merge all lead-lag time
        mergebeforeavg                    = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)
        mergebeforeavgcp                  = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)  ;--> cp = copy
        do i = 0, nlag-1
          variabel                        = f->t({lag[i]},:,:,:)              ;-> dimsizesnya 32 x 27 x 141 x 121
          mergebeforeavgcp(0:0,:,:,:,:)   = (/ variabel /)                    ;-> dimsizesnya 32 x 27 x 141 x 121
          variabel                       := mergebeforeavgcp(0:0,:,:,:,:)     ;-> dimsizesnya 1 x 32 x 27 x 141 x 121
          mergebeforeavg(i,:,:,:,:)       = variabel
        end do
        mergebeforeavg!0   = "timelag"
        mergebeforeavg!1   = "time"
        mergebeforeavg!2   = "lev"
        mergebeforeavg!3   = "lat"
        mergebeforeavg!4   = "lon"
        mergebeforeavg&timelag = timelag
        mergebeforeavg&time  = timecscens
        mergebeforeavg&lev   = level
        mergebeforeavg&lat   = lat
        mergebeforeavg&lon   = lon
        
      else if var .eq. "q" then  ;--------------------------------------------------------------
        ;--> Merge all lead-lag time
        mergebeforeavg                    = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)
        mergebeforeavgcp                  = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)  ;--> cp = copy
        do i = 0, nlag-1
          variabel                        = f->q({lag[i]},:,:,:)              ;-> dimsizesnya 32 x 27 x 141 x 121
          mergebeforeavgcp(0:0,:,:,:,:)   = (/ variabel /)                    ;-> dimsizesnya 32 x 27 x 141 x 121
          variabel                       := mergebeforeavgcp(0:0,:,:,:,:)     ;-> dimsizesnya 1 x 32 x 27 x 141 x 121
          mergebeforeavg(i,:,:,:,:)       = variabel
        end do
        mergebeforeavg!0   = "timelag"
        mergebeforeavg!1   = "time"
        mergebeforeavg!2   = "lev"
        mergebeforeavg!3   = "lat"
        mergebeforeavg!4   = "lon"
        mergebeforeavg&timelag = timelag
        mergebeforeavg&time  = timecscens
        mergebeforeavg&lev   = level
        mergebeforeavg&lat   = lat
        mergebeforeavg&lon   = lon
        
      else if var .eq. "w" then  ;--------------------------------------------------------------
        ;--> Merge all lead-lag time
        mergebeforeavg                    = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)
        mergebeforeavgcp                  = new((/nlag, ntime, nlev, nlat, nlon/), typeof(varsample), varsample@_FillValue)  ;--> cp = copy
        do i = 0, nlag-1
          variabel                        = f->w({lag[i]},:,:,:)              ;-> dimsizesnya 32 x 27 x 141 x 121
          mergebeforeavgcp(0:0,:,:,:,:)   = (/ variabel /)                    ;-> dimsizesnya 32 x 27 x 141 x 121
          variabel                       := mergebeforeavgcp(0:0,:,:,:,:)     ;-> dimsizesnya 1 x 32 x 27 x 141 x 121
          mergebeforeavg(i,:,:,:,:)       = variabel
        end do
        mergebeforeavg!0   = "timelag"
        mergebeforeavg!1   = "time"
        mergebeforeavg!2   = "lev"
        mergebeforeavg!3   = "lat"
        mergebeforeavg!4   = "lon"
        mergebeforeavg&timelag = timelag
        mergebeforeavg&time  = timecscens
        mergebeforeavg&lev   = level
        mergebeforeavg&lat   = lat
        mergebeforeavg&lon   = lon
        
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
    return mergebeforeavg                                                                     ;
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
    timecs        = ispan(0,dimsizes(datecs)-1,1)
    timecs@units  = "days since 2010-01-01 00:00:0.0"
    timecens        = ispan(0,dimsizes(datecens)-1,1)
    timecens@units  = "days since 2010-01-01 00:00:0.0"
    nlag          = dimsizes(timelag) 
    print(nlag)
    ;print(lagcs)
    ;print(lagcssst)

  ;;------------------------------------------------------------------------------------------;
  ;                                      READ DATA FROM FILE                                  ;
  ;;------------------------------------------------------------------------------------------;

  pressurelevel = True
  CS            = False
  CENS          = True
  u             = False
  v             = False
  t             = False
  q             = False
  w             = True


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

      if (CS)
        if (u)
          ucs     = varsel(fpressurelevel, "u", usample, datecs, lagcs, nlag, nlev, nlat, nlon, "cs", timelag, timecs, level, lat, lon)
          copy_VarAtts(usample,ucs)
          printVarSummary(ucs)
        end if
        if (v)
          vcs     = varsel(fpressurelevel, "v", vsample, datecs, lagcs, nlag, nlev, nlat, nlon, "cs", timelag, timecs, level, lat, lon)
          copy_VarAtts(vsample,vcs)
          printVarSummary(vcs)
        end if
        if (t)
          tcs     = varsel(fpressurelevel, "t", tsample, datecs, lagcs, nlag, nlev, nlat, nlon, "cs", timelag, timecs, level, lat, lon)
          copy_VarAtts(tsample,tcs)
          printVarSummary(tcs)
        end if
        if (q)
          qcs     = varsel(fpressurelevel, "q", qsample, datecs, lagcs, nlag, nlev, nlat, nlon, "cs", timelag, timecs, level, lat, lon)
          copy_VarAtts(qsample,qcs)
          printVarSummary(qcs)
        end if
        if (w)
          wcs     = varsel(fpressurelevel, "w", wsample, datecs, lagcs, nlag, nlev, nlat, nlon, "cs", timelag, timecs, level, lat, lon)
          copy_VarAtts(wsample,wcs)
          printVarSummary(wcs)
        end if
      end if

      ;===

      if (CENS)
        if (u)
          ucens     = varsel(fpressurelevel, "u", usample, datecens, lagcens, nlag, nlev, nlat, nlon, "cens", timelag, timecens, level, lat, lon)
          copy_VarAtts(usample,ucens)
          printVarSummary(ucens)
        end if
        if (v)
          vcens     = varsel(fpressurelevel, "v", vsample, datecens, lagcens, nlag, nlev, nlat, nlon, "cens", timelag, timecens, level, lat, lon)
          copy_VarAtts(vsample,vcens)
          printVarSummary(vcens)
        end if
        if (t)
          tcens     = varsel(fpressurelevel, "t", tsample, datecens, lagcens, nlag, nlev, nlat, nlon, "cens", timelag, timecens, level, lat, lon)
          copy_VarAtts(tsample,tcens)
          printVarSummary(tcens)
        end if
        if (q)
          qcens     = varsel(fpressurelevel, "q", qsample, datecens, lagcens, nlag, nlev, nlat, nlon, "cens", timelag, timecens, level, lat, lon)
          copy_VarAtts(qsample,qcens)
          printVarSummary(qcens)
        end if
        if (w)
          wcens     = varsel(fpressurelevel, "w", wsample, datecens, lagcens, nlag, nlev, nlat, nlon, "cens", timelag, timecens, level, lat, lon)
          copy_VarAtts(wsample,wcens)
          printVarSummary(wcens)
        end if
      end if
    end if

  ;;------------------------------------------------------------------------------------------;
  ;                                      WRITE DATA TO NETCDF                                 ;
  ;;------------------------------------------------------------------------------------------;


  netCDF        = True                                       ; Write netCDF 

  ;---Pressure level
    
    ;---CS

      if (netCDF) .and. (CS) .and. (u)
          diro    = "./"
          filo    = "varsel_pressurelevel_cs_u.nc"
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
          ;ucs = ([/ ucs1, ucs2, ucs3, ucs4, ucs5, ucs6, ucs7, ucs8, ucs9, ucs10, ucs11, ucs12, ucs13, ucs14, ucs15, ucs16, ucs17, ucs18, ucs19, ucs20, ucs21 /])
          ;do il = 0, nlag-1
          ;  ncdf->$ucs[il]$   := ucs(il,:,:,:,:)    ;-> cs stands for cold surge
          ;end do
          ncdf->ucs1 = ucs(0,:,:,:,:)
          ncdf->ucs2 = ucs(1,:,:,:,:)
          ncdf->ucs3 = ucs(2,:,:,:,:)
          ncdf->ucs4 = ucs(3,:,:,:,:)
          ncdf->ucs5 = ucs(4,:,:,:,:)
          ncdf->ucs6 = ucs(5,:,:,:,:)
          ncdf->ucs7 = ucs(6,:,:,:,:)
          ncdf->ucs8 = ucs(7,:,:,:,:)
          ncdf->ucs9 = ucs(8,:,:,:,:)
          ncdf->ucs10 = ucs(9,:,:,:,:)
          ncdf->ucs11 = ucs(10,:,:,:,:)
          ncdf->ucs12 = ucs(11,:,:,:,:)
          ncdf->ucs13 = ucs(12,:,:,:,:)
          ncdf->ucs14 = ucs(13,:,:,:,:)
          ncdf->ucs15 = ucs(14,:,:,:,:)
          ncdf->ucs16 = ucs(15,:,:,:,:)
          ncdf->ucs17 = ucs(16,:,:,:,:)
          ncdf->ucs18 = ucs(17,:,:,:,:)
          ncdf->ucs19 = ucs(18,:,:,:,:)
          ncdf->ucs20 = ucs(19,:,:,:,:)
          ncdf->ucs21 = ucs(20,:,:,:,:)
      end if

      if (netCDF) .and. (CS) .and. (v)
          diro    = "./"
          filo    = "varsel_pressurelevel_cs_v.nc"
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
          ncdf->vcs1 = vcs(0,:,:,:,:)
          ncdf->vcs2 = vcs(1,:,:,:,:)
          ncdf->vcs3 = vcs(2,:,:,:,:)
          ncdf->vcs4 = vcs(3,:,:,:,:)
          ncdf->vcs5 = vcs(4,:,:,:,:)
          ncdf->vcs6 = vcs(5,:,:,:,:)
          ncdf->vcs7 = vcs(6,:,:,:,:)
          ncdf->vcs8 = vcs(7,:,:,:,:)
          ncdf->vcs9 = vcs(8,:,:,:,:)
          ncdf->vcs10 = vcs(9,:,:,:,:)
          ncdf->vcs11 = vcs(10,:,:,:,:)
          ncdf->vcs12 = vcs(11,:,:,:,:)
          ncdf->vcs13 = vcs(12,:,:,:,:)
          ncdf->vcs14 = vcs(13,:,:,:,:)
          ncdf->vcs15 = vcs(14,:,:,:,:)
          ncdf->vcs16 = vcs(15,:,:,:,:)
          ncdf->vcs17 = vcs(16,:,:,:,:)
          ncdf->vcs18 = vcs(17,:,:,:,:)
          ncdf->vcs19 = vcs(18,:,:,:,:)
          ncdf->vcs20 = vcs(19,:,:,:,:)
          ncdf->vcs21 = vcs(20,:,:,:,:)
      end if

      if (netCDF) .and. (CS) .and. (t)
          diro    = "./"
          filo    = "varsel_pressurelevel_cs_t.nc"
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
          ncdf->tcs1 = tcs(0,:,:,:,:)
          ncdf->tcs2 = tcs(1,:,:,:,:)
          ncdf->tcs3 = tcs(2,:,:,:,:)
          ncdf->tcs4 = tcs(3,:,:,:,:)
          ncdf->tcs5 = tcs(4,:,:,:,:)
          ncdf->tcs6 = tcs(5,:,:,:,:)
          ncdf->tcs7 = tcs(6,:,:,:,:)
          ncdf->tcs8 = tcs(7,:,:,:,:)
          ncdf->tcs9 = tcs(8,:,:,:,:)
          ncdf->tcs10 = tcs(9,:,:,:,:)
          ncdf->tcs11 = tcs(10,:,:,:,:)
          ncdf->tcs12 = tcs(11,:,:,:,:)
          ncdf->tcs13 = tcs(12,:,:,:,:)
          ncdf->tcs14 = tcs(13,:,:,:,:)
          ncdf->tcs15 = tcs(14,:,:,:,:)
          ncdf->tcs16 = tcs(15,:,:,:,:)
          ncdf->tcs17 = tcs(16,:,:,:,:)
          ncdf->tcs18 = tcs(17,:,:,:,:)
          ncdf->tcs19 = tcs(18,:,:,:,:)
          ncdf->tcs20 = tcs(19,:,:,:,:)
          ncdf->tcs21 = tcs(20,:,:,:,:)
      end if

      if (netCDF) .and. (CS) .and. (q)
          diro    = "./"
          filo    = "varsel_pressurelevel_cs_q.nc"
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
          ncdf->qcs1 = qcs(0,:,:,:,:)
          ncdf->qcs2 = qcs(1,:,:,:,:)
          ncdf->qcs3 = qcs(2,:,:,:,:)
          ncdf->qcs4 = qcs(3,:,:,:,:)
          ncdf->qcs5 = qcs(4,:,:,:,:)
          ncdf->qcs6 = qcs(5,:,:,:,:)
          ncdf->qcs7 = qcs(6,:,:,:,:)
          ncdf->qcs8 = qcs(7,:,:,:,:)
          ncdf->qcs9 = qcs(8,:,:,:,:)
          ncdf->qcs10 = qcs(9,:,:,:,:)
          ncdf->qcs11 = qcs(10,:,:,:,:)
          ncdf->qcs12 = qcs(11,:,:,:,:)
          ncdf->qcs13 = qcs(12,:,:,:,:)
          ncdf->qcs14 = qcs(13,:,:,:,:)
          ncdf->qcs15 = qcs(14,:,:,:,:)
          ncdf->qcs16 = qcs(15,:,:,:,:)
          ncdf->qcs17 = qcs(16,:,:,:,:)
          ncdf->qcs18 = qcs(17,:,:,:,:)
          ncdf->qcs19 = qcs(18,:,:,:,:)
          ncdf->qcs20 = qcs(19,:,:,:,:)
          ncdf->qcs21 = qcs(20,:,:,:,:)
      end if

      if (netCDF) .and. (CS) .and. (w)
          diro    = "./"
          filo    = "varsel_pressurelevel_cs_w.nc"
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
          ncdf->wcs1 = wcs(0,:,:,:,:)
          ncdf->wcs2 = wcs(1,:,:,:,:)
          ncdf->wcs3 = wcs(2,:,:,:,:)
          ncdf->wcs4 = wcs(3,:,:,:,:)
          ncdf->wcs5 = wcs(4,:,:,:,:)
          ncdf->wcs6 = wcs(5,:,:,:,:)
          ncdf->wcs7 = wcs(6,:,:,:,:)
          ncdf->wcs8 = wcs(7,:,:,:,:)
          ncdf->wcs9 = wcs(8,:,:,:,:)
          ncdf->wcs10 = wcs(9,:,:,:,:)
          ncdf->wcs11 = wcs(10,:,:,:,:)
          ncdf->wcs12 = wcs(11,:,:,:,:)
          ncdf->wcs13 = wcs(12,:,:,:,:)
          ncdf->wcs14 = wcs(13,:,:,:,:)
          ncdf->wcs15 = wcs(14,:,:,:,:)
          ncdf->wcs16 = wcs(15,:,:,:,:)
          ncdf->wcs17 = wcs(16,:,:,:,:)
          ncdf->wcs18 = wcs(17,:,:,:,:)
          ncdf->wcs19 = wcs(18,:,:,:,:)
          ncdf->wcs20 = wcs(19,:,:,:,:)
          ncdf->wcs21 = wcs(20,:,:,:,:)
      end if
    
    ;---CENS

      if (netCDF) .and. (CENS) .and. (u)
          diro    = "./"
          filo    = "varsel_pressurelevel_cens_u.nc"
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
          ;ucens = ([/ ucens1, ucens2, ucens3, ucens4, ucens5, ucens6, ucens7, ucens8, ucens9, ucens10, ucens11, ucens12, ucens13, ucens14, ucens15, ucens16, ucens17, ucens18, ucens19, ucens20, ucens21 /])
          ;do il = 0, nlag-1
          ;  ncdf->$ucens[il]$   := ucens(il,:,:,:,:)    ;-> cens stands for cold surge
          ;end do
          ncdf->ucens1 = ucens(0,:,:,:,:)
          ncdf->ucens2 = ucens(1,:,:,:,:)
          ncdf->ucens3 = ucens(2,:,:,:,:)
          ncdf->ucens4 = ucens(3,:,:,:,:)
          ncdf->ucens5 = ucens(4,:,:,:,:)
          ncdf->ucens6 = ucens(5,:,:,:,:)
          ncdf->ucens7 = ucens(6,:,:,:,:)
          ncdf->ucens8 = ucens(7,:,:,:,:)
          ncdf->ucens9 = ucens(8,:,:,:,:)
          ncdf->ucens10 = ucens(9,:,:,:,:)
          ncdf->ucens11 = ucens(10,:,:,:,:)
          ncdf->ucens12 = ucens(11,:,:,:,:)
          ncdf->ucens13 = ucens(12,:,:,:,:)
          ncdf->ucens14 = ucens(13,:,:,:,:)
          ncdf->ucens15 = ucens(14,:,:,:,:)
          ncdf->ucens16 = ucens(15,:,:,:,:)
          ncdf->ucens17 = ucens(16,:,:,:,:)
          ncdf->ucens18 = ucens(17,:,:,:,:)
          ncdf->ucens19 = ucens(18,:,:,:,:)
          ncdf->ucens20 = ucens(19,:,:,:,:)
          ncdf->ucens21 = ucens(20,:,:,:,:)
      end if

      if (netCDF) .and. (CENS) .and. (v)
          diro    = "./"
          filo    = "varsel_pressurelevel_cens_v.nc"
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
          ncdf->vcens1 = vcens(0,:,:,:,:)
          ncdf->vcens2 = vcens(1,:,:,:,:)
          ncdf->vcens3 = vcens(2,:,:,:,:)
          ncdf->vcens4 = vcens(3,:,:,:,:)
          ncdf->vcens5 = vcens(4,:,:,:,:)
          ncdf->vcens6 = vcens(5,:,:,:,:)
          ncdf->vcens7 = vcens(6,:,:,:,:)
          ncdf->vcens8 = vcens(7,:,:,:,:)
          ncdf->vcens9 = vcens(8,:,:,:,:)
          ncdf->vcens10 = vcens(9,:,:,:,:)
          ncdf->vcens11 = vcens(10,:,:,:,:)
          ncdf->vcens12 = vcens(11,:,:,:,:)
          ncdf->vcens13 = vcens(12,:,:,:,:)
          ncdf->vcens14 = vcens(13,:,:,:,:)
          ncdf->vcens15 = vcens(14,:,:,:,:)
          ncdf->vcens16 = vcens(15,:,:,:,:)
          ncdf->vcens17 = vcens(16,:,:,:,:)
          ncdf->vcens18 = vcens(17,:,:,:,:)
          ncdf->vcens19 = vcens(18,:,:,:,:)
          ncdf->vcens20 = vcens(19,:,:,:,:)
          ncdf->vcens21 = vcens(20,:,:,:,:)
      end if

      if (netCDF) .and. (CENS) .and. (t)
          diro    = "./"
          filo    = "varsel_pressurelevel_cens_t.nc"
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
          ncdf->tcens1 = tcens(0,:,:,:,:)
          ncdf->tcens2 = tcens(1,:,:,:,:)
          ncdf->tcens3 = tcens(2,:,:,:,:)
          ncdf->tcens4 = tcens(3,:,:,:,:)
          ncdf->tcens5 = tcens(4,:,:,:,:)
          ncdf->tcens6 = tcens(5,:,:,:,:)
          ncdf->tcens7 = tcens(6,:,:,:,:)
          ncdf->tcens8 = tcens(7,:,:,:,:)
          ncdf->tcens9 = tcens(8,:,:,:,:)
          ncdf->tcens10 = tcens(9,:,:,:,:)
          ncdf->tcens11 = tcens(10,:,:,:,:)
          ncdf->tcens12 = tcens(11,:,:,:,:)
          ncdf->tcens13 = tcens(12,:,:,:,:)
          ncdf->tcens14 = tcens(13,:,:,:,:)
          ncdf->tcens15 = tcens(14,:,:,:,:)
          ncdf->tcens16 = tcens(15,:,:,:,:)
          ncdf->tcens17 = tcens(16,:,:,:,:)
          ncdf->tcens18 = tcens(17,:,:,:,:)
          ncdf->tcens19 = tcens(18,:,:,:,:)
          ncdf->tcens20 = tcens(19,:,:,:,:)
          ncdf->tcens21 = tcens(20,:,:,:,:)
      end if

      if (netCDF) .and. (CENS) .and. (q)
          diro    = "./"
          filo    = "varsel_pressurelevel_cens_q.nc"
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
          ncdf->qcens1 = qcens(0,:,:,:,:)
          ncdf->qcens2 = qcens(1,:,:,:,:)
          ncdf->qcens3 = qcens(2,:,:,:,:)
          ncdf->qcens4 = qcens(3,:,:,:,:)
          ncdf->qcens5 = qcens(4,:,:,:,:)
          ncdf->qcens6 = qcens(5,:,:,:,:)
          ncdf->qcens7 = qcens(6,:,:,:,:)
          ncdf->qcens8 = qcens(7,:,:,:,:)
          ncdf->qcens9 = qcens(8,:,:,:,:)
          ncdf->qcens10 = qcens(9,:,:,:,:)
          ncdf->qcens11 = qcens(10,:,:,:,:)
          ncdf->qcens12 = qcens(11,:,:,:,:)
          ncdf->qcens13 = qcens(12,:,:,:,:)
          ncdf->qcens14 = qcens(13,:,:,:,:)
          ncdf->qcens15 = qcens(14,:,:,:,:)
          ncdf->qcens16 = qcens(15,:,:,:,:)
          ncdf->qcens17 = qcens(16,:,:,:,:)
          ncdf->qcens18 = qcens(17,:,:,:,:)
          ncdf->qcens19 = qcens(18,:,:,:,:)
          ncdf->qcens20 = qcens(19,:,:,:,:)
          ncdf->qcens21 = qcens(20,:,:,:,:)
      end if

      if (netCDF) .and. (CENS) .and. (w)
          diro    = "./"
          filo    = "varsel_pressurelevel_cens_w.nc"
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
          ncdf->wcens1 = wcens(0,:,:,:,:)
          ncdf->wcens2 = wcens(1,:,:,:,:)
          ncdf->wcens3 = wcens(2,:,:,:,:)
          ncdf->wcens4 = wcens(3,:,:,:,:)
          ncdf->wcens5 = wcens(4,:,:,:,:)
          ncdf->wcens6 = wcens(5,:,:,:,:)
          ncdf->wcens7 = wcens(6,:,:,:,:)
          ncdf->wcens8 = wcens(7,:,:,:,:)
          ncdf->wcens9 = wcens(8,:,:,:,:)
          ncdf->wcens10 = wcens(9,:,:,:,:)
          ncdf->wcens11 = wcens(10,:,:,:,:)
          ncdf->wcens12 = wcens(11,:,:,:,:)
          ncdf->wcens13 = wcens(12,:,:,:,:)
          ncdf->wcens14 = wcens(13,:,:,:,:)
          ncdf->wcens15 = wcens(14,:,:,:,:)
          ncdf->wcens16 = wcens(15,:,:,:,:)
          ncdf->wcens17 = wcens(16,:,:,:,:)
          ncdf->wcens18 = wcens(17,:,:,:,:)
          ncdf->wcens19 = wcens(18,:,:,:,:)
          ncdf->wcens20 = wcens(19,:,:,:,:)
          ncdf->wcens21 = wcens(20,:,:,:,:)
      end if

  finish = systemfunc("date")
  
  print("Program start : "+ start +" ")
  print("Program end   : "+ finish +" ")
  
end