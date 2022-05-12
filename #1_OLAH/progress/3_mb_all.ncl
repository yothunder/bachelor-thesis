;===========================================================================================;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;                                                                                           ;
; Start code => Thursday, 03 Feb 2022 - 17.15 WIB (10.15 UTC)
; Last time saved => Saturday, 23 April 2022 - 20.48 WIB
;                                                                                           ;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;===========================================================================================;
;===========================================================================================;
;;------------------------------------------------------------------------------------------:
;				   Calculate Moisture Budget : use function for convenience
;;------------------------------------------------------------------------------------------:
;===========================================================================================;

begin

  start = systemfunc("date")
  print(start)

  undef("moisture_budget")
  function moisture_budget(time[*]:numeric,p,u,v,q,omega,npr[1]:integer,lat,lon,opt[1]:logical,var)
  begin
    ;;------------------------------------------------------------------------------------------:
    ; Nomenclature
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

    print("========================")
    print("Starting function moisture_budget for "+ var)
    print("")

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
        ; VIMFD           = -VIMFD                          ; Note the preceding -1 [negative precedes integration] 
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

    diri    = "../data/#/"
    f       = addfile(diri+"monmean_pressurelevel.nc","r")      ; daily mean data
                                                                ; convenience: make all:  S->N
    w       = f->w(:,::-1,::-1,:)                                ; Pascal/s
    u       = f->u(:,::-1,::-1,:)                                ; m/s
    v       = f->v(:,::-1,::-1,:)                                ; m/s
    q       = f->q(:,::-1,::-1,:)                                ; kg/kg

    lat     = f->latitude
    lon     = f->longitude
    
    ;---Convert "hours since ..." to "seconds since ..."

    time        = f->time                                   ; "hours since 1800-1-1"
    time        = time*3600                                          
    time@units  = "seconds since 1800-1-1 00:00:0.0"
    ;printVarSummary(time)
    ;print("---")
    ;ymdh        = cd_calendar(time,-3)
    ;print(ymdh)


    ;---Convert hPa -> Pa for function

    p           = f->level
    p           = p*100                                      ; Pa  [100000,...,10000]
    p@units     = "Pa"
    p!0         = "p"
    p&p         =  p                   ; not necessary
    ;printVarSummary(p)
    ;print("---")
    
  ;---Running function

    npr         = 1            ; number of dimension level
    opt         = True

    var         = "All Clim"
    mb          = moisture_budget(time,p,u,v,q,w,npr,lat,lon,opt,var) 
    dqdt        = mb[0]
    pwdt        = mb[1]
    uq          = mb[2]
    vq          = mb[3]
    iuq         = mb[4]
    ivq         = mb[5]
    mfd         = mb[6]
    vimfd       = mb[7]
    dwq         = mb[8]
    idwq        = mb[9]

  ;---Checking Metadata

    print("================")
    printVarSummary(mb)
    print("================")
    print("================")
    print(" ")
    print(" ")
    print("================")
    print("================")
    printVarSummary(dqdt)
    printMinMax(dqdt,0)
    print("================")
    printVarSummary(pwdt)
    printMinMax(pwdt,0)
    print("================")
    printVarSummary(uq)
    printMinMax(uq,0)
    print("================")
    printVarSummary(vq)
    printMinMax(vq,0)
    print("================")
    printVarSummary(iuq)
    printMinMax(iuq,0)
    print("================")
    printVarSummary(ivq)
    printMinMax(ivq,0)
    print("================")
    printVarSummary(mfd)
    printMinMax(mfd,0)
    print("================")
    printVarSummary(vimfd)
    printMinMax(vimfd,0)
    print("================")
    printVarSummary(dwq)
    printMinMax(dwq,0)
    print("================")
    printVarSummary(idwq)
    printMinMax(idwq,0)
    print("================")
    print("================")
 
  ;***********************************************
  ;---Save to a netcdf file
  ;***********************************************

    netCDF  = True                                       ; Write netCDF 

    if (netCDF)
        diro                = "./"
        filo                = "monmean_moisture_budget.nc"
        ptho                = diro+filo
        system("/bin/rm -f "+ptho)
        ncdf                = addfile(ptho,"c")
      
        fAtt = True
        fAtt@title          = "Monmean Moisture Budget"
        fAtt@source_name    = "ECMWF Reanalysis v5 (ERA5)"
        fAtt@source_URL     = "https://climate.copernicus.eu/climate-reanalysis"
        fAtt@source         = "ECMWF"
        fAtt@Conventions    = "None"
        fAtt@creation_date  = systemfunc("date")
        fileattdef(ncdf,fAtt)             ; copy file attributes
       
        filedimdef(ncdf,"time",-1,True)   ; make time an UNLIMITED dimension
        ncdf->dqdt        = dqdt
        ncdf->pwdt        = pwdt
        ncdf->uq          = uq
        ncdf->vq          = vq
        ncdf->iuq         = iuq
        ncdf->ivq         = ivq
        ncdf->mfd         = mfd
        ncdf->vimfd       = vimfd
        ncdf->dwq         = dwq
        ncdf->idwq        = idwq
    end if

  finish = systemfunc("date")
  
  print("Program start : "+ start +" ")
  print("Program end   : "+ finish +" ")
  
end