begin
  
  pathin = "./"
  fhf    = addfile(pathin+"#hf_q1q2.nc","r")
  fsst   = addfile(pathin+"#sst.nc","r")
  fmb    = addfile(pathin+"#mb.nc","r")
  hf     = True
  sst    = True
  q1q2   = True
  mb     = True
  netCDF = True

  ra   = ([/ 9, 18, 110, 118 /])
  rb   = ([/ 3, 8, 105, 112.5 /])
  rc   = ([/ -2.5, 3.5, 105, 109 /])
  rd   = ([/ -6, -3.5, 106.5, 114.5 /])

  ras  = "REGION A"
  rbs  = "REGION B"
  rcs  = "REGION C"
  rds  = "REGION D"


  wgty       = 1
  wgtx       = 1
  opt        = 1
  optmiss     = 0 ;set jd 0 karena ada missing value, supaya nggak muncul "entire grid undefined"

  sshfsample    = fhf->sshfcsmean
  slhfsample    = fhf->slhfcsmean
  sstsample     = fsst->sstcsmean
  q1percpsample = fhf->q1percpcsmean
  q2percpsample = fhf->q2percpcsmean
  q1intsample   = fhf->q1intcsmean
  q2intsample   = fhf->q2intcsmean
  esample       = fmb->ecsmean
  tpsample      = fmb->tpcsmean
  pwdtsample    = fmb->pwdtcsmean
  iuqsample     = fmb->iuqcsmean
  ivqsample     = fmb->ivqcsmean
  vimfdsample   = fmb->vimfdcsmean
  latsample     = fhf->lat
  lonsample     = fhf->lon
  levsample     = fhf->lev

  lat = 1
  lat@units = latsample@units
  lat@long_name = latsample@long_name
  lon = 1
  lon@units = lonsample@units
  lon@long_name = lonsample@long_name

  ;--hf
  if (hf)

    ;--CS

    sshfcsmean_ra = wgt_areaave(fhf->sshfcsmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, opt)
    sshfcsmean_rb = wgt_areaave(fhf->sshfcsmean(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, opt)
    sshfcsmean_rc = wgt_areaave(fhf->sshfcsmean(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, opt)
    sshfcsmean_rd = wgt_areaave(fhf->sshfcsmean(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, opt)

    sshfcsdiff_ra = wgt_areaave(fhf->sshfcsdiff(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, opt)
    sshfcsdiff_rb = wgt_areaave(fhf->sshfcsdiff(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, opt)
    sshfcsdiff_rc = wgt_areaave(fhf->sshfcsdiff(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, opt)
    sshfcsdiff_rd = wgt_areaave(fhf->sshfcsdiff(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, opt)

    sshfcspval_ra = wgt_areaave(fhf->sshfcspval(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, opt)
    sshfcspval_rb = wgt_areaave(fhf->sshfcspval(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, opt)
    sshfcspval_rc = wgt_areaave(fhf->sshfcspval(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, opt)
    sshfcspval_rd = wgt_areaave(fhf->sshfcspval(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, opt)

    slhfcsmean_ra = wgt_areaave(fhf->slhfcsmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, opt)
    slhfcsmean_rb = wgt_areaave(fhf->slhfcsmean(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, opt)
    slhfcsmean_rc = wgt_areaave(fhf->slhfcsmean(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, opt)
    slhfcsmean_rd = wgt_areaave(fhf->slhfcsmean(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, opt)

    slhfcsdiff_ra = wgt_areaave(fhf->slhfcsdiff(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, opt)
    slhfcsdiff_rb = wgt_areaave(fhf->slhfcsdiff(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, opt)
    slhfcsdiff_rc = wgt_areaave(fhf->slhfcsdiff(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, opt)
    slhfcsdiff_rd = wgt_areaave(fhf->slhfcsdiff(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, opt)

    slhfcspval_ra = wgt_areaave(fhf->slhfcspval(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, opt)
    slhfcspval_rb = wgt_areaave(fhf->slhfcspval(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, opt)
    slhfcspval_rc = wgt_areaave(fhf->slhfcspval(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, opt)
    slhfcspval_rd = wgt_areaave(fhf->slhfcspval(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, opt)

    ;--CENS

    sshfcensmean_ra = wgt_areaave(fhf->sshfcensmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, opt)
    sshfcensmean_rb = wgt_areaave(fhf->sshfcensmean(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, opt)
    sshfcensmean_rc = wgt_areaave(fhf->sshfcensmean(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, opt)
    sshfcensmean_rd = wgt_areaave(fhf->sshfcensmean(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, opt)

    sshfcensdiff_ra = wgt_areaave(fhf->sshfcensdiff(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, opt)
    sshfcensdiff_rb = wgt_areaave(fhf->sshfcensdiff(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, opt)
    sshfcensdiff_rc = wgt_areaave(fhf->sshfcensdiff(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, opt)
    sshfcensdiff_rd = wgt_areaave(fhf->sshfcensdiff(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, opt)

    sshfcenspval_ra = wgt_areaave(fhf->sshfcenspval(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, opt)
    sshfcenspval_rb = wgt_areaave(fhf->sshfcenspval(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, opt)
    sshfcenspval_rc = wgt_areaave(fhf->sshfcenspval(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, opt)
    sshfcenspval_rd = wgt_areaave(fhf->sshfcenspval(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, opt)

    slhfcensmean_ra = wgt_areaave(fhf->slhfcensmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, opt)
    slhfcensmean_rb = wgt_areaave(fhf->slhfcensmean(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, opt)
    slhfcensmean_rc = wgt_areaave(fhf->slhfcensmean(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, opt)
    slhfcensmean_rd = wgt_areaave(fhf->slhfcensmean(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, opt)

    slhfcensdiff_ra = wgt_areaave(fhf->slhfcensdiff(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, opt)
    slhfcensdiff_rb = wgt_areaave(fhf->slhfcensdiff(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, opt)
    slhfcensdiff_rc = wgt_areaave(fhf->slhfcensdiff(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, opt)
    slhfcensdiff_rd = wgt_areaave(fhf->slhfcensdiff(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, opt)

    slhfcenspval_ra = wgt_areaave(fhf->slhfcenspval(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, opt)
    slhfcenspval_rb = wgt_areaave(fhf->slhfcenspval(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, opt)
    slhfcenspval_rc = wgt_areaave(fhf->slhfcenspval(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, opt)
    slhfcenspval_rd = wgt_areaave(fhf->slhfcenspval(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, opt)

  end if

  ;--sst
  if (sst)

    ;--CS

    sstcsmean_ra = wgt_areaave(fsst->sstcsmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    sstcsmean_rb = wgt_areaave(fsst->sstcsmean(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    sstcsmean_rc = wgt_areaave(fsst->sstcsmean(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    sstcsmean_rd = wgt_areaave(fsst->sstcsmean(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    sstcsdiff_ra = wgt_areaave(fsst->sstcsdiff(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    sstcsdiff_rb = wgt_areaave(fsst->sstcsdiff(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    sstcsdiff_rc = wgt_areaave(fsst->sstcsdiff(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    sstcsdiff_rd = wgt_areaave(fsst->sstcsdiff(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    sstcspval_ra = wgt_areaave(fsst->sstcspval(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    sstcspval_rb = wgt_areaave(fsst->sstcspval(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    sstcspval_rc = wgt_areaave(fsst->sstcspval(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    sstcspval_rd = wgt_areaave(fsst->sstcspval(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    ;--CENS
    
    sstcensmean_ra = wgt_areaave(fsst->sstcensmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    sstcensmean_rb = wgt_areaave(fsst->sstcensmean(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    sstcensmean_rc = wgt_areaave(fsst->sstcensmean(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    sstcensmean_rd = wgt_areaave(fsst->sstcensmean(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    sstcensdiff_ra = wgt_areaave(fsst->sstcensdiff(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    sstcensdiff_rb = wgt_areaave(fsst->sstcensdiff(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    sstcensdiff_rc = wgt_areaave(fsst->sstcensdiff(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    sstcensdiff_rd = wgt_areaave(fsst->sstcensdiff(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    sstcenspval_ra = wgt_areaave(fsst->sstcenspval(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    sstcenspval_rb = wgt_areaave(fsst->sstcenspval(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    sstcenspval_rc = wgt_areaave(fsst->sstcenspval(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    sstcenspval_rd = wgt_areaave(fsst->sstcenspval(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

  end if

  ;--q1q2
  if(q1q2)

    ;--CS

    q1percpcsmean_ra = wgt_areaave(fhf->q1percpcsmean(:,:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, opt)
    q1percpcsmean_rb = wgt_areaave(fhf->q1percpcsmean(:,:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, opt)
    q1percpcsmean_rc = wgt_areaave(fhf->q1percpcsmean(:,:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, opt)
    q1percpcsmean_rd = wgt_areaave(fhf->q1percpcsmean(:,:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, opt)

    q1percpcsdiff_ra = wgt_areaave(doubletofloat(fhf->q1percpcsdiff(:,:,{ra[0]:ra[1]},{ra[2]:ra[3]})), wgty, wgtx, opt)
    q1percpcsdiff_rb = wgt_areaave(doubletofloat(fhf->q1percpcsdiff(:,:,{rb[0]:rb[1]},{rb[2]:rb[3]})), wgty, wgtx, opt)
    q1percpcsdiff_rc = wgt_areaave(doubletofloat(fhf->q1percpcsdiff(:,:,{rc[0]:rc[1]},{rc[2]:rc[3]})), wgty, wgtx, opt)
    q1percpcsdiff_rd = wgt_areaave(doubletofloat(fhf->q1percpcsdiff(:,:,{rd[0]:rd[1]},{rd[2]:rd[3]})), wgty, wgtx, opt)

    q1percpcspval_ra = wgt_areaave(doubletofloat(fhf->q1percpcspval(:,:,{ra[0]:ra[1]},{ra[2]:ra[3]})), wgty, wgtx, optmiss)
    q1percpcspval_rb = wgt_areaave(doubletofloat(fhf->q1percpcspval(:,:,{rb[0]:rb[1]},{rb[2]:rb[3]})), wgty, wgtx, optmiss)
    q1percpcspval_rc = wgt_areaave(doubletofloat(fhf->q1percpcspval(:,:,{rc[0]:rc[1]},{rc[2]:rc[3]})), wgty, wgtx, optmiss)
    q1percpcspval_rd = wgt_areaave(doubletofloat(fhf->q1percpcspval(:,:,{rd[0]:rd[1]},{rd[2]:rd[3]})), wgty, wgtx, optmiss)

    q2percpcsmean_ra = wgt_areaave(fhf->q2percpcsmean(:,:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, opt)
    q2percpcsmean_rb = wgt_areaave(fhf->q2percpcsmean(:,:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, opt)
    q2percpcsmean_rc = wgt_areaave(fhf->q2percpcsmean(:,:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, opt)
    q2percpcsmean_rd = wgt_areaave(fhf->q2percpcsmean(:,:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, opt)

    q2percpcsdiff_ra = wgt_areaave(doubletofloat(fhf->q2percpcsdiff(:,:,{ra[0]:ra[1]},{ra[2]:ra[3]})), wgty, wgtx, opt)
    q2percpcsdiff_rb = wgt_areaave(doubletofloat(fhf->q2percpcsdiff(:,:,{rb[0]:rb[1]},{rb[2]:rb[3]})), wgty, wgtx, opt)
    q2percpcsdiff_rc = wgt_areaave(doubletofloat(fhf->q2percpcsdiff(:,:,{rc[0]:rc[1]},{rc[2]:rc[3]})), wgty, wgtx, opt)
    q2percpcsdiff_rd = wgt_areaave(doubletofloat(fhf->q2percpcsdiff(:,:,{rd[0]:rd[1]},{rd[2]:rd[3]})), wgty, wgtx, opt)

    q2percpcspval_ra = wgt_areaave(doubletofloat(fhf->q2percpcspval(:,:,{ra[0]:ra[1]},{ra[2]:ra[3]})), wgty, wgtx, optmiss)
    q2percpcspval_rb = wgt_areaave(doubletofloat(fhf->q2percpcspval(:,:,{rb[0]:rb[1]},{rb[2]:rb[3]})), wgty, wgtx, optmiss)
    q2percpcspval_rc = wgt_areaave(doubletofloat(fhf->q2percpcspval(:,:,{rc[0]:rc[1]},{rc[2]:rc[3]})), wgty, wgtx, optmiss)
    q2percpcspval_rd = wgt_areaave(doubletofloat(fhf->q2percpcspval(:,:,{rd[0]:rd[1]},{rd[2]:rd[3]})), wgty, wgtx, optmiss)

    ;---

    q1intcsmean_ra = wgt_areaave(fhf->q1intcsmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, opt)
    q1intcsmean_rb = wgt_areaave(fhf->q1intcsmean(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, opt)
    q1intcsmean_rc = wgt_areaave(fhf->q1intcsmean(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, opt)
    q1intcsmean_rd = wgt_areaave(fhf->q1intcsmean(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, opt)

    q1intcsdiff_ra = wgt_areaave(doubletofloat(fhf->q1intcsdiff(:,{ra[0]:ra[1]},{ra[2]:ra[3]})), wgty, wgtx, opt)
    q1intcsdiff_rb = wgt_areaave(doubletofloat(fhf->q1intcsdiff(:,{rb[0]:rb[1]},{rb[2]:rb[3]})), wgty, wgtx, opt)
    q1intcsdiff_rc = wgt_areaave(doubletofloat(fhf->q1intcsdiff(:,{rc[0]:rc[1]},{rc[2]:rc[3]})), wgty, wgtx, opt)
    q1intcsdiff_rd = wgt_areaave(doubletofloat(fhf->q1intcsdiff(:,{rd[0]:rd[1]},{rd[2]:rd[3]})), wgty, wgtx, opt)

    q1intcspval_ra = wgt_areaave(doubletofloat(fhf->q1intcspval(:,{ra[0]:ra[1]},{ra[2]:ra[3]})), wgty, wgtx, optmiss)
    q1intcspval_rb = wgt_areaave(doubletofloat(fhf->q1intcspval(:,{rb[0]:rb[1]},{rb[2]:rb[3]})), wgty, wgtx, optmiss)
    q1intcspval_rc = wgt_areaave(doubletofloat(fhf->q1intcspval(:,{rc[0]:rc[1]},{rc[2]:rc[3]})), wgty, wgtx, optmiss)
    q1intcspval_rd = wgt_areaave(doubletofloat(fhf->q1intcspval(:,{rd[0]:rd[1]},{rd[2]:rd[3]})), wgty, wgtx, optmiss)

    q2intcsmean_ra = wgt_areaave(fhf->q2intcsmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, opt)
    q2intcsmean_rb = wgt_areaave(fhf->q2intcsmean(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, opt)
    q2intcsmean_rc = wgt_areaave(fhf->q2intcsmean(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, opt)
    q2intcsmean_rd = wgt_areaave(fhf->q2intcsmean(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, opt)

    q2intcsdiff_ra = wgt_areaave(doubletofloat(fhf->q2intcsdiff(:,{ra[0]:ra[1]},{ra[2]:ra[3]})), wgty, wgtx, opt)
    q2intcsdiff_rb = wgt_areaave(doubletofloat(fhf->q2intcsdiff(:,{rb[0]:rb[1]},{rb[2]:rb[3]})), wgty, wgtx, opt)
    q2intcsdiff_rc = wgt_areaave(doubletofloat(fhf->q2intcsdiff(:,{rc[0]:rc[1]},{rc[2]:rc[3]})), wgty, wgtx, opt)
    q2intcsdiff_rd = wgt_areaave(doubletofloat(fhf->q2intcsdiff(:,{rd[0]:rd[1]},{rd[2]:rd[3]})), wgty, wgtx, opt)

    q2intcspval_ra = wgt_areaave(doubletofloat(fhf->q2intcspval(:,{ra[0]:ra[1]},{ra[2]:ra[3]})), wgty, wgtx, optmiss)
    q2intcspval_rb = wgt_areaave(doubletofloat(fhf->q2intcspval(:,{rb[0]:rb[1]},{rb[2]:rb[3]})), wgty, wgtx, optmiss)
    q2intcspval_rc = wgt_areaave(doubletofloat(fhf->q2intcspval(:,{rc[0]:rc[1]},{rc[2]:rc[3]})), wgty, wgtx, optmiss)
    q2intcspval_rd = wgt_areaave(doubletofloat(fhf->q2intcspval(:,{rd[0]:rd[1]},{rd[2]:rd[3]})), wgty, wgtx, optmiss)

    ;--CENS

    q1percpcensmean_ra = wgt_areaave(fhf->q1percpcensmean(:,:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, opt)
    q1percpcensmean_rb = wgt_areaave(fhf->q1percpcensmean(:,:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, opt)
    q1percpcensmean_rc = wgt_areaave(fhf->q1percpcensmean(:,:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, opt)
    q1percpcensmean_rd = wgt_areaave(fhf->q1percpcensmean(:,:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, opt)

    q1percpcensdiff_ra = wgt_areaave(doubletofloat(fhf->q1percpcensdiff(:,:,{ra[0]:ra[1]},{ra[2]:ra[3]})), wgty, wgtx, opt)
    q1percpcensdiff_rb = wgt_areaave(doubletofloat(fhf->q1percpcensdiff(:,:,{rb[0]:rb[1]},{rb[2]:rb[3]})), wgty, wgtx, opt)
    q1percpcensdiff_rc = wgt_areaave(doubletofloat(fhf->q1percpcensdiff(:,:,{rc[0]:rc[1]},{rc[2]:rc[3]})), wgty, wgtx, opt)
    q1percpcensdiff_rd = wgt_areaave(doubletofloat(fhf->q1percpcensdiff(:,:,{rd[0]:rd[1]},{rd[2]:rd[3]})), wgty, wgtx, opt)

    q1percpcenspval_ra = wgt_areaave(doubletofloat(fhf->q1percpcenspval(:,:,{ra[0]:ra[1]},{ra[2]:ra[3]})), wgty, wgtx, optmiss)
    q1percpcenspval_rb = wgt_areaave(doubletofloat(fhf->q1percpcenspval(:,:,{rb[0]:rb[1]},{rb[2]:rb[3]})), wgty, wgtx, optmiss)
    q1percpcenspval_rc = wgt_areaave(doubletofloat(fhf->q1percpcenspval(:,:,{rc[0]:rc[1]},{rc[2]:rc[3]})), wgty, wgtx, optmiss)
    q1percpcenspval_rd = wgt_areaave(doubletofloat(fhf->q1percpcenspval(:,:,{rd[0]:rd[1]},{rd[2]:rd[3]})), wgty, wgtx, optmiss)

    q2percpcensmean_ra = wgt_areaave(fhf->q2percpcensmean(:,:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, opt)
    q2percpcensmean_rb = wgt_areaave(fhf->q2percpcensmean(:,:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, opt)
    q2percpcensmean_rc = wgt_areaave(fhf->q2percpcensmean(:,:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, opt)
    q2percpcensmean_rd = wgt_areaave(fhf->q2percpcensmean(:,:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, opt)

    q2percpcensdiff_ra = wgt_areaave(doubletofloat(fhf->q2percpcensdiff(:,:,{ra[0]:ra[1]},{ra[2]:ra[3]})), wgty, wgtx, opt)
    q2percpcensdiff_rb = wgt_areaave(doubletofloat(fhf->q2percpcensdiff(:,:,{rb[0]:rb[1]},{rb[2]:rb[3]})), wgty, wgtx, opt)
    q2percpcensdiff_rc = wgt_areaave(doubletofloat(fhf->q2percpcensdiff(:,:,{rc[0]:rc[1]},{rc[2]:rc[3]})), wgty, wgtx, opt)
    q2percpcensdiff_rd = wgt_areaave(doubletofloat(fhf->q2percpcensdiff(:,:,{rd[0]:rd[1]},{rd[2]:rd[3]})), wgty, wgtx, opt)

    q2percpcenspval_ra = wgt_areaave(doubletofloat(fhf->q2percpcenspval(:,:,{ra[0]:ra[1]},{ra[2]:ra[3]})), wgty, wgtx, optmiss)
    q2percpcenspval_rb = wgt_areaave(doubletofloat(fhf->q2percpcenspval(:,:,{rb[0]:rb[1]},{rb[2]:rb[3]})), wgty, wgtx, optmiss)
    q2percpcenspval_rc = wgt_areaave(doubletofloat(fhf->q2percpcenspval(:,:,{rc[0]:rc[1]},{rc[2]:rc[3]})), wgty, wgtx, optmiss)
    q2percpcenspval_rd = wgt_areaave(doubletofloat(fhf->q2percpcenspval(:,:,{rd[0]:rd[1]},{rd[2]:rd[3]})), wgty, wgtx, optmiss)

    ;---

    q1intcensmean_ra = wgt_areaave(fhf->q1intcensmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, opt)
    q1intcensmean_rb = wgt_areaave(fhf->q1intcensmean(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, opt)
    q1intcensmean_rc = wgt_areaave(fhf->q1intcensmean(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, opt)
    q1intcensmean_rd = wgt_areaave(fhf->q1intcensmean(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, opt)

    q1intcensdiff_ra = wgt_areaave(doubletofloat(fhf->q1intcensdiff(:,{ra[0]:ra[1]},{ra[2]:ra[3]})), wgty, wgtx, opt)
    q1intcensdiff_rb = wgt_areaave(doubletofloat(fhf->q1intcensdiff(:,{rb[0]:rb[1]},{rb[2]:rb[3]})), wgty, wgtx, opt)
    q1intcensdiff_rc = wgt_areaave(doubletofloat(fhf->q1intcensdiff(:,{rc[0]:rc[1]},{rc[2]:rc[3]})), wgty, wgtx, opt)
    q1intcensdiff_rd = wgt_areaave(doubletofloat(fhf->q1intcensdiff(:,{rd[0]:rd[1]},{rd[2]:rd[3]})), wgty, wgtx, opt)

    q1intcenspval_ra = wgt_areaave(doubletofloat(fhf->q1intcenspval(:,{ra[0]:ra[1]},{ra[2]:ra[3]})), wgty, wgtx, optmiss)
    q1intcenspval_rb = wgt_areaave(doubletofloat(fhf->q1intcenspval(:,{rb[0]:rb[1]},{rb[2]:rb[3]})), wgty, wgtx, optmiss)
    q1intcenspval_rc = wgt_areaave(doubletofloat(fhf->q1intcenspval(:,{rc[0]:rc[1]},{rc[2]:rc[3]})), wgty, wgtx, optmiss)
    q1intcenspval_rd = wgt_areaave(doubletofloat(fhf->q1intcenspval(:,{rd[0]:rd[1]},{rd[2]:rd[3]})), wgty, wgtx, optmiss)

    q2intcensmean_ra = wgt_areaave(fhf->q2intcensmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, opt)
    q2intcensmean_rb = wgt_areaave(fhf->q2intcensmean(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, opt)
    q2intcensmean_rc = wgt_areaave(fhf->q2intcensmean(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, opt)
    q2intcensmean_rd = wgt_areaave(fhf->q2intcensmean(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, opt)

    q2intcensdiff_ra = wgt_areaave(doubletofloat(fhf->q2intcensdiff(:,{ra[0]:ra[1]},{ra[2]:ra[3]})), wgty, wgtx, opt)
    q2intcensdiff_rb = wgt_areaave(doubletofloat(fhf->q2intcensdiff(:,{rb[0]:rb[1]},{rb[2]:rb[3]})), wgty, wgtx, opt)
    q2intcensdiff_rc = wgt_areaave(doubletofloat(fhf->q2intcensdiff(:,{rc[0]:rc[1]},{rc[2]:rc[3]})), wgty, wgtx, opt)
    q2intcensdiff_rd = wgt_areaave(doubletofloat(fhf->q2intcensdiff(:,{rd[0]:rd[1]},{rd[2]:rd[3]})), wgty, wgtx, opt)

    q2intcenspval_ra = wgt_areaave(doubletofloat(fhf->q2intcenspval(:,{ra[0]:ra[1]},{ra[2]:ra[3]})), wgty, wgtx, optmiss)
    q2intcenspval_rb = wgt_areaave(doubletofloat(fhf->q2intcenspval(:,{rb[0]:rb[1]},{rb[2]:rb[3]})), wgty, wgtx, optmiss)
    q2intcenspval_rc = wgt_areaave(doubletofloat(fhf->q2intcenspval(:,{rc[0]:rc[1]},{rc[2]:rc[3]})), wgty, wgtx, optmiss)
    q2intcenspval_rd = wgt_areaave(doubletofloat(fhf->q2intcenspval(:,{rd[0]:rd[1]},{rd[2]:rd[3]})), wgty, wgtx, optmiss)
  end if

  ;--mb
  if(mb)

    ;--CS

    ecsmean_ra = wgt_areaave(fmb->ecsmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    ecsmean_rb = wgt_areaave(fmb->ecsmean(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    ecsmean_rc = wgt_areaave(fmb->ecsmean(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    ecsmean_rd = wgt_areaave(fmb->ecsmean(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    ecsdiff_ra = wgt_areaave(fmb->ecsdiff(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    ecsdiff_rb = wgt_areaave(fmb->ecsdiff(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    ecsdiff_rc = wgt_areaave(fmb->ecsdiff(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    ecsdiff_rd = wgt_areaave(fmb->ecsdiff(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    ecspval_ra = wgt_areaave(fmb->ecspval(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    ecspval_rb = wgt_areaave(fmb->ecspval(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    ecspval_rc = wgt_areaave(fmb->ecspval(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    ecspval_rd = wgt_areaave(fmb->ecspval(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)
  
    tpcsmean_ra = wgt_areaave(fmb->tpcsmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    tpcsmean_rb = wgt_areaave(fmb->tpcsmean(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    tpcsmean_rc = wgt_areaave(fmb->tpcsmean(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    tpcsmean_rd = wgt_areaave(fmb->tpcsmean(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    tpcsdiff_ra = wgt_areaave(fmb->tpcsdiff(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    tpcsdiff_rb = wgt_areaave(fmb->tpcsdiff(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    tpcsdiff_rc = wgt_areaave(fmb->tpcsdiff(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    tpcsdiff_rd = wgt_areaave(fmb->tpcsdiff(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    tpcspval_ra = wgt_areaave(fmb->tpcspval(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    tpcspval_rb = wgt_areaave(fmb->tpcspval(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    tpcspval_rc = wgt_areaave(fmb->tpcspval(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    tpcspval_rd = wgt_areaave(fmb->tpcspval(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    pwdtcsmean_ra = wgt_areaave(fmb->pwdtcsmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    pwdtcsmean_rb = wgt_areaave(fmb->pwdtcsmean(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    pwdtcsmean_rc = wgt_areaave(fmb->pwdtcsmean(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    pwdtcsmean_rd = wgt_areaave(fmb->pwdtcsmean(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    pwdtcsdiff_ra = wgt_areaave(fmb->pwdtcsdiff(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    pwdtcsdiff_rb = wgt_areaave(fmb->pwdtcsdiff(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    pwdtcsdiff_rc = wgt_areaave(fmb->pwdtcsdiff(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    pwdtcsdiff_rd = wgt_areaave(fmb->pwdtcsdiff(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    pwdtcspval_ra = wgt_areaave(fmb->pwdtcspval(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    pwdtcspval_rb = wgt_areaave(fmb->pwdtcspval(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    pwdtcspval_rc = wgt_areaave(fmb->pwdtcspval(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    pwdtcspval_rd = wgt_areaave(fmb->pwdtcspval(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    iuqcsmean_ra = wgt_areaave(fmb->iuqcsmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    iuqcsmean_rb = wgt_areaave(fmb->iuqcsmean(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    iuqcsmean_rc = wgt_areaave(fmb->iuqcsmean(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    iuqcsmean_rd = wgt_areaave(fmb->iuqcsmean(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    iuqcsdiff_ra = wgt_areaave(fmb->iuqcsdiff(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    iuqcsdiff_rb = wgt_areaave(fmb->iuqcsdiff(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    iuqcsdiff_rc = wgt_areaave(fmb->iuqcsdiff(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    iuqcsdiff_rd = wgt_areaave(fmb->iuqcsdiff(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    iuqcspval_ra = wgt_areaave(fmb->iuqcspval(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    iuqcspval_rb = wgt_areaave(fmb->iuqcspval(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    iuqcspval_rc = wgt_areaave(fmb->iuqcspval(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    iuqcspval_rd = wgt_areaave(fmb->iuqcspval(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)
  
    ivqcsmean_ra = wgt_areaave(fmb->ivqcsmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    ivqcsmean_rb = wgt_areaave(fmb->ivqcsmean(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    ivqcsmean_rc = wgt_areaave(fmb->ivqcsmean(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    ivqcsmean_rd = wgt_areaave(fmb->ivqcsmean(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    ivqcsdiff_ra = wgt_areaave(fmb->ivqcsdiff(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    ivqcsdiff_rb = wgt_areaave(fmb->ivqcsdiff(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    ivqcsdiff_rc = wgt_areaave(fmb->ivqcsdiff(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    ivqcsdiff_rd = wgt_areaave(fmb->ivqcsdiff(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    ivqcspval_ra = wgt_areaave(fmb->ivqcspval(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    ivqcspval_rb = wgt_areaave(fmb->ivqcspval(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    ivqcspval_rc = wgt_areaave(fmb->ivqcspval(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    ivqcspval_rd = wgt_areaave(fmb->ivqcspval(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    vimfdcsmean_ra = wgt_areaave(fmb->vimfdcsmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    vimfdcsmean_rb = wgt_areaave(fmb->vimfdcsmean(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    vimfdcsmean_rc = wgt_areaave(fmb->vimfdcsmean(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    vimfdcsmean_rd = wgt_areaave(fmb->vimfdcsmean(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    vimfdcsdiff_ra = wgt_areaave(fmb->vimfdcsdiff(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    vimfdcsdiff_rb = wgt_areaave(fmb->vimfdcsdiff(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    vimfdcsdiff_rc = wgt_areaave(fmb->vimfdcsdiff(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    vimfdcsdiff_rd = wgt_areaave(fmb->vimfdcsdiff(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    vimfdcspval_ra = wgt_areaave(fmb->vimfdcspval(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    vimfdcspval_rb = wgt_areaave(fmb->vimfdcspval(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    vimfdcspval_rc = wgt_areaave(fmb->vimfdcspval(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    vimfdcspval_rd = wgt_areaave(fmb->vimfdcspval(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    ;--CENS

    ecensmean_ra = wgt_areaave(fmb->ecensmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    ecensmean_rb = wgt_areaave(fmb->ecensmean(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    ecensmean_rc = wgt_areaave(fmb->ecensmean(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    ecensmean_rd = wgt_areaave(fmb->ecensmean(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    ecensdiff_ra = wgt_areaave(fmb->ecensdiff(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    ecensdiff_rb = wgt_areaave(fmb->ecensdiff(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    ecensdiff_rc = wgt_areaave(fmb->ecensdiff(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    ecensdiff_rd = wgt_areaave(fmb->ecensdiff(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    ecenspval_ra = wgt_areaave(fmb->ecenspval(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    ecenspval_rb = wgt_areaave(fmb->ecenspval(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    ecenspval_rc = wgt_areaave(fmb->ecenspval(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    ecenspval_rd = wgt_areaave(fmb->ecenspval(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)
  
    tpcensmean_ra = wgt_areaave(fmb->tpcensmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    tpcensmean_rb = wgt_areaave(fmb->tpcensmean(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    tpcensmean_rc = wgt_areaave(fmb->tpcensmean(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    tpcensmean_rd = wgt_areaave(fmb->tpcensmean(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    tpcensdiff_ra = wgt_areaave(fmb->tpcensdiff(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    tpcensdiff_rb = wgt_areaave(fmb->tpcensdiff(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    tpcensdiff_rc = wgt_areaave(fmb->tpcensdiff(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    tpcensdiff_rd = wgt_areaave(fmb->tpcensdiff(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    tpcenspval_ra = wgt_areaave(fmb->tpcenspval(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    tpcenspval_rb = wgt_areaave(fmb->tpcenspval(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    tpcenspval_rc = wgt_areaave(fmb->tpcenspval(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    tpcenspval_rd = wgt_areaave(fmb->tpcenspval(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    pwdtcensmean_ra = wgt_areaave(fmb->pwdtcensmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    pwdtcensmean_rb = wgt_areaave(fmb->pwdtcensmean(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    pwdtcensmean_rc = wgt_areaave(fmb->pwdtcensmean(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    pwdtcensmean_rd = wgt_areaave(fmb->pwdtcensmean(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    pwdtcensdiff_ra = wgt_areaave(fmb->pwdtcensdiff(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    pwdtcensdiff_rb = wgt_areaave(fmb->pwdtcensdiff(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    pwdtcensdiff_rc = wgt_areaave(fmb->pwdtcensdiff(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    pwdtcensdiff_rd = wgt_areaave(fmb->pwdtcensdiff(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    pwdtcenspval_ra = wgt_areaave(fmb->pwdtcenspval(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    pwdtcenspval_rb = wgt_areaave(fmb->pwdtcenspval(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    pwdtcenspval_rc = wgt_areaave(fmb->pwdtcenspval(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    pwdtcenspval_rd = wgt_areaave(fmb->pwdtcenspval(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    iuqcensmean_ra = wgt_areaave(fmb->iuqcensmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    iuqcensmean_rb = wgt_areaave(fmb->iuqcensmean(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    iuqcensmean_rc = wgt_areaave(fmb->iuqcensmean(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    iuqcensmean_rd = wgt_areaave(fmb->iuqcensmean(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    iuqcensdiff_ra = wgt_areaave(fmb->iuqcensdiff(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    iuqcensdiff_rb = wgt_areaave(fmb->iuqcensdiff(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    iuqcensdiff_rc = wgt_areaave(fmb->iuqcensdiff(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    iuqcensdiff_rd = wgt_areaave(fmb->iuqcensdiff(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    iuqcenspval_ra = wgt_areaave(fmb->iuqcenspval(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    iuqcenspval_rb = wgt_areaave(fmb->iuqcenspval(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    iuqcenspval_rc = wgt_areaave(fmb->iuqcenspval(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    iuqcenspval_rd = wgt_areaave(fmb->iuqcenspval(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)
  
    ivqcensmean_ra = wgt_areaave(fmb->ivqcensmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    ivqcensmean_rb = wgt_areaave(fmb->ivqcensmean(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    ivqcensmean_rc = wgt_areaave(fmb->ivqcensmean(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    ivqcensmean_rd = wgt_areaave(fmb->ivqcensmean(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    ivqcensdiff_ra = wgt_areaave(fmb->ivqcensdiff(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    ivqcensdiff_rb = wgt_areaave(fmb->ivqcensdiff(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    ivqcensdiff_rc = wgt_areaave(fmb->ivqcensdiff(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    ivqcensdiff_rd = wgt_areaave(fmb->ivqcensdiff(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    ivqcenspval_ra = wgt_areaave(fmb->ivqcenspval(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    ivqcenspval_rb = wgt_areaave(fmb->ivqcenspval(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    ivqcenspval_rc = wgt_areaave(fmb->ivqcenspval(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    ivqcenspval_rd = wgt_areaave(fmb->ivqcenspval(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    vimfdcensmean_ra = wgt_areaave(fmb->vimfdcensmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    vimfdcensmean_rb = wgt_areaave(fmb->vimfdcensmean(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    vimfdcensmean_rc = wgt_areaave(fmb->vimfdcensmean(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    vimfdcensmean_rd = wgt_areaave(fmb->vimfdcensmean(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    vimfdcensdiff_ra = wgt_areaave(fmb->vimfdcensdiff(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    vimfdcensdiff_rb = wgt_areaave(fmb->vimfdcensdiff(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    vimfdcensdiff_rc = wgt_areaave(fmb->vimfdcensdiff(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    vimfdcensdiff_rd = wgt_areaave(fmb->vimfdcensdiff(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)

    vimfdcenspval_ra = wgt_areaave(fmb->vimfdcenspval(:,{ra[0]:ra[1]},{ra[2]:ra[3]}), wgty, wgtx, optmiss)
    vimfdcenspval_rb = wgt_areaave(fmb->vimfdcenspval(:,{rb[0]:rb[1]},{rb[2]:rb[3]}), wgty, wgtx, optmiss)
    vimfdcenspval_rc = wgt_areaave(fmb->vimfdcenspval(:,{rc[0]:rc[1]},{rc[2]:rc[3]}), wgty, wgtx, optmiss)
    vimfdcenspval_rd = wgt_areaave(fmb->vimfdcenspval(:,{rd[0]:rd[1]},{rd[2]:rd[3]}), wgty, wgtx, optmiss)
  end if


  ;--Adjust Metadata

    ;--hf

      ;--mean

        baru                      = new((/ 21, 1, 1 /), typeof(sshfsample), sshfsample@_FillValue)
        sshfcsmean_ran           := baru
        sshfcsmean_ran(:,0:0,0:0) = (/ sshfcsmean_ra /)
        sshfcsmean_ra            := sshfcsmean_ran
        sshfcsmean_rbn           := baru
        sshfcsmean_rbn(:,0:0,0:0) = (/ sshfcsmean_rb /)
        sshfcsmean_rb            := sshfcsmean_rbn
        sshfcsmean_rcn           := baru
        sshfcsmean_rcn(:,0:0,0:0) = (/ sshfcsmean_rc /)
        sshfcsmean_rc            := sshfcsmean_rcn
        sshfcsmean_rdn           := baru
        sshfcsmean_rdn(:,0:0,0:0) = (/ sshfcsmean_rd /)
        sshfcsmean_rd            := sshfcsmean_rdn

        sshfcsmean_ra!0          = "timelag"
        sshfcsmean_ra!1          = "lat"
        sshfcsmean_ra!2          = "lon"
        sshfcsmean_ra&timelag    = sshfsample&timelag
        sshfcsmean_ra&lat        = lat
        sshfcsmean_ra&lon        = lon
        ;sshfcsmean_ra@long_name = sshfsample@long_name+" for "+ras
        sshfcsmean_ra@long_name  = sshfsample@long_name
        sshfcsmean_ra@units      = sshfsample@units
        copy_VarMeta(sshfcsmean_ra,sshfcsmean_rb)
        copy_VarMeta(sshfcsmean_ra,sshfcsmean_rc)
        copy_VarMeta(sshfcsmean_ra,sshfcsmean_rd)
        
        copy_VarCoords(sshfcsmean_ra, slhfcsmean_ra)
        slhfcsmean_ra@long_name  = slhfsample@long_name
        slhfcsmean_ra@units      = slhfsample@units
        copy_VarMeta(slhfcsmean_ra,slhfcsmean_rb)
        copy_VarMeta(slhfcsmean_ra,slhfcsmean_rc)
        copy_VarMeta(slhfcsmean_ra,slhfcsmean_rd)

        copy_VarMeta(sshfcsmean_ra,sshfcensmean_ra)
        copy_VarMeta(sshfcsmean_ra,sshfcensmean_rb)
        copy_VarMeta(sshfcsmean_ra,sshfcensmean_rc)
        copy_VarMeta(sshfcsmean_ra,sshfcensmean_rd)

        copy_VarMeta(slhfcsmean_ra,slhfcensmean_ra)
        copy_VarMeta(slhfcsmean_ra,slhfcensmean_rb)
        copy_VarMeta(slhfcsmean_ra,slhfcensmean_rc)
        copy_VarMeta(slhfcsmean_ra,slhfcensmean_rd)

      ;--diff
        copy_VarMeta(sshfcsmean_ra,sshfcsdiff_ra)
        copy_VarMeta(sshfcsmean_ra,sshfcsdiff_rb)
        copy_VarMeta(sshfcsmean_ra,sshfcsdiff_rc)
        copy_VarMeta(sshfcsmean_ra,sshfcsdiff_rd)
        copy_VarMeta(slhfcsmean_ra,slhfcsdiff_ra)
        copy_VarMeta(slhfcsmean_ra,slhfcsdiff_rb)
        copy_VarMeta(slhfcsmean_ra,slhfcsdiff_rc)
        copy_VarMeta(slhfcsmean_ra,slhfcsdiff_rd)

        copy_VarMeta(sshfcensmean_ra,sshfcensdiff_ra)
        copy_VarMeta(sshfcensmean_ra,sshfcensdiff_rb)
        copy_VarMeta(sshfcensmean_ra,sshfcensdiff_rc)
        copy_VarMeta(sshfcensmean_ra,sshfcensdiff_rd)
        copy_VarMeta(slhfcensmean_ra,slhfcensdiff_ra)
        copy_VarMeta(slhfcensmean_ra,slhfcensdiff_rb)
        copy_VarMeta(slhfcensmean_ra,slhfcensdiff_rc)
        copy_VarMeta(slhfcensmean_ra,slhfcensdiff_rd)

      ;--pval
        copy_VarMeta(sshfcsmean_ra,sshfcspval_ra)
        copy_VarMeta(sshfcsmean_ra,sshfcspval_rb)
        copy_VarMeta(sshfcsmean_ra,sshfcspval_rc)
        copy_VarMeta(sshfcsmean_ra,sshfcspval_rd)
        copy_VarMeta(slhfcsmean_ra,slhfcspval_ra)
        copy_VarMeta(slhfcsmean_ra,slhfcspval_rb)
        copy_VarMeta(slhfcsmean_ra,slhfcspval_rc)
        copy_VarMeta(slhfcsmean_ra,slhfcspval_rd)

        copy_VarMeta(sshfcensmean_ra,sshfcenspval_ra)
        copy_VarMeta(sshfcensmean_ra,sshfcenspval_rb)
        copy_VarMeta(sshfcensmean_ra,sshfcenspval_rc)
        copy_VarMeta(sshfcensmean_ra,sshfcenspval_rd)
        copy_VarMeta(slhfcensmean_ra,slhfcenspval_ra)
        copy_VarMeta(slhfcensmean_ra,slhfcenspval_rb)
        copy_VarMeta(slhfcensmean_ra,slhfcenspval_rc)
        copy_VarMeta(slhfcensmean_ra,slhfcenspval_rd)

    ;--sst

      ;--mean
        copy_VarCoords(sshfcsmean_ra, sstcsmean_ra)
        sstcsmean_ra@long_name  = sstsample@long_name
        sstcsmean_ra@units      = sstsample@units
        copy_VarMeta(sstcsmean_ra,sstcsmean_rb)
        copy_VarMeta(sstcsmean_ra,sstcsmean_rc)
        copy_VarMeta(sstcsmean_ra,sstcsmean_rd)

        copy_VarMeta(sstcsmean_ra,sstcensmean_ra)
        copy_VarMeta(sstcsmean_ra,sstcensmean_rb)
        copy_VarMeta(sstcsmean_ra,sstcensmean_rc)
        copy_VarMeta(sstcsmean_ra,sstcensmean_rd)

      ;--diff
        copy_VarMeta(sstcsmean_ra,sstcsdiff_ra)
        copy_VarMeta(sstcsmean_ra,sstcsdiff_rb)
        copy_VarMeta(sstcsmean_ra,sstcsdiff_rc)
        copy_VarMeta(sstcsmean_ra,sstcsdiff_rd)

        copy_VarMeta(sstcensmean_ra,sstcensdiff_ra)
        copy_VarMeta(sstcensmean_ra,sstcensdiff_rb)
        copy_VarMeta(sstcensmean_ra,sstcensdiff_rc)
        copy_VarMeta(sstcensmean_ra,sstcensdiff_rd)

      ;--pval
        copy_VarMeta(sstcsmean_ra,sstcspval_ra)
        copy_VarMeta(sstcsmean_ra,sstcspval_rb)
        copy_VarMeta(sstcsmean_ra,sstcspval_rc)
        copy_VarMeta(sstcsmean_ra,sstcspval_rd)

        copy_VarMeta(sstcensmean_ra,sstcenspval_ra)
        copy_VarMeta(sstcensmean_ra,sstcenspval_rb)
        copy_VarMeta(sstcensmean_ra,sstcenspval_rc)
        copy_VarMeta(sstcensmean_ra,sstcenspval_rd)

    ;--q1q2

      ;qpercp

        ;--mean
          baruu                          = new((/ 21, 27, 1, 1 /), typeof(q1percpsample), q1percpsample@_FillValue)
          q1percpcsmean_ran             := baruu
          q1percpcsmean_ran(:,:,0:0,0:0) = (/ q1percpcsmean_ra /)
          q1percpcsmean_ra              := q1percpcsmean_ran
          q1percpcsmean_rbn             := baruu
          q1percpcsmean_rbn(:,:,0:0,0:0) = (/ q1percpcsmean_rb /)
          q1percpcsmean_rb              := q1percpcsmean_rbn
          q1percpcsmean_rcn             := baruu
          q1percpcsmean_rcn(:,:,0:0,0:0) = (/ q1percpcsmean_rc /)
          q1percpcsmean_rc              := q1percpcsmean_rcn
          q1percpcsmean_rdn             := baruu
          q1percpcsmean_rdn(:,:,0:0,0:0) = (/ q1percpcsmean_rd /)
          q1percpcsmean_rd              := q1percpcsmean_rdn

          q1percpcsmean_ra!0          = "timelag"
          q1percpcsmean_ra!1          = "lev"
          q1percpcsmean_ra!2          = "lat"
          q1percpcsmean_ra!3          = "lon"
          q1percpcsmean_ra&timelag    = q1percpsample&timelag
          q1percpcsmean_ra&lev        = levsample
          q1percpcsmean_ra&lat        = lat
          q1percpcsmean_ra&lon        = lon
          q1percpcsmean_ra@long_name  = q1percpsample@long_name
          q1percpcsmean_ra@units      = q1percpsample@units
          copy_VarMeta(q1percpcsmean_ra,q1percpcsmean_rb)
          copy_VarMeta(q1percpcsmean_ra,q1percpcsmean_rc)
          copy_VarMeta(q1percpcsmean_ra,q1percpcsmean_rd)
    
          copy_VarCoords(q1percpcsmean_ra,q2percpcsmean_ra)
          q2percpcsmean_ra@long_name  = q2percpsample@long_name
          q2percpcsmean_ra@units      = q2percpsample@units
          copy_VarMeta(q2percpcsmean_ra,q2percpcsmean_rb)
          copy_VarMeta(q2percpcsmean_ra,q2percpcsmean_rc)
          copy_VarMeta(q2percpcsmean_ra,q2percpcsmean_rd)
      
          copy_VarMeta(q1percpcsmean_ra,q1percpcensmean_ra)
          copy_VarMeta(q1percpcsmean_ra,q1percpcensmean_rb)
          copy_VarMeta(q1percpcsmean_ra,q1percpcensmean_rc)
          copy_VarMeta(q1percpcsmean_ra,q1percpcensmean_rd)
          copy_VarMeta(q2percpcsmean_ra,q2percpcensmean_ra)
          copy_VarMeta(q2percpcsmean_ra,q2percpcensmean_rb)
          copy_VarMeta(q2percpcsmean_ra,q2percpcensmean_rc)
          copy_VarMeta(q2percpcsmean_ra,q2percpcensmean_rd)

        ;--diff
          copy_VarMeta(q1percpcsmean_ra,q1percpcsdiff_ra)
          copy_VarMeta(q1percpcsmean_ra,q1percpcsdiff_rb)
          copy_VarMeta(q1percpcsmean_ra,q1percpcsdiff_rc)
          copy_VarMeta(q1percpcsmean_ra,q1percpcsdiff_rd)
          copy_VarMeta(q2percpcsmean_ra,q2percpcsdiff_ra)
          copy_VarMeta(q2percpcsmean_ra,q2percpcsdiff_rb)
          copy_VarMeta(q2percpcsmean_ra,q2percpcsdiff_rc)
          copy_VarMeta(q2percpcsmean_ra,q2percpcsdiff_rd)
      
          copy_VarMeta(q1percpcsmean_ra,q1percpcensdiff_ra)
          copy_VarMeta(q1percpcsmean_ra,q1percpcensdiff_rb)
          copy_VarMeta(q1percpcsmean_ra,q1percpcensdiff_rc)
          copy_VarMeta(q1percpcsmean_ra,q1percpcensdiff_rd)
          copy_VarMeta(q2percpcsmean_ra,q2percpcensdiff_ra)
          copy_VarMeta(q2percpcsmean_ra,q2percpcensdiff_rb)
          copy_VarMeta(q2percpcsmean_ra,q2percpcensdiff_rc)
          copy_VarMeta(q2percpcsmean_ra,q2percpcensdiff_rd)

        ;--pval
          copy_VarMeta(q1percpcsmean_ra,q1percpcspval_ra)
          copy_VarMeta(q1percpcsmean_ra,q1percpcspval_rb)
          copy_VarMeta(q1percpcsmean_ra,q1percpcspval_rc)
          copy_VarMeta(q1percpcsmean_ra,q1percpcspval_rd)
          copy_VarMeta(q2percpcsmean_ra,q2percpcspval_ra)
          copy_VarMeta(q2percpcsmean_ra,q2percpcspval_rb)
          copy_VarMeta(q2percpcsmean_ra,q2percpcspval_rc)
          copy_VarMeta(q2percpcsmean_ra,q2percpcspval_rd)
      
          copy_VarMeta(q1percpcsmean_ra,q1percpcenspval_ra)
          copy_VarMeta(q1percpcsmean_ra,q1percpcenspval_rb)
          copy_VarMeta(q1percpcsmean_ra,q1percpcenspval_rc)
          copy_VarMeta(q1percpcsmean_ra,q1percpcenspval_rd)
          copy_VarMeta(q2percpcsmean_ra,q2percpcenspval_ra)
          copy_VarMeta(q2percpcsmean_ra,q2percpcenspval_rb)
          copy_VarMeta(q2percpcsmean_ra,q2percpcenspval_rc)
          copy_VarMeta(q2percpcsmean_ra,q2percpcenspval_rd)

      ;int
        ;--mean
          copy_VarCoords(sshfcsmean_ra, q1intcsmean_ra)
          q1intcsmean_ra@long_name  = q1intsample@long_name
          q1intcsmean_ra@units      = q1intsample@units
          copy_VarMeta(q1intcsmean_ra,q1intcsmean_rb)
          copy_VarMeta(q1intcsmean_ra,q1intcsmean_rc)
          copy_VarMeta(q1intcsmean_ra,q1intcsmean_rd)
          copy_VarCoords(q1intcsmean_ra, q2intcsmean_ra)
          q2intcsmean_ra@long_name  = q2intsample@long_name
          q2intcsmean_ra@units      = q2intsample@units
          copy_VarMeta(q2intcsmean_ra,q2intcsmean_rb)
          copy_VarMeta(q2intcsmean_ra,q2intcsmean_rc)
          copy_VarMeta(q2intcsmean_ra,q2intcsmean_rd)
      
          copy_VarMeta(q1intcsmean_ra,q1intcensmean_ra)
          copy_VarMeta(q1intcsmean_ra,q1intcensmean_rb)
          copy_VarMeta(q1intcsmean_ra,q1intcensmean_rc)
          copy_VarMeta(q1intcsmean_ra,q1intcensmean_rd)
          copy_VarMeta(q2intcsmean_ra,q2intcensmean_ra)
          copy_VarMeta(q2intcsmean_ra,q2intcensmean_rb)
          copy_VarMeta(q2intcsmean_ra,q2intcensmean_rc)
          copy_VarMeta(q2intcsmean_ra,q2intcensmean_rd)

        ;--diff
          copy_VarMeta(q1intcsmean_ra,q1intcsdiff_ra)
          copy_VarMeta(q1intcsmean_ra,q1intcsdiff_rb)
          copy_VarMeta(q1intcsmean_ra,q1intcsdiff_rc)
          copy_VarMeta(q1intcsmean_ra,q1intcsdiff_rd)
          copy_VarMeta(q2intcsmean_ra,q2intcsdiff_ra)
          copy_VarMeta(q2intcsmean_ra,q2intcsdiff_rb)
          copy_VarMeta(q2intcsmean_ra,q2intcsdiff_rc)
          copy_VarMeta(q2intcsmean_ra,q2intcsdiff_rd)
      
          copy_VarMeta(q1intcsmean_ra,q1intcensdiff_ra)
          copy_VarMeta(q1intcsmean_ra,q1intcensdiff_rb)
          copy_VarMeta(q1intcsmean_ra,q1intcensdiff_rc)
          copy_VarMeta(q1intcsmean_ra,q1intcensdiff_rd)
          copy_VarMeta(q2intcsmean_ra,q2intcensdiff_ra)
          copy_VarMeta(q2intcsmean_ra,q2intcensdiff_rb)
          copy_VarMeta(q2intcsmean_ra,q2intcensdiff_rc)
          copy_VarMeta(q2intcsmean_ra,q2intcensdiff_rd)

        ;--pval
          copy_VarMeta(q1intcsmean_ra,q1intcspval_ra)
          copy_VarMeta(q1intcsmean_ra,q1intcspval_rb)
          copy_VarMeta(q1intcsmean_ra,q1intcspval_rc)
          copy_VarMeta(q1intcsmean_ra,q1intcspval_rd)
          copy_VarMeta(q2intcsmean_ra,q2intcspval_ra)
          copy_VarMeta(q2intcsmean_ra,q2intcspval_rb)
          copy_VarMeta(q2intcsmean_ra,q2intcspval_rc)
          copy_VarMeta(q2intcsmean_ra,q2intcspval_rd)
      
          copy_VarMeta(q1intcsmean_ra,q1intcenspval_ra)
          copy_VarMeta(q1intcsmean_ra,q1intcenspval_rb)
          copy_VarMeta(q1intcsmean_ra,q1intcenspval_rc)
          copy_VarMeta(q1intcsmean_ra,q1intcenspval_rd)
          copy_VarMeta(q2intcsmean_ra,q2intcenspval_ra)
          copy_VarMeta(q2intcsmean_ra,q2intcenspval_rb)
          copy_VarMeta(q2intcsmean_ra,q2intcenspval_rc)
          copy_VarMeta(q2intcsmean_ra,q2intcenspval_rd)

    ;--mb

      ;--E-P

        ;--mean
          barumb                      = new((/ 21, 1, 1 /), typeof(esample), esample@_FillValue)
          ecsmean_ran           := barumb
          ecsmean_ran(:,0:0,0:0) = (/ ecsmean_ra /)
          ecsmean_ra            := ecsmean_ran
          ecsmean_rbn           := barumb
          ecsmean_rbn(:,0:0,0:0) = (/ ecsmean_rb /)
          ecsmean_rb            := ecsmean_rbn
          ecsmean_rcn           := barumb
          ecsmean_rcn(:,0:0,0:0) = (/ ecsmean_rc /)
          ecsmean_rc            := ecsmean_rcn
          ecsmean_rdn           := barumb
          ecsmean_rdn(:,0:0,0:0) = (/ ecsmean_rd /)
          ecsmean_rd            := ecsmean_rdn

          ecsmean_ra!0          = "timelag"
          ecsmean_ra!1          = "lat"
          ecsmean_ra!2          = "lon"
          ecsmean_ra&timelag    = esample&timelag
          ecsmean_ra&lat        = lat
          ecsmean_ra&lon        = lon
          ecsmean_ra@long_name  = esample@long_name
          ecsmean_ra@units      = esample@units
          copy_VarMeta(ecsmean_ra,ecsmean_rb)
          copy_VarMeta(ecsmean_ra,ecsmean_rc)
          copy_VarMeta(ecsmean_ra,ecsmean_rd)
          copy_VarCoords(ecsmean_ra, tpcsmean_ra)
          tpcsmean_ra@long_name  = tpsample@long_name
          tpcsmean_ra@units      = tpsample@units
          copy_VarMeta(tpcsmean_ra,tpcsmean_rb)
          copy_VarMeta(tpcsmean_ra,tpcsmean_rc)
          copy_VarMeta(tpcsmean_ra,tpcsmean_rd)
      
          copy_VarMeta(ecsmean_ra,ecensmean_ra)
          copy_VarMeta(ecsmean_ra,ecensmean_rb)
          copy_VarMeta(ecsmean_ra,ecensmean_rc)
          copy_VarMeta(ecsmean_ra,ecensmean_rd)
          copy_VarMeta(tpcsmean_ra,tpcensmean_ra)
          copy_VarMeta(tpcsmean_ra,tpcensmean_rb)
          copy_VarMeta(tpcsmean_ra,tpcensmean_rc)
          copy_VarMeta(tpcsmean_ra,tpcensmean_rd)

          printVarSummary(sshfcsmean_ra)
          printVarSummary(ecsmean_ra)

        ;--diff
          copy_VarMeta(ecsmean_ra,ecsdiff_ra)
          copy_VarMeta(ecsmean_ra,ecsdiff_rb)
          copy_VarMeta(ecsmean_ra,ecsdiff_rc)
          copy_VarMeta(ecsmean_ra,ecsdiff_rd)
          copy_VarMeta(tpcsmean_ra,tpcsdiff_ra)
          copy_VarMeta(tpcsmean_ra,tpcsdiff_rb)
          copy_VarMeta(tpcsmean_ra,tpcsdiff_rc)
          copy_VarMeta(tpcsmean_ra,tpcsdiff_rd)
      
          copy_VarMeta(ecsmean_ra,ecensdiff_ra)
          copy_VarMeta(ecsmean_ra,ecensdiff_rb)
          copy_VarMeta(ecsmean_ra,ecensdiff_rc)
          copy_VarMeta(ecsmean_ra,ecensdiff_rd)
          copy_VarMeta(tpcsmean_ra,tpcensdiff_ra)
          copy_VarMeta(tpcsmean_ra,tpcensdiff_rb)
          copy_VarMeta(tpcsmean_ra,tpcensdiff_rc)
          copy_VarMeta(tpcsmean_ra,tpcensdiff_rd)

        ;--pval
          copy_VarMeta(ecsmean_ra,ecspval_ra)
          copy_VarMeta(ecsmean_ra,ecspval_rb)
          copy_VarMeta(ecsmean_ra,ecspval_rc)
          copy_VarMeta(ecsmean_ra,ecspval_rd)
          copy_VarMeta(tpcsmean_ra,tpcspval_ra)
          copy_VarMeta(tpcsmean_ra,tpcspval_rb)
          copy_VarMeta(tpcsmean_ra,tpcspval_rc)
          copy_VarMeta(tpcsmean_ra,tpcspval_rd)
      
          copy_VarMeta(ecsmean_ra,ecenspval_ra)
          copy_VarMeta(ecsmean_ra,ecenspval_rb)
          copy_VarMeta(ecsmean_ra,ecenspval_rc)
          copy_VarMeta(ecsmean_ra,ecenspval_rd)
          copy_VarMeta(tpcsmean_ra,tpcenspval_ra)
          copy_VarMeta(tpcsmean_ra,tpcenspval_rb)
          copy_VarMeta(tpcsmean_ra,tpcenspval_rc)
          copy_VarMeta(tpcsmean_ra,tpcenspval_rd)

      ;--pwdt
        ;--mean
          copy_VarCoords(sshfcsmean_ra, pwdtcsmean_ra)
          pwdtcsmean_ra@long_name  = pwdtsample@long_name
          pwdtcsmean_ra@units      = pwdtsample@units
          copy_VarMeta(pwdtcsmean_ra,pwdtcsmean_rb)
          copy_VarMeta(pwdtcsmean_ra,pwdtcsmean_rc)
          copy_VarMeta(pwdtcsmean_ra,pwdtcsmean_rd)

          copy_VarMeta(pwdtcsmean_ra,pwdtcensmean_ra)
          copy_VarMeta(pwdtcsmean_ra,pwdtcensmean_rb)
          copy_VarMeta(pwdtcsmean_ra,pwdtcensmean_rc)
          copy_VarMeta(pwdtcsmean_ra,pwdtcensmean_rd)

        ;--diff
          copy_VarMeta(pwdtcsmean_ra,pwdtcsdiff_ra)
          copy_VarMeta(pwdtcsmean_ra,pwdtcsdiff_rb)
          copy_VarMeta(pwdtcsmean_ra,pwdtcsdiff_rc)
          copy_VarMeta(pwdtcsmean_ra,pwdtcsdiff_rd)

          copy_VarMeta(pwdtcsmean_ra,pwdtcensdiff_ra)
          copy_VarMeta(pwdtcsmean_ra,pwdtcensdiff_rb)
          copy_VarMeta(pwdtcsmean_ra,pwdtcensdiff_rc)
          copy_VarMeta(pwdtcsmean_ra,pwdtcensdiff_rd)

        ;--pval
          copy_VarMeta(pwdtcsmean_ra,pwdtcspval_ra)
          copy_VarMeta(pwdtcsmean_ra,pwdtcspval_rb)
          copy_VarMeta(pwdtcsmean_ra,pwdtcspval_rc)
          copy_VarMeta(pwdtcsmean_ra,pwdtcspval_rd)

          copy_VarMeta(pwdtcsmean_ra,pwdtcenspval_ra)
          copy_VarMeta(pwdtcsmean_ra,pwdtcenspval_rb)
          copy_VarMeta(pwdtcsmean_ra,pwdtcenspval_rc)
          copy_VarMeta(pwdtcsmean_ra,pwdtcenspval_rd)

      ;--iuq_ivq
        ;--mean
          copy_VarCoords(sshfcsmean_ra, iuqcsmean_ra)
          iuqcsmean_ra@long_name  = iuqsample@long_name
          iuqcsmean_ra@units      = iuqsample@units
          copy_VarMeta(iuqcsmean_ra,iuqcsmean_rb)
          copy_VarMeta(iuqcsmean_ra,iuqcsmean_rc)
          copy_VarMeta(iuqcsmean_ra,iuqcsmean_rd)
          copy_VarCoords(iuqcsmean_ra, ivqcsmean_ra)
          ivqcsmean_ra@long_name  = ivqsample@long_name
          ivqcsmean_ra@units      = ivqsample@units
          copy_VarMeta(ivqcsmean_ra,ivqcsmean_rb)
          copy_VarMeta(ivqcsmean_ra,ivqcsmean_rc)
          copy_VarMeta(ivqcsmean_ra,ivqcsmean_rd)
      
          copy_VarMeta(iuqcsmean_ra,iuqcensmean_ra)
          copy_VarMeta(iuqcsmean_ra,iuqcensmean_rb)
          copy_VarMeta(iuqcsmean_ra,iuqcensmean_rc)
          copy_VarMeta(iuqcsmean_ra,iuqcensmean_rd)
          copy_VarMeta(ivqcsmean_ra,ivqcensmean_ra)
          copy_VarMeta(ivqcsmean_ra,ivqcensmean_rb)
          copy_VarMeta(ivqcsmean_ra,ivqcensmean_rc)
          copy_VarMeta(ivqcsmean_ra,ivqcensmean_rd)

        ;--diff
          copy_VarMeta(iuqcsmean_ra,iuqcsdiff_ra)
          copy_VarMeta(iuqcsmean_ra,iuqcsdiff_rb)
          copy_VarMeta(iuqcsmean_ra,iuqcsdiff_rc)
          copy_VarMeta(iuqcsmean_ra,iuqcsdiff_rd)
          copy_VarMeta(ivqcsmean_ra,ivqcsdiff_ra)
          copy_VarMeta(ivqcsmean_ra,ivqcsdiff_rb)
          copy_VarMeta(ivqcsmean_ra,ivqcsdiff_rc)
          copy_VarMeta(ivqcsmean_ra,ivqcsdiff_rd)
      
          copy_VarMeta(iuqcsmean_ra,iuqcensdiff_ra)
          copy_VarMeta(iuqcsmean_ra,iuqcensdiff_rb)
          copy_VarMeta(iuqcsmean_ra,iuqcensdiff_rc)
          copy_VarMeta(iuqcsmean_ra,iuqcensdiff_rd)
          copy_VarMeta(ivqcsmean_ra,ivqcensdiff_ra)
          copy_VarMeta(ivqcsmean_ra,ivqcensdiff_rb)
          copy_VarMeta(ivqcsmean_ra,ivqcensdiff_rc)
          copy_VarMeta(ivqcsmean_ra,ivqcensdiff_rd)

        ;--pval
          copy_VarMeta(iuqcsmean_ra,iuqcspval_ra)
          copy_VarMeta(iuqcsmean_ra,iuqcspval_rb)
          copy_VarMeta(iuqcsmean_ra,iuqcspval_rc)
          copy_VarMeta(iuqcsmean_ra,iuqcspval_rd)
          copy_VarMeta(ivqcsmean_ra,ivqcspval_ra)
          copy_VarMeta(ivqcsmean_ra,ivqcspval_rb)
          copy_VarMeta(ivqcsmean_ra,ivqcspval_rc)
          copy_VarMeta(ivqcsmean_ra,ivqcspval_rd)
      
          copy_VarMeta(iuqcsmean_ra,iuqcenspval_ra)
          copy_VarMeta(iuqcsmean_ra,iuqcenspval_rb)
          copy_VarMeta(iuqcsmean_ra,iuqcenspval_rc)
          copy_VarMeta(iuqcsmean_ra,iuqcenspval_rd)
          copy_VarMeta(ivqcsmean_ra,ivqcenspval_ra)
          copy_VarMeta(ivqcsmean_ra,ivqcenspval_rb)
          copy_VarMeta(ivqcsmean_ra,ivqcenspval_rc)
          copy_VarMeta(ivqcsmean_ra,ivqcenspval_rd)

      ;--vimfd
        ;--mean
          copy_VarCoords(sshfcsmean_ra, vimfdcsmean_ra)
          vimfdcsmean_ra@long_name  = vimfdsample@long_name
          vimfdcsmean_ra@units      = vimfdsample@units
          copy_VarMeta(vimfdcsmean_ra,vimfdcsmean_rb)
          copy_VarMeta(vimfdcsmean_ra,vimfdcsmean_rc)
          copy_VarMeta(vimfdcsmean_ra,vimfdcsmean_rd)

          copy_VarMeta(vimfdcsmean_ra,vimfdcensmean_ra)
          copy_VarMeta(vimfdcsmean_ra,vimfdcensmean_rb)
          copy_VarMeta(vimfdcsmean_ra,vimfdcensmean_rc)
          copy_VarMeta(vimfdcsmean_ra,vimfdcensmean_rd)

        ;--diff
          copy_VarMeta(vimfdcsmean_ra,vimfdcsdiff_ra)
          copy_VarMeta(vimfdcsmean_ra,vimfdcsdiff_rb)
          copy_VarMeta(vimfdcsmean_ra,vimfdcsdiff_rc)
          copy_VarMeta(vimfdcsmean_ra,vimfdcsdiff_rd)

          copy_VarMeta(vimfdcsmean_ra,vimfdcensdiff_ra)
          copy_VarMeta(vimfdcsmean_ra,vimfdcensdiff_rb)
          copy_VarMeta(vimfdcsmean_ra,vimfdcensdiff_rc)
          copy_VarMeta(vimfdcsmean_ra,vimfdcensdiff_rd)

        ;--pval
          copy_VarMeta(vimfdcsmean_ra,vimfdcspval_ra)
          copy_VarMeta(vimfdcsmean_ra,vimfdcspval_rb)
          copy_VarMeta(vimfdcsmean_ra,vimfdcspval_rc)
          copy_VarMeta(vimfdcsmean_ra,vimfdcspval_rd)

          copy_VarMeta(vimfdcsmean_ra,vimfdcenspval_ra)
          copy_VarMeta(vimfdcsmean_ra,vimfdcenspval_rb)
          copy_VarMeta(vimfdcsmean_ra,vimfdcenspval_rc)
          copy_VarMeta(vimfdcsmean_ra,vimfdcenspval_rd)


    ;printVarSummary(sstsample)
    ;printMinMax(sstsample,0)
    ;print("==")
    ;printVarSummary(fsst->sstcsmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}))
    ;printMinMax(fsst->sstcsmean(:,{ra[0]:ra[1]},{ra[2]:ra[3]}),0)
    ;printVarSummary(sstcsmean_ra)
    ;printMinMax(sstcsmean_ra,0)
    ;printVarSummary(sstcensmean_ra)
    ;printMinMax(sstcensmean_ra,0)

  ;--Write NetCDF

    if (netCDF) .and. (hf) .and. (sst)
      diro                = "./"
      filo                = "#graphic_hf_sst.nc"
      ptho                = diro+filo
      system("/bin/rm -f "+ptho)
      ncdf                = addfile(ptho,"c")
    
      fAtt = True
      fAtt@title          = "Visualisasi - Grafik"
      fAtt@source         = "ECMWF"
      fAtt@Conventions    = "None"
      fAtt@creation_date  = systemfunc("date")
      fileattdef(ncdf,fAtt)             ; copy file attributes
     
      filedimdef(ncdf,"timelag",-1,True)   ; make time an UNLIMITED dimension
      ;--hf
        ncdf->sshfcsmeanra = sshfcsmean_ra
        ncdf->sshfcsmeanrb = sshfcsmean_rb
        ncdf->sshfcsmeanrc = sshfcsmean_rc
        ncdf->sshfcsmeanrd = sshfcsmean_rd
        ncdf->sshfcsdiffra = sshfcsdiff_ra
        ncdf->sshfcsdiffrb = sshfcsdiff_rb
        ncdf->sshfcsdiffrc = sshfcsdiff_rc
        ncdf->sshfcsdiffrd = sshfcsdiff_rd
        ncdf->sshfcspvalra = sshfcspval_ra
        ncdf->sshfcspvalrb = sshfcspval_rb
        ncdf->sshfcspvalrc = sshfcspval_rc
        ncdf->sshfcspvalrd = sshfcspval_rd

        ncdf->slhfcsmeanra = slhfcsmean_ra
        ncdf->slhfcsmeanrb = slhfcsmean_rb
        ncdf->slhfcsmeanrc = slhfcsmean_rc
        ncdf->slhfcsmeanrd = slhfcsmean_rd
        ncdf->slhfcsdiffra = slhfcsdiff_ra
        ncdf->slhfcsdiffrb = slhfcsdiff_rb
        ncdf->slhfcsdiffrc = slhfcsdiff_rc
        ncdf->slhfcsdiffrd = slhfcsdiff_rd
        ncdf->slhfcspvalra = slhfcspval_ra
        ncdf->slhfcspvalrb = slhfcspval_rb
        ncdf->slhfcspvalrc = slhfcspval_rc
        ncdf->slhfcspvalrd = slhfcspval_rd

        ncdf->sshfcensmeanra = sshfcensmean_ra 
        ncdf->sshfcensmeanrb = sshfcensmean_rb 
        ncdf->sshfcensmeanrc = sshfcensmean_rc 
        ncdf->sshfcensmeanrd = sshfcensmean_rd
        ncdf->sshfcensdiffra = sshfcensdiff_ra 
        ncdf->sshfcensdiffrb = sshfcensdiff_rb 
        ncdf->sshfcensdiffrc = sshfcensdiff_rc 
        ncdf->sshfcensdiffrd = sshfcensdiff_rd 
        ncdf->sshfcenspvalra = sshfcenspval_ra 
        ncdf->sshfcenspvalrb = sshfcenspval_rb 
        ncdf->sshfcenspvalrc = sshfcenspval_rc 
        ncdf->sshfcenspvalrd = sshfcenspval_rd 

        ncdf->slhfcensmeanra = slhfcensmean_ra 
        ncdf->slhfcensmeanrb = slhfcensmean_rb 
        ncdf->slhfcensmeanrc = slhfcensmean_rc 
        ncdf->slhfcensmeanrd = slhfcensmean_rd 
        ncdf->slhfcensdiffra = slhfcensdiff_ra 
        ncdf->slhfcensdiffrb = slhfcensdiff_rb 
        ncdf->slhfcensdiffrc = slhfcensdiff_rc 
        ncdf->slhfcensdiffrd = slhfcensdiff_rd 
        ncdf->slhfcenspvalra = slhfcenspval_ra 
        ncdf->slhfcenspvalrb = slhfcenspval_rb 
        ncdf->slhfcenspvalrc = slhfcenspval_rc
        ncdf->slhfcenspvalrd = slhfcenspval_rd 
      
      ;--sst

        ncdf->sstcsmeanra = sstcsmean_ra
        ncdf->sstcsmeanrb = sstcsmean_rb
        ncdf->sstcsmeanrc = sstcsmean_rc
        ncdf->sstcsmeanrd = sstcsmean_rd
        ncdf->sstcsdiffra = sstcsdiff_ra
        ncdf->sstcsdiffrb = sstcsdiff_rb
        ncdf->sstcsdiffrc = sstcsdiff_rc
        ncdf->sstcsdiffrd = sstcsdiff_rd
        ncdf->sstcspvalra = sstcspval_ra
        ncdf->sstcspvalrb = sstcspval_rb
        ncdf->sstcspvalrc = sstcspval_rc
        ncdf->sstcspvalrd = sstcspval_rd

        ncdf->sstcensmeanra = sstcensmean_ra
        ncdf->sstcensmeanrb = sstcensmean_rb
        ncdf->sstcensmeanrc = sstcensmean_rc
        ncdf->sstcensmeanrd = sstcensmean_rd
        ncdf->sstcensdiffra = sstcensdiff_ra
        ncdf->sstcensdiffrb = sstcensdiff_rb
        ncdf->sstcensdiffrc = sstcensdiff_rc
        ncdf->sstcensdiffrd = sstcensdiff_rd
        ncdf->sstcenspvalra = sstcenspval_ra
        ncdf->sstcenspvalrb = sstcenspval_rb
        ncdf->sstcenspvalrc = sstcenspval_rc
        ncdf->sstcenspvalrd = sstcenspval_rd

    end if

    if (netCDF) .and. (q1q2)
      diro                = "./"
      filo                = "#graphic_q1q2.nc"
      ptho                = diro+filo
      system("/bin/rm -f "+ptho)
      ncdf                = addfile(ptho,"c")
    
      fAtt = True
      fAtt@title          = "Visualisasi - Grafik"
      fAtt@source         = "ECMWF"
      fAtt@Conventions    = "None"
      fAtt@creation_date  = systemfunc("date")
      fileattdef(ncdf,fAtt)             ; copy file attributes
     
      filedimdef(ncdf,"timelag",-1,True)   ; make time an UNLIMITED dimension
      ncdf->q1pcpcsmeanra = q1percpcsmean_ra
      ncdf->q1pcpcsmeanrb = q1percpcsmean_rb
      ncdf->q1pcpcsmeanrc = q1percpcsmean_rc
      ncdf->q1pcpcsmeanrd = q1percpcsmean_rd
      ncdf->q1pcpcsdiffra = q1percpcsdiff_ra
      ncdf->q1pcpcsdiffrb = q1percpcsdiff_rb
      ncdf->q1pcpcsdiffrc = q1percpcsdiff_rc
      ncdf->q1pcpcsdiffrd = q1percpcsdiff_rd
      ncdf->q1pcpcspvalra = q1percpcspval_ra
      ncdf->q1pcpcspvalrb = q1percpcspval_rb
      ncdf->q1pcpcspvalrc = q1percpcspval_rc
      ncdf->q1pcpcspvalrd = q1percpcspval_rd
      ncdf->q2pcpcsmeanra = q2percpcsmean_ra
      ncdf->q2pcpcsmeanrb = q2percpcsmean_rb
      ncdf->q2pcpcsmeanrc = q2percpcsmean_rc
      ncdf->q2pcpcsmeanrd = q2percpcsmean_rd
      ncdf->q2pcpcsdiffra = q2percpcsdiff_ra
      ncdf->q2pcpcsdiffrb = q2percpcsdiff_rb
      ncdf->q2pcpcsdiffrc = q2percpcsdiff_rc
      ncdf->q2pcpcsdiffrd = q2percpcsdiff_rd
      ncdf->q2pcpcspvalra = q2percpcspval_ra
      ncdf->q2pcpcspvalrb = q2percpcspval_rb
      ncdf->q2pcpcspvalrc = q2percpcspval_rc
      ncdf->q2pcpcspvalrd = q2percpcspval_rd

      ncdf->q1intcsmeanra = q1intcsmean_ra
      ncdf->q1intcsmeanrb = q1intcsmean_rb
      ncdf->q1intcsmeanrc = q1intcsmean_rc
      ncdf->q1intcsmeanrd = q1intcsmean_rd
      ncdf->q1intcsdiffra = q1intcsdiff_ra
      ncdf->q1intcsdiffrb = q1intcsdiff_rb
      ncdf->q1intcsdiffrc = q1intcsdiff_rc
      ncdf->q1intcsdiffrd = q1intcsdiff_rd
      ncdf->q1intcspvalra = q1intcspval_ra
      ncdf->q1intcspvalrb = q1intcspval_rb
      ncdf->q1intcspvalrc = q1intcspval_rc
      ncdf->q1intcspvalrd = q1intcspval_rd
      ncdf->q2intcsmeanra = q2intcsmean_ra
      ncdf->q2intcsmeanrb = q2intcsmean_rb
      ncdf->q2intcsmeanrc = q2intcsmean_rc
      ncdf->q2intcsmeanrd = q2intcsmean_rd
      ncdf->q2intcsdiffra = q2intcsdiff_ra
      ncdf->q2intcsdiffrb = q2intcsdiff_rb
      ncdf->q2intcsdiffrc = q2intcsdiff_rc
      ncdf->q2intcsdiffrd = q2intcsdiff_rd
      ncdf->q2intcspvalra = q2intcspval_ra
      ncdf->q2intcspvalrb = q2intcspval_rb
      ncdf->q2intcspvalrc = q2intcspval_rc
      ncdf->q2intcspvalrd = q2intcspval_rd


      ncdf->q1pcpcensmeanra = q1percpcensmean_ra  
      ncdf->q1pcpcensmeanrb = q1percpcensmean_rb  
      ncdf->q1pcpcensmeanrc = q1percpcensmean_rc  
      ncdf->q1pcpcensmeanrd = q1percpcensmean_rd 
      ncdf->q1pcpcensdiffra = q1percpcensdiff_ra  
      ncdf->q1pcpcensdiffrb = q1percpcensdiff_rb  
      ncdf->q1pcpcensdiffrc = q1percpcensdiff_rc  
      ncdf->q1pcpcensdiffrd = q1percpcensdiff_rd  
      ncdf->q1pcpcenspvalra = q1percpcenspval_ra  
      ncdf->q1pcpcenspvalrb = q1percpcenspval_rb  
      ncdf->q1pcpcenspvalrc = q1percpcenspval_rc  
      ncdf->q1pcpcenspvalrd = q1percpcenspval_rd  
      ncdf->q2pcpcensmeanra = q2percpcensmean_ra  
      ncdf->q2pcpcensmeanrb = q2percpcensmean_rb  
      ncdf->q2pcpcensmeanrc = q2percpcensmean_rc  
      ncdf->q2pcpcensmeanrd = q2percpcensmean_rd  
      ncdf->q2pcpcensdiffra = q2percpcensdiff_ra  
      ncdf->q2pcpcensdiffrb = q2percpcensdiff_rb  
      ncdf->q2pcpcensdiffrc = q2percpcensdiff_rc  
      ncdf->q2pcpcensdiffrd = q2percpcensdiff_rd  
      ncdf->q2pcpcenspvalra = q2percpcenspval_ra  
      ncdf->q2pcpcenspvalrb = q2percpcenspval_rb  
      ncdf->q2pcpcenspvalrc = q2percpcenspval_rc 
      ncdf->q2pcpcenspvalrd = q2percpcenspval_rd  

      ncdf->q1intcensmeanra = q1intcensmean_ra 
      ncdf->q1intcensmeanrb = q1intcensmean_rb 
      ncdf->q1intcensmeanrc = q1intcensmean_rc 
      ncdf->q1intcensmeanrd = q1intcensmean_rd 
      ncdf->q1intcensdiffra = q1intcensdiff_ra 
      ncdf->q1intcensdiffrb = q1intcensdiff_rb 
      ncdf->q1intcensdiffrc = q1intcensdiff_rc 
      ncdf->q1intcensdiffrd = q1intcensdiff_rd 
      ncdf->q1intcenspvalra = q1intcenspval_ra 
      ncdf->q1intcenspvalrb = q1intcenspval_rb 
      ncdf->q1intcenspvalrc = q1intcenspval_rc 
      ncdf->q1intcenspvalrd = q1intcenspval_rd 
      ncdf->q2intcensmeanra = q2intcensmean_ra 
      ncdf->q2intcensmeanrb = q2intcensmean_rb 
      ncdf->q2intcensmeanrc = q2intcensmean_rc 
      ncdf->q2intcensmeanrd = q2intcensmean_rd 
      ncdf->q2intcensdiffra = q2intcensdiff_ra 
      ncdf->q2intcensdiffrb = q2intcensdiff_rb 
      ncdf->q2intcensdiffrc = q2intcensdiff_rc 
      ncdf->q2intcensdiffrd = q2intcensdiff_rd 
      ncdf->q2intcenspvalra = q2intcenspval_ra 
      ncdf->q2intcenspvalrb = q2intcenspval_rb 
      ncdf->q2intcenspvalrc = q2intcenspval_rc 
      ncdf->q2intcenspvalrd = q2intcenspval_rd 

    end if

    if (netCDF) .and. (mb)
      diro                = "./"
      filo                = "#graphic_mb.nc"
      ptho                = diro+filo
      system("/bin/rm -f "+ptho)
      ncdf                = addfile(ptho,"c")
    
      fAtt = True
      fAtt@title          = "Visualisasi - Grafik"
      fAtt@source         = "ECMWF"
      fAtt@Conventions    = "None"
      fAtt@creation_date  = systemfunc("date")
      fileattdef(ncdf,fAtt)             ; copy file attributes
     
      filedimdef(ncdf,"timelag",-1,True)   ; make time an UNLIMITED dimension
      ;--E-P
        ncdf->ecsmeanra = ecsmean_ra
        ncdf->ecsmeanrb = ecsmean_rb
        ncdf->ecsmeanrc = ecsmean_rc
        ncdf->ecsmeanrd = ecsmean_rd
        ncdf->ecsdiffra = ecsdiff_ra
        ncdf->ecsdiffrb = ecsdiff_rb
        ncdf->ecsdiffrc = ecsdiff_rc
        ncdf->ecsdiffrd = ecsdiff_rd
        ncdf->ecspvalra = ecspval_ra
        ncdf->ecspvalrb = ecspval_rb
        ncdf->ecspvalrc = ecspval_rc
        ncdf->ecspvalrd = ecspval_rd

        ncdf->tpcsmeanra = tpcsmean_ra
        ncdf->tpcsmeanrb = tpcsmean_rb
        ncdf->tpcsmeanrc = tpcsmean_rc
        ncdf->tpcsmeanrd = tpcsmean_rd
        ncdf->tpcsdiffra = tpcsdiff_ra
        ncdf->tpcsdiffrb = tpcsdiff_rb
        ncdf->tpcsdiffrc = tpcsdiff_rc
        ncdf->tpcsdiffrd = tpcsdiff_rd
        ncdf->tpcspvalra = tpcspval_ra
        ncdf->tpcspvalrb = tpcspval_rb
        ncdf->tpcspvalrc = tpcspval_rc
        ncdf->tpcspvalrd = tpcspval_rd

        ncdf->ecensmeanra = ecensmean_ra 
        ncdf->ecensmeanrb = ecensmean_rb 
        ncdf->ecensmeanrc = ecensmean_rc 
        ncdf->ecensmeanrd = ecensmean_rd
        ncdf->ecensdiffra = ecensdiff_ra 
        ncdf->ecensdiffrb = ecensdiff_rb 
        ncdf->ecensdiffrc = ecensdiff_rc 
        ncdf->ecensdiffrd = ecensdiff_rd 
        ncdf->ecenspvalra = ecenspval_ra 
        ncdf->ecenspvalrb = ecenspval_rb 
        ncdf->ecenspvalrc = ecenspval_rc 
        ncdf->ecenspvalrd = ecenspval_rd 

        ncdf->tpcensmeanra = tpcensmean_ra 
        ncdf->tpcensmeanrb = tpcensmean_rb 
        ncdf->tpcensmeanrc = tpcensmean_rc 
        ncdf->tpcensmeanrd = tpcensmean_rd 
        ncdf->tpcensdiffra = tpcensdiff_ra 
        ncdf->tpcensdiffrb = tpcensdiff_rb 
        ncdf->tpcensdiffrc = tpcensdiff_rc 
        ncdf->tpcensdiffrd = tpcensdiff_rd 
        ncdf->tpcenspvalra = tpcenspval_ra 
        ncdf->tpcenspvalrb = tpcenspval_rb 
        ncdf->tpcenspvalrc = tpcenspval_rc
        ncdf->tpcenspvalrd = tpcenspval_rd 
      
      ;--pwdt
        ncdf->pwdtcsmeanra = pwdtcsmean_ra
        ncdf->pwdtcsmeanrb = pwdtcsmean_rb
        ncdf->pwdtcsmeanrc = pwdtcsmean_rc
        ncdf->pwdtcsmeanrd = pwdtcsmean_rd
        ncdf->pwdtcsdiffra = pwdtcsdiff_ra
        ncdf->pwdtcsdiffrb = pwdtcsdiff_rb
        ncdf->pwdtcsdiffrc = pwdtcsdiff_rc
        ncdf->pwdtcsdiffrd = pwdtcsdiff_rd
        ncdf->pwdtcspvalra = pwdtcspval_ra
        ncdf->pwdtcspvalrb = pwdtcspval_rb
        ncdf->pwdtcspvalrc = pwdtcspval_rc
        ncdf->pwdtcspvalrd = pwdtcspval_rd

        ncdf->pwdtcensmeanra = pwdtcensmean_ra
        ncdf->pwdtcensmeanrb = pwdtcensmean_rb
        ncdf->pwdtcensmeanrc = pwdtcensmean_rc
        ncdf->pwdtcensmeanrd = pwdtcensmean_rd
        ncdf->pwdtcensdiffra = pwdtcensdiff_ra
        ncdf->pwdtcensdiffrb = pwdtcensdiff_rb
        ncdf->pwdtcensdiffrc = pwdtcensdiff_rc
        ncdf->pwdtcensdiffrd = pwdtcensdiff_rd
        ncdf->pwdtcenspvalra = pwdtcenspval_ra
        ncdf->pwdtcenspvalrb = pwdtcenspval_rb
        ncdf->pwdtcenspvalrc = pwdtcenspval_rc
        ncdf->pwdtcenspvalrd = pwdtcenspval_rd

      ;--iuq_ivq
        ncdf->iuqcsmeanra = iuqcsmean_ra
        ncdf->iuqcsmeanrb = iuqcsmean_rb
        ncdf->iuqcsmeanrc = iuqcsmean_rc
        ncdf->iuqcsmeanrd = iuqcsmean_rd
        ncdf->iuqcsdiffra = iuqcsdiff_ra
        ncdf->iuqcsdiffrb = iuqcsdiff_rb
        ncdf->iuqcsdiffrc = iuqcsdiff_rc
        ncdf->iuqcsdiffrd = iuqcsdiff_rd
        ncdf->iuqcspvalra = iuqcspval_ra
        ncdf->iuqcspvalrb = iuqcspval_rb
        ncdf->iuqcspvalrc = iuqcspval_rc
        ncdf->iuqcspvalrd = iuqcspval_rd

        ncdf->ivqcsmeanra = ivqcsmean_ra
        ncdf->ivqcsmeanrb = ivqcsmean_rb
        ncdf->ivqcsmeanrc = ivqcsmean_rc
        ncdf->ivqcsmeanrd = ivqcsmean_rd
        ncdf->ivqcsdiffra = ivqcsdiff_ra
        ncdf->ivqcsdiffrb = ivqcsdiff_rb
        ncdf->ivqcsdiffrc = ivqcsdiff_rc
        ncdf->ivqcsdiffrd = ivqcsdiff_rd
        ncdf->ivqcspvalra = ivqcspval_ra
        ncdf->ivqcspvalrb = ivqcspval_rb
        ncdf->ivqcspvalrc = ivqcspval_rc
        ncdf->ivqcspvalrd = ivqcspval_rd

        ncdf->iuqcensmeanra = iuqcensmean_ra 
        ncdf->iuqcensmeanrb = iuqcensmean_rb 
        ncdf->iuqcensmeanrc = iuqcensmean_rc 
        ncdf->iuqcensmeanrd = iuqcensmean_rd
        ncdf->iuqcensdiffra = iuqcensdiff_ra 
        ncdf->iuqcensdiffrb = iuqcensdiff_rb 
        ncdf->iuqcensdiffrc = iuqcensdiff_rc 
        ncdf->iuqcensdiffrd = iuqcensdiff_rd 
        ncdf->iuqcenspvalra = iuqcenspval_ra 
        ncdf->iuqcenspvalrb = iuqcenspval_rb 
        ncdf->iuqcenspvalrc = iuqcenspval_rc 
        ncdf->iuqcenspvalrd = iuqcenspval_rd 

        ncdf->ivqcensmeanra = ivqcensmean_ra 
        ncdf->ivqcensmeanrb = ivqcensmean_rb 
        ncdf->ivqcensmeanrc = ivqcensmean_rc 
        ncdf->ivqcensmeanrd = ivqcensmean_rd 
        ncdf->ivqcensdiffra = ivqcensdiff_ra 
        ncdf->ivqcensdiffrb = ivqcensdiff_rb 
        ncdf->ivqcensdiffrc = ivqcensdiff_rc 
        ncdf->ivqcensdiffrd = ivqcensdiff_rd 
        ncdf->ivqcenspvalra = ivqcenspval_ra 
        ncdf->ivqcenspvalrb = ivqcenspval_rb 
        ncdf->ivqcenspvalrc = ivqcenspval_rc
        ncdf->ivqcenspvalrd = ivqcenspval_rd 

      ;--vimfd
        ncdf->vimfdcsmeanra = vimfdcsmean_ra
        ncdf->vimfdcsmeanrb = vimfdcsmean_rb
        ncdf->vimfdcsmeanrc = vimfdcsmean_rc
        ncdf->vimfdcsmeanrd = vimfdcsmean_rd
        ncdf->vimfdcsdiffra = vimfdcsdiff_ra
        ncdf->vimfdcsdiffrb = vimfdcsdiff_rb
        ncdf->vimfdcsdiffrc = vimfdcsdiff_rc
        ncdf->vimfdcsdiffrd = vimfdcsdiff_rd
        ncdf->vimfdcspvalra = vimfdcspval_ra
        ncdf->vimfdcspvalrb = vimfdcspval_rb
        ncdf->vimfdcspvalrc = vimfdcspval_rc
        ncdf->vimfdcspvalrd = vimfdcspval_rd

        ncdf->vimfdcensmeanra = vimfdcensmean_ra
        ncdf->vimfdcensmeanrb = vimfdcensmean_rb
        ncdf->vimfdcensmeanrc = vimfdcensmean_rc
        ncdf->vimfdcensmeanrd = vimfdcensmean_rd
        ncdf->vimfdcensdiffra = vimfdcensdiff_ra
        ncdf->vimfdcensdiffrb = vimfdcensdiff_rb
        ncdf->vimfdcensdiffrc = vimfdcensdiff_rc
        ncdf->vimfdcensdiffrd = vimfdcensdiff_rd
        ncdf->vimfdcenspvalra = vimfdcenspval_ra
        ncdf->vimfdcenspvalrb = vimfdcenspval_rb
        ncdf->vimfdcenspvalrc = vimfdcenspval_rc
        ncdf->vimfdcenspvalrd = vimfdcenspval_rd

    end if

 end