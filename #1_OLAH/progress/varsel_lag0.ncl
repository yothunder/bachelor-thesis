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
                                                                                            ;
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
      units0   = "seconds since 1981-01-01 00:00:00.0"
    else
      units0   = "hours since 1899-12-31 15:00:00.0"
    end if

    undef ("datesel")
    function datesel(date, yyyy, mm, dd, hh, sc, units, opt)
    begin 
    
    datelag = cd_inv_calendar(yyyy,mm,dd,hh,mn,sc,units, opt)
    
    return (datelag)
    end
    
    print("Starting nested-function timesel-datesel")
    lag0    = datesel(date, yyyy, mm, dd, hh, sc, units0, optdate)
    print("Nested-function timesel-datesel is done")  
    

    print("")
    print("Function timesel is done")
    print("========================")

    return lag0
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
    
    if var .eq. "u" then
      variabel                        = f->v({lag},:,:,:)              ;-> dimsizesnya 32 x 27 x 141 x 121

    else if var .eq. "v" then
      variabel                        = f->v({lag},:,:,:)

    else if var .eq. "t" then
      variabel                        = f->t({lag},:,:,:)            ;-> dimsizesnya 32 x 27 x 141 x 121

    else if var .eq. "q" then
      variabel                        = f->q({lag},:,:,:)
      
    else if var .eq. "w" then
      variabel                        = f->w({lag},:,:,:)

    else if var .eq. "e" then
      variabel                        = f->e({lag},:,:)

    else if var .eq. "tp" then
      variabel                        = f->tp({lag},:,:)       ;-> dimsizesnya 32 x 141 x 121

    else if var .eq. "slhf" then
      variabel                        = f->slhf({lag},:,:)

    else if var .eq. "sshf" then
      variabel                        = f->sshf({lag},:,:)

    else if var .eq. "sst" then
      variabel                        = short2flt(f->analysed_sst({lag},:,:))

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

    return variabel
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
    ncs           = dimsizes(datecs)
    ncens         = dimsizes(datecens)
    timecs        = ispan(0,ncs-1,1)
    timecens      = ispan(0,ncens-1,1)
    timecs@units   = "hours since 1900-01-01 00:00:00.0"
    timecens@units = "hours since 1900-01-01 00:00:00.0"

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
  singlelevel   = True

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
    
      ucs     = varsel(fpressurelevel, "u", usample, datecs, lagcs, nlag, nlev, nlat, nlon)
      vcs     = varsel(fpressurelevel, "v", vsample, datecs, lagcs, nlag, nlev, nlat, nlon)
      tcs     = varsel(fpressurelevel, "t", tsample, datecs, lagcs, nlag, nlev, nlat, nlon)
      qcs     = varsel(fpressurelevel, "q", qsample, datecs, lagcs, nlag, nlev, nlat, nlon)
      wcs     = varsel(fpressurelevel, "w", wsample, datecs, lagcs, nlag, nlev, nlat, nlon)

      ucs!0       = "timecs"
      ucs!1       = "lev"
      ucs!2       = "lat"
      ucs!3       = "lon"
      ucs&timecs  = timecs
      ucs&lev     = level
      ucs&lat     = lat
      ucs&lon     = lon
     
      copy_VarAtts(usample,ucs)
      copy_VarAtts(vsample,vcs)
      copy_VarAtts(tsample,tcs)
      copy_VarAtts(qsample,qcs)
      copy_VarAtts(wsample,wcs)
      copy_VarCoords(ucs, vcs)
      copy_VarCoords(ucs, tcs)
      copy_VarCoords(ucs, qcs)
      copy_VarCoords(ucs, wcs)
      printVarSummary(ucs)
      printVarSummary(vcs)
      printVarSummary(tcs)
      printVarSummary(qcs)
      printVarSummary(wcs)

      ;===

      ucens   = varsel(fpressurelevel, "u", usample, datecens, lagcens, nlag, nlev, nlat, nlon)
      vcens   = varsel(fpressurelevel, "v", vsample, datecens, lagcens, nlag, nlev, nlat, nlon)
      tcens   = varsel(fpressurelevel, "t", tsample, datecens, lagcens, nlag, nlev, nlat, nlon)
      qcens   = varsel(fpressurelevel, "q", qsample, datecens, lagcens, nlag, nlev, nlat, nlon)
      wcens   = varsel(fpressurelevel, "w", wsample, datecens, lagcens, nlag, nlev, nlat, nlon)

      ucens!0        = "timecens"
      ucens!1        = "lev"
      ucens!2        = "lat"
      ucens!3        = "lon"
      ucens&timecens = timecens
      ucens&lev      = level
      ucens&lat      = lat
      ucens&lon      = lon

      copy_VarAtts(usample,ucens)
      copy_VarAtts(vsample,vcens)
      copy_VarAtts(tsample,tcens)
      copy_VarAtts(qsample,qcens)
      copy_VarAtts(wsample,wcs)
      copy_VarCoords(ucens,vcens)
      copy_VarCoords(ucens,tcens)
      copy_VarCoords(ucens,qcens)
      copy_VarCoords(ucens,wcens)
      printVarSummary(ucens)
      printVarSummary(vcens)
      printVarSummary(tcens)
      printVarSummary(qcens)
      printVarSummary(wcens)
    
    end if


  ;---Single level

    if (singlelevel)

      fsinglelevel   = addfile("../data/daymean_singlelevel.nc","r" )
      fsst           = addfile("../data/daymean_sst.nc","r")
      esample     = fsinglelevel->e(1:2,:,:)
      tpsample    = fsinglelevel->tp(1:2,:,:)
      slhfsample  = fsinglelevel->slhf(1:2,:,:)
      sshfsample  = fsinglelevel->sshf(1:2,:,:)
      sstsample   = fsst->analysed_sst(1:2,:,:)
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
      ;print(nlatsst)
      ;print(nlonsst)
      ;printMinMax(sstsample,0)

      ecs       = varsel(fsinglelevel, "e", esample, datecs, lagcs, nlag, nlev, nlat, nlon)
      tpcs      = varsel(fsinglelevel, "tp", tpsample, datecs, lagcs, nlag, nlev, nlat, nlon)
      slhfcs    = varsel(fsinglelevel, "slhf", slhfsample, datecs, lagcs, nlag, nlev, nlat, nlon)
      sshfcs    = varsel(fsinglelevel, "sshf", sshfsample, datecs, lagcs, nlag, nlev, nlat, nlon)
      sstcs     = varsel(fsst, "sst", sstsample, datecs, lagcssst, nlag, nlev, nlatsst, nlonsst)

      ecs!0       = "timecs"
      ecs!1       = "lat"
      ecs!2       = "lon"
      ecs&timecs  = timecs
      ecs&lat     = lat
      ecs&lon     = lon

      sstcs!0       = "timecs"
      sstcs!1       = "lat"
      sstcs!2       = "lon"
      sstcs&timecs  = timecs
      sstcs&lat     = latsst
      sstcs&lon     = lonsst

      copy_VarAtts(esample,ecs)
      copy_VarAtts(tpsample,tpcs)
      copy_VarAtts(slhfsample,slhfcs)
      copy_VarAtts(sshfsample,sshfcs)
      copy_VarAtts(sstsample,sstcs)
      copy_VarCoords(ecs, tpcs)
      copy_VarCoords(ecs, slhfcs)
      copy_VarCoords(ecs, sshfcs)
      printVarSummary(ecs)
      printVarSummary(tpcs)
      printVarSummary(slhfcs)
      printVarSummary(sshfcs)
      printVarSummary(sstcs)

      ;=======

      ecens     = varsel(fsinglelevel, "e", esample, datecens, lagcens, nlag, nlev, nlat, nlon)
      tpcens    = varsel(fsinglelevel, "tp", tpsample, datecens, lagcens, nlag, nlev, nlat, nlon)
      slhfcens  = varsel(fsinglelevel, "slhf", slhfsample, datecens, lagcens, nlag, nlev, nlat, nlon)
      sshfcens  = varsel(fsinglelevel, "sshf", sshfsample, datecens, lagcens, nlag, nlev, nlat, nlon)
      sstcens   = varsel(fsst, "sst", sstsample, datecens, lagcenssst, nlag, nlev, nlatsst, nlonsst)

      ecens!0         = "timecens"
      ecens!1         = "lat"
      ecens!2         = "lon"
      ecens&timecens  = timecens
      ecens&lat       = lat
      ecens&lon       = lon

      sstcens!0        = "timecens"
      sstcens!1        = "lat"
      sstcens!2        = "lon"
      sstcens&timecens = timecens
      sstcens&lat      = latsst
      sstcens&lon      = lonsst

      copy_VarAtts(esample,ecens)
      copy_VarAtts(tpsample,tpcens)
      copy_VarAtts(slhfsample,slhfcens)
      copy_VarAtts(sshfsample,sshfcens)
      copy_VarAtts(sstsample,sstcens)
      copy_VarCoords(ecens,tpcens)
      copy_VarCoords(ecens,slhfcens)
      copy_VarCoords(ecens,sshfcens)
      printVarSummary(ecens)
      printVarSummary(tpcens)
      printVarSummary(slhfcens)
      printVarSummary(sshfcens)
      printVarSummary(sstcens)

    end if    

  ;;------------------------------------------------------------------------------------------;  
    
    end_read_time = get_cpu_time()
    
  ;;------------------------------------------------------------------------------------------;
  ;                                      WRITE DATA TO NETCDF                                 ;
  ;;------------------------------------------------------------------------------------------;

  start_write_time = get_cpu_time()
  CS            = True
  CENS          = True
  netCDF        = True                                       ; Write netCDF 

  ;---CS pressurelevel
   
    if (netCDF) .and. (CS) .and. (pressurelevel)
        diro    = "./"
        filo    = "varsel_cs_pressurelevel.nc"
        ptho    = diro+filo
        system("/bin/rm -f "+ptho)  ;-> delete the existing file
        ncdf    = addfile(ptho,"c")
      
        fAtt                = True
        fAtt@title          = "Pressure Level - Variable selection CS"
        fAtt@source_name    = "ECMWF Reanalysis v5 (ERA5)"
        fAtt@source_URL     = "https://climate.copernicus.eu/climate-reanalysis"
        fAtt@source         = "ECMWF"
        fAtt@Conventions    = "None"
        fAtt@creation_date = systemfunc("date")
        fileattdef(ncdf,fAtt)            ; copy file attributes
       
        filedimdef(ncdf,"time",-1,True) ; make time an UNLIMITED dimension
        ncdf->ucs   = ucs
        ncdf->vcs   = vcs
        ncdf->tcs   = tcs
        ncdf->qcs   = qcs
        ncdf->wcs   = wcs
    end if

  ;---CENS pressurelevel
   
    if (netCDF) .and. (CENS) .and. (pressurelevel)
        diro    = "./"
        filo    = "varsel_cens_pressurelevel.nc"
        ptho    = diro+filo
        system("/bin/rm -f "+ptho)  ;-> delete the existing file
        ncdf    = addfile(ptho,"c")
      
        fAtt                = True
        fAtt@title          = "Pressure Level - Variable selection CS"
        fAtt@source_name    = "ECMWF Reanalysis v5 (ERA5)"
        fAtt@source_URL     = "https://climate.copernicus.eu/climate-reanalysis"
        fAtt@source         = "ECMWF"
        fAtt@Conventions    = "None"
        fAtt@creation_date = systemfunc("date")
        fileattdef(ncdf,fAtt)            ; copy file attributes
       
        filedimdef(ncdf,"time",-1,True) ; make time an UNLIMITED dimension
        ncdf->ucens   = ucens
        ncdf->vcens   = vcens
        ncdf->tcens   = tcens
        ncdf->qcens   = qcens
        ncdf->wcens   = wcens
    end if  

    if (netCDF) .and. (CS) .and. (singlelevel)
        diro    = "./"
        filo    = "varsel_cs_singlelevel.nc"
        ptho    = diro+filo
        system("/bin/rm -f "+ptho)  ;-> delete the existing file
        ncdf    = addfile(ptho,"c")
      
        fAtt                = True
        fAtt@title          = "Single Pressure - Variable selection CS"
        fAtt@source_name    = "ECMWF Reanalysis v5 (ERA5)"
        fAtt@source_URL     = "https://climate.copernicus.eu/climate-reanalysis"
        fAtt@source         = "ECMWF"
        fAtt@Conventions    = "None"
        fAtt@creation_date = systemfunc("date")
        fileattdef(ncdf,fAtt)            ; copy file attributes
       
        filedimdef(ncdf,"time",-1,True) ; make time an UNLIMITED dimension
        ncdf->ecs     = ecs    ;-> cs stands for cold surge
        ncdf->tpcs    = tpcs
        ncdf->slhfcs  = slhfcs
        ncdf->sshfcs  = sshfcs
    end if  

  ;---CENS singlelevel

    if (netCDF) .and. (CENS) .and. (singlelevel)
        diro    = "./"
        filo    = "varsel_cens_singlelevel.nc"
        ptho    = diro+filo
        system("/bin/rm -f "+ptho)  ;-> delete the existing file
        ncdf    = addfile(ptho,"c")
      
        fAtt                = True
        fAtt@title          = "Single Pressure - Variable selection CENS"
        fAtt@source_name    = "ECMWF Reanalysis v5 (ERA5)"
        fAtt@source_URL     = "https://climate.copernicus.eu/climate-reanalysis"
        fAtt@source         = "ECMWF"
        fAtt@Conventions    = "None"
        fAtt@creation_date = systemfunc("date")
        fileattdef(ncdf,fAtt)            ; copy file attributes
       
        filedimdef(ncdf,"time",-1,True) ; make time an UNLIMITED dimension
        ncdf->ecens      = ecens    ;-> cs stands for cold surge
        ncdf->tpcens     = tpcens
        ncdf->slhfcens   = slhfcens
        ncdf->sshfcens   = sshfcens
    end if

  ;---CS SST

    if (netCDF) .and. (singlelevel) .and. (CS)
        diro    = "./"
        filo    = "varsel_cs_sst.nc"
        ptho    = diro+filo
        system("/bin/rm -f "+ptho)  ;-> delete the existing file
        ncdf    = addfile(ptho,"c")
      
        fAtt                = True
        fAtt@title          = "Sea Surface Temperature - Variable selection CS"
        fAtt@source_name    = "Sea surface temperature daily data from 1981 to present derived from satellite observations"
        fAtt@source_URL     = "https://cds.climate.copernicus.eu/cdsapp#!/dataset/satellite-sea-surface-temperature"
        fAtt@source         = "ATSR<1,2>-ESACCI-L3U-v2.0, AATSR-ESACCI-L3U-v2.0, AVHRR<07,09,11,12,14,15,16,17,18,19>_G-ESACCI-L3U-v2.0, AVHRRMTA_G-ESACCI-L3U-v2.0"
        fAtt@Conventions    = "None"
        fAtt@creation_date = systemfunc("date")
        fileattdef(ncdf,fAtt)            ; copy file attributes
       
        filedimdef(ncdf,"time",-1,True) ; make time an UNLIMITED dimension
        ncdf->sstcs    = sstcs
    end if  

  ;---CENS SST

    if (netCDF) .and. (singlelevel) .and. (CENS)
        diro    = "./"
        filo    = "varsel_cens_sst.nc"
        ptho    = diro+filo
        system("/bin/rm -f "+ptho)  ;-> delete the existing file
        ncdf    = addfile(ptho,"c")
      
        fAtt                = True
        fAtt@title          = "Sea Surface Temperature - Variable selection CENS"
        fAtt@source_name    = "Sea surface temperature daily data from 1981 to present derived from satellite observations"
        fAtt@source_URL     = "https://cds.climate.copernicus.eu/cdsapp#!/dataset/satellite-sea-surface-temperature"
        fAtt@source         = "ATSR<1,2>-ESACCI-L3U-v2.0, AATSR-ESACCI-L3U-v2.0, AVHRR<07,09,11,12,14,15,16,17,18,19>_G-ESACCI-L3U-v2.0, AVHRRMTA_G-ESACCI-L3U-v2.0"
        fAtt@Conventions    = "None"
        fAtt@creation_date = systemfunc("date")
        fileattdef(ncdf,fAtt)            ; copy file attributes
       
        filedimdef(ncdf,"time",-1,True) ; make time an UNLIMITED dimension
        ncdf->sstcens    = sstcens
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

end