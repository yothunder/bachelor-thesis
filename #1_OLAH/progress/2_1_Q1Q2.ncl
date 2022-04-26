;===========================================================================================;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;
; Progres_v2 - first time writing code => Wednesday, 05 Jan 2022 - 20.44 WIB (13.44 UTC)    ;
;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;===========================================================================================;

;===========================================================================================;
;;------------------------------------------------------------------------------------------;
;					Calculate Q1Q2 : use function for convenience
;;------------------------------------------------------------------------------------------;
;===========================================================================================;

undef("Q1Q2_yanai")
function Q1Q2_yanai(time[*]:numeric,p,u,v,H,T,omega,lat,lon,npr[1]:integer,opt[1]:logical, var:string)
;;------------------------------------------------------------------------------------------;	
; Nomenclature
; time    - "seconds since ..."
; p       - Pressure [Pa]
; u,v     - zonal, meridional wind components[m/s]
; H       - specific humidity [kg/kg]
; T       - temperature [K]  or [C]
; omega   - vertical velocity [Pa/s]
; npr     - demension number corresponding to pressure dimension
; opt     - set to False
;;------------------------------------------------------------------------------------------;	
;;  Q1  = Cp*dTdt - Cp*(omega*ss-advT)
;;  Q1  = Cp*[ dTdt- omega*ss-advT ]
;;  q1  = dTdt- omega*ss-advT
;;  Q1  = Cp*[ q1 ]
;;
;;  Q1  = Total diabatic heating [including radiation, latent heating, and
;;        sfc heat flux) and sub-grid scale heat flux convergence
;;---
;;  q2  = -(dHdt +advH +dHdp)
;;  Q2  = Lc*[ q2 ]
;;
;;  Q2  = the latent heating due to condensation or evaporation processes
;;        and subgrid-scale moisture flux convergences,
;;------------------------------------------------------------------------------------------;

;local dimp, dimu, dimv, dimH, dimT, dimo             \										
;    , rankp, ranku, rankv, rankH, rankT, ranko       \										
;    , Cp, Lc, dTdt, ss, opt_adv, long_name, units    \										
;    , gridType, advT, q1, Q1percp, Q1, dHdt, advH, loq, q2, Q2percp, Q2						

begin
;;             Use for error testing
;;dimp         = dimsizes(p)
;;dimu         = dimsizes(u)
;;dimv         = dimsizes(v)
;;dimH         = dimsizes(H)
;;dimT         = dimsizes(T)
;;dimo         = dimsizes(omega)
;;rankp        = dimsizes(dimp)
;;ranku        = dimsizes(dimu)
;;rankv        = dimsizes(dimv)
;;rankH        = dimsizes(dimH)
;;rankT        = dimsizes(dimT)
;;ranko        = dimsizes(dimo)

  print("========================")
  print("Starting function Q1Q2_yanai for "+ var)
  print("")

;;------------------------------------------------------------------------------------------;
;---Compute local dT/dt  {K/s}
;;------------------------------------------------------------------------------------------;

  dTdt                     = center_finite_diff_n (T,time,False,0,0)
  copy_VarCoords(T, dTdt)										; 'time' is 'seconds since'
  dTdt@longname            = "Temperature: Local Time derivative"
  dTdt@units               = "K/s"
  ;printVarSummary(dTdt)
  ;printMinMax(dTdt,0)
  ;print("-----")

;;------------------------------------------------------------------------------------------;
;---Compute static stability {K/Pa} <==>  or "K-m-s2/kg"
;;------------------------------------------------------------------------------------------;

  ss                       = static_stability (p , T, 1, 0)
  ;printVarSummary(ss)
  ;printMinMax(ss,0)
  ;print("-----")
																				
;;------------------------------------------------------------------------------------------;
;---Compute advection term: regional fixed grid: spherical harmonics
;---U*(dT/dx) + V*(dT/dy):  [m/s][K/m] -> {K/s}
;;------------------------------------------------------------------------------------------;

  opt_adv                = 0
  long_name              = "temp advection"
  units                  = "K/s"
  gridType               = 1
  cyclic                 = False
  advT                   = advect_variable_cfd(u,v,T,lat,lon,cyclic,long_name,units,opt_adv)
; advect_variable_cfd => harusnya pakai fungsi ini karena lebih cocok untuk regional grid

;;------------------------------------------------------------------------------------------;
;---Net Heat
;;------------------------------------------------------------------------------------------;
																							;
  q1                     = dTdt - (omega*ss-advT)      	; term_1 - term_2
  q1@long_name           = "q1: Net Heat Flux"
  q1@units               = "K/s"
  copy_VarCoords(T,q1)
  ;printVarSummary(q1)
  ;printMinMax(q1,0)
  ;print("-----")

;;------------------------------------------------------------------------------------------;
;---Compute local dH/dt
;;------------------------------------------------------------------------------------------;

  dHdt                   = center_finite_diff_n (H,time,False,0,0)
  copy_VarCoords(H, dHdt)
  dHdt@longname          = "Specific Humidity: Local Time derivative"
  dHdt@units             = "(kg/kg.s)"
  ;printVarSummary(dHdt)
  ;printMinMax(dHdt,0)
  ;print("-----")

;;------------------------------------------------------------------------------------------;
;---Compute advection term: regional fixed grid: spherical harmonics
;---U*(dH/dlon) + V*(dH/dlat)
;;------------------------------------------------------------------------------------------;

  long_name              = "moisture advection"
  units                  = "(kg/kg*s)"     ; (m/s)*(g/kg)*(1/m)
  advH                   = advect_variable_cfd(u,v,H,lat,lon,cyclic,long_name,units,opt_adv)

;;------------------------------------------------------------------------------------------;
;---Compute vertical movement of H
;;------------------------------------------------------------------------------------------;

  dHdp                     = center_finite_diff_n (H,p,False,1,npr)
  copy_VarCoords(H, dHdp)
  dHdp@longname            = "Specific Humidity: Local Vertical Derivative"
  dHdp@units               = "(kg/kg*Pa)"   
  ;printVarSummary(dHdp)
  ;printMinMax(dHdp,0)
  ;print("-----")

  dHdp                     = omega*dHdp               ; overwrite ... convenience
  dHdp@longname            = "Specific Humidity: Vertical Moisture Transport"
  dHdp@units               = "(kg/kg*s)"       ; [(Pa/s)(g/kg)/Pa)]  
  ;printVarSummary(dHdp)
  ;printMinMax(dHdp,0)
  ;print("-----")

;;------------------------------------------------------------------------------------------;
;---Apparent Heat Source 
;;------------------------------------------------------------------------------------------;

  Cp                       = 1004.64 
  Cp@long_name             = "specific heat of dry air at constant pressure"
  Cp@units                 = "(J/kg*K)" 

  Q1                       = q1*Cp									; used for vertical integral
  Q1@long_name             = "Q1: Apparent Heat Source"
  Q1@info                  = "used for vertically integrated plot"
  Q1@units                 = "(J/kg*s)"     
  copy_VarCoords(T,Q1)
    
  Q1percp                  = q1                                    	; used for time vs height 
  Q1percp@long_name        = "Q1: Apparent Heat Source / heating rate"
  Q1percp@info             = "used for time vs height plot"
  Q1percp@units            = "K/s"
  copy_VarCoords(T,Q1percp)
  ;printVarSummary(Q1percp) 
  ;printMinMax(Q1percp,0)
  ;print("-----") 

;;------------------------------------------------------------------------------------------;
;---Apparent Moisture Sink 
;;------------------------------------------------------------------------------------------;

  q2              		   = -(dHdt +advH +dHdp)
  q2@long_name             = "q2: moisture sink"      
  q2@units                 = "(kg/kg*s)"
  copy_VarCoords(T,q2)
  ;printVarSummary(q2) 

  Lc                       = 2.26e6    ; [J/kg]=[m2/s2]  
  Lc@long_name             = "Latent Heat of Condensation/Vaporization"
  Lc@units                 = "J/kg"  ; ==> "m2/s2"

  Q2                       = (Lc*q2)						; used for vertical integral    
  Q2@long_name             = "Q2: Apparent Moisture Sink"
  Q2@info                  = "used for vertically integrated plot"
  Q2@units                 = "(J/kg*s)"
  copy_VarCoords(T,Q2)
  
  Q2percp                  = Q2/Cp							; used for time vs height
  Q2percp@long_name        = "Q2: Apparent Moisture Sink / drying rate"
  Q2percp@info             = "used for time vs height plot"
  Q2percp@units            = "K/s"
  copy_VarCoords(T,Q2percp)
  ;printVarSummary(Q2percp) 
  ;printMinMax(Q2percp,0)
  ;print("-----")

;;------------------------------------------------------------------------------------------;
;---Make Q1, Q2 to per day
;;------------------------------------------------------------------------------------------;

  Q1percp                  = Q1percp*86400
  Q2percp                  = Q2percp*86400
  Q1percp@units            = "K/day"
  Q2percp@units            = "K/day"

;;------------------------------------------------------------------------------------------;
;---Vertical integration
; J[oule]      kg-m2/s2 = N-m = Pa/m3 = W-s       ; energy           
;;------------------------------------------------------------------------------------------;

  ptop            = 10000.0                             ; Pa
  pbot            = 100000.0
  vopt            = 1 

  g               = 9.80665                             ; [m/s2] gravity at 45 deg lat used by the WMO
  dp              = dpres_plevel_Wrap(p,pbot,ptop,0)
  dpg             = dp/g                                ; Pa/(m/s2)=> (Pa-s2)/m   
  dpg@long_name   = "Layer Mass Weighting"
  dpg@units       = "kg/m**2"                           ; dp/g     => Pa/(m/s2) => [kg/(m-s2)][m/s2] reduce to (kg/m2)
                                                        ;             Pa (s2/m) => [kg/(m-s2)][s2/m]=>[kg/m2]
  dpgq1           = conform(Q1,dpg,1)                   ; reassign [convenience]

  Q1int           = wgt_vertical_n(Q1,dpgq1,vopt,1)     ; SUM[q1*dpg]  => (K/s)(kg/m2)
  Q1int@long_name = "Apparent Heat Source: vertically integrated"
  Q1int@units     = "W/m**2"
  ;printVarSummary(Q1int)
  copy_VarCoords(T(:,0,:,:),Q1int)
  ;printMinMax(Q1int,0)
  ;print("-----")

  dpgq2           = conform(Q2,dpg,1)
  
  Q2int           = wgt_vertical_n(Q2,dpgq2,vopt,1)
  Q2int@long_name = "Apparent Moisture Sink: vertically integrated"
  Q2int@units     = "W/m**2"
  copy_VarCoords(T(:,0,:,:),Q2int)
  ;printMinMax(Q2int,0)
  ;print("-----")

  print("")
  print("Function Q1Q2_yanai for "+ var +" is done")
  print("========================")

  return( [/Q1int, Q2int, Q1percp, Q2percp/] )
end

;===========================================================================================;
;;------------------------------------------------------------------------------------------;
;                                         MAIN CODE
;;------------------------------------------------------------------------------------------;
;===========================================================================================;


;---Variable and file handling

  diri        = "../data/"
  f           = addfile(diri+"varsel_pressurelevel.nc","r")      ; daily mean data
  fmean       = addfile(diri+"clim_mean_pressurelevel.nc","r")
  fvari       = addfile(diri+"clim_vari_pressurelevel.nc","r")
                                                              ; convenience: make all:  S->N
  tcsmean         = f->tcsmean(:,:,::-1,:)                                ; degK
  wcsmean         = f->wcsmean(:,:,::-1,:)                                ; Pascal/s
  ucsmean         = f->ucsmean(:,:,::-1,:)                                ; m/s
  vcsmean         = f->vcsmean(:,:,::-1,:)                                ; m/s
  qcsmean         = f->qcsmean(:,:,::-1,:)                                ; kg/kg

  tcensmean       = f->tcensmean(:,:,::-1,:)
  wcensmean       = f->wcensmean(:,:,::-1,:)
  ucensmean       = f->ucensmean(:,:,::-1,:)
  vcensmean       = f->vcensmean(:,:,::-1,:)
  qcensmean       = f->qcensmean(:,:,::-1,:)

  tcsvari         = f->tcsvari(:,:,::-1,:)                                ; degK
  wcsvari         = f->wcsvari(:,:,::-1,:)                                ; Pascal/s
  ucsvari         = f->ucsvari(:,:,::-1,:)                                ; m/s
  vcsvari         = f->vcsvari(:,:,::-1,:)                                ; m/s
  qcsvari         = f->qcsvari(:,:,::-1,:)                                ; kg/kg

  tcensvari       = f->tcensvari(:,:,::-1,:)
  wcensvari       = f->wcensvari(:,:,::-1,:)
  ucensvari       = f->ucensvari(:,:,::-1,:)
  vcensvari       = f->vcensvari(:,:,::-1,:)
  qcensvari       = f->qcensvari(:,:,::-1,:)

;===

  tmean       = fmean->t(:,:,::-1,:)
  wmean       = fmean->w(:,:,::-1,:)
  umean       = fmean->u(:,:,::-1,:)
  vmean       = fmean->v(:,:,::-1,:)
  qmean       = fmean->q(:,:,::-1,:)

  tvari       = fvari->t(:,:,::-1,:)
  wvari       = fvari->w(:,:,::-1,:)
  uvari       = fvari->u(:,:,::-1,:)
  vvari       = fvari->v(:,:,::-1,:)
  qvari       = fvari->q(:,:,::-1,:)

  lat	        = tcsmean&lat
  lon	        = tcsmean&lon
  latmean     = tmean&latitude
  lonmean     = tmean&longitude
  latvari     = tvari&latitude
  lonvari     = tvari&longitude

;---Convert "hours since ..." to "seconds since ..."

  time        = f->timelag                                   ; "hours since 1800-1-1"
  time        = time*24*3600                                          
  time@units  = "seconds since 1800-1-1 00:00:0.0"
  ;printVarSummary(time)
  ;print("---")
  t           = time                 ; Lyndz' name 
  ymdh        = cd_calendar(time,-3)
  print(ymdh)

  timemean        = fmean->time                                   ; "hours since 1800-1-1"
  timemean        = timemean*3600                                          
  timemean@units  = "seconds since 1800-1-1 00:00:0.0"
  ;printVarSummary(timemean)
  ;print("---")
  ;tmean           = timemean                 ; Lyndz' name 
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
  
;;------------------------------------------------------------------------------------------;

  npr         = 1            ; number of dimension level
  opt         = True

;---For MeanClim
  
  var         = "Mean Clim"
  q1q2mean    = Q1Q2_yanai(timemean,p,umean,vmean,qmean,tmean,wmean,latmean,lonmean,npr,opt,var)
  Q1intmean   = q1q2mean[0]
  Q2intmean   = q1q2mean[1]
  Q1percpmean = q1q2mean[2]
  Q2percpmean = q1q2mean[3]
  printVarSummary(q1q2mean)

;---For VariClim
  
  var         = "Vari Clim"
  q1q2vari    = Q1Q2_yanai(timemean,p,uvari,vvari,qvari,tvari,wvari,latvari,lonvari,npr,opt,var)
  Q1intvari   = q1q2vari[0]
  Q2intvari   = q1q2vari[1]
  Q1percpvari = q1q2vari[2]
  Q2percpvari = q1q2vari[3]
  printVarSummary(q1q2vari)

  Q1intmean!0 = "time"
  Q1intmean!1 = "lat"
  Q1intmean!2 = "lon"
  Q1intmean&time = tmean&time
  Q1intmean&lat  = tmean&latitude
  Q1intmean&lon  = tmean&longitude
  copy_VarMeta(Q1intmean,Q2intmean)
  printVarSummary(Q1intmean)
  printVarSummary(Q2intmean)

  Q1percpmean!0 = "time"
  Q1percpmean!1 = "lev"
  Q1percpmean!2 = "lat"
  Q1percpmean!3 = "lon"
  Q1percpmean&time = tmean&time
  Q1percpmean&lev  = tmean&level
  Q1percpmean&lat  = tmean&latitude
  Q1percpmean&lon  = tmean&longitude
  copy_VarMeta(Q1percpmean,Q2percpmean)
  printVarSummary(Q1percpmean)
  printVarSummary(Q2percpmean)

  Q1intvari!0 = "time"
  Q1intvari!1 = "lat"
  Q1intvari!2 = "lon"
  Q1intvari&time = tvari&time
  Q1intvari&lat  = tvari&latitude
  Q1intvari&lon  = tvari&longitude
  copy_VarMeta(Q1intvari,Q2intvari)
  printVarSummary(Q1intvari)
  printVarSummary(Q2intvari)

  Q1percpvari!0 = "time"
  Q1percpvari!1 = "lev"
  Q1percpvari!2 = "lat"
  Q1percpvari!3 = "lon"
  Q1percpvari&time = tvari&time
  Q1percpvari&lev  = tvari&level
  Q1percpvari&lat  = tvari&latitude
  Q1percpvari&lon  = tvari&longitude
  copy_VarMeta(Q1percpvari,Q2percpvari)
  printVarSummary(Q1percpvari)
  printVarSummary(Q2percpvari)


  Meta = True

  if (Meta)

  ;---For CS

    var         = "CS"
    q1q2csmean      = Q1Q2_yanai(time,p,ucsmean,vcsmean,qcsmean,tcsmean,wcsmean,lat,lon,npr,opt,var)
    Q1intcsmean     = q1q2csmean[0]
    Q2intcsmean     = q1q2csmean[1]
    Q1percpcsmean   = q1q2csmean[2]
    Q2percpcsmean   = q1q2csmean[3]
    q1q2csvari      = Q1Q2_yanai(time,p,ucsvari,vcsvari,qcsvari,tcsvari,wcsvari,lat,lon,npr,opt,var)
    Q1intcsvari     = q1q2csvari[0]
    Q2intcsvari     = q1q2csvari[1]
    Q1percpcsvari   = q1q2csvari[2]
    Q2percpcsvari   = q1q2csvari[3]
    printVarSummary(q1q2csmean)
    printVarSummary(q1q2csvari)


  ;---For CENS
    
    var         = "CENS"
    q1q2censmean    = Q1Q2_yanai(time,p,ucensmean,vcensmean,qcensmean,tcensmean,wcensmean,lat,lon,npr,opt,var)
    Q1intcensmean   = q1q2censmean[0]
    Q2intcensmean   = q1q2censmean[1]
    Q1percpcensmean = q1q2censmean[2]
    Q2percpcensmean = q1q2censmean[3]
    q1q2censvari    = Q1Q2_yanai(time,p,ucensvari,vcensvari,qcensvari,tcensvari,wcensvari,lat,lon,npr,opt,var)
    Q1intcensvari   = q1q2censvari[0]
    Q2intcensvari   = q1q2censvari[1]
    Q1percpcensvari = q1q2censvari[2]
    Q2percpcensvari = q1q2censvari[3]
    printVarSummary(q1q2censmean)
    printVarSummary(q1q2censvari)

  ;---Metadata Checking

    
    print("================")
    print("================")
    printVarSummary(Q1intmean)
    printMinMax(Q1intmean,0)
    print("================")
    printVarSummary(Q2intmean)
    printMinMax(Q2intmean,0)
    print("================")
    print("================")
    printVarSummary(Q1percpmean)
    printMinMax(Q1percpmean,0)
    print("================")
    printVarSummary(Q2percpmean)
    printMinMax(Q2percpmean,0)
    print("================")
    print("================")

    
    print("================")
    print("================")
    printVarSummary(Q1intvari)
    printMinMax(Q1intvari,0)
    print("================")
    printVarSummary(Q2intvari)
    printMinMax(Q2intvari,0)
    print("================")
    print("================")
    printVarSummary(Q1percpvari)
    printMinMax(Q1percpvari,0)
    print("================")
    printVarSummary(Q2percpvari)
    printMinMax(Q2percpvari,0)
    print("================")
    print("================")

    print("================")
    printVarSummary(Q1intcsmean)
    printMinMax(Q1intcsmean,0)
    print("================")
    printVarSummary(Q2intcsmean)
    printMinMax(Q2intcsmean,0)
    print("================")
    print("================")
    printVarSummary(Q1percpcsmean)
    printMinMax(Q1percpcsmean,0)
    print("================")
    printVarSummary(Q2percpcsmean)
    printMinMax(Q2percpcsmean,0)
    print("================")
    print("================")
    print(" ")
    print(" ")
    print("================")
    print("================")
    printVarSummary(Q1intcensmean)
    printMinMax(Q1intcensmean,0)
    print("================")
    printVarSummary(Q2intcensmean)
    printMinMax(Q2intcensmean,0)
    print("================")
    print("================")
    printVarSummary(Q1percpcensmean)
    printMinMax(Q1percpcensmean,0)
    print("================")
    printVarSummary(Q2percpcensmean)
    printMinMax(Q2percpcensmean,0)

  end if

;;------------------------------------------------------------------------------------------;
;---Save to a netcdf file
;;------------------------------------------------------------------------------------------;

  netCDF      = True                                              ; Write netCDF 
  MeanVari    = True

  if (netCDF) .and. (Meta)
      diro = "./"
      filo = "YANAI_Q1Q2.nc"
      ptho = diro+filo
      system("/bin/rm -f "+ptho)
      ncdf = addfile(ptho,"c")
    
      fAtt = True
      fAtt@title          = "Apparent Heat Source and Moisture Sink based on Yanai et al. 1973"
      fAtt@source_name    = "ECMWF Reanalysis v5 (ERA5)"
      fAtt@source_URL     = "https://climate.copernicus.eu/climate-reanalysis"
      fAtt@source         = "ECMWF"
      fAtt@Conventions    = "None"
      fAtt@creation_date  = systemfunc("date")
      fileattdef(ncdf,fAtt)            ; copy file attributes
     
      filedimdef(ncdf,"time",-1,True) ; make time an UNLIMITED dimension
      ncdf->Q1percpcsmean   = Q1percpcsmean
      ncdf->Q2percpcsmean   = Q2percpcsmean
  	  ncdf->Q1intcsmean     = Q1intcsmean
  	  ncdf->Q2intcsmean     = Q2intcsmean
      ncdf->Q1percpcensmean = Q1percpcensmean
      ncdf->Q2percpcensmean = Q2percpcensmean
      ncdf->Q1intcensmean   = Q1intcensmean
      ncdf->Q2intcensmean   = Q2intcensmean

      ncdf->Q1percpcsvari   = Q1percpcsvari
      ncdf->Q2percpcsvari   = Q2percpcsvari
      ncdf->Q1intcsvari     = Q1intcsvari
      ncdf->Q2intcsvari     = Q2intcsvari
      ncdf->Q1percpcensvari = Q1percpcensvari
      ncdf->Q2percpcensvari = Q2percpcensvari
      ncdf->Q1intcensvari   = Q1intcensvari
      ncdf->Q2intcensvari   = Q2intcensvari
  end if

  if (netCDF) .and. (MeanVari)
      diro = "./"
      filo = "YANAI_Q1Q2_meanclim.nc"
      ptho = diro+filo
      system("/bin/rm -f "+ptho)
      ncdf = addfile(ptho,"c")
    
      fAtt = True
      fAtt@title          = "Apparent Heat Source and Moisture Sink based on Yanai et al. 1973"
      fAtt@source_name    = "ECMWF Reanalysis v5 (ERA5)"
      fAtt@source_URL     = "https://climate.copernicus.eu/climate-reanalysis"
      fAtt@source         = "ECMWF"
      fAtt@Conventions    = "None"
      fAtt@creation_date  = systemfunc("date")
      fileattdef(ncdf,fAtt)            ; copy file attributes
     
      filedimdef(ncdf,"time",-1,True) ; make time an UNLIMITED dimension
      ncdf->Q1percpmean   = Q1percpmean
      ncdf->Q2percpmean   = Q2percpmean
      ncdf->Q1intmean     = Q1intmean
      ncdf->Q2intmean     = Q2intmean

      ncdf->Q1percpvari   = Q1percpvari
      ncdf->Q2percpvari   = Q2percpvari
      ncdf->Q1intvari     = Q1intvari
      ncdf->Q2intvari     = Q2intvari
  end if

;===========================================================================================;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;
; Progres_v2 - last save => Wednesday, 19 Apr 2022 - 17.20 WIB (10.20 UTC)
;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;===========================================================================================;