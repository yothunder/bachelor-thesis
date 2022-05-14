;===========================================================================================;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;                                                                                           ;
; Start code => Sat, 14 May 2022 - 08.57 WIB
; Last time saved => Sat, 14 May 2022 - 11.18 WIB
;                                                                                           ;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;===========================================================================================;

  
  start = systemfunc("date")
  print(start)
  start_read_time = get_cpu_time()

  ;===========================================================================================;
  ;;------------------------------------------------------------------------------------------:
  ;				   Calculate Moisture Budget : use function for convenience
  ;;------------------------------------------------------------------------------------------:
  ;===========================================================================================;

  undef("moisture_budget")
  function moisture_budget(time[*]:numeric,p,u,v,q,omega,lat,lon,npr[1]:integer,opt[1]:logical,var,lag:string)
  begin

    print("========================")
    print("Starting function moisture_budget for "+ var +" lag "+ lag)
    print("")
    
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
      mfd@units              = "(kg/kg*s)"                                 ; (1/m)*[(m/s)(kg/kg)] => [kg/(kg-s)]

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

      uq_dpg          = uq*dpgq                         ; mass weighted 'uq'; [m/s][kg/kg][kg/m2]=>[m/s][g/kg]
      iuq             = dim_sum_n(uq_dpg, 1)
      iuq@long_name   = "Integrated Zonal UQ [uq*dpg]" 
      iuq@LONG_NAME   = "Sum: Mass Weighted Integrated Zonal Moisture Flux [uq*dpg]" 
      iuq@units       = "[m/s][kg/kg]"
      copy_VarCoords(u(:,0,:,:), iuq)                ; (time,lat,lon)
      delete(uq_dpg)

      vq_dpg          = vq*dpgq                         ; mass weighted 'vq'; [m/s][g/kg][kg/m2]=>[m/s][g/kg] 
      ivq             = dim_sum_n(vq_dpg, 1)
      ivq@long_name   = "Integrated Meridional VQ [vq*dpg]" 
      ivq@LONG_NAME   = "Sum: Mass Weighted Integrated Meridional Moisture Flux [vq*dpg]" 
      ivq@units       = "[m/s][kg/kg]"
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

      pwdtavg = dim_avg_n(pwdt,0)
      iuqavg  = dim_avg_n(iuq,0)
      ivqavg  = dim_avg_n(ivq,0)
      vimfdavg= dim_avg_n(vimfd,0)
      pwdtvar = dim_variance_n(pwdt,0)
      iuqvar  = dim_variance_n(iuq,0)
      ivqvar  = dim_variance_n(ivq,0)
      vimfdvar= dim_variance_n(vimfd,0)

    print("")
    print("Function moisture budget for "+ var +" is done")
    print("========================")

    return( [/pwdtavg, iuqavg, ivqavg, vimfdavg, pwdtvar, iuqvar, ivqvar, vimfdvar/] )

  end

  ;===========================================================================================;
  ;;------------------------------------------------------------------------------------------:
  ;                                         MAIN CODE
  ;;------------------------------------------------------------------------------------------:
  ;===========================================================================================;


  ;---Command control

    diri        = "../data/#/"

    CS          = False
    CENS        = True
    netCDF      = False
    npr         = 1            ; number of dimension level
    opt         = True

    ;---For CS

    if (CS)

      fucs        = addfile(diri+"varsel_pressurelevel_cs_u.nc","r")      ; daily mean data
      fvcs        = addfile(diri+"varsel_pressurelevel_cs_v.nc","r")      ; daily mean data
      fwcs        = addfile(diri+"varsel_pressurelevel_cs_w.nc","r")      ; daily mean data
      fqcs        = addfile(diri+"varsel_pressurelevel_cs_q.nc","r")      ; daily mean data
                                                                  ; convenience: make all:  S->N
      ucs = ([/ fucs->ucs1(:,:,::-1,:), fucs->ucs2(:,:,::-1,:), fucs->ucs3(:,:,::-1,:), fucs->ucs4(:,:,::-1,:), fucs->ucs5(:,:,::-1,:), fucs->ucs6(:,:,::-1,:), fucs->ucs7(:,:,::-1,:), fucs->ucs8(:,:,::-1,:), fucs->ucs9(:,:,::-1,:), fucs->ucs10(:,:,::-1,:), fucs->ucs11(:,:,::-1,:), fucs->ucs12(:,:,::-1,:), fucs->ucs13(:,:,::-1,:), fucs->ucs14(:,:,::-1,:), fucs->ucs15(:,:,::-1,:), fucs->ucs16(:,:,::-1,:), fucs->ucs17(:,:,::-1,:), fucs->ucs18(:,:,::-1,:), fucs->ucs19(:,:,::-1,:), fucs->ucs20(:,:,::-1,:), fucs->ucs21(:,:,::-1,:) /])
      vcs = ([/ fvcs->vcs1(:,:,::-1,:), fvcs->vcs2(:,:,::-1,:), fvcs->vcs3(:,:,::-1,:), fvcs->vcs4(:,:,::-1,:), fvcs->vcs5(:,:,::-1,:), fvcs->vcs6(:,:,::-1,:), fvcs->vcs7(:,:,::-1,:), fvcs->vcs8(:,:,::-1,:), fvcs->vcs9(:,:,::-1,:), fvcs->vcs10(:,:,::-1,:), fvcs->vcs11(:,:,::-1,:), fvcs->vcs12(:,:,::-1,:), fvcs->vcs13(:,:,::-1,:), fvcs->vcs14(:,:,::-1,:), fvcs->vcs15(:,:,::-1,:), fvcs->vcs16(:,:,::-1,:), fvcs->vcs17(:,:,::-1,:), fvcs->vcs18(:,:,::-1,:), fvcs->vcs19(:,:,::-1,:), fvcs->vcs20(:,:,::-1,:), fvcs->vcs21(:,:,::-1,:) /])
      wcs = ([/ fwcs->wcs1(:,:,::-1,:), fwcs->wcs2(:,:,::-1,:), fwcs->wcs3(:,:,::-1,:), fwcs->wcs4(:,:,::-1,:), fwcs->wcs5(:,:,::-1,:), fwcs->wcs6(:,:,::-1,:), fwcs->wcs7(:,:,::-1,:), fwcs->wcs8(:,:,::-1,:), fwcs->wcs9(:,:,::-1,:), fwcs->wcs10(:,:,::-1,:), fwcs->wcs11(:,:,::-1,:), fwcs->wcs12(:,:,::-1,:), fwcs->wcs13(:,:,::-1,:), fwcs->wcs14(:,:,::-1,:), fwcs->wcs15(:,:,::-1,:), fwcs->wcs16(:,:,::-1,:), fwcs->wcs17(:,:,::-1,:), fwcs->wcs18(:,:,::-1,:), fwcs->wcs19(:,:,::-1,:), fwcs->wcs20(:,:,::-1,:), fwcs->wcs21(:,:,::-1,:) /])
      qcs = ([/ fqcs->qcs1(:,:,::-1,:), fqcs->qcs2(:,:,::-1,:), fqcs->qcs3(:,:,::-1,:), fqcs->qcs4(:,:,::-1,:), fqcs->qcs5(:,:,::-1,:), fqcs->qcs6(:,:,::-1,:), fqcs->qcs7(:,:,::-1,:), fqcs->qcs8(:,:,::-1,:), fqcs->qcs9(:,:,::-1,:), fqcs->qcs10(:,:,::-1,:), fqcs->qcs11(:,:,::-1,:), fqcs->qcs12(:,:,::-1,:), fqcs->qcs13(:,:,::-1,:), fqcs->qcs14(:,:,::-1,:), fqcs->qcs15(:,:,::-1,:), fqcs->qcs16(:,:,::-1,:), fqcs->qcs17(:,:,::-1,:), fqcs->qcs18(:,:,::-1,:), fqcs->qcs19(:,:,::-1,:), fqcs->qcs20(:,:,::-1,:), fqcs->qcs21(:,:,::-1,:) /])
      
      timelag       = ispan(0,20,1)
      timelag@units = "days since 2010-01-01 00:00:0.0"
      lat         = ucs[0]&lat
      lon         = ucs[0]&lon
      nlag        = dimsizes(timelag)
      nlat        = dimsizes(lat)
      nlon        = dimsizes(lon)

      ;---Convert "hours since ..." to "seconds since ..."

      time        = fvcs->timecs                                   ; "hours since 1800-1-1"
      time        = time*24*3600                                          
      time@units  = "seconds since 1800-1-1 00:00:0.0"
      ;printVarSummary(time)
      ;print("---")
      ymdh        = cd_calendar(time,-3)
      ;print(ymdh)

      ;---Convert hPa -> Pa for function

      p           = fvcs->lev
      p           = p*100                                      ; Pa  [100000,...,10000]
      p@units     = "Pa"
      p!0         = "p"
      p&p         =  p                   ; not necessary
      ;printVarSummary(p)
      ;print("---")

      ;---Running function

      var           = "CS"
      mbcs1      = moisture_budget(time,p,ucs[0],vcs[0],qcs[0],wcs[0],lat,lon,npr,opt,var,"1")
      mbcs2      = moisture_budget(time,p,ucs[1],vcs[1],qcs[1],wcs[1],lat,lon,npr,opt,var,"2")
      mbcs3      = moisture_budget(time,p,ucs[2],vcs[2],qcs[2],wcs[2],lat,lon,npr,opt,var,"3")
      mbcs4      = moisture_budget(time,p,ucs[3],vcs[3],qcs[3],wcs[3],lat,lon,npr,opt,var,"4")
      mbcs5      = moisture_budget(time,p,ucs[4],vcs[4],qcs[4],wcs[4],lat,lon,npr,opt,var,"5")
      mbcs6      = moisture_budget(time,p,ucs[5],vcs[5],qcs[5],wcs[5],lat,lon,npr,opt,var,"6")
      mbcs7      = moisture_budget(time,p,ucs[6],vcs[6],qcs[6],wcs[6],lat,lon,npr,opt,var,"7")
      mbcs8      = moisture_budget(time,p,ucs[7],vcs[7],qcs[7],wcs[7],lat,lon,npr,opt,var,"8")
      mbcs9      = moisture_budget(time,p,ucs[8],vcs[8],qcs[8],wcs[8],lat,lon,npr,opt,var,"9")
      mbcs10      = moisture_budget(time,p,ucs[9],vcs[9],qcs[9],wcs[9],lat,lon,npr,opt,var,"10")
      mbcs11      = moisture_budget(time,p,ucs[10],vcs[10],qcs[10],wcs[10],lat,lon,npr,opt,var,"11")
      mbcs12      = moisture_budget(time,p,ucs[11],vcs[11],qcs[11],wcs[11],lat,lon,npr,opt,var,"12")
      mbcs13      = moisture_budget(time,p,ucs[12],vcs[12],qcs[12],wcs[12],lat,lon,npr,opt,var,"13")
      mbcs14      = moisture_budget(time,p,ucs[13],vcs[13],qcs[13],wcs[13],lat,lon,npr,opt,var,"14")
      mbcs15      = moisture_budget(time,p,ucs[14],vcs[14],qcs[14],wcs[14],lat,lon,npr,opt,var,"15")
      mbcs16      = moisture_budget(time,p,ucs[15],vcs[15],qcs[15],wcs[15],lat,lon,npr,opt,var,"16")
      mbcs17      = moisture_budget(time,p,ucs[16],vcs[16],qcs[16],wcs[16],lat,lon,npr,opt,var,"17")
      mbcs18      = moisture_budget(time,p,ucs[17],vcs[17],qcs[17],wcs[17],lat,lon,npr,opt,var,"18")
      mbcs19      = moisture_budget(time,p,ucs[18],vcs[18],qcs[18],wcs[18],lat,lon,npr,opt,var,"19")
      mbcs20      = moisture_budget(time,p,ucs[19],vcs[19],qcs[19],wcs[19],lat,lon,npr,opt,var,"20")
      mbcs21      = moisture_budget(time,p,ucs[20],vcs[20],qcs[20],wcs[20],lat,lon,npr,opt,var,"21")


      print("Begin array manipulation")

      pwdtcsavg  = ([/ mbcs1[0], mbcs2[0], mbcs3[0], mbcs4[0], mbcs5[0], mbcs6[0], mbcs7[0], mbcs8[0], mbcs9[0], mbcs10[0], mbcs11[0], mbcs12[0], mbcs13[0], mbcs14[0], mbcs15[0], mbcs16[0], mbcs17[0], mbcs18[0], mbcs19[0], mbcs20[0], mbcs21[0] /])
      iuqcsavg  = ([/ mbcs1[1], mbcs2[1], mbcs3[1], mbcs4[1], mbcs5[1], mbcs6[1], mbcs7[1], mbcs8[1], mbcs9[1], mbcs10[1], mbcs11[1], mbcs12[1], mbcs13[1], mbcs14[1], mbcs15[1], mbcs16[1], mbcs17[1], mbcs18[1], mbcs19[1], mbcs20[1], mbcs21[1] /])
      ivqcsavg  = ([/ mbcs1[2], mbcs2[2], mbcs3[2], mbcs4[2], mbcs5[2], mbcs6[2], mbcs7[2], mbcs8[2], mbcs9[2], mbcs10[2], mbcs11[2], mbcs12[2], mbcs13[2], mbcs14[2], mbcs15[2], mbcs16[2], mbcs17[2], mbcs18[2], mbcs19[2], mbcs20[2], mbcs21[2] /])
      vimfdcsavg  = ([/ mbcs1[3], mbcs2[3], mbcs3[3], mbcs4[3], mbcs5[3], mbcs6[3], mbcs7[3], mbcs8[3], mbcs9[3], mbcs10[3], mbcs11[3], mbcs12[3], mbcs13[3], mbcs14[3], mbcs15[3], mbcs16[3], mbcs17[3], mbcs18[3], mbcs19[3], mbcs20[3], mbcs21[3] /])

      pwdtcsvar  = ([/ mbcs1[4], mbcs2[4], mbcs3[4], mbcs4[4], mbcs5[4], mbcs6[4], mbcs7[4], mbcs8[4], mbcs9[4], mbcs10[4], mbcs11[4], mbcs12[4], mbcs13[4], mbcs14[4], mbcs15[4], mbcs16[4], mbcs17[4], mbcs18[4], mbcs19[4], mbcs20[4], mbcs21[4] /])
      iuqcsvar  = ([/ mbcs1[5], mbcs2[5], mbcs3[5], mbcs4[5], mbcs5[5], mbcs6[5], mbcs7[5], mbcs8[5], mbcs9[5], mbcs10[5], mbcs11[5], mbcs12[5], mbcs13[5], mbcs14[5], mbcs15[5], mbcs16[5], mbcs17[5], mbcs18[5], mbcs19[5], mbcs20[5], mbcs21[5] /])
      ivqcsvar  = ([/ mbcs1[6], mbcs2[6], mbcs3[6], mbcs4[6], mbcs5[6], mbcs6[6], mbcs7[6], mbcs8[6], mbcs9[6], mbcs10[6], mbcs11[6], mbcs12[6], mbcs13[6], mbcs14[6], mbcs15[6], mbcs16[6], mbcs17[6], mbcs18[6], mbcs19[6], mbcs20[6], mbcs21[6] /])
      vimfdcsvar  = ([/ mbcs1[7], mbcs2[7], mbcs3[7], mbcs4[7], mbcs5[7], mbcs6[7], mbcs7[7], mbcs8[7], mbcs9[7], mbcs10[7], mbcs11[7], mbcs12[7], mbcs13[7], mbcs14[7], mbcs15[7], mbcs16[7], mbcs17[7], mbcs18[7], mbcs19[7], mbcs20[7], mbcs21[7] /])
      
      mergepwdtcsavg                    = new((/nlag, nlat, nlon/), typeof(pwdtcsavg[0]), pwdtcsavg[0]@_FillValue)
      mergepwdtcsavgcp                  = new((/nlag, nlat, nlon/), typeof(pwdtcsavg[0]), pwdtcsavg[0]@_FillValue)
      do i = 0, 20
        variabelpwdtcsavg                        = pwdtcsavg[i]
        mergepwdtcsavgcp(0:0,:,:)      = (/ variabelpwdtcsavg /)
        variabelpwdtcsavg                       := mergepwdtcsavgcp(0:0,:,:)
        mergepwdtcsavg(i,:,:)          = variabelpwdtcsavg
      end do
      printVarSummary(mergepwdtcsavg)

      mergeiuqcsavg                    = new((/nlag, nlat, nlon/), typeof(iuqcsavg[0]), iuqcsavg[0]@_FillValue)
      mergeiuqcsavgcp                  = new((/nlag, nlat, nlon/), typeof(iuqcsavg[0]), iuqcsavg[0]@_FillValue)
      do i = 0, 20
        variabeliuqcsavg                        = iuqcsavg[i]
        mergeiuqcsavgcp(0:0,:,:)      = (/ variabeliuqcsavg /)
        variabeliuqcsavg                       := mergeiuqcsavgcp(0:0,:,:)
        mergeiuqcsavg(i,:,:)          = variabeliuqcsavg
      end do
      printVarSummary(mergeiuqcsavg)

      mergeivqcsavg                    = new((/nlag, nlat, nlon/), typeof(ivqcsavg[0]), ivqcsavg[0]@_FillValue)
      mergeivqcsavgcp                  = new((/nlag, nlat, nlon/), typeof(ivqcsavg[0]), ivqcsavg[0]@_FillValue)
      do i = 0, 20
        variabelivqcsavg                        = ivqcsavg[i]
        mergeivqcsavgcp(0:0,:,:)      = (/ variabelivqcsavg /)
        variabelivqcsavg                       := mergeivqcsavgcp(0:0,:,:)
        mergeivqcsavg(i,:,:)          = variabelivqcsavg
      end do
      printVarSummary(mergeivqcsavg)

      mergevimfdcsavg                    = new((/nlag, nlat, nlon/), typeof(ivqcsavg[0]), ivqcsavg[0]@_FillValue)
      mergevimfdcsavgcp                  = new((/nlag, nlat, nlon/), typeof(ivqcsavg[0]), ivqcsavg[0]@_FillValue)
      do i = 0, 20
        variabelivqcsavg                        = ivqcsavg[i]
        mergevimfdcsavgcp(0:0,:,:)      = (/ variabelivqcsavg /)
        variabelivqcsavg                       := mergevimfdcsavgcp(0:0,:,:)
        mergeivqcsavg(i,:,:)          = variabelivqcsavg
      end do
      printVarSummary(mergevimfdcsavg)

      mergepwdtcsvar                    = new((/nlag, nlat, nlon/), typeof(pwdtcsvar[0]), pwdtcsvar[0]@_FillValue)
      mergepwdtcsvarcp                  = new((/nlag, nlat, nlon/), typeof(pwdtcsvar[0]), pwdtcsvar[0]@_FillValue)
      do i = 0, 20
        variabelpwdtcsvar                        = pwdtcsvar[i]
        mergepwdtcsvarcp(0:0,:,:)      = (/ variabelpwdtcsvar /)
        variabelpwdtcsvar                       := mergepwdtcsvarcp(0:0,:,:)
        mergepwdtcsvar(i,:,:)          = variabelpwdtcsvar
      end do
      printVarSummary(mergepwdtcsvar)

      mergeiuqcsvar                    = new((/nlag, nlat, nlon/), typeof(iuqcsvar[0]), iuqcsvar[0]@_FillValue)
      mergeiuqcsvarcp                  = new((/nlag, nlat, nlon/), typeof(iuqcsvar[0]), iuqcsvar[0]@_FillValue)
      do i = 0, 20
        variabeliuqcsvar                        = iuqcsvar[i]
        mergeiuqcsvarcp(0:0,:,:)      = (/ variabeliuqcsvar /)
        variabeliuqcsvar                       := mergeiuqcsvarcp(0:0,:,:)
        mergeiuqcsvar(i,:,:)          = variabeliuqcsvar
      end do
      printVarSummary(mergeiuqcsvar)

      mergeivqcsvar                    = new((/nlag, nlat, nlon/), typeof(ivqcsvar[0]), ivqcsvar[0]@_FillValue)
      mergeivqcsvarcp                  = new((/nlag, nlat, nlon/), typeof(ivqcsvar[0]), ivqcsvar[0]@_FillValue)
      do i = 0, 20
        variabelivqcsvar                        = ivqcsvar[i]
        mergeivqcsvarcp(0:0,:,:)      = (/ variabelivqcsvar /)
        variabelivqcsvar                       := mergeivqcsvarcp(0:0,:,:)
        mergeivqcsvar(i,:,:)          = variabelivqcsvar
      end do
      printVarSummary(mergeivqcsvar)

      mergevimfdcsvar                    = new((/nlag, nlat, nlon/), typeof(ivqcsvar[0]), ivqcsvar[0]@_FillValue)
      mergevimfdcsvarcp                  = new((/nlag, nlat, nlon/), typeof(ivqcsvar[0]), ivqcsvar[0]@_FillValue)
      do i = 0, 20
        variabelivqcsvar                        = ivqcsvar[i]
        mergevimfdcsvarcp(0:0,:,:)      = (/ variabelivqcsvar /)
        variabelivqcsvar                       := mergevimfdcsvarcp(0:0,:,:)
        mergeivqcsvar(i,:,:)          = variabelivqcsvar
      end do
      printVarSummary(mergevimfdcsvar)

      mergepwdtcsavg!0 = "timelag"
      mergepwdtcsavg!1 = "lat"
      mergepwdtcsavg!2 = "lon"
      mergepwdtcsavg&timelag = timelag
      mergepwdtcsavg&lat     = lat
      mergepwdtcsavg&lon     = lon
      mergepwdtcsavg@long_name = "dW/dt: Precipitable water tendency"
      mergepwdtcsavg@units     = "(kg/m**2)/s"

      copy_VarCoords(mergepwdtcsavg, mergeiuqcsavg)
      mergeiuqcsavg@long_name = "Zonal Integrated Moisture Flux"
      mergeiuqcsavg@units     = "(kg/m**2)/s"
      copy_VarCoords(mergepwdtcsavg, mergeivqcsavg)
      mergeivqcsavg@long_name = "Meridional Integrated Moisture Flux"
      mergeivqcsavg@units     = "(kg/m**2)/s"
      copy_VarCoords(mergepwdtcsavg, mergevimfdcsavg)
      mergevimfdcsavg@long_name = "Integrated Horizontal Moisture Flux Divergence"
      mergevimfdcsavg@units     = "(kg/m**2)/s"

      copy_VarMeta(mergepwdtcsavg, mergepwdtcsvar)
      copy_VarMeta(mergeiuqcsavg, mergeiuqcsvar)
      copy_VarMeta(mergeivqcsavg, mergeivqcsvar)
      copy_VarMeta(mergevimfdcsavg, mergevimfdcsvar)

      printVarSummary(mergepwdtcsavg)
      printVarSummary(mergeiuqcsavg)
      printVarSummary(mergeivqcsavg)
      printVarSummary(mergevimfdcsavg)
      printVarSummary(mergepwdtcsvar)
      printVarSummary(mergeiuqcsvar)
      printVarSummary(mergeivqcsvar)
      printVarSummary(mergevimfdcsvar)

    end if

    if (CENS)

      fucens        = addfile(diri+"varsel_pressurelevel_cens_u.nc","r")      ; daily mean data
      fvcens        = addfile(diri+"varsel_pressurelevel_cens_v.nc","r")      ; daily mean data
      fwcens        = addfile(diri+"varsel_pressurelevel_cens_w.nc","r")      ; daily mean data
      fqcens        = addfile(diri+"varsel_pressurelevel_cens_q.nc","r")      ; daily mean data
                                                                  ; convenience: make all:  S->N
      ucens = ([/ fucens->ucens1(:,:,::-1,:), fucens->ucens2(:,:,::-1,:), fucens->ucens3(:,:,::-1,:), fucens->ucens4(:,:,::-1,:), fucens->ucens5(:,:,::-1,:), fucens->ucens6(:,:,::-1,:), fucens->ucens7(:,:,::-1,:), fucens->ucens8(:,:,::-1,:), fucens->ucens9(:,:,::-1,:), fucens->ucens10(:,:,::-1,:), fucens->ucens11(:,:,::-1,:), fucens->ucens12(:,:,::-1,:), fucens->ucens13(:,:,::-1,:), fucens->ucens14(:,:,::-1,:), fucens->ucens15(:,:,::-1,:), fucens->ucens16(:,:,::-1,:), fucens->ucens17(:,:,::-1,:), fucens->ucens18(:,:,::-1,:), fucens->ucens19(:,:,::-1,:), fucens->ucens20(:,:,::-1,:), fucens->ucens21(:,:,::-1,:) /])
      vcens = ([/ fvcens->vcens1(:,:,::-1,:), fvcens->vcens2(:,:,::-1,:), fvcens->vcens3(:,:,::-1,:), fvcens->vcens4(:,:,::-1,:), fvcens->vcens5(:,:,::-1,:), fvcens->vcens6(:,:,::-1,:), fvcens->vcens7(:,:,::-1,:), fvcens->vcens8(:,:,::-1,:), fvcens->vcens9(:,:,::-1,:), fvcens->vcens10(:,:,::-1,:), fvcens->vcens11(:,:,::-1,:), fvcens->vcens12(:,:,::-1,:), fvcens->vcens13(:,:,::-1,:), fvcens->vcens14(:,:,::-1,:), fvcens->vcens15(:,:,::-1,:), fvcens->vcens16(:,:,::-1,:), fvcens->vcens17(:,:,::-1,:), fvcens->vcens18(:,:,::-1,:), fvcens->vcens19(:,:,::-1,:), fvcens->vcens20(:,:,::-1,:), fvcens->vcens21(:,:,::-1,:) /])
      wcens = ([/ fwcens->wcens1(:,:,::-1,:), fwcens->wcens2(:,:,::-1,:), fwcens->wcens3(:,:,::-1,:), fwcens->wcens4(:,:,::-1,:), fwcens->wcens5(:,:,::-1,:), fwcens->wcens6(:,:,::-1,:), fwcens->wcens7(:,:,::-1,:), fwcens->wcens8(:,:,::-1,:), fwcens->wcens9(:,:,::-1,:), fwcens->wcens10(:,:,::-1,:), fwcens->wcens11(:,:,::-1,:), fwcens->wcens12(:,:,::-1,:), fwcens->wcens13(:,:,::-1,:), fwcens->wcens14(:,:,::-1,:), fwcens->wcens15(:,:,::-1,:), fwcens->wcens16(:,:,::-1,:), fwcens->wcens17(:,:,::-1,:), fwcens->wcens18(:,:,::-1,:), fwcens->wcens19(:,:,::-1,:), fwcens->wcens20(:,:,::-1,:), fwcens->wcens21(:,:,::-1,:) /])
      qcens = ([/ fqcens->qcens1(:,:,::-1,:), fqcens->qcens2(:,:,::-1,:), fqcens->qcens3(:,:,::-1,:), fqcens->qcens4(:,:,::-1,:), fqcens->qcens5(:,:,::-1,:), fqcens->qcens6(:,:,::-1,:), fqcens->qcens7(:,:,::-1,:), fqcens->qcens8(:,:,::-1,:), fqcens->qcens9(:,:,::-1,:), fqcens->qcens10(:,:,::-1,:), fqcens->qcens11(:,:,::-1,:), fqcens->qcens12(:,:,::-1,:), fqcens->qcens13(:,:,::-1,:), fqcens->qcens14(:,:,::-1,:), fqcens->qcens15(:,:,::-1,:), fqcens->qcens16(:,:,::-1,:), fqcens->qcens17(:,:,::-1,:), fqcens->qcens18(:,:,::-1,:), fqcens->qcens19(:,:,::-1,:), fqcens->qcens20(:,:,::-1,:), fqcens->qcens21(:,:,::-1,:) /])
      
      timelag       = ispan(0,20,1)
      timelag@units = "days since 2010-01-01 00:00:0.0"
      lat         = ucens[0]&lat
      lon         = ucens[0]&lon
      nlag        = dimsizes(timelag)
      nlat        = dimsizes(lat)
      nlon        = dimsizes(lon)

      ;---Convert "hours since ..." to "seconds since ..."

      time        = fvcens->timecens                                   ; "hours since 1800-1-1"
      time        = time*24*3600                                          
      time@units  = "seconds since 1800-1-1 00:00:0.0"
      printVarSummary(time)
      print(time)
      ;print("---")
      ymdh        = cd_calendar(time,-3)
      ;print(ymdh)

      ;---Convert hPa -> Pa for function

      p           = fvcens->lev
      p           = p*100                                      ; Pa  [100000,...,10000]
      p@units     = "Pa"
      p!0         = "p"
      p&p         =  p                   ; not necessary
      ;printVarSummary(p)
      ;print("---")

      ;---Running function

      var           = "cens"
      mbcens1      = moisture_budget(time,p,ucens[0],vcens[0],qcens[0],wcens[0],lat,lon,npr,opt,var,"1")
      mbcens2      = moisture_budget(time,p,ucens[1],vcens[1],qcens[1],wcens[1],lat,lon,npr,opt,var,"2")
      mbcens3      = moisture_budget(time,p,ucens[2],vcens[2],qcens[2],wcens[2],lat,lon,npr,opt,var,"3")
      mbcens4      = moisture_budget(time,p,ucens[3],vcens[3],qcens[3],wcens[3],lat,lon,npr,opt,var,"4")
      mbcens5      = moisture_budget(time,p,ucens[4],vcens[4],qcens[4],wcens[4],lat,lon,npr,opt,var,"5")
      mbcens6      = moisture_budget(time,p,ucens[5],vcens[5],qcens[5],wcens[5],lat,lon,npr,opt,var,"6")
      mbcens7      = moisture_budget(time,p,ucens[6],vcens[6],qcens[6],wcens[6],lat,lon,npr,opt,var,"7")
      mbcens8      = moisture_budget(time,p,ucens[7],vcens[7],qcens[7],wcens[7],lat,lon,npr,opt,var,"8")
      mbcens9      = moisture_budget(time,p,ucens[8],vcens[8],qcens[8],wcens[8],lat,lon,npr,opt,var,"9")
      mbcens10      = moisture_budget(time,p,ucens[9],vcens[9],qcens[9],wcens[9],lat,lon,npr,opt,var,"10")
      mbcens11      = moisture_budget(time,p,ucens[10],vcens[10],qcens[10],wcens[10],lat,lon,npr,opt,var,"11")
      mbcens12      = moisture_budget(time,p,ucens[11],vcens[11],qcens[11],wcens[11],lat,lon,npr,opt,var,"12")
      mbcens13      = moisture_budget(time,p,ucens[12],vcens[12],qcens[12],wcens[12],lat,lon,npr,opt,var,"13")
      mbcens14      = moisture_budget(time,p,ucens[13],vcens[13],qcens[13],wcens[13],lat,lon,npr,opt,var,"14")
      mbcens15      = moisture_budget(time,p,ucens[14],vcens[14],qcens[14],wcens[14],lat,lon,npr,opt,var,"15")
      mbcens16      = moisture_budget(time,p,ucens[15],vcens[15],qcens[15],wcens[15],lat,lon,npr,opt,var,"16")
      mbcens17      = moisture_budget(time,p,ucens[16],vcens[16],qcens[16],wcens[16],lat,lon,npr,opt,var,"17")
      mbcens18      = moisture_budget(time,p,ucens[17],vcens[17],qcens[17],wcens[17],lat,lon,npr,opt,var,"18")
      mbcens19      = moisture_budget(time,p,ucens[18],vcens[18],qcens[18],wcens[18],lat,lon,npr,opt,var,"19")
      mbcens20      = moisture_budget(time,p,ucens[19],vcens[19],qcens[19],wcens[19],lat,lon,npr,opt,var,"20")
      mbcens21      = moisture_budget(time,p,ucens[20],vcens[20],qcens[20],wcens[20],lat,lon,npr,opt,var,"21")


      print("Begin array manipulation")

      pwdtcensavg  = ([/ mbcens1[0], mbcens2[0], mbcens3[0], mbcens4[0], mbcens5[0], mbcens6[0], mbcens7[0], mbcens8[0], mbcens9[0], mbcens10[0], mbcens11[0], mbcens12[0], mbcens13[0], mbcens14[0], mbcens15[0], mbcens16[0], mbcens17[0], mbcens18[0], mbcens19[0], mbcens20[0], mbcens21[0] /])
      iuqcensavg  = ([/ mbcens1[1], mbcens2[1], mbcens3[1], mbcens4[1], mbcens5[1], mbcens6[1], mbcens7[1], mbcens8[1], mbcens9[1], mbcens10[1], mbcens11[1], mbcens12[1], mbcens13[1], mbcens14[1], mbcens15[1], mbcens16[1], mbcens17[1], mbcens18[1], mbcens19[1], mbcens20[1], mbcens21[1] /])
      ivqcensavg  = ([/ mbcens1[2], mbcens2[2], mbcens3[2], mbcens4[2], mbcens5[2], mbcens6[2], mbcens7[2], mbcens8[2], mbcens9[2], mbcens10[2], mbcens11[2], mbcens12[2], mbcens13[2], mbcens14[2], mbcens15[2], mbcens16[2], mbcens17[2], mbcens18[2], mbcens19[2], mbcens20[2], mbcens21[2] /])
      vimfdcensavg  = ([/ mbcens1[3], mbcens2[3], mbcens3[3], mbcens4[3], mbcens5[3], mbcens6[3], mbcens7[3], mbcens8[3], mbcens9[3], mbcens10[3], mbcens11[3], mbcens12[3], mbcens13[3], mbcens14[3], mbcens15[3], mbcens16[3], mbcens17[3], mbcens18[3], mbcens19[3], mbcens20[3], mbcens21[3] /])

      pwdtcensvar  = ([/ mbcens1[4], mbcens2[4], mbcens3[4], mbcens4[4], mbcens5[4], mbcens6[4], mbcens7[4], mbcens8[4], mbcens9[4], mbcens10[4], mbcens11[4], mbcens12[4], mbcens13[4], mbcens14[4], mbcens15[4], mbcens16[4], mbcens17[4], mbcens18[4], mbcens19[4], mbcens20[4], mbcens21[4] /])
      iuqcensvar  = ([/ mbcens1[5], mbcens2[5], mbcens3[5], mbcens4[5], mbcens5[5], mbcens6[5], mbcens7[5], mbcens8[5], mbcens9[5], mbcens10[5], mbcens11[5], mbcens12[5], mbcens13[5], mbcens14[5], mbcens15[5], mbcens16[5], mbcens17[5], mbcens18[5], mbcens19[5], mbcens20[5], mbcens21[5] /])
      ivqcensvar  = ([/ mbcens1[6], mbcens2[6], mbcens3[6], mbcens4[6], mbcens5[6], mbcens6[6], mbcens7[6], mbcens8[6], mbcens9[6], mbcens10[6], mbcens11[6], mbcens12[6], mbcens13[6], mbcens14[6], mbcens15[6], mbcens16[6], mbcens17[6], mbcens18[6], mbcens19[6], mbcens20[6], mbcens21[6] /])
      vimfdcensvar  = ([/ mbcens1[7], mbcens2[7], mbcens3[7], mbcens4[7], mbcens5[7], mbcens6[7], mbcens7[7], mbcens8[7], mbcens9[7], mbcens10[7], mbcens11[7], mbcens12[7], mbcens13[7], mbcens14[7], mbcens15[7], mbcens16[7], mbcens17[7], mbcens18[7], mbcens19[7], mbcens20[7], mbcens21[7] /])
      
      mergepwdtcensavg                    = new((/nlag, nlat, nlon/), typeof(pwdtcensavg[0]), pwdtcensavg[0]@_FillValue)
      mergepwdtcensavgcp                  = new((/nlag, nlat, nlon/), typeof(pwdtcensavg[0]), pwdtcensavg[0]@_FillValue)
      do i = 0, 20
        variabelpwdtcensavg                        = pwdtcensavg[i]
        mergepwdtcensavgcp(0:0,:,:)      = (/ variabelpwdtcensavg /)
        variabelpwdtcensavg                       := mergepwdtcensavgcp(0:0,:,:)
        mergepwdtcensavg(i,:,:)          = variabelpwdtcensavg
      end do
      printVarSummary(mergepwdtcensavg)

      mergeiuqcensavg                    = new((/nlag, nlat, nlon/), typeof(iuqcensavg[0]), iuqcensavg[0]@_FillValue)
      mergeiuqcensavgcp                  = new((/nlag, nlat, nlon/), typeof(iuqcensavg[0]), iuqcensavg[0]@_FillValue)
      do i = 0, 20
        variabeliuqcensavg                        = iuqcensavg[i]
        mergeiuqcensavgcp(0:0,:,:)      = (/ variabeliuqcensavg /)
        variabeliuqcensavg                       := mergeiuqcensavgcp(0:0,:,:)
        mergeiuqcensavg(i,:,:)          = variabeliuqcensavg
      end do
      printVarSummary(mergeiuqcensavg)

      mergeivqcensavg                    = new((/nlag, nlat, nlon/), typeof(ivqcensavg[0]), ivqcensavg[0]@_FillValue)
      mergeivqcensavgcp                  = new((/nlag, nlat, nlon/), typeof(ivqcensavg[0]), ivqcensavg[0]@_FillValue)
      do i = 0, 20
        variabelivqcensavg                        = ivqcensavg[i]
        mergeivqcensavgcp(0:0,:,:)      = (/ variabelivqcensavg /)
        variabelivqcensavg                       := mergeivqcensavgcp(0:0,:,:)
        mergeivqcensavg(i,:,:)          = variabelivqcensavg
      end do
      printVarSummary(mergeivqcensavg)

      mergevimfdcensavg                    = new((/nlag, nlat, nlon/), typeof(ivqcensavg[0]), ivqcensavg[0]@_FillValue)
      mergevimfdcensavgcp                  = new((/nlag, nlat, nlon/), typeof(ivqcensavg[0]), ivqcensavg[0]@_FillValue)
      do i = 0, 20
        variabelivqcensavg                        = ivqcensavg[i]
        mergevimfdcensavgcp(0:0,:,:)      = (/ variabelivqcensavg /)
        variabelivqcensavg                       := mergevimfdcensavgcp(0:0,:,:)
        mergeivqcensavg(i,:,:)          = variabelivqcensavg
      end do
      printVarSummary(mergevimfdcensavg)

      mergepwdtcensvar                    = new((/nlag, nlat, nlon/), typeof(pwdtcensvar[0]), pwdtcensvar[0]@_FillValue)
      mergepwdtcensvarcp                  = new((/nlag, nlat, nlon/), typeof(pwdtcensvar[0]), pwdtcensvar[0]@_FillValue)
      do i = 0, 20
        variabelpwdtcensvar                        = pwdtcensvar[i]
        mergepwdtcensvarcp(0:0,:,:)      = (/ variabelpwdtcensvar /)
        variabelpwdtcensvar                       := mergepwdtcensvarcp(0:0,:,:)
        mergepwdtcensvar(i,:,:)          = variabelpwdtcensvar
      end do
      printVarSummary(mergepwdtcensvar)

      mergeiuqcensvar                    = new((/nlag, nlat, nlon/), typeof(iuqcensvar[0]), iuqcensvar[0]@_FillValue)
      mergeiuqcensvarcp                  = new((/nlag, nlat, nlon/), typeof(iuqcensvar[0]), iuqcensvar[0]@_FillValue)
      do i = 0, 20
        variabeliuqcensvar                        = iuqcensvar[i]
        mergeiuqcensvarcp(0:0,:,:)      = (/ variabeliuqcensvar /)
        variabeliuqcensvar                       := mergeiuqcensvarcp(0:0,:,:)
        mergeiuqcensvar(i,:,:)          = variabeliuqcensvar
      end do
      printVarSummary(mergeiuqcensvar)

      mergeivqcensvar                    = new((/nlag, nlat, nlon/), typeof(ivqcensvar[0]), ivqcensvar[0]@_FillValue)
      mergeivqcensvarcp                  = new((/nlag, nlat, nlon/), typeof(ivqcensvar[0]), ivqcensvar[0]@_FillValue)
      do i = 0, 20
        variabelivqcensvar                        = ivqcensvar[i]
        mergeivqcensvarcp(0:0,:,:)      = (/ variabelivqcensvar /)
        variabelivqcensvar                       := mergeivqcensvarcp(0:0,:,:)
        mergeivqcensvar(i,:,:)          = variabelivqcensvar
      end do
      printVarSummary(mergeivqcensvar)

      mergevimfdcensvar                    = new((/nlag, nlat, nlon/), typeof(ivqcensvar[0]), ivqcensvar[0]@_FillValue)
      mergevimfdcensvarcp                  = new((/nlag, nlat, nlon/), typeof(ivqcensvar[0]), ivqcensvar[0]@_FillValue)
      do i = 0, 20
        variabelivqcensvar                        = ivqcensvar[i]
        mergevimfdcensvarcp(0:0,:,:)      = (/ variabelivqcensvar /)
        variabelivqcensvar                       := mergevimfdcensvarcp(0:0,:,:)
        mergeivqcensvar(i,:,:)          = variabelivqcensvar
      end do
      printVarSummary(mergevimfdcensvar)

      mergepwdtcensavg!0 = "timelag"
      mergepwdtcensavg!1 = "lat"
      mergepwdtcensavg!2 = "lon"
      mergepwdtcensavg&timelag = timelag
      mergepwdtcensavg&lat     = lat
      mergepwdtcensavg&lon     = lon
      mergepwdtcensavg@long_name = "dW/dt: Precipitable water tendency"
      mergepwdtcensavg@units     = "(kg/m**2)/s"

      copy_VarCoords(mergepwdtcensavg, mergeiuqcensavg)
      mergeiuqcensavg@long_name = "Zonal Integrated Moisture Flux"
      mergeiuqcensavg@units     = "(kg/m**2)/s"
      copy_VarCoords(mergepwdtcensavg, mergeivqcensavg)
      mergeivqcensavg@long_name = "Meridional Integrated Moisture Flux"
      mergeivqcensavg@units     = "(kg/m**2)/s"
      copy_VarCoords(mergepwdtcensavg, mergevimfdcensavg)
      mergevimfdcensavg@long_name = "Integrated Horizontal Moisture Flux Divergence"
      mergevimfdcensavg@units     = "(kg/m**2)/s"

      copy_VarMeta(mergepwdtcensavg, mergepwdtcensvar)
      copy_VarMeta(mergeiuqcensavg, mergeiuqcensvar)
      copy_VarMeta(mergeivqcensavg, mergeivqcensvar)
      copy_VarMeta(mergevimfdcensavg, mergevimfdcensvar)

      printVarSummary(mergepwdtcensavg)
      printVarSummary(mergeiuqcensavg)
      printVarSummary(mergeivqcensavg)
      printVarSummary(mergevimfdcensavg)
      printVarSummary(mergepwdtcensvar)
      printVarSummary(mergeiuqcensvar)
      printVarSummary(mergeivqcensvar)
      printVarSummary(mergevimfdcensvar)

    end if

  ;***********************************************
  ;---Save to a netcdf file
  ;***********************************************

    if (netCDF) .and. (CS)
      diro                = "./"
      filo                = "moisture_budget_cs.nc"
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
     
      filedimdef(ncdf,"timelag",-1,True)   ; make time an UNLIMITED dimension
      ncdf->pwdtcsmean        = mergepwdtcsavg
      ncdf->iuqcsmean         = mergeiuqcsavg
	    ncdf->ivqcsmean         = mergeivqcsavg
	    ncdf->vimfdcsmean       = mergevimfdcsavg
      ncdf->pwdtcsvari        = mergepwdtcsvar
      ncdf->iuqcsvari         = mergeiuqcsvar
      ncdf->ivqcsvari         = mergeivqcsvar
      ncdf->vimfdcsvari       = mergevimfdcsvar
    end if

    if (netCDF) .and. (CENS)
      diro                = "./"
      filo                = "moisture_budget_cens.nc"
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
     
      filedimdef(ncdf,"timelag",-1,True)   ; make time an UNLIMITED dimension
      ncdf->pwdtcensmean        = mergepwdtcensavg
      ncdf->iuqcensmean         = mergeiuqcensavg
      ncdf->ivqcensmean         = mergeivqcensavg
      ncdf->vimfdcensmean       = mergevimfdcensavg
      ncdf->pwdtcensvari        = mergepwdtcensvar
      ncdf->iuqcensvari         = mergeiuqcensvar
      ncdf->ivqcensvari         = mergeivqcensvar
      ncdf->vimfdcensvari       = mergevimfdcensvar
    end if

  finish = systemfunc("date")
  
  print("Program start : "+ start +" ")
  print("Program end   : "+ finish +" ")
