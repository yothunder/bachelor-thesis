;===========================================================================================;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;
;   Progres_v3 - first time writing code => Thursday, 03 Feb 2022 - 17.15 WIB (10.15 UTC)   ;
;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;===========================================================================================;

begin
  
  start = systemfunc("date")
  print(start)
  start_read_time = get_cpu_time()

  ;===========================================================================================;
  ;;------------------------------------------------------------------------------------------:
  ;				   Calculate Moisture Budget : use function for convenience
  ;;------------------------------------------------------------------------------------------:
  ;===========================================================================================;

  begin

    print("========================")
    print("Starting function moisture_budget for "+ var)
    print("")

    undef("moisture_budget")
    function moisture_budget(time[*]:numeric,p,u,v,q,omega,npr[1]:integer,lat,lon,opt[1]:logical,var)
    
    ;;-Nomenclature-----------------------------------------------------------------------------:
      ; 
      ; time    - "seconds since ..."
      ; p       - Pressure [Pa]
      ; u,v     - zonal, meridional wind components[m/s]
      ; q       - specific humidity [kg/kg]
      ; omega   - vertical velocity [Pa/s]
      ; npr     - dimension number corresponding to pressure dimension
      ; lat     - dimension corresponding to latitude dimension, used for advection and divergence
      ; lon     - dimension corresponding to latitude dimension
      ; opt     - set to False
      ;;------------------------------------------------------------------------------------------:
      ;																						
      ;  Moisture budget
      ;  e - c = dq/dt + {del}.[u*q, v*q] + d(omega*q)/dt
      ;  E - P = d<q>/dt + {del}.<[u*q, v*q]> + d<(omega*q)>/dt
      ;  <.>   = 1/g * Int_ps->ptop(.)
      ;
      ;;------------------------------------------------------------------------------------------:

    ;*******************************************
    ;---Compute local dq/dt  {(kg/kg)/s}
    ;*******************************************

      dqdt                    = center_finite_diff_n (q,time,False,0,0)     ; 'time' is 'seconds since'
      copy_VarCoords(q, dqdt)
      dqdt@longname           = "Spesific humidity: Local Time derivative"
      dqdt@units              = "(kg/kg)/s"
      ;printVarSummary(dqdt)
      ;printMinMax(dqdt,0)
      ;print("-----")

    ;*******************************************
    ;---Compute moisture flux  {(kg/kg)/s}
    ;*******************************************

      uq                      = u*q                                         ; (:,:,:,:)
      uq@long_name            = "Zonal Moisture Flux [uq]"
      uq@units                = "["+u@units+"]["+q@units+"]"                ; [m/s][kg/kg]     
      copy_VarCoords(u,uq)                                                  ; (time,level,lat,lon)

      vq                      = v*q                                         ; (:,:,:,:)
      vq@long_name            = "Meridional Moisture Flux [vq]"
      vq@units                = "["+v@units+"]["+q@units+"]" 
      copy_VarCoords(v,vq)                                                  ; (time,level,lat,lon)

    ;*******************************************
    ;---Horizontal Divergence of moisture flux: uv2dv_cfd => regional 'fixed' rectilinear grid
    ;*******************************************
      
      mfd                    = uv2dv_cfd(uq, vq, lat, lon, 2)              ; (time,level,lat,lon)
      copy_VarCoords(q, mfd)
      mfd@long_name          = "Horizontal Divergence of Moisture Flux"
      mfd@units              = "(kg/kg*s)"                                 ; (1/m)*[(m/s)(g/kg)] => [g/(kg-s)]

    ;*******************************************
    ;---Vertical Divergence of moisture flux: uv2dvF => global 'fixed' rectilinear grid
    ;*******************************************
      
      dqdp                    = center_finite_diff_n (q,p,False,1,npr)
      copy_VarCoords(q, dqdp)
      dwq                     = omega*dqdp   
      copy_VarCoords(q, dwq)  
      dwq@long_name           = "Vertical Divergence of Moisture Flux"
      dwq@units               = "(kg/kg)/s"
      ;printVarSummary(dwq)
      ;printMinMax(dwq,0)
      ;print("-----")  

    ;********************************************
    ;---Vertical integration
    ; [Joule]      kg-m2/s2 = N-m = Pa/m3 = W-s           ; energy           
    ;********************************************

      ptop            = 10000.0                           ; Pa
      pbot            = 100000.0
      vopt            = 1                                 ; weighted vertical sum

      g               = 9.80665                           ; [m/s2] gravity at 45 deg lat used by the WMO
      dp              = dpres_plevel_Wrap(p,pbot,ptop,0)
      dpg             = dp/g                              ; Pa/(m/s2)=> (Pa-s2)/m   
      dpg@long_name   = "Layer Mass Weighting"
      dpg@units       = "kg/m**2"                         ; dp/g     => Pa/(m/s2) => [kg/(m-s2)][m/s2] reduce to (kg/m2)
                                                          ;             Pa (s2/m) => [kg/(m-s2)][s2/m]=>[kg/m2]
                        
    ;-Precipitable water tendency

      dpgq            = conform(q,dpg,1)
      pw              = wgt_vertical_n(q,dpgq,vopt,1)
      copy_VarCoords(q(:,0,:,:),pw)
      pw@long_name    = "Precipitable water"
      pw@units        = "kg/m**2"
      
      pwdt            = center_finite_diff_n (pw,time,False,0,0)
      copy_VarCoords(q(:,0,:,:),pwdt)
      pwdt@long_name  = "Precipitable water tendency"
      pwdt@units      = "(kg/m**2)/s"
      pwdt@info       = "Term 1 in moisture budget eq."    
      
      delete(pw)
      
    ;-Vertically Integrated Horizontal Moisture flux

      uq_dpg          = uq*dpgq                         ; mass weighted 'uq'; [m/s][g/kg][kg/m2]=>[m/s][g/kg]
      iuq             = dim_sum_n(uq_dpg, 1)
      iuq@long_name   = "Integrated Zonal UQ [uq*dpg]" 
      iuq@LONG_NAME   = "Sum: Mass Weighted Integrated Zonal Moisture Flux [uq*dpg]" 
      iuq@units       = "[m/s][g/kg]"
      copy_VarCoords(u(:,0,:,:), iuq)                ; (time,lat,lon)
      delete(uq_dpg)

      vq_dpg          = vq*dpgq                         ; mass weighted 'vq'; [m/s][g/kg][kg/m2]=>[m/s][g/kg] 
      ivq             = dim_sum_n(vq_dpg, 1)
      ivq@long_name   = "Integrated Meridional VQ [vq*dpg]" 
      ivq@LONG_NAME   = "Sum: Mass Weighted Integrated Meridional Moisture Flux [vq*dpg]" 
      ivq@units       = "[m/s][g/kg]"
      copy_VarCoords(v(:,0,:,:), ivq)                ; (time,lat,lon)
      delete(vq_dpg)
      
    ;-Vertically Integrated Horizontal Moisture flux Divergence

      mfd_dpg        = mfd*dpgq                         ;  [g/(kg-s)][kg/m2] => [g/(m2-s)]
      imfd           = dim_sum_n(mfd_dpg, 1)
      imfd@long_name = "Integrated Mass Wgt MFD" 
      imfd@LONG_NAME = "Integrated Mass Weighted Moisture Flux Divergence" 
      imfd@units     = "(kg/m**2)/s"
      copy_VarCoords(u(:,0,:,:), imfd)               ; (time,lat,lon)
      delete(mfd_dpg)

      vimfd           =  imfd                           ; keep meta data                         
      ;VIMFD           = -VIMFD                          ; Note the preceding -1 [negative precedes integration] 
      vimfd@long_name = "Vertically Integrated Moisture Flux Divergence"
      vimfd@units     = "(kg/m**2)/s"
      vimfd@info      = "Term 2 in moisture budget eq."
      
    ;-Vertically Integrated Vertical Moisture flux Divergence

      dpgdwq          = conform(dwq,dpg,1)
      idwq            = wgt_vertical_n(dwq,dpgdwq,vopt,1)
      copy_VarCoords(q(:,0,:,:),idwq)
      idwq@long_name  = "Integrated vertical moisture flux divergence"
      idwq@units      = "(kg/m**2)/s"
      idwq@info       = "Term 3 in moisture budget eq."

    print("")
    print("Function moisture budget for "+ var +" is done")
    print("========================")

    return( [/dqdt, pwdt, uq, vq, iuq, ivq, mfd, vimfd, dwq, idwq/] )
    
  end

  ;===========================================================================================;
  ;;------------------------------------------------------------------------------------------:
  ;                                         MAIN CODE
  ;;------------------------------------------------------------------------------------------:
  ;===========================================================================================;


  ;---Variable and file handling

    diri    = "../data/"
    f       = addfile(diri+"varsel_pressurelevel.nc","r")      ; daily mean data
    fmean   = addfile(diri+"clim_mean_pressurelevel.nc","r")
    fvari   = addfile(diri+"clim_vari_pressurelevel.nc","r")
                                                                ; convenience: make all:  S->N
    wcsmean     = f->wcsmean(:,:,::-1,:)                                ; Pascal/s
    ucsmean     = f->ucsmean(:,:,::-1,:)                                ; m/s
    vcsmean     = f->vcsmean(:,:,::-1,:)                                ; m/s
    qcsmean     = f->qcsmean(:,:,::-1,:)                                ; kg/kg

    wcensmean   = f->wcensmean(:,:,::-1,:)
    ucensmean   = f->ucensmean(:,:,::-1,:)
    vcensmean   = f->vcensmean(:,:,::-1,:)
    qcensmean   = f->qcensmean(:,:,::-1,:)

    wcsvari     = f->wcsvari(:,:,::-1,:)                                ; Pascal/s
    ucsvari     = f->ucsvari(:,:,::-1,:)                                ; m/s
    vcsvari     = f->vcsvari(:,:,::-1,:)                                ; m/s
    qcsvari     = f->qcsvari(:,:,::-1,:)                                ; kg/kg

    wcensvari   = f->wcensvari(:,:,::-1,:)
    ucensvari   = f->ucensvari(:,:,::-1,:)
    vcensvari   = f->vcensvari(:,:,::-1,:)
    qcensvari   = f->qcensvari(:,:,::-1,:)

    wmean   = fmean->w(:,:,::-1,:)
    umean   = fmean->u(:,:,::-1,:)
    vmean   = fmean->v(:,:,::-1,:)
    qmean   = fmean->q(:,:,::-1,:) 

    wvari   = fvari->w(:,:,::-1,:)
    uvari   = fvari->u(:,:,::-1,:)
    vvari   = fvari->v(:,:,::-1,:)
    qvari   = fvari->q(:,:,::-1,:) 

    lat     = f->lat
    lon     = f->lon
    
  ;---Convert "hours since ..." to "seconds since ..."

    time        = f->timelag                                   ; "hours since 1800-1-1"
    time        = time*24*3600                                          
    time@units  = "seconds since 1800-1-1 00:00:0.0"
    ;printVarSummary(time)
    ;print("---")
    t           = time                 ; Lyndz' name 
    ymdh        = cd_calendar(time,-3)
    ;print(ymdh)

    timemean        = fmean->time                                   ; "hours since 1800-1-1"
    timemean        = timemean*3600                                          
    timemean@units  = "seconds since 1800-1-1 00:00:0.0"
    ;printVarSummary(timemean)
    ;print("---")
    tmean           = timemean                 ; Lyndz' name 
    ymdhmean        = cd_calendar(timemean,-3)
    ;print(ymdhmean)

  ;---Convert hPa -> Pa for function

    p           = f->lev
    p           = p*100                                      ; Pa  [100000,...,10000]
    p@units     = "Pa"
    p!0         = "p"
    p&p         =  p                   ; not necessary
    ;printVarSummary(p)
    ;print("---")
    
  ;++++++++++++++++++++++++++++++++++++++++++++++++++++++

    npr         = 1            ; number of dimension level
    opt         = True
    CSCENS      = True
    MeanVari    = True


    if (CSCENS)

    ;---For CS
      var           = "CS"
      mbcsmean          = moisture_budget(time,p,ucsmean,vcsmean,qcsmean,wcsmean,npr,lat,lon,opt,var) 
      dqdtcsmean        = mbcsmean[0]
      pwdtcsmean        = mbcsmean[1]
      uqcsmean          = mbcsmean[2]
      vqcsmean          = mbcsmean[3]
      iuqcsmean         = mbcsmean[4]
      ivqcsmean         = mbcsmean[5]
      mfdcsmean         = mbcsmean[6]
      vimfdcsmean       = mbcsmean[7]
      dwqcsmean         = mbcsmean[8]
      idwqcsmean        = mbcsmean[9]

      mbcsvari          = moisture_budget(time,p,ucsvari,vcsvari,qcsvari,wcsvari,npr,lat,lon,opt,var) 
      dqdtcsvari        = mbcsvari[0]
      pwdtcsvari        = mbcsvari[1]
      uqcsvari          = mbcsvari[2]
      vqcsvari          = mbcsvari[3]
      iuqcsvari         = mbcsvari[4]
      ivqcsvari         = mbcsvari[5]
      mfdcsvari         = mbcsvari[6]
      vimfdcsvari       = mbcsvari[7]
      dwqcsvari         = mbcsvari[8]
      idwqcsvari        = mbcsvari[9]

    ;---For CENS
      var           = "CENS"
      mbcensmean        = moisture_budget(time,p,ucensmean,vcensmean,qcensmean,wcensmean,npr,lat,lon,opt,var) 
      dqdtcensmean      = mbcensmean[0]
      pwdtcensmean      = mbcensmean[1]
      uqcensmean        = mbcensmean[2]
      vqcensmean        = mbcensmean[3]
      iuqcensmean       = mbcensmean[4]
      ivqcensmean       = mbcensmean[5]
      mfdcensmean       = mbcensmean[6]
      vimfdcensmean     = mbcensmean[7]
      dwqcensmean       = mbcensmean[8]
      idwqcensmean      = mbcensmean[9]

      mbcensvari        = moisture_budget(time,p,ucensvari,vcensvari,qcensvari,wcensvari,npr,lat,lon,opt,var) 
      dqdtcensvari      = mbcensvari[0]
      pwdtcensvari      = mbcensvari[1]
      uqcensvari        = mbcensvari[2]
      vqcensvari        = mbcensvari[3]
      iuqcensvari       = mbcensvari[4]
      ivqcensvari       = mbcensvari[5]
      mfdcensvari       = mbcensvari[6]
      vimfdcensvari     = mbcensvari[7]
      dwqcensvari       = mbcensvari[8]
      idwqcensvari      = mbcensvari[9]
    
    end if

  ;--- For meanvariclim

    if (MeanVari)
      var           = "Mean Clim"
      mbmean        = moisture_budget(timemean,p,umean,vmean,qmean, wmean,npr,lat,lon,opt,var) 
      dqdtmean      = mbmean[0]
      pwdtmean      = mbmean[1]
      uqmean        = mbmean[2]
      vqmean        = mbmean[3]
      iuqmean       = mbmean[4]
      ivqmean       = mbmean[5]
      mfdmean       = mbmean[6]
      vimfdmean     = mbmean[7]
      dwqmean       = mbmean[8]
      idwqmean      = mbmean[9]  

      var           = "Vari Clim"
      mbvari        = moisture_budget(timemean,p,uvari,vvari,qvari, wvari,npr,lat,lon,opt,var) 
      dqdtvari      = mbvari[0]
      pwdtvari      = mbvari[1]
      uqvari        = mbvari[2]
      vqvari        = mbvari[3]
      iuqvari       = mbvari[4]
      ivqvari       = mbvari[5]
      mfdvari       = mbvari[6]
      vimfdvari     = mbvari[7]
      dwqvari       = mbvari[8]
      idwqvari      = mbvari[9]  
    end if

  ;---Checking Metadata
    
    Meta = False

    if (Meta)
      print("================")
      printVarSummary(mbcs)
      printVarSummary(mbcens)
      print("================")
      print("================")
      print(" ")
      print(" ")
      print("================")
      print("================")
      printVarSummary(dqdtcs)
      printMinMax(dqdtcs,0)
      print("================")
      printVarSummary(pwdtcs)
      printMinMax(pwdtcs,0)
      print("================")
      printVarSummary(uqcs)
      printMinMax(uqcs,0)
      print("================")
      printVarSummary(vqcs)
      printMinMax(vqcs,0)
      print("================")
      printVarSummary(iuqcs)
      printMinMax(iuqcs,0)
      print("================")
      printVarSummary(ivqcs)
      printMinMax(ivqcs,0)
      print("================")
      printVarSummary(mfdcs)
      printMinMax(mfdcs,0)
      print("================")
      printVarSummary(vimfdcs)
      printMinMax(vimfdcs,0)
      print("================")
      printVarSummary(dwqcs)
      printMinMax(dwqcs,0)
      print("================")
      printVarSummary(idwqcs)
      printMinMax(idwqcs,0)
      print("================")
      print("================")
      print(" ")
      print(" ")
      print("================")
      print("================")
      printVarSummary(dqdtcens)
      printMinMax(dqdtcens,0)
      print("================")
      printVarSummary(pwdtcens)
      printMinMax(pwdtcens,0)
      print("================")
      printVarSummary(uqcens)
      printMinMax(uqcens,0)
      print("================")
      printVarSummary(vqcens)
      printMinMax(vqcens,0)
      print("================")
      printVarSummary(iuqcens)
      printMinMax(iuqcens,0)
      print("================")
      printVarSummary(ivqcens)
      printMinMax(ivqcens,0)
      print("================")
      printVarSummary(mfdcens)
      printMinMax(mfdcens,0)
      print("================")
      printVarSummary(vimfdcens)
      printMinMax(vimfdcens,0)
      print("================")
      printVarSummary(dwqcens)
      printMinMax(dwqcens,0)
      print("================")
      printVarSummary(idwqcens)
      printMinMax(idwqcens,0)
      print("================")
      print("================")
      ;print(" ")
      ;print(" ")
      ;print("================")
      ;print("================")
      ;printVarSummary(ecs)
      ;printMinMax(ecs,0)
      ;print("================")
      ;printVarSummary(pcs)
      ;printMinMax(pcs,0)
      ;print("================")
      ;printVarSummary(ecens)
      ;printMinMax(ecens,0)
      ;print("================")
      ;printVarSummary(pcens)
      ;printMinMax(pcens,0)
      ;print("================")
      ;print("================")
      ;print("================")
      ;print(" ")
      ;print(" ")
      ;print("================")
      ;print("================")
      print("================")
      print("================")
      print(" ")
      print(" ")
      print("================")
      print("================")
      printVarSummary(dqdtmean)
      printMinMax(dqdtmean,0)
      print("================")
      printVarSummary(pwdtmean)
      printMinMax(pwdtmean,0)
      print("================")
      printVarSummary(uqmean)
      printMinMax(uqmean,0)
      print("================")
      printVarSummary(vqmean)
      printMinMax(vqmean,0)
      print("================")
      printVarSummary(iuqmean)
      printMinMax(iuqmean,0)
      print("================")
      printVarSummary(ivqmean)
      printMinMax(ivqmean,0)
      print("================")
      printVarSummary(mfdmean)
      printMinMax(mfdmean,0)
      print("================")
      printVarSummary(vimfdmean)
      printMinMax(vimfdmean,0)
      print("================")
      printVarSummary(dwqmean)
      printMinMax(dwqmean,0)
      print("================")
      printVarSummary(idwqmean)
      printMinMax(idwqmean,0)
      print("================")
      print("================")
    end if

  ;***********************************************
  ;---Save to a netcdf file
  ;***********************************************

    netCDF  = True                                       ; Write netCDF 

    if (netCDF) 
        diro                = "./"
        filo                = "moisture_budget.nc"
        ptho                = diro+filo
        system("/bin/rm -f "+ptho)
        ncdf                = addfile(ptho,"c")
      
        fAtt = True
        fAtt@title          = "Moisture Budget"
        fAtt@source_name    = "ECMWF Reanalysis v5 (ERA5)"
        fAtt@source_URL     = "https://climate.copernicus.eu/climate-reanalysis"
        fAtt@source         = "ECMWF"
        fAtt@Conventions    = "None"
        fAtt@creation_date  = systemfunc("date")
        fileattdef(ncdf,fAtt)             ; copy file attributes
       
        filedimdef(ncdf,"time",-1,True)   ; make time an UNLIMITED dimension
        ncdf->dqdtcsmean        = dqdtcsmean
        ncdf->pwdtcsmean        = pwdtcsmean
  	    ncdf->uqcsmean          = uqcsmean
  	    ncdf->vqcsmean          = vqcsmean
  	    ncdf->iuqcsmean         = iuqcsmean
        ncdf->ivqcsmean         = ivqcsmean
        ncdf->mfdcsmean         = mfdcsmean
        ncdf->vimfdcsmean       = vimfdcsmean
        ncdf->dwqcsmean         = dwqcsmean
        ncdf->idwqcsmean        = idwqcsmean

        ncdf->dqdtcensmean      = dqdtcensmean
        ncdf->pwdtcensmean      = pwdtcensmean
        ncdf->uqcensmean        = uqcensmean
        ncdf->vqcensmean        = vqcensmean
        ncdf->iuqcensmean       = iuqcensmean
        ncdf->ivqcensmean       = ivqcensmean
        ncdf->mfdcensmean       = mfdcensmean
        ncdf->vimfdcensmean     = vimfdcensmean
        ncdf->dwqcensmean       = dwqcensmean
        ncdf->idwqcensmean      = idwqcensmean

        ncdf->dqdtcsvari        = dqdtcsvari
        ncdf->pwdtcsvari        = pwdtcsvari
        ncdf->uqcsvari          = uqcsvari
        ncdf->vqcsvari          = vqcsvari
        ncdf->iuqcsvari         = iuqcsvari
        ncdf->ivqcsvari         = ivqcsvari
        ncdf->mfdcsvari         = mfdcsvari
        ncdf->vimfdcsvari       = vimfdcsvari
        ncdf->dwqcsvari         = dwqcsvari
        ncdf->idwqcsvari        = idwqcsvari

        ncdf->dqdtcensvari      = dqdtcensvari
        ncdf->pwdtcensvari      = pwdtcensvari
        ncdf->uqcensvari        = uqcensvari
        ncdf->vqcensvari        = vqcensvari
        ncdf->iuqcensvari       = iuqcensvari
        ncdf->ivqcensvari       = ivqcensvari
        ncdf->mfdcensvari       = mfdcensvari
        ncdf->vimfdcensvari     = vimfdcensvari
        ncdf->dwqcensvari       = dwqcensvari
        ncdf->idwqcensvari      = idwqcensvari
    end if

    if (netCDF) .and. (MeanVari)
        diro                = "./"
        filo                = "moisture_budget_clim_meanvari.nc"
        ptho                = diro+filo
        system("/bin/rm -f "+ptho)
        ncdf                = addfile(ptho,"c")
      
        fAtt = True
        fAtt@title          = "Moisture Budget"
        fAtt@source_name    = "ECMWF Reanalysis v5 (ERA5)"
        fAtt@source_URL     = "https://climate.copernicus.eu/climate-reanalysis"
        fAtt@source         = "ECMWF"
        fAtt@Conventions    = "None"
        fAtt@creation_date  = systemfunc("date")
        fileattdef(ncdf,fAtt)             ; copy file attributes
       
        filedimdef(ncdf,"time",-1,True)   ; make time an UNLIMITED dimension
        ncdf->dqdtmean        = dqdtmean
        ncdf->pwdtmean        = pwdtmean
        ncdf->uqmean          = uqmean
        ncdf->vqmean          = vqmean
        ncdf->iuqmean         = iuqmean
        ncdf->ivqmean         = ivqmean
        ncdf->mfdmean         = mfdmean
        ncdf->vimfdmean       = vimfdmean
        ncdf->dwqmean         = dwqmean
        ncdf->idwqmean        = idwqmean

        ncdf->dqdtvari        = dqdtvari
        ncdf->pwdtvari        = pwdtvari
        ncdf->uqvari          = uqvari
        ncdf->vqvari          = vqvari
        ncdf->iuqvari         = iuqvari
        ncdf->ivqvari         = ivqvari
        ncdf->mfdvari         = mfdvari
        ncdf->vimfdvari       = vimfdvari
        ncdf->dwqvari         = dwqvari
        ncdf->idwqvari        = idwqvari
    end if

end