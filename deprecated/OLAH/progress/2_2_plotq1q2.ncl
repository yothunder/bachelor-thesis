;===========================================================================================;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;																							;
; Progres_v2.1 - first time writing code => Wednesday, 02 Feb 2022 - 15.08 WIB (08.08 UTC)  ;
;																							;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;===========================================================================================;

;***********************************************
; Import file
;***********************************************

  f      = addfile("YANAI_Q1Q2__.nc","r" )

;***********************************************
; Selecting Region
;***********************************************
  
  q1int = dble2flt(f->Q1int)
  q2int = dble2flt(f->Q2int)
  printVarSummary(q1int)
  printVarSummary(q2int)
  
  lat1 = 3
  lat2 = 8
  lon1 = 105
  lon2 = 113
  rbq1 = dble2flt(f->Q1percp(:,:,{lat1:lat2},{lon1:lon2}))
  rbq2 = dble2flt(f->Q2percp(:,:,105:113,3:8))
  rbq1_ave = wgt_areaave(rbq1, 1.0, 1.0, 1)
  rbq2_ave = wgt_areaave(rbq2, 1.0, 1.0, 1)
  copy_VarMeta(rbq1,rbq1_ave)
  copy_VarMeta(rbq2,rbq2_ave)
  rbq1_ave&level@units = "millibars"
  rbq2_ave&level@units = "millibars"
  rbq1_ave := rbq1_ave(level|:,time|:)
  rbq2_ave := rbq2_ave(level|:,time|:)
  printVarSummary(rbq1)
  printVarSummary(rbq2_ave)
  
;***********************************************
;---Plot
;***********************************************

  nt    = 10
  YMDH  = nt
  LEVP  = 925

  plot  = new(2,graphic)

  wks   = gsn_open_wks("pdf","q2q1_yanai__")            ; send graphics to PNG file
        
;--- mfc_adv and mfc_con at a specified pressure level

  res                       = True                    ; plot mods desired
  res@gsnDraw               = False                   ; don't draw yet
  res@gsnFrame              = False                   ; don't advance frame yet
  res@gsnAddCyclic          = False                   ; non-global data
  res@gsnMajorLonSpacing    = 5                       ; tick mark interval for longitude
  res@gsnMajorLatSpacing    = 5                       ; tick mark interval for latitude
  res@mpLimitMode           = "Corners"
  res@mpLeftCornerLonF      = 95.                     ; min longitude
  res@mpRightCornerLonF     = 125.                    ; max longitude
  res@mpLeftCornerLatF      = -10.                    ; min latitude
  res@mpRightCornerLatF     = 25.                     ; max latitude
  res@pmTickMarkDisplayMode = "Always"
  
  res@cnFillOn              = True                    ; turn on color
  res@cnLinesOn             = False                   ; turn off contour lines
  res@cnLineLabelsOn        = False                   ; turn off contour lines
 ;res@cnFillPalette         = "ViBlGrWhYeOrRe"        ; set White-in-Middle color map
  res@cnFillPalette         = "amwg256"               ; set White-in-Middle color map
 ;res@cnFillMode            = "RasterFill"
  res@mpFillOn              = False                   ; turn off map fill
;;res@lbLabelBarOn          = False                   ; turn off individual cb's
  res@lbOrientation         = "Horizontal"            ; default Vertical
                                                      ; Use a common scale
  res@cnLevelSelectionMode  = "ManualLevels"          ; manual set levels so lb consistent
  res@cnMaxLevelValF        =    500.0                  ; max level
  res@cnMinLevelValF        = -res@cnMaxLevelValF     ; min level
  res@cnLevelSpacingF       =    50                 ; contour interval

; res@gsnCenterString       = LEVP+"hPa"
  plot(0)                   = gsn_csm_contour_map(wks,q1int(nt,:,:),res)

  res@cnMaxLevelValF        =    500.0                  ; max level
  res@cnMinLevelValF        = -res@cnMaxLevelValF     ; min level
  res@cnLevelSpacingF       =    50                 ; contour interval
  plot(1)                   = gsn_csm_contour_map(wks,q2int(nt,:,:),res)

  resP                      = True                    ; modify the panel plot
  resP@gsnMaximize          = True
; resP@gsnPanelMainString  := YMDH
;;resP@gsnPanelLabelBar     = True                    ; add common colorbar
  gsn_panel(wks,plot,(/1,2/),resP)                    ; now draw as one plot

  delete(res@gsnCenterString)                         ; not used for this plot


;---Cross section : time series

  
  plot1  = new(2,graphic)
  x      = (/-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9,10/)
  rbq1_ave&time = x  
  rbq2_ave&time = x  
  
  rescx                      = True                   ; plot mods desired
  rescx@gsnDraw              = False                   ; don't draw yet
  rescx@gsnFrame             = False                   ; don't advance frame yet
  rescx@gsnMaximize          = True
  rescx@cnLevelSelectionMode = "ManualLevels"         ; manual contour levels
  rescx@cnLinesOn            = False                  ; turn off contour lines
  rescx@cnLineLabelsOn       = False
  rescx@cnFillOn             = True                   ; turn on color fill
  rescx@cnFillPalette        = "ViBlGrWhYeOrRe"       ; set White-in-Middle color map
  rescx@cnFillPalette        = "amwg256"              ; set White-in-Middle color map
  rescx@tmYRMode             = "Automatic"            ; turn off special labels on right axis
;  rescx@tmXBMode             = "Explicit"
;  rescx@tmXBValues           = x
;  rescx@tmXBLabels           = ""+x
  
  rescx@cnMaxLevelValF       =  5.0                   ; max level
  rescx@cnMinLevelValF       = -rescx@cnMaxLevelValF  ; min level
  rescx@cnLevelSpacingF      =  0.25                  ; contour interval
  plot1(0)                   = gsn_csm_pres_hgt(wks,rbq1_ave,rescx)
  rescx@cnMaxLevelValF       =  5.0                   ; max level
  rescx@cnMinLevelValF       = -rescx@cnMaxLevelValF  ; min level
  rescx@cnLevelSpacingF      =  0.25                  ; contour interval
  plot1(1)                   = gsn_csm_pres_hgt(wks,rbq2_ave,rescx)

  rescxP                      = True                  ; modify the panel plot
  rescxP@gsnMaximize          = True
; rescxP@gsnPanelMainString  := YMDH
;;resP@gsnPanelLabelBar     = True                    ; add common colorbar
  gsn_panel(wks,plot1,(/1,2/),resP)                   ; now draw as one plot

;===========================================================================================;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;																							;
; Progres_v2.1 - last save => Wednesday, 05 Jan 2022 - 20.44 WIB (13.44 UTC)  				;
;																							;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;===========================================================================================;