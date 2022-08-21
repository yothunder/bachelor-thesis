;===========================================================================================;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;																							;
;   Progres_v3 - first time writing code => Thursday, 03 Feb 2022 - 17.15 WIB (10.15 UTC)   ;
;																							;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;===========================================================================================;
																							;
;===========================================================================================;
;;------------------------------------------------------------------------------------------:
;				   Calculate Moisture Budget : use function for convenience					;
;;------------------------------------------------------------------------------------------:
;===========================================================================================;
																							;
undef("moisture_budget")																	;
function moisture_budget(time[*]:numeric,p,u,v,q,omega,npr[1]:integer,lat,lon,opt[1]:logical)
;;------------------------------------------------------------------------------------------:
; Nomenclature																				;
; time    - "seconds since ..."																;
; p       - Pressure [Pa]																	;
; u,v     - zonal, meridional wind components[m/s]											;
; q       - specific humidity [kg/kg]														;
; omega   - vertical velocity [Pa/s]														;
; npr     - dimension number corresponding to pressure dimension							;
; lat     - dimension corresponding to latitude dimension, used for advection and divergence;
; lon     - dimension corresponding to latitude dimension									;
; opt     - set to False																	;
;;------------------------------------------------------------------------------------------:
;																						
;  Moisture budget
;  e - c = dq/dt + {del}.[u*q, v*q] + d(omega*q)/dt
;  E - P = d<q>/dt + {del}.<[u*q, v*q]> + d<(omega*q)>/dt
;  <>    = 1/g * Int_ps->ptop(.)
;
;;------------------------------------------------------------------------------------------:

begin

;*******************************************
;---Compute local dq/dt  {(kg/kg)/s}
;*******************************************

  dqdt = center_finite_diff_n (q,time,False,0,0)   ; 'time' is 'seconds since'
  copy_VarCoords(q, dqdt)
  dqdt@longname = "Spesific humidity: Local Time derivative"
  dqdt@units = "(kg/kg)/s"
  printVarSummary(dqdt)
  printMinMax(dqdt,0)
  print("-----")  

;*******************************************
;---Compute moisture flux  {(kg/kg)/s}
;*******************************************

  uq   = u*q                                  ; (:,:,:,:)
  uq@long_name = "Zonal Moisture Flux [uq]"
  uq@units = "["+u@units+"]["+q@units+"]"     ; [m/s][kg/kg]     
  copy_VarCoords(u,uq)                        ; (time,level,lat,lon)

  vq   = v*q                                  ; (:,:,:,:)
  vq@long_name = "Meridional Moisture Flux [vq]"
  vq@units = "["+v@units+"]["+q@units+"]" 
  copy_VarCoords(v,vq)                        ; (time,level,lat,lon)

;*******************************************
;---Horizontal Divergence of moisture flux: uv2dv_cfd => regional 'fixed' rectilinear grid
;*******************************************
  
  duvq           = uv2dv_cfd(uq, vq, lat, lon, 2)    ; (time,level,lat,lon)
  duvq@long_name = "Horizontal Divergence of Moisture Flux"
  duvq@units     = "(kg/kg*s)"    ; (1/m)*[(m/s)(g/kg)] => [g/(kg-s)]

;*******************************************
;---Vertical Divergence of moisture flux: uv2dvF => global 'fixed' rectilinear grid
;*******************************************
  
  dqdp                  = center_finite_diff_n (q,p,False,1,npr)
  copy_VarCoords(q, dqdp)
  dwq                   = omega*dqdp   
  copy_VarCoords(q, dwq)  
  dwq@longname          = "Vertical Divergence of Moisture Flux"
  dwq@units             = "(kg/kg)/s"
  printVarSummary(dwq)
  printMinMax(dwq,0)
  print("-----")  

  return( [/dqdt, uq, vq, duvq, dwq/] )
end

;===========================================================================================;
;;------------------------------------------------------------------------------------------:
;                                         MAIN CODE											;
;;------------------------------------------------------------------------------------------:
;===========================================================================================;

  netCDF  = True                                       ; Write netCDF 

;---Variable and file handling

  diri    = "./"  
  f1      = addfile(diri+"#w.nc","r")    ; daily mean data 
  f2      = addfile(diri+"#u.nc","r")
  f3      = addfile(diri+"#v.nc","r")
  f4      = addfile(diri+"#q.nc","r")
                                                       ; convenience: make all:  S->N
  omega   = f1->w(:,:,::-1,:)                          ; Pascal/s
  uwnd    = f2->u(:,:,::-1,:)                          ; m/s
  vwnd    = f3->v(:,:,::-1,:)                          ; m/s
  q       = f4->q(:,:,::-1,:)                          ; kg/kg   

  lat     = f1->lat
  lon     = f1->lon
  
;---Convert "hours since ..." to "seconds since ..."

  time        = f4->time                                   ; "hours since 1800-1-1"
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
  
;++++++++++++++++++++++++++++++++++++++++++++++++++++++

  npr         = 1            ; number of dimension level
  nlat        = 2
  nlon        = 3
  opt         = True
  mb          = moisture_budget(time,p,uwnd,vwnd,q,omega,npr,lat,lon,opt)
  print(mb)
 
  dqdt        = mb[0]
  uq          = mb[1]
  vq          = mb[2]
  duvq        = mb[3]
  dwq         = mb[4]

  print("================")

  print("================")


;********************************************
;---Vertical integration
; J[oule]      kg-m2/s2 = N-m = Pa/m3 = W-s       ; energy           
;********************************************

  ptop            = 10000.0                       ; Pa
  pbot            = 100000.0
  vopt            = 1                             ; weighted vertical sum

  g               = 9.80665                       ; [m/s2] gravity at 45 deg lat used by the WMO
  dp              = dpres_plevel_Wrap(p,pbot,ptop,0)
  dpg             = dp/g                          ; Pa/(m/s2)=> (Pa-s2)/m   
  dpg@long_name   = "Layer Mass Weighting"
  dpg@units       = "kg/m**2"               ; dp/g     => Pa/(m/s2) => [kg/(m-s2)][m/s2] reduce to (kg/m2)
                                        ;             Pa (s2/m) => [kg/(m-s2)][s2/m]=>[kg/m2]
										
;-Precipitable water tendency

  dpgq            = conform(q,dpg,1)
  pw              = wgt_vertical_n(q,dpgq,vopt,1)
  copy_VarCoords(q(:,0,:,:),pw)
  pw@long_name	  = "Precipitable water"
  pw@units		  = "kg/m**2"
  
  pwdt            = center_finite_diff_n (pw,time,False,0,0)
  copy_VarCoords(q(:,0,:,:),pwdt)
  pwdt@long_name  = "Precipitable water tendency"
  pwdt@units      = "(kg/m**2)/s"
  pwdt@info       = "Term 1 in moisture budget eq."    
  
  delete(pw)
  
;-Vertically Integrated Horizontal Moisture flux

  uq_dpg          = uq*dpgq                ; mass weighted 'uq'; [m/s][g/kg][kg/m2]=>[m/s][g/kg]
  iuq             = dim_sum_n(uq_dpg, 1)
  iuq@long_name   = "Integrated Zonal UQ [uq*dpg]" 
  iuq@LONG_NAME   = "Sum: Mass Weighted Integrated Zonal Moisture Flux [uq*dpg]" 
  iuq@units       = "[m/s][g/kg]"
  copy_VarCoords(uwnd(:,0,:,:), iuq)         ; (time,lat,lon)
  delete(uq_dpg)

  vq_dpg          = vq*dpgq                ; mass weighted 'vq'; [m/s][g/kg][kg/m2]=>[m/s][g/kg] 
  ivq             = dim_sum_n(vq_dpg, 1)
  ivq@long_name   = "Integrated Meridional VQ [vq*dpg]" 
  ivq@LONG_NAME   = "Sum: Mass Weighted Integrated Meridional Moisture Flux [vq*dpg]" 
  ivq@units       = "[m/s][g/kg]"
  copy_VarCoords(vwnd(:,0,:,:), ivq)         ; (time,lat,lon)
  delete(vq_dpg)
  
;-Vertically Integrated Horizontal Moisture flux Divergence

  duvq_dpg        = duvq*dpgq             ;  [g/(kg-s)][kg/m2] => [g/(m2-s)]
  iduvq           = dim_sum_n(duvq_dpg, 1)
  iduvq@long_name = "Integrated Mass Wgt MFD" 
  iduvq@LONG_NAME = "Integrated Mass Weighted Moisture Flux Divergence" 
  iduvq@units     = "(kg/m**2)/s"
  copy_VarCoords(uwnd(:,0,:,:), iduvq)      ; (time,lat,lon)
  delete(duvq_dpg)

  VIMFD           =  iduvq               ; keep meta data                         
; VIMFD           = -VIMFD               ; Note the preceding -1 [negative precedes integration] 
  VIMFD@long_name = "Vertically Integrated Moisture Flux Divergence"
  VIMFD@units     = "(kg/m**2)/s"
  VIMFD@info      = "Term 2 in moisture budget eq."
  
;-Vertically Integrated Vertical Moisture flux Divergence

  dpgdwq          = conform(dwq,dpg,1)
  idwq            = wgt_vertical_n(dwq,dpgdwq,vopt,1)
  copy_VarCoords(q(:,0,:,:),idwq)
  idwq@long_name  = "Integrated vertical moisture flux divergence"
  idwq@units      = "(kg/m**2)/s"
  idwq@info       = "Term 3 in moisture budget eq."
  
;***********************************************
;---Save to a netcdf file
;***********************************************

  if (netCDF) 
      diro = "./"
      filo = "moisture_budget.nc"
      ptho = diro+filo
      system("/bin/rm -f "+ptho)
      ncdf = addfile(ptho,"c")
    
      fAtt = True
      fAtt@title          = "Moisture Budget"
      ;fAtt@source_name   = "NCEP-NCAR Reanalysis 2"
      ;fAtt@source_URL    = "https://www.esrl.noaa.gov/psd/data/gridded/data.ncep.reanalysis2.html"
      ;fAtt@source        = "NOAA/OAR/ESRL PSD, Boulder, Colorado, USA"
      fAtt@Conventions    = "None"
      fAtt@creation_date = systemfunc("date")
      fileattdef(ncdf,fAtt)            ; copy file attributes
     
      filedimdef(ncdf,"time",-1,True) ; make time an UNLIMITED dimension
      ncdf->pwdt    = pwdt
      ncdf->iuq     = iuq
	  ncdf->ivq     = ivq
	  ncdf->VIMFD   = VIMFD
	  ncdf->idwq    = idwq
  end if

;===========================================================================================;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;																							;
; Progres_v3 - last save => Wednesday, 05 Jan 2022 - 20.44 WIB (13.44 UTC)				    ;
;																							;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;===========================================================================================;