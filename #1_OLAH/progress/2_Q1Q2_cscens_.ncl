;===========================================================================================;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;                                                                                           ;
; Start code => Friday, 13 May 2022 - 12.39 WIB
; Last time saved => Sat, 14 May 2022 - 08.57 WIB [done]
;                                                                                           ;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;===========================================================================================;


  
  start = systemfunc("date")
  print(start)
  start_read_time = get_cpu_time()

  ;===========================================================================================;
  ;;------------------------------------------------------------------------------------------;
  ;					Calculate Q1Q2 : use function for convenience
  ;;------------------------------------------------------------------------------------------;
  ;===========================================================================================;

  undef("Q1Q2_yanai")
  function Q1Q2_yanai(time[*]:numeric,p,u,v,H,T,omega,lat,lon,npr[1]:integer,opt[1]:logical, var:string, lag:string)
  begin

    print("========================")
    print("Starting function Q1Q2_yanai for "+ var +" lag "+ lag)
    print("")

    ;;Nomenclature------------------------------------------------------------------------------;	
      ; 
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

      ;;Use for error testing
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
      dHdp@long_name            = "Specific Humidity: Local Vertical Derivative"
      dHdp@units               = "(kg/kg*Pa)"   
      ;printVarSummary(dHdp)
      ;printMinMax(dHdp,0)
      ;print("-----")

      dHdp                     = omega*dHdp               ; overwrite ... convenience
      dHdp@long_name            = "Specific Humidity: Vertical Moisture Transport"
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

      Q1intavg = dim_avg_n(Q1int,0)
      Q2intavg = dim_avg_n(Q2int,0)
      Q1percpavg = dim_avg_n(Q1percp,0)
      Q2percpavg = dim_avg_n(Q2percp,0)
      Q1intvar = dim_variance_n(Q1int,0)
      Q2intvar = dim_variance_n(Q2int,0)
      Q1percpvar = dim_variance_n(Q1percp,0)
      Q2percpvar = dim_variance_n(Q2percp,0)

    print("")
    print("Function Q1Q2_yanai for "+ var +" is done")
    print("========================")

    return( [/Q1intavg, Q2intavg, Q1percpavg, Q2percpavg, Q1intvar, Q2intvar, Q1percpvar, Q2percpvar/] )
  end

  ;===========================================================================================;
  ;;------------------------------------------------------------------------------------------;
  ;                                         MAIN CODE
  ;;------------------------------------------------------------------------------------------;
  ;===========================================================================================;


  ;---Command control

    diri        = "../data/#/"

    CS          = False
    CENS        = False
    netCDF      = True
    npr         = 1            ; number of dimension level
    opt         = True

  ;---Running function

    ;---For CS

    if (CS)

      fucs        = addfile(diri+"varsel_pressurelevel_cs_u.nc","r")      ; daily mean data
      fvcs        = addfile(diri+"varsel_pressurelevel_cs_v.nc","r")      ; daily mean data
      fwcs        = addfile(diri+"varsel_pressurelevel_cs_w.nc","r")      ; daily mean data
      ftcs        = addfile(diri+"varsel_pressurelevel_cs_t.nc","r")      ; daily mean data
      fqcs        = addfile(diri+"varsel_pressurelevel_cs_q.nc","r")      ; daily mean data
                                                                  ; convenience: make all:  S->N
      ucs = ([/ fucs->ucs1(:,:,::-1,:), fucs->ucs2(:,:,::-1,:), fucs->ucs3(:,:,::-1,:), fucs->ucs4(:,:,::-1,:), fucs->ucs5(:,:,::-1,:), fucs->ucs6(:,:,::-1,:), fucs->ucs7(:,:,::-1,:), fucs->ucs8(:,:,::-1,:), fucs->ucs9(:,:,::-1,:), fucs->ucs10(:,:,::-1,:), fucs->ucs11(:,:,::-1,:), fucs->ucs12(:,:,::-1,:), fucs->ucs13(:,:,::-1,:), fucs->ucs14(:,:,::-1,:), fucs->ucs15(:,:,::-1,:), fucs->ucs16(:,:,::-1,:), fucs->ucs17(:,:,::-1,:), fucs->ucs18(:,:,::-1,:), fucs->ucs19(:,:,::-1,:), fucs->ucs20(:,:,::-1,:), fucs->ucs21(:,:,::-1,:) /])
      vcs = ([/ fvcs->vcs1(:,:,::-1,:), fvcs->vcs2(:,:,::-1,:), fvcs->vcs3(:,:,::-1,:), fvcs->vcs4(:,:,::-1,:), fvcs->vcs5(:,:,::-1,:), fvcs->vcs6(:,:,::-1,:), fvcs->vcs7(:,:,::-1,:), fvcs->vcs8(:,:,::-1,:), fvcs->vcs9(:,:,::-1,:), fvcs->vcs10(:,:,::-1,:), fvcs->vcs11(:,:,::-1,:), fvcs->vcs12(:,:,::-1,:), fvcs->vcs13(:,:,::-1,:), fvcs->vcs14(:,:,::-1,:), fvcs->vcs15(:,:,::-1,:), fvcs->vcs16(:,:,::-1,:), fvcs->vcs17(:,:,::-1,:), fvcs->vcs18(:,:,::-1,:), fvcs->vcs19(:,:,::-1,:), fvcs->vcs20(:,:,::-1,:), fvcs->vcs21(:,:,::-1,:) /])
      wcs = ([/ fwcs->wcs1(:,:,::-1,:), fwcs->wcs2(:,:,::-1,:), fwcs->wcs3(:,:,::-1,:), fwcs->wcs4(:,:,::-1,:), fwcs->wcs5(:,:,::-1,:), fwcs->wcs6(:,:,::-1,:), fwcs->wcs7(:,:,::-1,:), fwcs->wcs8(:,:,::-1,:), fwcs->wcs9(:,:,::-1,:), fwcs->wcs10(:,:,::-1,:), fwcs->wcs11(:,:,::-1,:), fwcs->wcs12(:,:,::-1,:), fwcs->wcs13(:,:,::-1,:), fwcs->wcs14(:,:,::-1,:), fwcs->wcs15(:,:,::-1,:), fwcs->wcs16(:,:,::-1,:), fwcs->wcs17(:,:,::-1,:), fwcs->wcs18(:,:,::-1,:), fwcs->wcs19(:,:,::-1,:), fwcs->wcs20(:,:,::-1,:), fwcs->wcs21(:,:,::-1,:) /])
      tcs = ([/ ftcs->tcs1(:,:,::-1,:), ftcs->tcs2(:,:,::-1,:), ftcs->tcs3(:,:,::-1,:), ftcs->tcs4(:,:,::-1,:), ftcs->tcs5(:,:,::-1,:), ftcs->tcs6(:,:,::-1,:), ftcs->tcs7(:,:,::-1,:), ftcs->tcs8(:,:,::-1,:), ftcs->tcs9(:,:,::-1,:), ftcs->tcs10(:,:,::-1,:), ftcs->tcs11(:,:,::-1,:), ftcs->tcs12(:,:,::-1,:), ftcs->tcs13(:,:,::-1,:), ftcs->tcs14(:,:,::-1,:), ftcs->tcs15(:,:,::-1,:), ftcs->tcs16(:,:,::-1,:), ftcs->tcs17(:,:,::-1,:), ftcs->tcs18(:,:,::-1,:), ftcs->tcs19(:,:,::-1,:), ftcs->tcs20(:,:,::-1,:), ftcs->tcs21(:,:,::-1,:) /])
      qcs = ([/ fqcs->qcs1(:,:,::-1,:), fqcs->qcs2(:,:,::-1,:), fqcs->qcs3(:,:,::-1,:), fqcs->qcs4(:,:,::-1,:), fqcs->qcs5(:,:,::-1,:), fqcs->qcs6(:,:,::-1,:), fqcs->qcs7(:,:,::-1,:), fqcs->qcs8(:,:,::-1,:), fqcs->qcs9(:,:,::-1,:), fqcs->qcs10(:,:,::-1,:), fqcs->qcs11(:,:,::-1,:), fqcs->qcs12(:,:,::-1,:), fqcs->qcs13(:,:,::-1,:), fqcs->qcs14(:,:,::-1,:), fqcs->qcs15(:,:,::-1,:), fqcs->qcs16(:,:,::-1,:), fqcs->qcs17(:,:,::-1,:), fqcs->qcs18(:,:,::-1,:), fqcs->qcs19(:,:,::-1,:), fqcs->qcs20(:,:,::-1,:), fqcs->qcs21(:,:,::-1,:) /])
      
      timelag       = ispan(0,20,1)
      timelag@units = "days since 2010-01-01 00:00:0.0"
      lev         = ucs[0]&lev
      lat         = ucs[0]&lat
      lon         = ucs[0]&lon
      nlag        = dimsizes(timelag)
      nlev        = dimsizes(lev)
      nlat        = dimsizes(lat)
      nlon        = dimsizes(lon)

      ;---Convert "hours since ..." to "seconds since ..."

      time        = fucs->time                                   ; "hours since 1800-1-1"
      time        = time*24*3600                                          
      time@units  = "seconds since 1800-1-1 00:00:0.0"
      ;printVarSummary(time)
      ;print("---")
      ymdh        = cd_calendar(time,-3)
      ;print(ymdh)

      ;---Convert hPa -> Pa for function

      p           = fucs->lev
      p           = p*100                                      ; Pa  [100000,...,10000]
      p@units     = "Pa"
      p!0         = "p"
      p&p         =  p                   ; not necessary
      ;printVarSummary(p)
      ;print("---")

      ;---Running function

      var         = "CS"
      q1q2cs1      = Q1Q2_yanai(time,p,ucs[0],vcs[0],qcs[0],tcs[0],wcs[0],lat,lon,npr,opt,var,"1")
      q1q2cs2      = Q1Q2_yanai(time,p,ucs[1],vcs[1],qcs[1],tcs[1],wcs[1],lat,lon,npr,opt,var,"2")
      q1q2cs3      = Q1Q2_yanai(time,p,ucs[2],vcs[2],qcs[2],tcs[2],wcs[2],lat,lon,npr,opt,var,"3")
      q1q2cs4      = Q1Q2_yanai(time,p,ucs[3],vcs[3],qcs[3],tcs[3],wcs[3],lat,lon,npr,opt,var,"4")
      q1q2cs5      = Q1Q2_yanai(time,p,ucs[4],vcs[4],qcs[4],tcs[4],wcs[4],lat,lon,npr,opt,var,"5")
      q1q2cs6      = Q1Q2_yanai(time,p,ucs[5],vcs[5],qcs[5],tcs[5],wcs[5],lat,lon,npr,opt,var,"6")
      q1q2cs7      = Q1Q2_yanai(time,p,ucs[6],vcs[6],qcs[6],tcs[6],wcs[6],lat,lon,npr,opt,var,"7")
      q1q2cs8      = Q1Q2_yanai(time,p,ucs[7],vcs[7],qcs[7],tcs[7],wcs[7],lat,lon,npr,opt,var,"8")
      q1q2cs9      = Q1Q2_yanai(time,p,ucs[8],vcs[8],qcs[8],tcs[8],wcs[8],lat,lon,npr,opt,var,"9")
      q1q2cs10      = Q1Q2_yanai(time,p,ucs[9],vcs[9],qcs[9],tcs[9],wcs[9],lat,lon,npr,opt,var,"10")
      q1q2cs11      = Q1Q2_yanai(time,p,ucs[10],vcs[10],qcs[10],tcs[10],wcs[10],lat,lon,npr,opt,var,"11")
      q1q2cs12      = Q1Q2_yanai(time,p,ucs[11],vcs[11],qcs[11],tcs[11],wcs[11],lat,lon,npr,opt,var,"12")
      q1q2cs13      = Q1Q2_yanai(time,p,ucs[12],vcs[12],qcs[12],tcs[12],wcs[12],lat,lon,npr,opt,var,"13")
      q1q2cs14      = Q1Q2_yanai(time,p,ucs[13],vcs[13],qcs[13],tcs[13],wcs[13],lat,lon,npr,opt,var,"14")
      q1q2cs15      = Q1Q2_yanai(time,p,ucs[14],vcs[14],qcs[14],tcs[14],wcs[14],lat,lon,npr,opt,var,"15")
      q1q2cs16      = Q1Q2_yanai(time,p,ucs[15],vcs[15],qcs[15],tcs[15],wcs[15],lat,lon,npr,opt,var,"16")
      q1q2cs17      = Q1Q2_yanai(time,p,ucs[16],vcs[16],qcs[16],tcs[16],wcs[16],lat,lon,npr,opt,var,"17")
      q1q2cs18      = Q1Q2_yanai(time,p,ucs[17],vcs[17],qcs[17],tcs[17],wcs[17],lat,lon,npr,opt,var,"18")
      q1q2cs19      = Q1Q2_yanai(time,p,ucs[18],vcs[18],qcs[18],tcs[18],wcs[18],lat,lon,npr,opt,var,"19")
      q1q2cs20      = Q1Q2_yanai(time,p,ucs[19],vcs[19],qcs[19],tcs[19],wcs[19],lat,lon,npr,opt,var,"20")
      q1q2cs21      = Q1Q2_yanai(time,p,ucs[20],vcs[20],qcs[20],tcs[20],wcs[20],lat,lon,npr,opt,var,"21")

      print("Begin array manipulation")

      q1intcsavg  = ([/ q1q2cs1[0], q1q2cs2[0], q1q2cs3[0], q1q2cs4[0], q1q2cs5[0], q1q2cs6[0], q1q2cs7[0], q1q2cs8[0], q1q2cs9[0], q1q2cs10[0], q1q2cs11[0], q1q2cs12[0], q1q2cs13[0], q1q2cs14[0], q1q2cs15[0], q1q2cs16[0], q1q2cs17[0], q1q2cs18[0], q1q2cs19[0], q1q2cs20[0], q1q2cs21[0] /])
      q2intcsavg  = ([/ q1q2cs1[1], q1q2cs2[1], q1q2cs3[1], q1q2cs4[1], q1q2cs5[1], q1q2cs6[1], q1q2cs7[1], q1q2cs8[1], q1q2cs9[1], q1q2cs10[1], q1q2cs11[1], q1q2cs12[1], q1q2cs13[1], q1q2cs14[1], q1q2cs15[1], q1q2cs16[1], q1q2cs17[1], q1q2cs18[1], q1q2cs19[1], q1q2cs20[1], q1q2cs21[1] /])
      q1pcpcsavg  = ([/ q1q2cs1[2], q1q2cs2[2], q1q2cs3[2], q1q2cs4[2], q1q2cs5[2], q1q2cs6[2], q1q2cs7[2], q1q2cs8[2], q1q2cs9[2], q1q2cs10[2], q1q2cs11[2], q1q2cs12[2], q1q2cs13[2], q1q2cs14[2], q1q2cs15[2], q1q2cs16[2], q1q2cs17[2], q1q2cs18[2], q1q2cs19[2], q1q2cs20[2], q1q2cs21[2] /])
      q2pcpcsavg  = ([/ q1q2cs1[3], q1q2cs2[3], q1q2cs3[3], q1q2cs4[3], q1q2cs5[3], q1q2cs6[3], q1q2cs7[3], q1q2cs8[3], q1q2cs9[3], q1q2cs10[3], q1q2cs11[3], q1q2cs12[3], q1q2cs13[3], q1q2cs14[3], q1q2cs15[3], q1q2cs16[3], q1q2cs17[3], q1q2cs18[3], q1q2cs19[3], q1q2cs20[3], q1q2cs21[3] /])

      q1intcsvar  = ([/ q1q2cs1[4], q1q2cs2[4], q1q2cs3[4], q1q2cs4[4], q1q2cs5[4], q1q2cs6[4], q1q2cs7[4], q1q2cs8[4], q1q2cs9[4], q1q2cs10[4], q1q2cs11[4], q1q2cs12[4], q1q2cs13[4], q1q2cs14[4], q1q2cs15[4], q1q2cs16[4], q1q2cs17[4], q1q2cs18[4], q1q2cs19[4], q1q2cs20[4], q1q2cs21[4] /])
      q2intcsvar  = ([/ q1q2cs1[5], q1q2cs2[5], q1q2cs3[5], q1q2cs4[5], q1q2cs5[5], q1q2cs6[5], q1q2cs7[5], q1q2cs8[5], q1q2cs9[5], q1q2cs10[5], q1q2cs11[5], q1q2cs12[5], q1q2cs13[5], q1q2cs14[5], q1q2cs15[5], q1q2cs16[5], q1q2cs17[5], q1q2cs18[5], q1q2cs19[5], q1q2cs20[5], q1q2cs21[5] /])
      q1pcpcsvar  = ([/ q1q2cs1[6], q1q2cs2[6], q1q2cs3[6], q1q2cs4[6], q1q2cs5[6], q1q2cs6[6], q1q2cs7[6], q1q2cs8[6], q1q2cs9[6], q1q2cs10[6], q1q2cs11[6], q1q2cs12[6], q1q2cs13[6], q1q2cs14[6], q1q2cs15[6], q1q2cs16[6], q1q2cs17[6], q1q2cs18[6], q1q2cs19[6], q1q2cs20[6], q1q2cs21[6] /])
      q2pcpcsvar  = ([/ q1q2cs1[7], q1q2cs2[7], q1q2cs3[7], q1q2cs4[7], q1q2cs5[7], q1q2cs6[7], q1q2cs7[7], q1q2cs8[7], q1q2cs9[7], q1q2cs10[7], q1q2cs11[7], q1q2cs12[7], q1q2cs13[7], q1q2cs14[7], q1q2cs15[7], q1q2cs16[7], q1q2cs17[7], q1q2cs18[7], q1q2cs19[7], q1q2cs20[7], q1q2cs21[7] /])
      
      mergeq1intcsavg                    = new((/nlag, nlat, nlon/), typeof(q1intcsavg[0]), q1intcsavg[0]@_FillValue)
      mergeq1intcsavgcp                  = new((/nlag, nlat, nlon/), typeof(q1intcsavg[0]), q1intcsavg[0]@_FillValue)
      do i = 0, 20
        variabelq1intcsavg                        = q1intcsavg[i]
        mergeq1intcsavgcp(0:0,:,:)      = (/ variabelq1intcsavg /)
        variabelq1intcsavg                       := mergeq1intcsavgcp(0:0,:,:)
        mergeq1intcsavg(i,:,:)          = variabelq1intcsavg
      end do
      printVarSummary(mergeq1intcsavg)

      mergeq2intcsavg                    = new((/nlag, nlat, nlon/), typeof(q2intcsavg[0]), q2intcsavg[0]@_FillValue)
      mergeq2intcsavgcp                  = new((/nlag, nlat, nlon/), typeof(q2intcsavg[0]), q2intcsavg[0]@_FillValue)
      do i = 0, 20
        variabelq2intcsavg                        = q2intcsavg[i]
        mergeq2intcsavgcp(0:0,:,:)      = (/ variabelq2intcsavg /)
        variabelq2intcsavg                       := mergeq2intcsavgcp(0:0,:,:)
        mergeq2intcsavg(i,:,:)          = variabelq2intcsavg
      end do
      printVarSummary(mergeq2intcsavg)

      mergeq1pcpcsavg                    = new((/nlag, nlev, nlat, nlon/), typeof(q1pcpcsavg[0]), q1pcpcsavg[0]@_FillValue)
      mergeq1pcpcsavgcp                  = new((/nlag, nlev, nlat, nlon/), typeof(q1pcpcsavg[0]), q1pcpcsavg[0]@_FillValue)
      do i = 0, 20
        variabelq1pcpcsavg                        = q1pcpcsavg[i]
        mergeq1pcpcsavgcp(0:0,:,:,:)      = (/ variabelq1pcpcsavg /)
        variabelq1pcpcsavg                       := mergeq1pcpcsavgcp(0:0,:,:,:)
        mergeq1pcpcsavg(i,:,:,:)          = variabelq1pcpcsavg
      end do
      printVarSummary(mergeq1pcpcsavg)

      mergeq2pcpcsavg                    = new((/nlag, nlev, nlat, nlon/), typeof(q1pcpcsavg[0]), q1pcpcsavg[0]@_FillValue)
      mergeq2pcpcsavgcp                  = new((/nlag, nlev, nlat, nlon/), typeof(q1pcpcsavg[0]), q1pcpcsavg[0]@_FillValue)
      do i = 0, 20
        variabelq1pcpcsavg                        = q1pcpcsavg[i]
        mergeq2pcpcsavgcp(0:0,:,:,:)      = (/ variabelq1pcpcsavg /)
        variabelq1pcpcsavg                       := mergeq2pcpcsavgcp(0:0,:,:,:)
        mergeq1pcpcsavg(i,:,:,:)          = variabelq1pcpcsavg
      end do
      printVarSummary(mergeq2pcpcsavg)

      mergeq1intcsvar                    = new((/nlag, nlat, nlon/), typeof(q1intcsvar[0]), q1intcsvar[0]@_FillValue)
      mergeq1intcsvarcp                  = new((/nlag, nlat, nlon/), typeof(q1intcsvar[0]), q1intcsvar[0]@_FillValue)
      do i = 0, 20
        variabelq1intcsvar                        = q1intcsvar[i]
        mergeq1intcsvarcp(0:0,:,:)      = (/ variabelq1intcsvar /)
        variabelq1intcsvar                       := mergeq1intcsvarcp(0:0,:,:)
        mergeq1intcsvar(i,:,:)          = variabelq1intcsvar
      end do
      printVarSummary(mergeq1intcsvar)

      mergeq2intcsvar                    = new((/nlag, nlat, nlon/), typeof(q2intcsvar[0]), q2intcsvar[0]@_FillValue)
      mergeq2intcsvarcp                  = new((/nlag, nlat, nlon/), typeof(q2intcsvar[0]), q2intcsvar[0]@_FillValue)
      do i = 0, 20
        variabelq2intcsvar                        = q2intcsvar[i]
        mergeq2intcsvarcp(0:0,:,:)      = (/ variabelq2intcsvar /)
        variabelq2intcsvar                       := mergeq2intcsvarcp(0:0,:,:)
        mergeq2intcsvar(i,:,:)          = variabelq2intcsvar
      end do
      printVarSummary(mergeq2intcsvar)

      mergeq1pcpcsvar                    = new((/nlag, nlev, nlat, nlon/), typeof(q1pcpcsvar[0]), q1pcpcsvar[0]@_FillValue)
      mergeq1pcpcsvarcp                  = new((/nlag, nlev, nlat, nlon/), typeof(q1pcpcsvar[0]), q1pcpcsvar[0]@_FillValue)
      do i = 0, 20
        variabelq1pcpcsvar                        = q1pcpcsvar[i]
        mergeq1pcpcsvarcp(0:0,:,:,:)      = (/ variabelq1pcpcsvar /)
        variabelq1pcpcsvar                       := mergeq1pcpcsvarcp(0:0,:,:,:)
        mergeq1pcpcsvar(i,:,:,:)          = variabelq1pcpcsvar
      end do
      printVarSummary(mergeq1pcpcsvar)

      mergeq2pcpcsvar                    = new((/nlag, nlev, nlat, nlon/), typeof(q1pcpcsvar[0]), q1pcpcsvar[0]@_FillValue)
      mergeq2pcpcsvarcp                  = new((/nlag, nlev, nlat, nlon/), typeof(q1pcpcsvar[0]), q1pcpcsvar[0]@_FillValue)
      do i = 0, 20
        variabelq1pcpcsvar                        = q1pcpcsvar[i]
        mergeq2pcpcsvarcp(0:0,:,:,:)      = (/ variabelq1pcpcsvar /)
        variabelq1pcpcsvar                       := mergeq2pcpcsvarcp(0:0,:,:,:)
        mergeq1pcpcsvar(i,:,:,:)          = variabelq1pcpcsvar
      end do
      printVarSummary(mergeq2pcpcsvar)

      mergeq1pcpcsavg!0 = "timelag"
      mergeq1pcpcsavg!1 = "lev"
      mergeq1pcpcsavg!2 = "lat"
      mergeq1pcpcsavg!3 = "lon"
      mergeq1pcpcsavg&timelag = timelag
      mergeq1pcpcsavg&lev     = lev
      mergeq1pcpcsavg&lat     = lat
      mergeq1pcpcsavg&lon     = lon
      mergeq1pcpcsavg@long_name = "Q1/cp: Apparent Heating rate"
      mergeq1pcpcsavg@units     = "K/day"

      copy_VarCoords(mergeq1pcpcsavg, mergeq2pcpcsavg)
      mergeq2pcpcsavg@long_name = "Q2/cp: Apparent Drying rate"
      mergeq2pcpcsavg@units     = "K/day"

      copy_VarMeta(mergeq1pcpcsavg, mergeq1pcpcsvar)
      copy_VarMeta(mergeq2pcpcsavg, mergeq2pcpcsvar)


      mergeq1intcsavg!0 = "timelag"
      mergeq1intcsavg!1 = "lat"
      mergeq1intcsavg!2 = "lon"
      mergeq1intcsavg&timelag = timelag
      mergeq1intcsavg&lat     = lat
      mergeq1intcsavg&lon     = lon
      mergeq1intcsavg@long_name = "<Q1>: Vertically Integrated Apparent Heat Source"
      mergeq1intcsavg@units     = "W/m**2"

      copy_VarCoords(mergeq1intcsavg, mergeq2intcsavg)
      mergeq2pcpcsavg@long_name = "<Q1>: Vertically Integrated Moisture Sink"
      mergeq2pcpcsavg@units     = "W/m**2"

      copy_VarMeta(mergeq1intcsavg, mergeq1intcsvar)
      copy_VarMeta(mergeq2intcsavg, mergeq2intcsvar)
      copy_VarMeta(mergeq1pcpcsavg, mergeq1pcpcsvar)
      copy_VarMeta(mergeq2pcpcsavg, mergeq2pcpcsvar)

      printVarSummary(mergeq1intcsavg)
      printVarSummary(mergeq2intcsavg)
      printVarSummary(mergeq1pcpcsavg)
      printVarSummary(mergeq2pcpcsavg)
      printVarSummary(mergeq1intcsvar)
      printVarSummary(mergeq2intcsvar)
      printVarSummary(mergeq1pcpcsvar)
      printVarSummary(mergeq2pcpcsvar)

    end if

    ;---For CENS
    if (CENS)

      fucens        = addfile(diri+"varsel_pressurelevel_cens_u.nc","r")      ; daily mean data
      fvcens        = addfile(diri+"varsel_pressurelevel_cens_v.nc","r")      ; daily mean data
      fwcens        = addfile(diri+"varsel_pressurelevel_cens_w.nc","r")      ; daily mean data
      ftcens        = addfile(diri+"varsel_pressurelevel_cens_t.nc","r")      ; daily mean data
      fqcens        = addfile(diri+"varsel_pressurelevel_cens_q.nc","r")      ; daily mean data
                                                                  ; convenience: make all:  S->N
      ucens = ([/ fucens->ucens1(:,:,::-1,:), fucens->ucens2(:,:,::-1,:), fucens->ucens3(:,:,::-1,:), fucens->ucens4(:,:,::-1,:), fucens->ucens5(:,:,::-1,:), fucens->ucens6(:,:,::-1,:), fucens->ucens7(:,:,::-1,:), fucens->ucens8(:,:,::-1,:), fucens->ucens9(:,:,::-1,:), fucens->ucens10(:,:,::-1,:), fucens->ucens11(:,:,::-1,:), fucens->ucens12(:,:,::-1,:), fucens->ucens13(:,:,::-1,:), fucens->ucens14(:,:,::-1,:), fucens->ucens15(:,:,::-1,:), fucens->ucens16(:,:,::-1,:), fucens->ucens17(:,:,::-1,:), fucens->ucens18(:,:,::-1,:), fucens->ucens19(:,:,::-1,:), fucens->ucens20(:,:,::-1,:), fucens->ucens21(:,:,::-1,:) /])
      vcens = ([/ fvcens->vcens1(:,:,::-1,:), fvcens->vcens2(:,:,::-1,:), fvcens->vcens3(:,:,::-1,:), fvcens->vcens4(:,:,::-1,:), fvcens->vcens5(:,:,::-1,:), fvcens->vcens6(:,:,::-1,:), fvcens->vcens7(:,:,::-1,:), fvcens->vcens8(:,:,::-1,:), fvcens->vcens9(:,:,::-1,:), fvcens->vcens10(:,:,::-1,:), fvcens->vcens11(:,:,::-1,:), fvcens->vcens12(:,:,::-1,:), fvcens->vcens13(:,:,::-1,:), fvcens->vcens14(:,:,::-1,:), fvcens->vcens15(:,:,::-1,:), fvcens->vcens16(:,:,::-1,:), fvcens->vcens17(:,:,::-1,:), fvcens->vcens18(:,:,::-1,:), fvcens->vcens19(:,:,::-1,:), fvcens->vcens20(:,:,::-1,:), fvcens->vcens21(:,:,::-1,:) /])
      wcens = ([/ fwcens->wcens1(:,:,::-1,:), fwcens->wcens2(:,:,::-1,:), fwcens->wcens3(:,:,::-1,:), fwcens->wcens4(:,:,::-1,:), fwcens->wcens5(:,:,::-1,:), fwcens->wcens6(:,:,::-1,:), fwcens->wcens7(:,:,::-1,:), fwcens->wcens8(:,:,::-1,:), fwcens->wcens9(:,:,::-1,:), fwcens->wcens10(:,:,::-1,:), fwcens->wcens11(:,:,::-1,:), fwcens->wcens12(:,:,::-1,:), fwcens->wcens13(:,:,::-1,:), fwcens->wcens14(:,:,::-1,:), fwcens->wcens15(:,:,::-1,:), fwcens->wcens16(:,:,::-1,:), fwcens->wcens17(:,:,::-1,:), fwcens->wcens18(:,:,::-1,:), fwcens->wcens19(:,:,::-1,:), fwcens->wcens20(:,:,::-1,:), fwcens->wcens21(:,:,::-1,:) /])
      tcens = ([/ ftcens->tcens1(:,:,::-1,:), ftcens->tcens2(:,:,::-1,:), ftcens->tcens3(:,:,::-1,:), ftcens->tcens4(:,:,::-1,:), ftcens->tcens5(:,:,::-1,:), ftcens->tcens6(:,:,::-1,:), ftcens->tcens7(:,:,::-1,:), ftcens->tcens8(:,:,::-1,:), ftcens->tcens9(:,:,::-1,:), ftcens->tcens10(:,:,::-1,:), ftcens->tcens11(:,:,::-1,:), ftcens->tcens12(:,:,::-1,:), ftcens->tcens13(:,:,::-1,:), ftcens->tcens14(:,:,::-1,:), ftcens->tcens15(:,:,::-1,:), ftcens->tcens16(:,:,::-1,:), ftcens->tcens17(:,:,::-1,:), ftcens->tcens18(:,:,::-1,:), ftcens->tcens19(:,:,::-1,:), ftcens->tcens20(:,:,::-1,:), ftcens->tcens21(:,:,::-1,:) /])
      qcens = ([/ fqcens->qcens1(:,:,::-1,:), fqcens->qcens2(:,:,::-1,:), fqcens->qcens3(:,:,::-1,:), fqcens->qcens4(:,:,::-1,:), fqcens->qcens5(:,:,::-1,:), fqcens->qcens6(:,:,::-1,:), fqcens->qcens7(:,:,::-1,:), fqcens->qcens8(:,:,::-1,:), fqcens->qcens9(:,:,::-1,:), fqcens->qcens10(:,:,::-1,:), fqcens->qcens11(:,:,::-1,:), fqcens->qcens12(:,:,::-1,:), fqcens->qcens13(:,:,::-1,:), fqcens->qcens14(:,:,::-1,:), fqcens->qcens15(:,:,::-1,:), fqcens->qcens16(:,:,::-1,:), fqcens->qcens17(:,:,::-1,:), fqcens->qcens18(:,:,::-1,:), fqcens->qcens19(:,:,::-1,:), fqcens->qcens20(:,:,::-1,:), fqcens->qcens21(:,:,::-1,:) /])
      
      timelag       = ispan(0,20,1)
      timelag@units = "days since 2010-01-01 00:00:0.0"
      lev         = ucens[0]&lev
      lat         = ucens[0]&lat
      lon         = ucens[0]&lon
      nlag        = dimsizes(timelag)
      nlev        = dimsizes(lev)
      nlat        = dimsizes(lat)
      nlon        = dimsizes(lon)

      ;---Convert "hours since ..." to "seconds since ..."

      time        = fucens->timecens                                   ; "hours since 1800-1-1"
      time        = time*24*3600                                          
      time@units  = "seconds since 1800-1-1 00:00:0.0"
      ;printVarSummary(time)
      ;print("---")
      ymdh        = cd_calendar(time,-3)
      ;print(ymdh)

      ;---Convert hPa -> Pa for function

      p           = fucens->lev
      p           = p*100                                      ; Pa  [100000,...,10000]
      p@units     = "Pa"
      p!0         = "p"
      p&p         =  p                   ; not necessary
      ;printVarSummary(p)
      ;print("---")

      ;---Running function

      var         = "cens"
      q1q2cens1      = Q1Q2_yanai(time,p,ucens[0],vcens[0],qcens[0],tcens[0],wcens[0],lat,lon,npr,opt,var,"1")
      q1q2cens2      = Q1Q2_yanai(time,p,ucens[1],vcens[1],qcens[1],tcens[1],wcens[1],lat,lon,npr,opt,var,"2")
      q1q2cens3      = Q1Q2_yanai(time,p,ucens[2],vcens[2],qcens[2],tcens[2],wcens[2],lat,lon,npr,opt,var,"3")
      q1q2cens4      = Q1Q2_yanai(time,p,ucens[3],vcens[3],qcens[3],tcens[3],wcens[3],lat,lon,npr,opt,var,"4")
      q1q2cens5      = Q1Q2_yanai(time,p,ucens[4],vcens[4],qcens[4],tcens[4],wcens[4],lat,lon,npr,opt,var,"5")
      q1q2cens6      = Q1Q2_yanai(time,p,ucens[5],vcens[5],qcens[5],tcens[5],wcens[5],lat,lon,npr,opt,var,"6")
      q1q2cens7      = Q1Q2_yanai(time,p,ucens[6],vcens[6],qcens[6],tcens[6],wcens[6],lat,lon,npr,opt,var,"7")
      q1q2cens8      = Q1Q2_yanai(time,p,ucens[7],vcens[7],qcens[7],tcens[7],wcens[7],lat,lon,npr,opt,var,"8")
      q1q2cens9      = Q1Q2_yanai(time,p,ucens[8],vcens[8],qcens[8],tcens[8],wcens[8],lat,lon,npr,opt,var,"9")
      q1q2cens10      = Q1Q2_yanai(time,p,ucens[9],vcens[9],qcens[9],tcens[9],wcens[9],lat,lon,npr,opt,var,"10")
      q1q2cens11      = Q1Q2_yanai(time,p,ucens[10],vcens[10],qcens[10],tcens[10],wcens[10],lat,lon,npr,opt,var,"11")
      q1q2cens12      = Q1Q2_yanai(time,p,ucens[11],vcens[11],qcens[11],tcens[11],wcens[11],lat,lon,npr,opt,var,"12")
      q1q2cens13      = Q1Q2_yanai(time,p,ucens[12],vcens[12],qcens[12],tcens[12],wcens[12],lat,lon,npr,opt,var,"13")
      q1q2cens14      = Q1Q2_yanai(time,p,ucens[13],vcens[13],qcens[13],tcens[13],wcens[13],lat,lon,npr,opt,var,"14")
      q1q2cens15      = Q1Q2_yanai(time,p,ucens[14],vcens[14],qcens[14],tcens[14],wcens[14],lat,lon,npr,opt,var,"15")
      q1q2cens16      = Q1Q2_yanai(time,p,ucens[15],vcens[15],qcens[15],tcens[15],wcens[15],lat,lon,npr,opt,var,"16")
      q1q2cens17      = Q1Q2_yanai(time,p,ucens[16],vcens[16],qcens[16],tcens[16],wcens[16],lat,lon,npr,opt,var,"17")
      q1q2cens18      = Q1Q2_yanai(time,p,ucens[17],vcens[17],qcens[17],tcens[17],wcens[17],lat,lon,npr,opt,var,"18")
      q1q2cens19      = Q1Q2_yanai(time,p,ucens[18],vcens[18],qcens[18],tcens[18],wcens[18],lat,lon,npr,opt,var,"19")
      q1q2cens20      = Q1Q2_yanai(time,p,ucens[19],vcens[19],qcens[19],tcens[19],wcens[19],lat,lon,npr,opt,var,"20")
      q1q2cens21      = Q1Q2_yanai(time,p,ucens[20],vcens[20],qcens[20],tcens[20],wcens[20],lat,lon,npr,opt,var,"21")

      print("Begin array manipulation")

      q1intcensavg  = ([/ q1q2cens1[0], q1q2cens2[0], q1q2cens3[0], q1q2cens4[0], q1q2cens5[0], q1q2cens6[0], q1q2cens7[0], q1q2cens8[0], q1q2cens9[0], q1q2cens10[0], q1q2cens11[0], q1q2cens12[0], q1q2cens13[0], q1q2cens14[0], q1q2cens15[0], q1q2cens16[0], q1q2cens17[0], q1q2cens18[0], q1q2cens19[0], q1q2cens20[0], q1q2cens21[0] /])
      q2intcensavg  = ([/ q1q2cens1[1], q1q2cens2[1], q1q2cens3[1], q1q2cens4[1], q1q2cens5[1], q1q2cens6[1], q1q2cens7[1], q1q2cens8[1], q1q2cens9[1], q1q2cens10[1], q1q2cens11[1], q1q2cens12[1], q1q2cens13[1], q1q2cens14[1], q1q2cens15[1], q1q2cens16[1], q1q2cens17[1], q1q2cens18[1], q1q2cens19[1], q1q2cens20[1], q1q2cens21[1] /])
      q1pcpcensavg  = ([/ q1q2cens1[2], q1q2cens2[2], q1q2cens3[2], q1q2cens4[2], q1q2cens5[2], q1q2cens6[2], q1q2cens7[2], q1q2cens8[2], q1q2cens9[2], q1q2cens10[2], q1q2cens11[2], q1q2cens12[2], q1q2cens13[2], q1q2cens14[2], q1q2cens15[2], q1q2cens16[2], q1q2cens17[2], q1q2cens18[2], q1q2cens19[2], q1q2cens20[2], q1q2cens21[2] /])
      q2pcpcensavg  = ([/ q1q2cens1[3], q1q2cens2[3], q1q2cens3[3], q1q2cens4[3], q1q2cens5[3], q1q2cens6[3], q1q2cens7[3], q1q2cens8[3], q1q2cens9[3], q1q2cens10[3], q1q2cens11[3], q1q2cens12[3], q1q2cens13[3], q1q2cens14[3], q1q2cens15[3], q1q2cens16[3], q1q2cens17[3], q1q2cens18[3], q1q2cens19[3], q1q2cens20[3], q1q2cens21[3] /])

      q1intcensvar  = ([/ q1q2cens1[4], q1q2cens2[4], q1q2cens3[4], q1q2cens4[4], q1q2cens5[4], q1q2cens6[4], q1q2cens7[4], q1q2cens8[4], q1q2cens9[4], q1q2cens10[4], q1q2cens11[4], q1q2cens12[4], q1q2cens13[4], q1q2cens14[4], q1q2cens15[4], q1q2cens16[4], q1q2cens17[4], q1q2cens18[4], q1q2cens19[4], q1q2cens20[4], q1q2cens21[4] /])
      q2intcensvar  = ([/ q1q2cens1[5], q1q2cens2[5], q1q2cens3[5], q1q2cens4[5], q1q2cens5[5], q1q2cens6[5], q1q2cens7[5], q1q2cens8[5], q1q2cens9[5], q1q2cens10[5], q1q2cens11[5], q1q2cens12[5], q1q2cens13[5], q1q2cens14[5], q1q2cens15[5], q1q2cens16[5], q1q2cens17[5], q1q2cens18[5], q1q2cens19[5], q1q2cens20[5], q1q2cens21[5] /])
      q1pcpcensvar  = ([/ q1q2cens1[6], q1q2cens2[6], q1q2cens3[6], q1q2cens4[6], q1q2cens5[6], q1q2cens6[6], q1q2cens7[6], q1q2cens8[6], q1q2cens9[6], q1q2cens10[6], q1q2cens11[6], q1q2cens12[6], q1q2cens13[6], q1q2cens14[6], q1q2cens15[6], q1q2cens16[6], q1q2cens17[6], q1q2cens18[6], q1q2cens19[6], q1q2cens20[6], q1q2cens21[6] /])
      q2pcpcensvar  = ([/ q1q2cens1[7], q1q2cens2[7], q1q2cens3[7], q1q2cens4[7], q1q2cens5[7], q1q2cens6[7], q1q2cens7[7], q1q2cens8[7], q1q2cens9[7], q1q2cens10[7], q1q2cens11[7], q1q2cens12[7], q1q2cens13[7], q1q2cens14[7], q1q2cens15[7], q1q2cens16[7], q1q2cens17[7], q1q2cens18[7], q1q2cens19[7], q1q2cens20[7], q1q2cens21[7] /])
      
      mergeq1intcensavg                    = new((/nlag, nlat, nlon/), typeof(q1intcensavg[0]), q1intcensavg[0]@_FillValue)
      mergeq1intcensavgcp                  = new((/nlag, nlat, nlon/), typeof(q1intcensavg[0]), q1intcensavg[0]@_FillValue)
      do i = 0, 20
        variabelq1intcensavg                        = q1intcensavg[i]
        mergeq1intcensavgcp(0:0,:,:)      = (/ variabelq1intcensavg /)
        variabelq1intcensavg                       := mergeq1intcensavgcp(0:0,:,:)
        mergeq1intcensavg(i,:,:)          = variabelq1intcensavg
      end do
      printVarSummary(mergeq1intcensavg)

      mergeq2intcensavg                    = new((/nlag, nlat, nlon/), typeof(q2intcensavg[0]), q2intcensavg[0]@_FillValue)
      mergeq2intcensavgcp                  = new((/nlag, nlat, nlon/), typeof(q2intcensavg[0]), q2intcensavg[0]@_FillValue)
      do i = 0, 20
        variabelq2intcensavg                        = q2intcensavg[i]
        mergeq2intcensavgcp(0:0,:,:)      = (/ variabelq2intcensavg /)
        variabelq2intcensavg                       := mergeq2intcensavgcp(0:0,:,:)
        mergeq2intcensavg(i,:,:)          = variabelq2intcensavg
      end do
      printVarSummary(mergeq2intcensavg)

      mergeq1pcpcensavg                    = new((/nlag, nlev, nlat, nlon/), typeof(q1pcpcensavg[0]), q1pcpcensavg[0]@_FillValue)
      mergeq1pcpcensavgcp                  = new((/nlag, nlev, nlat, nlon/), typeof(q1pcpcensavg[0]), q1pcpcensavg[0]@_FillValue)
      do i = 0, 20
        variabelq1pcpcensavg                        = q1pcpcensavg[i]
        mergeq1pcpcensavgcp(0:0,:,:,:)      = (/ variabelq1pcpcensavg /)
        variabelq1pcpcensavg                       := mergeq1pcpcensavgcp(0:0,:,:,:)
        mergeq1pcpcensavg(i,:,:,:)          = variabelq1pcpcensavg
      end do
      printVarSummary(mergeq1pcpcensavg)

      mergeq2pcpcensavg                    = new((/nlag, nlev, nlat, nlon/), typeof(q1pcpcensavg[0]), q1pcpcensavg[0]@_FillValue)
      mergeq2pcpcensavgcp                  = new((/nlag, nlev, nlat, nlon/), typeof(q1pcpcensavg[0]), q1pcpcensavg[0]@_FillValue)
      do i = 0, 20
        variabelq1pcpcensavg                        = q1pcpcensavg[i]
        mergeq2pcpcensavgcp(0:0,:,:,:)      = (/ variabelq1pcpcensavg /)
        variabelq1pcpcensavg                       := mergeq2pcpcensavgcp(0:0,:,:,:)
        mergeq1pcpcensavg(i,:,:,:)          = variabelq1pcpcensavg
      end do
      printVarSummary(mergeq2pcpcensavg)

      mergeq1intcensvar                    = new((/nlag, nlat, nlon/), typeof(q1intcensvar[0]), q1intcensvar[0]@_FillValue)
      mergeq1intcensvarcp                  = new((/nlag, nlat, nlon/), typeof(q1intcensvar[0]), q1intcensvar[0]@_FillValue)
      do i = 0, 20
        variabelq1intcensvar                        = q1intcensvar[i]
        mergeq1intcensvarcp(0:0,:,:)      = (/ variabelq1intcensvar /)
        variabelq1intcensvar                       := mergeq1intcensvarcp(0:0,:,:)
        mergeq1intcensvar(i,:,:)          = variabelq1intcensvar
      end do
      printVarSummary(mergeq1intcensvar)

      mergeq2intcensvar                    = new((/nlag, nlat, nlon/), typeof(q2intcensvar[0]), q2intcensvar[0]@_FillValue)
      mergeq2intcensvarcp                  = new((/nlag, nlat, nlon/), typeof(q2intcensvar[0]), q2intcensvar[0]@_FillValue)
      do i = 0, 20
        variabelq2intcensvar                        = q2intcensvar[i]
        mergeq2intcensvarcp(0:0,:,:)      = (/ variabelq2intcensvar /)
        variabelq2intcensvar                       := mergeq2intcensvarcp(0:0,:,:)
        mergeq2intcensvar(i,:,:)          = variabelq2intcensvar
      end do
      printVarSummary(mergeq2intcensvar)

      mergeq1pcpcensvar                    = new((/nlag, nlev, nlat, nlon/), typeof(q1pcpcensvar[0]), q1pcpcensvar[0]@_FillValue)
      mergeq1pcpcensvarcp                  = new((/nlag, nlev, nlat, nlon/), typeof(q1pcpcensvar[0]), q1pcpcensvar[0]@_FillValue)
      do i = 0, 20
        variabelq1pcpcensvar                        = q1pcpcensvar[i]
        mergeq1pcpcensvarcp(0:0,:,:,:)      = (/ variabelq1pcpcensvar /)
        variabelq1pcpcensvar                       := mergeq1pcpcensvarcp(0:0,:,:,:)
        mergeq1pcpcensvar(i,:,:,:)          = variabelq1pcpcensvar
      end do
      printVarSummary(mergeq1pcpcensvar)

      mergeq2pcpcensvar                    = new((/nlag, nlev, nlat, nlon/), typeof(q1pcpcensvar[0]), q1pcpcensvar[0]@_FillValue)
      mergeq2pcpcensvarcp                  = new((/nlag, nlev, nlat, nlon/), typeof(q1pcpcensvar[0]), q1pcpcensvar[0]@_FillValue)
      do i = 0, 20
        variabelq1pcpcensvar                        = q1pcpcensvar[i]
        mergeq2pcpcensvarcp(0:0,:,:,:)      = (/ variabelq1pcpcensvar /)
        variabelq1pcpcensvar                       := mergeq2pcpcensvarcp(0:0,:,:,:)
        mergeq1pcpcensvar(i,:,:,:)          = variabelq1pcpcensvar
      end do
      printVarSummary(mergeq2pcpcensvar)


      mergeq1pcpcensavg!0 = "timelag"
      mergeq1pcpcensavg!1 = "lev"
      mergeq1pcpcensavg!2 = "lat"
      mergeq1pcpcensavg!3 = "lon"
      mergeq1pcpcensavg&timelag = timelag
      mergeq1pcpcensavg&lev     = lev
      mergeq1pcpcensavg&lat     = lat
      mergeq1pcpcensavg&lon     = lon
      mergeq1pcpcensavg@long_name = "Q1/cp: Apparent Heating rate"
      mergeq1pcpcensavg@units     = "K/day"

      copy_VarCoords(mergeq1pcpcensavg, mergeq2pcpcensavg)
      mergeq2pcpcensavg@long_name = "Q2/cp: Apparent Drying rate"
      mergeq2pcpcensavg@units     = "K/day"

      copy_VarMeta(mergeq1pcpcensavg, mergeq1pcpcensvar)
      copy_VarMeta(mergeq2pcpcensavg, mergeq2pcpcensvar)


      mergeq1intcensavg!0 = "timelag"
      mergeq1intcensavg!1 = "lat"
      mergeq1intcensavg!2 = "lon"
      mergeq1intcensavg&timelag = timelag
      mergeq1intcensavg&lat     = lat
      mergeq1intcensavg&lon     = lon
      mergeq1intcensavg@long_name = "<Q1>: Vertically Integrated Apparent Heat Source"
      mergeq1intcensavg@units     = "W/m**2"

      copy_VarCoords(mergeq1intcensavg, mergeq2intcensavg)
      mergeq2pcpcensavg@long_name = "<Q1>: Vertically Integrated Moisture Sink"
      mergeq2pcpcensavg@units     = "W/m**2"

      copy_VarMeta(mergeq1intcensavg, mergeq1intcensvar)
      copy_VarMeta(mergeq2intcensavg, mergeq2intcensvar)
      copy_VarMeta(mergeq1pcpcensavg, mergeq1pcpcensvar)
      copy_VarMeta(mergeq2pcpcensavg, mergeq2pcpcensvar)

      printVarSummary(mergeq1intcensavg)
      printVarSummary(mergeq2intcensavg)
      printVarSummary(mergeq1pcpcensavg)
      printVarSummary(mergeq2pcpcensavg)
      printVarSummary(mergeq1intcensvar)
      printVarSummary(mergeq2intcensvar)
      printVarSummary(mergeq1pcpcensvar)
      printVarSummary(mergeq2pcpcensvar)

    end if

  ;;------------------------------------------------------------------------------------------;
  ;---Save to a netcdf file
  ;;------------------------------------------------------------------------------------------;

  if (netCDF) .and. (CS)
    diro = "./"
    filo = "YANAI_Q1Q2_CS.nc"
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
   
    filedimdef(ncdf,"timelag",-1,True) ; make time an UNLIMITED dimension
    ncdf->Q1percpcsmean   = mergeq1pcpcsavg
    ncdf->Q2percpcsmean   = mergeq2pcpcsavg
    ncdf->Q1intcsmean     = mergeq1intcsavg
    ncdf->Q2intcsmean     = mergeq2intcsavg

    ncdf->Q1percpcsvari   = mergeq1pcpcsvar
    ncdf->Q2percpcsvari   = mergeq2pcpcsvar
    ncdf->Q1intcsvari     = mergeq1intcsvar
    ncdf->Q2intcsvari     = mergeq2intcsvar
  end if

  if (netCDF) .and. (CENS)
    diro = "./"
    filo = "YANAI_Q1Q2_CENS.nc"
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
   
    filedimdef(ncdf,"timelag",-1,True) ; make time an UNLIMITED dimension
    ncdf->Q1percpcensmean = mergeq1pcpcensavg
    ncdf->Q2percpcensmean = mergeq2pcpcensavg
    ncdf->Q1intcensmean   = mergeq1intcensavg
    ncdf->Q2intcensmean   = mergeq2intcensavg

    ncdf->Q1percpcensvari = mergeq1pcpcensvar
    ncdf->Q2percpcensvari = mergeq2pcpcensvar
    ncdf->Q1intcensvari   = mergeq1intcensvar
    ncdf->Q2intcensvari   = mergeq2intcensvar
  end if

  finish = systemfunc("date")
  
  print("Program start : "+ start +" ")
  print("Program end   : "+ finish +" ")

