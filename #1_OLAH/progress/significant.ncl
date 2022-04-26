;===========================================================================================;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;                                                                                           ;
; Start code => Monday, 25 Apr 2022 - 16.32 WIB (09.32 UTC)                                 ;
; Last time saved => Sunday, 24 April 2022 - 20.37 WIB
;                                                                                           ;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;===========================================================================================;

begin

  start = systemfunc("date")
  print(start)
  start_read_time = get_cpu_time()

  undef ("signif")
  function signif(xavg, xvar, xn, yavg, yvar, yn)
  begin
    iflag           = False  ; population variance similar
    tval_opt        = False  ; p-value only
    prob            = ttest(xavg,xvar,xn,yavg,yvar,yn,iflag,tval_opt)

    pval            = (/prob/)
    pval@long_name  = "probability"
    copy_VarCoords(xavg,pval)
    diff            = xavg - yavg
    diff@long_name  = "difference of the means"
    copy_VarCoords(xavg,diff)

    return ([/ xavg, diff, pval /])
  end

  ;===========================================================================================;
  ;;------------------------------------------------------------------------------------------:
  ;                                         MAIN CODE
  ;;------------------------------------------------------------------------------------------:
  ;===========================================================================================;

  ;--Command control

    uv     = False
    sst    = False
    hf     = True
    q1q2   = True
    mb     = False
    netCDF = True

    xncs   = 32
    xncens = 31
    yn     = 53
    pathin = "../data/#/"

  ;===========================================================================================;
  ;                                   Karakteristik CS CENS
  ;===========================================================================================;
  
  ;---------------------------------------------
  ;---Horizontal Wind Component (U,V) - 925 hPa
  ;---------------------------------------------
  
    if (uv)

      ;---Assign variable: u,v wind

        fin1   = addfile(pathin+"varsel_pressurelevel.nc","r")
        fin2   = addfile(pathin+"monmean_pressurelevel.nc","r")
        level  = 925

        xucsavg   = fin1->ucsmean(:,{level},:,:)
        xucsvar   = fin1->ucsvari(:,{level},:,:)
        xvcsavg   = fin1->vcsmean(:,{level},:,:)
        xvcsvar   = fin1->vcsvari(:,{level},:,:)

        xucensavg   = fin1->ucensmean(:,{level},:,:)
        xucensvar   = fin1->ucensvari(:,{level},:,:)
        xvcensavg   = fin1->vcensmean(:,{level},:,:)
        xvcensvar   = fin1->vcensvari(:,{level},:,:)

        yucsavg_   = dim_avg_n(fin2->u(:,{level},:,:),0)
        yucsvar_   = dim_variance_n(fin2->u(:,{level},:,:),0)
        yvcsavg_   = dim_avg_n(fin2->v(:,{level},:,:),0)
        yvcsvar_   = dim_variance_n(fin2->v(:,{level},:,:),0)
        yucsavg      = new((/21, 141, 121/), typeof(yucsavg_), yucsavg_@_FillValue)
        yucsvar      = new((/21, 141, 121/), typeof(yucsavg_), yucsavg_@_FillValue)
        yvcsavg      = new((/21, 141, 121/), typeof(yucsavg_), yucsavg_@_FillValue)
        yvcsvar      = new((/21, 141, 121/), typeof(yucsavg_), yucsavg_@_FillValue)
        printVarSummary(yucsavg)
        printVarSummary(yucsavg_)
        
        do i=0, 20
          yucsavg(0:0,:,:) = (/yucsavg_/)
          yucsvar(0:0,:,:) = (/yucsvar_/)
          yvcsavg(0:0,:,:) = (/yvcsavg_/)
          yvcsvar(0:0,:,:) = (/yvcsvar_/)
          yucsavg_        := yucsavg(0:0,:,:)
          yucsvar_        := yucsvar(0:0,:,:)
          yvcsavg_        := yvcsavg(0:0,:,:)
          yvcsvar_        := yvcsvar(0:0,:,:)
          yucsavg(i,:,:)   = yucsavg_
          yucsvar(i,:,:)   = yucsvar_
          yvcsavg(i,:,:)   = yvcsavg_
          yvcsvar(i,:,:)   = yvcsavg_
        end do

      ;---Calculate significance

        ucs      = signif(xucsavg,xucsvar,xncs,yucsavg,yucsvar,yn)
        vcs      = signif(xvcsavg,xvcsvar,xncs,yvcsavg,yvcsvar,yn)
        ucens    = signif(xucsavg,xucsvar,xncens,yucsavg,yucsvar,yn)
        vcens    = signif(xvcsavg,xvcsvar,xncens,yvcsavg,yvcsvar,yn)

    end if

  ;===========================================================================================;
  ;                                    Pelembapan CS CENS
  ;===========================================================================================;

  ;-------
  ;---SST
  ;-------

    if (sst)

      fin1        = addfile(pathin+"varsel_sst.nc","r")
      fin2        = addfile(pathin+"monmean_sst.nc","r")

      ;---Assign variable: analysed_sst

        xsstcsavg   = fin1->sstcsmean(:,:,:)
        xsstcsvar   = fin1->sstcsvari(:,:,:)

        xsstcensavg = fin1->sstcensmean(:,:,:)
        xsstcensvar = fin1->sstcensvari(:,:,:)

        ysstavg_  = dim_avg_n(short2flt(fin2->analysed_sst(:,:,:)),0)
        ysstvar_  = dim_variance_n(short2flt(fin2->analysed_sst(:,:,:)),0)

        ysstavg   = new((/21, 700, 600/), typeof(ysstavg_), ysstavg_@_FillValue)
        ysstvar   = new((/21, 700, 600/), typeof(ysstavg_), ysstavg_@_FillValue)

        printVarSummary(ysstavg)
        printVarSummary(ysstavg_)

        do i=0, 20
          ysstavg(0:0,:,:) = (/ysstavg_/)
          ysstvar(0:0,:,:) = (/ysstvar_/)

          ysstavg_        := ysstavg(0:0,:,:)
          ysstvar_        := ysstvar(0:0,:,:)

          ysstavg(i,:,:)   = ysstavg_
          ysstvar(i,:,:)   = ysstvar_
        end do

      ;---Calculate significance

        sstcs      = signif(xsstcsavg,xsstcsvar,xncs,ysstavg,ysstvar,yn)
        sstcens    = signif(xsstcensavg,xsstcensvar,xncens,ysstavg,ysstvar,yn)

    end if

  ;-------------
  ;---Heat Flux
  ;-------------

    if (hf)

      fsile1   = addfile(pathin+"varsel_singlelevel.nc","r")
      fsile2   = addfile(pathin+"monmean_singlelevel.nc","r")

      ;---Assign varieble: sshf & slhf
        xsshfcsavg   = fsile1->sshfcsmean(:,:,:)
        xsshfcsvar   = fsile1->sshfcsvari(:,:,:)
        xslhfcsavg   = fsile1->slhfcsmean(:,:,:)
        xslhfcsvar   = fsile1->slhfcsvari(:,:,:)

        xsshfcensavg   = fsile1->sshfcensmean(:,:,:)
        xsshfcensvar   = fsile1->sshfcensvari(:,:,:)
        xslhfcensavg   = fsile1->slhfcensmean(:,:,:)
        xslhfcensvar   = fsile1->slhfcensvari(:,:,:)

        ysshfavg_   = dim_avg_n(fsile2->sshf(:,:,:),0)
        ysshfvar_   = dim_variance_n(fsile2->sshf(:,:,:),0)
        yslhfavg_   = dim_avg_n(fsile2->slhf(:,:,:),0)
        yslhfvar_   = dim_variance_n(fsile2->slhf(:,:,:),0)

        ysshfavg      = new((/21, 141, 121/), typeof(ysshfavg_), ysshfavg_@_FillValue)
        ysshfvar      = new((/21, 141, 121/), typeof(ysshfavg_), ysshfavg_@_FillValue)
        yslhfavg      = new((/21, 141, 121/), typeof(ysshfavg_), ysshfavg_@_FillValue)
        yslhfvar      = new((/21, 141, 121/), typeof(ysshfavg_), ysshfavg_@_FillValue)

        ;printVarSummary(xsshfcsavg)
        ;printVarSummary(ysshfavg_)
        ;printVarSummary(ysshfavg)

        do i=0, 20
          ysshfavg(0:0,:,:) = (/ysshfavg_/)
          ysshfvar(0:0,:,:) = (/ysshfvar_/)
          yslhfavg(0:0,:,:) = (/yslhfavg_/)
          yslhfvar(0:0,:,:) = (/yslhfvar_/)

          ysshfavg_          := ysshfavg(0:0,:,:)
          ysshfvar_          := ysshfvar(0:0,:,:)
          yslhfavg_          := yslhfavg(0:0,:,:)
          yslhfvar_          := yslhfvar(0:0,:,:)

          ysshfavg(i,:,:)   = ysshfavg_
          ysshfvar(i,:,:)   = ysshfvar_
          yslhfavg(i,:,:)   = yslhfavg_
          yslhfvar(i,:,:)   = yslhfvar_
        end do

      ;---Calculate significance

        sshfcs      = signif(xsshfcsavg,xsshfcsvar,xncs,ysshfavg,ysshfvar,yn)
        slhfcs      = signif(xslhfcsavg,xslhfcsvar,xncs,yslhfavg,yslhfvar,yn)

        sshfcens      = signif(xsshfcensavg,xsshfcensvar,xncens,ysshfavg,ysshfvar,yn)
        slhfcens      = signif(xslhfcensavg,xslhfcensvar,xncens,yslhfavg,yslhfvar,yn)

    end if

  ;--------------
  ;---Yanai_Q1Q2
  ;--------------

    if (q1q2)

      fq1q21   = addfile(pathin+"var_YANAI_Q1Q2.nc","r")
      fq1q22   = addfile(pathin+"monmean_YANAI_Q1Q2.nc","r")
      time     = fq1q21->timelag
      lev      = fq1q21->lev
      lat      = fq1q21->lat
      lon      = fq1q21->lon

      ;---Q/cp

        xq1percpcsavg   = doubletofloat(fq1q21->Q1percpcsmean(:,:,:,:))
        xq1percpcsvar   = doubletofloat(fq1q21->Q1percpcsvari(:,:,:,:))
        xq2percpcsavg   = doubletofloat(fq1q21->Q2percpcsmean(:,:,:,:))
        xq2percpcsvar   = doubletofloat(fq1q21->Q2percpcsvari(:,:,:,:))
        xq1percpcsavg!0 = "timelag"
        xq1percpcsavg!1 = "lev"
        xq1percpcsavg!2 = "lat"
        xq1percpcsavg!3 = "lon"
        xq1percpcsavg&timelag = time
        xq1percpcsavg&lev     = lev
        xq1percpcsavg&lat     = lat
        xq1percpcsavg&lon     = lon
        copy_VarCoords(xq1percpcsavg, xq1percpcsvar)
        copy_VarCoords(xq1percpcsavg, xq2percpcsavg)
        copy_VarCoords(xq1percpcsavg, xq2percpcsvar)

        xq1percpcensavg = doubletofloat(fq1q21->Q1percpcensmean(:,:,:,:))
        xq1percpcensvar = doubletofloat(fq1q21->Q1percpcensvari(:,:,:,:))
        xq2percpcensavg = doubletofloat(fq1q21->Q2percpcensmean(:,:,:,:))
        xq2percpcensvar = doubletofloat(fq1q21->Q2percpcensvari(:,:,:,:))
        copy_VarCoords(xq1percpcsavg, xq1percpcensavg)
        copy_VarCoords(xq1percpcsavg, xq1percpcensvar)
        copy_VarCoords(xq1percpcsavg, xq2percpcensavg)
        copy_VarCoords(xq1percpcsavg, xq2percpcensvar)

        yq1percpavg_    = dim_avg_n(fq1q22->Q1percp(:,:,:,:),0)
        yq1percpvar_    = dim_variance_n(fq1q22->Q1percp(:,:,:,:),0)
        yq2percpavg_    = dim_avg_n(fq1q22->Q2percp(:,:,:,:),0)
        yq2percpvar_    = dim_variance_n(fq1q22->Q2percp(:,:,:,:),0)

        yq1percpavg     = new((/21, 27, 141, 121/), typeof(yq1percpavg_), yq1percpavg_@_FillValue)
        yq1percpvar     = new((/21, 27, 141, 121/), typeof(yq1percpavg_), yq1percpavg_@_FillValue)
        yq2percpavg     = new((/21, 27, 141, 121/), typeof(yq1percpavg_), yq1percpavg_@_FillValue)
        yq2percpvar     = new((/21, 27, 141, 121/), typeof(yq1percpavg_), yq1percpavg_@_FillValue)

        ;printVarSummary(yq1percpavg_)
        ;printVarSummary(yq1percpavg)

        do i=0, 20
          yq1percpavg(0:0,:,:,:) = (/yq1percpavg_/)
          yq1percpvar(0:0,:,:,:) = (/yq1percpvar_/)
          yq2percpavg(0:0,:,:,:) = (/yq2percpavg_/)
          yq2percpvar(0:0,:,:,:) = (/yq2percpvar_/)

          yq1percpavg_          := yq1percpavg(0:0,:,:,:)
          yq1percpvar_          := yq1percpvar(0:0,:,:,:)
          yq2percpavg_          := yq2percpavg(0:0,:,:,:)
          yq2percpvar_          := yq2percpvar(0:0,:,:,:)

          yq1percpavg(i,:,:,:)   = yq1percpavg_
          yq1percpvar(i,:,:,:)   = yq1percpvar_
          yq2percpavg(i,:,:,:)   = yq2percpavg_
          yq2percpvar(i,:,:,:)   = yq2percpvar_
        end do

      ;---<Q>

        xq1intcsavg   = doubletofloat(fq1q21->Q1intcsmean(:,:,:))
        xq1intcsvar   = doubletofloat(fq1q21->Q1intcsvari(:,:,:))
        xq2intcsavg   = doubletofloat(fq1q21->Q2intcsmean(:,:,:))
        xq2intcsvar   = doubletofloat(fq1q21->Q2intcsvari(:,:,:))

        xq1intcensavg = doubletofloat(fq1q21->Q1intcensmean(:,:,:))
        xq1intcensvar = doubletofloat(fq1q21->Q1intcensvari(:,:,:))
        xq2intcensavg = doubletofloat(fq1q21->Q2intcensmean(:,:,:))
        xq2intcensvar = doubletofloat(fq1q21->Q2intcensvari(:,:,:))

        yq1intavg_    = dim_avg_n(fq1q22->Q1int(:,:,:),0)
        yq1intvar_    = dim_variance_n(fq1q22->Q1int(:,:,:),0)
        yq2intavg_    = dim_avg_n(fq1q22->Q2int(:,:,:),0)
        yq2intvar_    = dim_variance_n(fq1q22->Q2int(:,:,:),0)

        yq1intavg     = new((/21, 141, 121/), typeof(yq1intavg_), yq1intavg_@_FillValue)
        yq1intvar     = new((/21, 141, 121/), typeof(yq1intavg_), yq1intavg_@_FillValue)
        yq2intavg     = new((/21, 141, 121/), typeof(yq1intavg_), yq1intavg_@_FillValue)
        yq2intvar     = new((/21, 141, 121/), typeof(yq1intavg_), yq1intavg_@_FillValue)

        ;printVarSummary(yq1intavg_)
        ;printVarSummary(yq1intavg)

        do i=0, 20
          yq1intavg(0:0,:,:) = (/yq1intavg_/)
          yq1intvar(0:0,:,:) = (/yq1intvar_/)
          yq2intavg(0:0,:,:) = (/yq2intavg_/)
          yq2intvar(0:0,:,:) = (/yq2intvar_/)

          yq1intavg_          := yq1intavg(0:0,:,:)
          yq1intvar_          := yq1intvar(0:0,:,:)
          yq2intavg_          := yq2intavg(0:0,:,:)
          yq2intvar_          := yq2intvar(0:0,:,:)

          yq1intavg(i,:,:)   = yq1intavg_
          yq1intvar(i,:,:)   = yq1intvar_
          yq2intavg(i,:,:)   = yq2intavg_
          yq2intvar(i,:,:)   = yq2intvar_
        end do

      ;---Calculate significance

        ;--Q/cp
        q1percpcs      = signif(xq1percpcsavg,xq1percpcsvar,xncs,yq1percpavg,yq1percpvar,yn)
        q2percpcs      = signif(xq2percpcsavg,xq2percpcsvar,xncs,yq2percpavg,yq2percpvar,yn)
        q1percpcens    = signif(xq1percpcensavg,xq1percpcensvar,xncens,yq1percpavg,yq1percpvar,yn)
        q2percpcens    = signif(xq2percpcensavg,xq2percpcensvar,xncens,yq2percpavg,yq2percpvar,yn)

        ;--<Q>
        q1intcs      = signif(xq1intcsavg,xq1intcsvar,xncs,yq1intavg,yq1intvar,yn)
        q2intcs      = signif(xq2intcsavg,xq2intcsvar,xncs,yq2intavg,yq2intvar,yn)
        q1intcens    = signif(xq1intcensavg,xq1intcensvar,xncens,yq1intavg,yq1intvar,yn)
        q2intcens    = signif(xq2intcensavg,xq2intcensvar,xncens,yq2intavg,yq2intvar,yn)

        printVarSummary(xq1percpcsavg)
        printVarSummary(q1percpcs[0])
        printVarSummary(q1percpcs[1])
        printVarSummary(q1percpcs[2])
        printVarSummary(q1percpcens[0])
        printVarSummary(q1percpcens[1])
        printVarSummary(q1percpcens[2])

    end if

  ;===========================================================================================;
  ;                                   Moisture Budget CS CENS
  ;===========================================================================================;

  if (mb)

    fsile1   = addfile(pathin+"varsel_singlelevel.nc","r")
    fsile2   = addfile(pathin+"monmean_singlelevel.nc","r")

    fmb1   = addfile(pathin+"var_moisture_budget.nc","r")
    fmb2   = addfile(pathin+"monmean_moisture_budget.nc","r")

    ;---E-P

      xecsavg     = fsile1->ecsmean(:,:,:)
      xecsvar     = fsile1->ecsvari(:,:,:)
      xtpcsavg    = fsile1->tpcsmean(:,:,:)
      xtpcsvar    = fsile1->tpcsvari(:,:,:)

      xecensavg   = fsile1->ecensmean(:,:,:)
      xecensvar   = fsile1->ecensvari(:,:,:)
      xtpcensavg  = fsile1->tpcensmean(:,:,:)
      xtpcensvar  = fsile1->tpcensvari(:,:,:)

      yeavg_      = dim_avg_n(fsile2->e(:,:,:),0)
      yevar_      = dim_variance_n(fsile2->e(:,:,:),0)
      ytpavg_     = dim_avg_n(fsile2->tp(:,:,:),0)
      ytpvar_     = dim_variance_n(fsile2->tp(:,:,:),0)

      yeavg       = new((/21, 141, 121/), typeof(yeavg_), yeavg_@_FillValue)
      yevar       = new((/21, 141, 121/), typeof(yeavg_), yeavg_@_FillValue)
      ytpavg      = new((/21, 141, 121/), typeof(yeavg_), yeavg_@_FillValue)
      ytpvar      = new((/21, 141, 121/), typeof(yeavg_), yeavg_@_FillValue)

      printVarSummary(yeavg_)
      printVarSummary(yeavg)

      do i=0, 20
        yeavg(0:0,:,:)  = (/yeavg_/)
        yevar(0:0,:,:)  = (/yevar_/)
        ytpavg(0:0,:,:) = (/ytpavg_/)
        ytpvar(0:0,:,:) = (/ytpvar_/)

        yeavg_         := yeavg(0:0,:,:)
        yevar_         := yevar(0:0,:,:)
        ytpavg_        := ytpavg(0:0,:,:)
        ytpvar_        := ytpvar(0:0,:,:)

        yeavg(i,:,:)    = yeavg_
        yevar(i,:,:)    = yevar_
        ytpavg(i,:,:)   = ytpavg_
        ytpvar(i,:,:)   = ytpvar_
      end do

    ;---d<q>/dt : Precipitable water tendency

      xpwdtcsavg     = fmb1->pwdtcsmean(:,:,:)
      xpwdtcsvar     = fmb1->pwdtcsvari(:,:,:)

      xpwdtcensavg   = fmb1->pwdtcensmean(:,:,:)
      xpwdtcensvar   = fmb1->pwdtcensvari(:,:,:)

      ypwdtavg_      = dim_avg_n(fmb2->pwdt(:,:,:),0)
      ypwdtvar_      = dim_variance_n(fmb2->pwdt(:,:,:),0)

      ypwdtavg       = new((/21, 141, 121/), typeof(ypwdtavg_), ypwdtavg_@_FillValue)
      ypwdtvar       = new((/21, 141, 121/), typeof(ypwdtavg_), ypwdtavg_@_FillValue)

      printVarSummary(ypwdtavg_)
      printVarSummary(ypwdtavg)

      do i=0, 20
        ypwdtavg(0:0,:,:)  = (/ypwdtavg_/)
        ypwdtvar(0:0,:,:)  = (/ypwdtvar_/)

        ypwdtavg_         := ypwdtavg(0:0,:,:)
        ypwdtvar_         := ypwdtvar(0:0,:,:)

        ypwdtavg(i,:,:)    = ypwdtavg_
        ypwdtvar(i,:,:)    = ypwdtvar_
      end do

    ;---iuq_ivq : integrated moisture flux (zonal & meridional)

      xiuqcsavg     = fsile1->ecsmean(:,:,:)
      xiuqcsvar     = fsile1->ecsvari(:,:,:)
      xivqcsavg    = fsile1->tpcsmean(:,:,:)
      xivqcsvar    = fsile1->tpcsvari(:,:,:)

      xiuqcensavg   = fsile1->ecensmean(:,:,:)
      xiuqcensvar   = fsile1->ecensvari(:,:,:)
      xivqcensavg  = fsile1->tpcensmean(:,:,:)
      xivqcensvar  = fsile1->tpcensvari(:,:,:)

      yiuqavg_      = dim_avg_n(fsile2->e(:,:,:),0)
      yiuqvar_      = dim_variance_n(fsile2->e(:,:,:),0)
      yivqavg_     = dim_avg_n(fsile2->tp(:,:,:),0)
      yivqvar_     = dim_variance_n(fsile2->tp(:,:,:),0)

      yiuqavg       = new((/21, 141, 121/), typeof(yiuqavg_), yiuqavg_@_FillValue)
      yiuqvar       = new((/21, 141, 121/), typeof(yiuqavg_), yiuqavg_@_FillValue)
      yivqavg      = new((/21, 141, 121/), typeof(yiuqavg_), yiuqavg_@_FillValue)
      yivqvar      = new((/21, 141, 121/), typeof(yiuqavg_), yiuqavg_@_FillValue)

      printVarSummary(yiuqavg_)
      printVarSummary(yiuqavg)

      do i=0, 20
        yiuqavg(0:0,:,:)  = (/yiuqavg_/)
        yiuqvar(0:0,:,:)  = (/yiuqvar_/)
        yivqavg(0:0,:,:) = (/yivqavg_/)
        yivqvar(0:0,:,:) = (/yivqvar_/)

        yiuqavg_         := yiuqavg(0:0,:,:)
        yiuqvar_         := yiuqvar(0:0,:,:)
        yivqavg_        := yivqavg(0:0,:,:)
        yivqvar_        := yivqvar(0:0,:,:)

        yiuqavg(i,:,:)    = yiuqavg_
        yiuqvar(i,:,:)    = yiuqvar_
        yivqavg(i,:,:)   = yivqavg_
        yivqvar(i,:,:)   = yivqvar_
      end do

    ;---{del}.[iuq, ivq] : Vertically Integrated Moisture flux divergence

      xvimfdcsavg     = fmb1->vimfdcsmean(:,:,:)
      xvimfdcsvar     = fmb1->vimfdcsvari(:,:,:)

      xvimfdcensavg   = fmb1->vimfdcensmean(:,:,:)
      xvimfdcensvar   = fmb1->vimfdcensvari(:,:,:)

      yvimfdavg_      = dim_avg_n(fmb2->vimfd(:,:,:),0)
      yvimfdvar_      = dim_variance_n(fmb2->vimfd(:,:,:),0)

      yvimfdavg       = new((/21, 141, 121/), typeof(yvimfdavg_), yvimfdavg_@_FillValue)
      yvimfdvar       = new((/21, 141, 121/), typeof(yvimfdavg_), yvimfdavg_@_FillValue)

      printVarSummary(yvimfdavg_)
      printVarSummary(yvimfdavg)

      do i=0, 20
        yvimfdavg(0:0,:,:)  = (/yvimfdavg_/)
        yvimfdvar(0:0,:,:)  = (/yvimfdvar_/)

        yvimfdavg_         := yvimfdavg(0:0,:,:)
        yvimfdvar_         := yvimfdvar(0:0,:,:)

        yvimfdavg(i,:,:)    = yvimfdavg_
        yvimfdvar(i,:,:)    = yvimfdvar_
      end do

    ;---Calculate significance

      ;--E-P
      ecs      = signif(xecsavg,xecsvar,xncs,yeavg,yevar,yn)
      tpcs     = signif(xtpcsavg,xtpcsvar,xncs,ytpavg,ytpvar,yn)
      ecens    = signif(xecensavg,xecensvar,xncens,yeavg,yevar,yn)
      tpcens   = signif(xtpcensavg,xtpcensvar,xncens,ytpavg,ytpvar,yn)

      ;--pwdt
      pwdtcs      = signif(xpwdtcsavg,xpwdtcsvar,xncs,ypwdtavg,ypwdtvar,yn)
      pwdtcens    = signif(xpwdtcensavg,xpwdtcensvar,xncens,ypwdtavg,ypwdtvar,yn)

      ;--iuq_ivq
      iuqcs      = signif(xiuqcsavg,xiuqcsvar,xncs,yiuqavg,yiuqvar,yn)
      ivqcs      = signif(xivqcsavg,xivqcsvar,xncs,yivqavg,yivqvar,yn)
      iuqcens    = signif(xiuqcensavg,xiuqcensvar,xncens,yiuqavg,yiuqvar,yn)
      ivqcens    = signif(xivqcensavg,xivqcensvar,xncens,yivqavg,yivqvar,yn)

      ;--{del}.[iuq, ivq]
      vimfdcs      = signif(xvimfdcsavg,xvimfdcsvar,xncs,yvimfdavg,yvimfdvar,yn)
      vimfdcens    = signif(xvimfdcensavg,xvimfdcensvar,xncens,yvimfdavg,yvimfdvar,yn)
  end if

  ;===========================================================================================;
  ;                                       Write NetCDF
  ;===========================================================================================;

    if (netCDF) .and. (uv)
      diro                = "./"
      filo                = "#uv.nc"
      ptho                = diro+filo
      system("/bin/rm -f "+ptho)
      ncdf                = addfile(ptho,"c")
    
      fAtt = True
      fAtt@title          = "UV Wind - CS/CENS"
      fAtt@source         = "ECMWF"
      fAtt@Conventions    = "None"
      fAtt@creation_date  = systemfunc("date")
      fileattdef(ncdf,fAtt)             ; copy file attributes
     
      filedimdef(ncdf,"time",-1,True)   ; make time an UNLIMITED dimension
      ncdf->ucsmean   = ucs[0]
      ncdf->ucsdiff   = ucs[1]
      ncdf->ucspval   = ucs[2]
      ncdf->ucensmean = ucens[0]
      ncdf->ucensdiff = ucens[1]
      ncdf->ucenspval = ucens[2]

      ncdf->vcsmean   = vcs[0]
      ncdf->vcsdiff   = vcs[1]
      ncdf->vcspval   = vcs[2]
      ncdf->vcensmean = vcens[0]
      ncdf->vcensdiff = vcens[1]
      ncdf->vcenspval = vcens[2]
    end if

    if (netCDF) .and. (sst)
      diro                = "./"
      filo                = "#sst.nc"
      ptho                = diro+filo
      system("/bin/rm -f "+ptho)
      ncdf                = addfile(ptho,"c")
    
      fAtt = True
      fAtt@title          = "SST - CS/CENS"
      fAtt@source         = "ECMWF"
      fAtt@Conventions    = "None"
      fAtt@creation_date  = systemfunc("date")
      fileattdef(ncdf,fAtt)             ; copy file attribssttes
     
      filedimdef(ncdf,"time",-1,True)   ; make time an UNLIMITED dimension
      ncdf->sstcsmean   = sstcs[0]
      ncdf->sstcsdiff   = sstcs[1]
      ncdf->sstcspval   = sstcs[2]
      ncdf->sstcensmean = sstcens[0]
      ncdf->sstcensdiff = sstcens[1]
      ncdf->sstcenspval = sstcens[2]
    end if

    if (netCDF) .and. (hf) .and. (q1q2) 
      diro                = "./"
      filo                = "#hf_q1q2.nc"
      ptho                = diro+filo
      system("/bin/rm -f "+ptho)
      ncdf                = addfile(ptho,"c")
    
      fAtt = True
      fAtt@title          = "Surface Heat Flux and Yanai_Q1Q2 - CS/CENS"
      fAtt@source         = "ECMWF"
      fAtt@Conventions    = "None"
      fAtt@creation_date  = systemfunc("date")
      fileattdef(ncdf,fAtt)             ; copy file attributes
     
      filedimdef(ncdf,"time",-1,True)   ; make time an UNLIMITED dimension
      ncdf->sshfcsmean   = sshfcs[0]
      ncdf->sshfcsdiff   = sshfcs[1]
      ncdf->sshfcspval   = sshfcs[2]
      ncdf->sshfcensmean = sshfcens[0]
      ncdf->sshfcensdiff = sshfcens[1]
      ncdf->sshfcenspval = sshfcens[2]

      ncdf->slhfcsmean   = slhfcs[0]
      ncdf->slhfcsdiff   = slhfcs[1]
      ncdf->slhfcspval   = slhfcs[2]
      ncdf->slhfcensmean = slhfcens[0]
      ncdf->slhfcensdiff = slhfcens[1]
      ncdf->slhfcenspval = slhfcens[2]

      ncdf->q1percpcsmean   = q1percpcs[0]
      ncdf->q1percpcsdiff   = q1percpcs[1]
      ncdf->q1percpcspval   = q1percpcs[2]
      ncdf->q1percpcensmean = q1percpcens[0]
      ncdf->q1percpcensdiff = q1percpcens[1]
      ncdf->q1percpcenspval = q1percpcens[2]

      ncdf->q2percpcsmean   = q2percpcs[0]
      ncdf->q2percpcsdiff   = q2percpcs[1]
      ncdf->q2percpcspval   = q2percpcs[2]
      ncdf->q2percpcensmean = q2percpcens[0]
      ncdf->q2percpcensdiff = q2percpcens[1]
      ncdf->q2percpcenspval = q2percpcens[2]

      ncdf->q1intcsmean   = q1intcs[0]
      ncdf->q1intcsdiff   = q1intcs[1]
      ncdf->q1intcspval   = q1intcs[2]
      ncdf->q1intcensmean = q1intcens[0]
      ncdf->q1intcensdiff = q1intcens[1]
      ncdf->q1intcenspval = q1intcens[2]
      
      ncdf->q2intcsmean   = q2intcs[0]
      ncdf->q2intcsdiff   = q2intcs[1]
      ncdf->q2intcspval   = q2intcs[2]
      ncdf->q2intcensmean = q2intcens[0]
      ncdf->q2intcensdiff = q2intcens[1]
      ncdf->q2intcenspval = q2intcens[2]
    end if

    if (netCDF) .and. (mb) 
      diro                = "./"
      filo                = "#mb.nc"
      ptho                = diro+filo
      system("/bin/rm -f "+ptho)
      ncdf                = addfile(ptho,"c")
    
      fAtt = True
      fAtt@title          = "Surface Heat Flux and Yanai_Q1Q2 - CS/CENS"
      fAtt@source         = "ECMWF"
      fAtt@Conventions    = "None"
      fAtt@creation_date  = systemfunc("date")
      fileattdef(ncdf,fAtt)             ; copy file attributes
     
      filedimdef(ncdf,"time",-1,True)   ; make time an UNLIMITED dimension
      ncdf->ecsmean   = ecs[0]
      ncdf->ecsdiff   = ecs[1]
      ncdf->ecspval   = ecs[2]
      ncdf->ecensmean = ecens[0]
      ncdf->ecensdiff = ecens[1]
      ncdf->ecenspval = ecens[2]

      ncdf->tpcsmean   = tpcs[0]
      ncdf->tpcsdiff   = tpcs[1]
      ncdf->tpcspval   = tpcs[2]
      ncdf->tpcensmean = tpcens[0]
      ncdf->tpcensdiff = tpcens[1]
      ncdf->tpcenspval = tpcens[2]

      ncdf->pwdtcsmean   = pwdtcs[0]
      ncdf->pwdtcsdiff   = pwdtcs[1]
      ncdf->pwdtcspval   = pwdtcs[2]
      ncdf->pwdtcensmean = pwdtcens[0]
      ncdf->pwdtcensdiff = pwdtcens[1]
      ncdf->pwdtcenspval = pwdtcens[2]

      ncdf->iuqcsmean   = iuqcs[0]
      ncdf->iuqcsdiff   = iuqcs[1]
      ncdf->iuqcspval   = iuqcs[2]
      ncdf->iuqcensmean = iuqcens[0]
      ncdf->iuqcensdiff = iuqcens[1]
      ncdf->iuqcenspval = iuqcens[2]

      ncdf->ivqcsmean   = ivqcs[0]
      ncdf->ivqcsdiff   = ivqcs[1]
      ncdf->ivqcspval   = ivqcs[2]
      ncdf->ivqcensmean = ivqcens[0]
      ncdf->ivqcensdiff = ivqcens[1]
      ncdf->ivqcenspval = ivqcens[2]
      
      ncdf->vimfdcsmean   = vimfdcs[0]
      ncdf->vimfdcsdiff   = vimfdcs[1]
      ncdf->vimfdcspval   = vimfdcs[2]
      ncdf->vimfdcensmean = vimfdcens[0]
      ncdf->vimfdcensdiff = vimfdcens[1]
      ncdf->vimfdcenspval = vimfdcens[2]
    end if

  finish = systemfunc("date")
  
  print("Program start : "+ start +" ")
  print("Program end   : "+ finish +" ")

end