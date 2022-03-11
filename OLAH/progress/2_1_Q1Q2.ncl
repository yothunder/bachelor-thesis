;===========================================================================================;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;																							;
; Progres_v2 - first time writing code => Wednesday, 05 Jan 2022 - 20.44 WIB (13.44 UTC)    ;
;																							;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;===========================================================================================;
																							;
;===========================================================================================;
;;------------------------------------------------------------------------------------------;
;					Calculate Q1Q2 : use function for convenience							;
;;------------------------------------------------------------------------------------------;
;===========================================================================================;
																							;
undef("Q1Q2_yanai")																			;
function Q1Q2_yanai(time[*]:numeric,p,u,v,H,T,omega,npr[1]:integer,opt[1]:logical)	;
;;------------------------------------------------------------------------------------------;	
; Nomenclature																				;
; time    - "seconds since ..."																;
; p       - Pressure [Pa]																	;
; u,v     - zonal, meridional wind components[m/s]											;
; H       - specific humidity [kg/kg]														;
; T       - temperature [K]  or [C]															;
; omega   - vertical velocity [Pa/s]														;
; npr     - demension number corresponding to pressure dimension							;
; opt     - set to False																	;
;;------------------------------------------------------------------------------------------;	
;;  Q1  = Cp*dTdt - Cp*(omega*ss-advT)														;
;;  Q1  = Cp*[ dTdt- omega*ss-advT ]														;
;;  q1  = dTdt- omega*ss-advT    															;
;;  Q1  = Cp*[ q1 ]                   														;
;;																							;
;;  Q1  = Total diabatic heating [including radiation, latent heating, and					;
;;        sfc heat flux) and sub-grid scale heat flux convergence							;
;;---																						;
;;  q2  = -(dHdt +advH +dHdp)																;
;;  Q2  = Lc*[ q2 ]																			;
;;																							;
;;  Q2  = the latent heating due to condensation or evaporation processes					;
;;        and subgrid-scale moisture flux convergences,										;
;;------------------------------------------------------------------------------------------;
																							;
;local dimp, dimu, dimv, dimH, dimT, dimo             \										
;    , rankp, ranku, rankv, rankH, rankT, ranko       \										
;    , Cp, Lc, dTdt, ss, opt_adv, long_name, units    \										
;    , gridType, advT, q1, Q1percp, Q1, dHdt, advH, loq, q2, Q2percp, Q2						
																							;
begin																						;
;;             Use for error testing														;
;;dimp         = dimsizes(p)																;
;;dimu         = dimsizes(u)																;
;;dimv         = dimsizes(v)																;
;;dimH         = dimsizes(H)																;
;;dimT         = dimsizes(T)																;
;;dimo         = dimsizes(omega)															;
																							;
;;rankp        = dimsizes(dimp)																;
;;ranku        = dimsizes(dimu)																;
;;rankv        = dimsizes(dimv)																;
;;rankH        = dimsizes(dimH)																;
;;rankT        = dimsizes(dimT)																;
;;ranko        = dimsizes(dimo)																;
																							;
;;------------------------------------------------------------------------------------------;
;---Compute local dT/dt  {K/s}																;
;;------------------------------------------------------------------------------------------;
																							;
  dTdt                     = center_finite_diff_n (T,time,False,0,0)						;
  copy_VarCoords(T, dTdt)										; 'time' is 'seconds since'	;
  dTdt@longname            = "Temperature: Local Time derivative"							;
  dTdt@units               = "K/s"															;
  printVarSummary(dTdt)																		;
  printMinMax(dTdt,0)																		;
  print("-----")																			;
																							;
;;------------------------------------------------------------------------------------------;
;---Compute static stability {K/Pa} <==>  or "K-m-s2/kg"									;
;;------------------------------------------------------------------------------------------;
																							;
  ss                       = static_stability (p , T, 1, 0) 								;
  printVarSummary(ss)																		;
  printMinMax(ss,0)																			;
  print("-----")																			;
																							;
;;------------------------------------------------------------------------------------------;
;---Compute advection term: regional fixed grid: spherical harmonics						;
;---U*(dT/dx) + V*(dT/dy):  [m/s][K/m] -> {K/s}												;
;;------------------------------------------------------------------------------------------;
																							;
  opt_adv                = 0																;
  long_name              = "temp advection"													;
  units                  = "K/s"															;
  gridType               = 1  																;
  advT                   = advect_variable(u,v,T,gridType,long_name,units,opt_adv)      	;
; advect_variable_cfd => harusnya pakai fungsi ini karena lebih cocok untuk regional grid   ;
																							;
;;------------------------------------------------------------------------------------------;
;---Net Heat																				;
;;------------------------------------------------------------------------------------------;
																							;
  q1                     = dTdt - (omega*ss-advT)      	; term_1 - term_2					;
  q1@long_name           = "q1: Net Heat Flux"												;
  q1@units               = "K/s"															;
  copy_VarCoords(T,q1)																		;
  printVarSummary(q1) 																		;
  printMinMax(q1,0)																			;	
  print("-----")																			;
																							;
;;------------------------------------------------------------------------------------------;
;---Compute local dH/dt																		;
;;------------------------------------------------------------------------------------------;
																							;
  dHdt                   = center_finite_diff_n (H,time,False,0,0)							;
  copy_VarCoords(H, dHdt)																	;
  dHdt@longname          = "Specific Humidity: Local Time derivative"						;
  dHdt@units             = "(kg/kg.s)"   													;
  printVarSummary(dHdt)																		;
  printMinMax(dHdt,0)																		;
  print("-----")																			;
																							;
;;------------------------------------------------------------------------------------------;
;---Compute advection term: regional fixed grid: spherical harmonics
;---U*(dH/dlon) + V*(dH/dlat)
;;------------------------------------------------------------------------------------------;

  long_name              = "moisture advection"
  units                  = "(kg/kg*s)"     ; (m/s)*(g/kg)*(1/m)
  advH                   = advect_variable(u,v,H,gridType,long_name,units,opt_adv)  

;;------------------------------------------------------------------------------------------;
;---Compute vertical movement of H
;;------------------------------------------------------------------------------------------;

  dHdp                     = center_finite_diff_n (H,p,False,1,npr)
  copy_VarCoords(H, dHdp)
  dHdp@longname            = "Specific Humidity: Local Vertical Derivative"
  dHdp@units               = "(kg/kg*Pa)"   
  printVarSummary(dHdp)
  printMinMax(dHdp,0)
  print("-----")

  dHdp                     = omega*dHdp               ; overwrite ... convenience
  dHdp@longname            = "Specific Humidity: Vertical Moisture Transport"
  dHdp@units               = "(kg/kg*s)"       ; [(Pa/s)(g/kg)/Pa)]  
  printVarSummary(dHdp)
  printMinMax(dHdp,0)
  print("-----")

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
  printVarSummary(Q1percp) 
  printMinMax(Q1percp,0)
  print("-----") 

;;------------------------------------------------------------------------------------------;
;---Apparent Moisture Sink 
;;------------------------------------------------------------------------------------------;

  q2              		   = -(dHdt +advH +dHdp)
  q2@long_name             = "q2: moisture sink"      
  q2@units                 = "(kg/kg*s)"
  copy_VarCoords(T,q2)
  printVarSummary(q2) 

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
  printVarSummary(Q2percp) 
  printMinMax(Q2percp,0)
  print("-----")

;;------------------------------------------------------------------------------------------;
;---Make Q1, Q2 to per day
;;------------------------------------------------------------------------------------------;
																							;
  Q1percp                  = Q1percp*86400													;
  Q2percp                  = Q2percp*86400													;
  Q1percp@units            = "K/day"														;
  Q2percp@units            = "K/day"														;
																							;
  return( [/Q1, Q2, Q1percp, Q2percp/] )													;
end																							;
																							;
;===========================================================================================;
;;------------------------------------------------------------------------------------------;
;                                         MAIN CODE											;
;;------------------------------------------------------------------------------------------;
;===========================================================================================;

  netCDF  = True                                       ; Write netCDF 

;---Variable and file handling

  diri    = "./"
  f1      = addfile(diri+"#t.nc","r")    ; daily mean data
  f2      = addfile(diri+"#w.nc","r")     
  f3      = addfile(diri+"#u.nc","r")
  f4      = addfile(diri+"#v.nc","r")
  f5      = addfile(diri+"#q.nc","r")
                                                       ; convenience: make all:  S->N
  temp    = f1->t(:,:,::-1,:)                          ; degK
  omega   = f2->w(:,:,::-1,:)                          ; Pascal/s
  uwnd    = f3->u(:,:,::-1,:)                          ; m/s
  vwnd    = f4->v(:,:,::-1,:)                          ; m/s
  q       = f5->q(:,:,::-1,:)                          ; kg/kg   
  
  lat	  = f1->lat
  lon	  = f1->lon
  
;---Convert "hours since ..." to "seconds since ..."

  time        = f5->time                                   ; "hours since 1800-1-1"
  time        = time*3600                                          
  time@units  = "seconds since 1800-1-1 00:00:0.0"
  printVarSummary(time)
  print("---")
  t           = time                 ; Lyndz' name 

  ymdh        = cd_calendar(time,-3)
  print(ymdh)

;---Convert hPa -> Pa for function

  p           = f1->level
  p           = p*100                                      ; Pa  [100000,...,10000]
  p@units     = "Pa"
  p!0         = "p"
  p&p         =  p                   ; not necessary
  printVarSummary(p)
  print("---")
  
;;------------------------------------------------------------------------------------------;
  Cp          = 1004.64      ; specific heat of dry air at constant pressure 
  Cp@units    = "(J/K*kg)"  

  npr         = 1            ; number of dimension level
  opt         = True
  q1q2        = Q1Q2_yanai(time,p,uwnd,vwnd,q,temp,omega,npr,opt)
  print(q1q2)
 
  Q1percp     = q1q2[2]
  Q2percp     = q1q2[3]
  
  Q1          = q1q2[0]
  Q2          = q1q2[1]
  printVarSummary(Q1)
  printMinMax(Q1,0)
  print("================")
  printVarSummary(Q2)
  printMinMax(Q2,0)
  print("================")


;;------------------------------------------------------------------------------------------;
;---Vertical integration
; J[oule]      kg-m2/s2 = N-m = Pa/m3 = W-s       ; energy           
;;------------------------------------------------------------------------------------------;

  ptop            = 10000.0                       ; Pa
  pbot            = 100000.0
  vopt            = 1 

  g               = 9.80665                       ; [m/s2] gravity at 45 deg lat used by the WMO
  dp              = dpres_plevel_Wrap(p,pbot,ptop,0)
  dpg             = dp/g                          ; Pa/(m/s2)=> (Pa-s2)/m   
  dpg@long_name   = "Layer Mass Weighting"
  dpg@units       = "kg/m**2"               ; dp/g     => Pa/(m/s2) => [kg/(m-s2)][m/s2] reduce to (kg/m2)
                                        ;             Pa (s2/m) => [kg/(m-s2)][s2/m]=>[kg/m2]
  dpgq1           = conform(Q1,dpg,1)             ; reassign [convenience]

  Q1int           = wgt_vertical_n(Q1,dpgq1,vopt,1) ; SUM[q1*dpg]  => (K/s)(kg/m2)
  Q1int@long_name = "Apparent Heat Source: vertically integrated"
  Q1int@units     = "W/m**2"
  printVarSummary(Q1int)
  copy_VarCoords(temp(:,0,:,:),Q1int)
  printMinMax(Q1int,0)
  print("-----")

  dpgq2           = conform(Q2,dpg,1)
  
  Q2int           = wgt_vertical_n(Q2,dpgq2,vopt,1)
  Q2int@long_name = "Apparent Moisture Sink: vertically integrated"
  Q2int@units     = "W/m**2"
  copy_VarCoords(temp(:,0,:,:),Q2int)
  printMinMax(Q2int,0)
  print("-----")

;;------------------------------------------------------------------------------------------;
;---Save to a netcdf file
;;------------------------------------------------------------------------------------------;

  if (netCDF) 
      diro = "./"
      filo = "YANAI_Q1Q2__.nc"
      ptho = diro+filo
      system("/bin/rm -f "+ptho)
      ncdf = addfile(ptho,"c")
    
      fAtt = True
      fAtt@title          = "Apparent Heat Source and Moisture Sink based on Yanai et al. 1973"
      ;fAtt@source_name   = "NCEP-NCAR Reanalysis 2"
      ;fAtt@source_URL    = "https://www.esrl.noaa.gov/psd/data/gridded/data.ncep.reanalysis2.html"
      ;fAtt@source        = "NOAA/OAR/ESRL PSD, Boulder, Colorado, USA"
      fAtt@Conventions    = "None"
      fAtt@creation_date = systemfunc("date")
      fileattdef(ncdf,fAtt)            ; copy file attributes
     
      filedimdef(ncdf,"time",-1,True) ; make time an UNLIMITED dimension
      ncdf->Q1percp = Q1percp
      ncdf->Q2percp = Q2percp
	  ncdf->Q1int   = Q1int
	  ncdf->Q2int   = Q2int
  end if

;===========================================================================================;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;																							;
; Progres_v2 - last save => Wednesday, 05 Jan 2022 - 20.44 WIB (13.44 UTC)				    ;
;																							;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;===========================================================================================;