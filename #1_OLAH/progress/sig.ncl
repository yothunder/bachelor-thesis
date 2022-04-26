;=======================================================================
; name
;   signif.ncl
;
; category
;   NCL script
;
; description
;   This script computes statistical significance (p-value) using the
;   two-tailed t-test.
;
; usage
;   ncl signif.ncl
;
; input
;   two time series files to be compared (e.g., control vs. perturbed)
;
; output
;   diff: difference of the two data (e.g., control vs. perturbed)
;   pval: p-value (<0.05 -> significant at 5% level of falsely rejecting
;         the null hypothesis, i.e., control=perturbed;
;         <0.1 for single-tailed t-test)
;
; refrence
;   NCL web page (ttest)
;
; author
;   m.yoshimori
;=======================================================================

begin

; specify file names (input&output, netCDF)
  pathin = "../data/"                  ; directory
  fin1 = pathin+"daymean_pressurelevel.nc"        ; input file name #1
; fin2 = "ts_t2m_y2001-y2015_djf.nc"  ; input file name #2
  fout = "signif"      ; output file name
  foutnc = fout+".nc"

; open input files
  in1 = addfile(fin1,"r")
; in2 = addfile(pathin+fin2,"r")
  
  level = 925
; read data
  v1   = in1->v(:,{level},:,:)
  v2   = in1->u(:,{level},:,:)

; t-test
;  xtmp = tmp1(lat|:,lon|:,time|:)
;  ytmp = tmp2(lat|:,lon|:,time|:)
  xv = v1(latitude|:,longitude|:,time|:)
  yv = v2(latitude|:,longitude|:,time|:)
  Xave = dim_avg_Wrap(xv)
  Yave = dim_avg_Wrap(yv)
  Xvar = dim_variance(xv)
  Yvar = dim_variance(yv)
  Xs   = dimsizes(v1(0,0,:))
  Ys   = dimsizes(v2(0,0,:))
  print(Xs)
  print(Ys)
  iflag    = False  ; population variance similar
  tval_opt = False  ; p-value only
  prob = ttest(Xave,Xvar,Xs,Yave,Yvar,Ys,iflag,tval_opt)

; calc. the difference
  diff = Xave
  diff = Yave - Xave
  pval = Xave
  pval = (/prob/)
  diff@long_name = "difference of the means"
  pval@long_name = "probability"

; write output file
  system("rm " + foutnc)     ; remove any pre-existing file
  out = addfile(foutnc,"c")  ; open netCDF file
  out->diff = diff
  out->pval = pval
 
;***********************************************************************
; remove the following part unless the graphical output is needed.
;***********************************************************************

Plot = True

if (Plot)
  ;-----
  ; plot
  ;-----

  ; judge significance
    siglvl = 0.05
    sig = pval
    ndim = dimsizes(pval)
    nlat = ndim(0)
    nlon = ndim(1)
    do j=0,nlat-1
      do i=0,nlon-1
        if (pval(j,i).lt.siglvl) then
          sig(j,i) = 1.
        else
          sig(j,i) = 0.
        end if
      end do
    end do

  ; create a plot
    wks = gsn_open_wks("png",fout)	; open an eps file
    gsn_define_colormap(wks,"nrl_sirkes")	; choose a color map

    colors = gsn_retrieve_colormap(wks)    ; retreive the colors
  ;  colors(13,:) = (/1.00,1.00,1.00/)      ; force the color to white
  ;  colors(12,:) = (/1.00,1.00,1.00/)      ; force the color to white
  ;  colors(11,:) = (/1.00,1.00,1.00/)      ; force the color to white
    gsn_define_colormap(wks,colors)        ; redefine the color table

  ; basic settings
    res = True		; plot mods desired
    res@gsnDraw = False	; draw plot
    res@gsnFrame = False	; advance frame
    res@cnFillOn = True	; turn on color fill
    res@cnLinesOn = False	; turn off contour lines
    res@cnLineLabelsOn = False    ; turn off contour labels

  ; contour levels
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnMinLevelValF = -4.
    res@cnMaxLevelValF =  4.
    res@cnLevelSpacingF = 0.4

  ; reshape color bars
    res@lbOrientation = "vertical"        ; vertical label bars
  ;  res@pmLabelBarOrthogonalPosF = -0.02  ; shift left-right
    res@lbLabelStride = 4                 ; label interval
    res@lbBoxMinorExtentF = 0.2           ; slim width

  ; adjust aspect ratio
  ; res@mpShapeMode = "FreeAspect"
  ; res@vpWidthF = 0.75
  ; res@vpHeightF = 0.45

  ; map
    res@mpFillOn = False         ; turn off gray continents
  ; res@mpCenterLonF = 180       ; set centers the plot at 180E
    res@gsnMajorLonSpacing = 5  ; tick mark interval for longitude
    res@gsnMajorLatSpacing = 5  ; tick mark interval for latitude
    res@mpLimitMode = "Corners"
    res@mpLeftCornerLonF = 95. ;-- min longitude
    res@mpRightCornerLonF = 125. ;-- max longitude
    res@mpLeftCornerLatF = -10. ;-- min latitude
    res@mpRightCornerLatF = 25. ;-- max latitude
    res@pmTickMarkDisplayMode = "Always"

  ; colar table
    res@gsnSpreadColors = True   ; spread out color table

  ; font size
    res@tiMainFontHeightF = 0.022     ; fontsize of the main title
    res@txFontHeightF = 0.02          ; fontsize of the subtitles
    res@tmXBLabelFontHeightF = 0.018  ; fontsize of tickmark labels (x-axis)
    res@tmYLLabelFontHeightF = 0.018  ; fontsize of tickmark labels (x-axis)

  ; title
    res@tiMainString = "Difference (2001-2015) - (1979-1993)"      ; title
    res@gsnCenterString = ""	                    ; subtitle
    res@gsnLeftString = "DJF"                         ; upper-left subtitle
    res@gsnRightString = "~S~o~N~C"  ; upper-right subtitle
    res@gsnAddCyclic = False
    
  ; plot
  ; res@gsnMaximize          =  True			    ;-- maxmize plot in frame
    plot = gsn_csm_contour_map_ce(wks,diff,res)

  ;------------------------------
  ; plot statistical significance
  ;------------------------------

    sgres                      = True		; significance
    sgres@gsnDraw              = False		; draw plot
    sgres@gsnFrame             = False		; advance frome
    sgres@cnInfoLabelOn        = False		; turn off info label
    sgres@cnLinesOn            = False		; draw contour lines
    sgres@cnLineLabelsOn       = False		; draw contour labels
  ;  sgres@cnFillScaleF         = 0.6		; add extra density
    sgres@cnFillDotSizeF       = 0.003

  ; activate if gray shading for B&W plot  
    sgres@cnFillOn = True
    sgres@cnFillColors = (/"transparent","transparent"/)	; choose one color for our single cn level
    sgres@cnLevelSelectionMode = "ExplicitLevels"	; set explicit contour levels
    sgres@cnLevels = 0.5	; only set one level
    sgres@lbLabelBarOn = False

    sgres@tiMainString = ""     ; title
    sgres@gsnCenterString = ""  ; subtitle
    sgres@gsnLeftString = ""    ; upper-left subtitle
    sgres@gsnRightString = ""   ; upper-right subtitle
    sgres@gsnAddCyclic = False
    sig_plot = gsn_csm_contour(wks,sig,sgres)

    opt = True
    opt@gsnShadeFillType = "pattern"
    opt@gsnShadeHigh     = 17
    sig_plot = gsn_contour_shade(sig_plot,-999.,0.5,opt)

    overlay(plot,sig_plot)

    draw(plot)
    frame(wks)

  ;***********************************************************************
  ; remove the above part unless the graphical output is needed.
  ;***********************************************************************

  end if

end