;-------------------------------------------------------------------------------------------;
;===========================================================================================;
; Progres_v1 - first time writing code => Wednesday, 15 Dec 2021 - 14.57 WIB (07.57 UTC)    ;
;===========================================================================================;
;-------------------------------------------------------------------------------------------;
																							;
;===========================================================================================;
;==========Cold surge and cross equatorial surge identification=============================;
;===========================================================================================;

;---assign some variable for boundary of cs and ces index---									

  latScs = 7.5  ; for cs index																;
  latNcs = 12.5																				;
  lonLcs = 110																				;
  lonRcs = 115																				;
  latSces = -4  ; for ces index																;
  latNces = 0																				;
  lonLces = 105																				;
  lonRces = 110																				;
  levelindex = 925 ; 925 hPa																;
																							;
;---Import file---																			;
																							;
  f     = addfile("daymean_201011.nc","r" ) ; import file, "r" means just for "read"			;
  time1  = f->time																			;
  time   = cd_calendar(time1,-2) ; Human readable (https://www.ncl.ucar.edu/Document/Functions/date.shtml)
  ntime  = dimsizes(time)																	;
; yrfrac = yyyymmdd_to_yyyyfrac(time(:),0)													;
; print(ntime)																				;

  level = f->level
  lat   = f->latitude
  lon   = f->longitude
  
  printVarSummary(level)
  printVarSummary(lat)
  printVarSummary(lon)
  
																							;
;-for cs index---																			;
  xcs               = f->v(:,{levelindex},{latScs:latNcs},{lonLcs:lonRcs}) ; convert data type from short to float (https://www.ncl.ucar.edu/Document/Functions/type_convert.shtml)
  xcs_avg           = wgt_areaave(xcs, 1.0, 1.0, 1) ; area average meridional wind for cs index
  xcs_avg@long_name = "areal avg v-wind for cs"												;
																							;
;-for ces index---																			;
  xces               = f->v(:,{levelindex},{latSces:latNces},{lonLces:lonRces}) ; convert data type from short to float (https://www.ncl.ucar.edu/Document/Functions/type_convert.shtml)
  xces_avg           = wgt_areaave(xces, 1.0, 1.0, 1) ; area average meridional wind for cs index
  xces_avg@long_name = "areal avg v-wind for ces"											;
																							;
																							;
; printVarSummary(xcs)																		;
; printMinMax(xcs_avg,1)																	;
; printVarSummary(xces_avg)																	;
; printMinMax(xces_avg,1)																	;

;-------------------------------------------------------------------------------------------;																							;
;----------Filtering------------------------------------------------------------------------;
;-------------------------------------------------------------------------------------------;
																							;	
  xcs_runningunsmoothed  = runave_n(xcs_avg,5,0,0) ;---> Ini yang dipakai filter 5 harian	;
  xces_runningunsmoothed = runave_n(xces_avg,4,0,0) ;---> Ini yang dipakai filter 4 harian	;
																							;
;---Remove the first and the last ten days. Fill with missing value---						;
																							;
  do i = 0, 9																				;
    xcs_runningunsmoothed(i) = -32767														;
	xces_runningunsmoothed(i) = -32767														;
  end do																					;
  do i = ntime-10, ntime-1																	;
    xcs_runningunsmoothed(i) = -32767														;
	xces_runningunsmoothed(i) = -32767														;
  end do																					;
																							;
;---Di kotak ini filterisasi lanczos, tidak jadi dipakai--------------------------------;	;
;  ihp    							= 0													;	;
;  sigma  							= 1.0												;	;
;  nWgt   							= 11												;	;
;  fcacs  							= 1./5.												;	;
;  fcaces 							= 1./4.												;	;
;  wgtcs  							= filwgts_lanczos(nWgt, ihp, fcacs, -999., sigma)	;	;
;  wgtces 							= filwgts_lanczos(nWgt, ihp, fcaces, -999., sigma)	;	;
;  lpfcs  							= wgt_runave_n(xcs_avg,wgtcs,0,0) 					;	;
;  lpfces 							= wgt_runave_n(xces_avg,wgtces,0,0);				;	;
;  lpfcs@long_name  				= "CS Index filtered"								;	;
;  lpfcs!0          				= "time"											;	;
;  lpfcs&time       				= time												;	;
;  lpfcs@_FillValue_original		= -32767											;	;
;  lpfcs@missing_value_original		= -32767											;	;	
;  lpfcs@missing_value				= -32767											;	;
;  lpfces@long_name					= "CES Index filtered"								;	;
;  printVarSummary(lpfcs)																;	;
;  printMinMax(lpfcs,1)																	;	;
;  printVarSummary(lpfces)																;	;
;  printMinMax(lpfces,1)																;	;
;---------------------------------------------------------------------------------------;	;
																							;
;-------------------------------------------------------------------------------------------;
;-----------Index Selection-----------------------------------------------------------------;
;-------------------------------------------------------------------------------------------;
																							;
  cs    = -8 ; index treshold for cs
  ces	= -5 ; index treshold for ces

;---create an array index for cs and ces---

  csi  = ind(.not.ismissing(xcs_runningunsmoothed) .and. xcs_runningunsmoothed.le.cs)
  cesi  = ind(.not.ismissing(xces_runningunsmoothed) .and. xces_runningunsmoothed.le.ces)

;---Index selection for lead-lag or time lag analysis---
  
  x = ispan (0,ntime,1) ; array for time selection
  if (.not.all(ismissing(csi)) .and. .not.all(ismissing(cesi)) .and. .not.all(ismissing(x))) then
	tcsi_0 = x(csi-1)
	tcsi_1 = x(csi-2)
	tcsi_2 = x(csi-3)
	tcsi_3 = x(csi-4)
	tcsi_4 = x(csi-5)
	tcsi_5 = x(csi-6)
	tcsi_6 = x(csi-7)
	tcsi_7 = x(csi-8)
	tcsi_8 = x(csi-9)
	tcsi_9 = x(csi-10)
	tcsi_10 = x(csi)
	tcstime = time(csi)
	tcsi_11 = x(csi+1)
	tcsi_12 = x(csi+2)
	tcsi_13 = x(csi+3)
	tcsi_14 = x(csi+4)
	tcsi_15 = x(csi+5)
	tcsi_16 = x(csi+6)
	tcsi_17 = x(csi+7)
	tcsi_18 = x(csi+8)
	tcsi_19 = x(csi+9)
	tcsi_20 = x(csi+10)
	
	;--for ces
	tcesim1 = x(cesi-1)
	tcesim2 = x(cesi-2)
	tcesim3 = x(cesi-3)
	tcesim4 = x(cesi-4)
	tcesim5 = x(cesi-5)
	tcesim6 = x(cesi-6)
	tcesim7 = x(cesi-7)
	tcesim8 = x(cesi-8)
	tcesim9 = x(cesi-9)
	tcesim10 = x(cesi-10)
	tcesi = x(cesi)
	tcestime = time(cesi)
	tcesip1 = x(cesi+1)
	tcesip2 = x(cesi+2)
	tcesip3 = x(cesi+3)
	tcesip4 = x(cesi+4)
	tcesip5 = x(cesi+5)
	tcesip6 = x(cesi+6)
	tcesip7 = x(cesi+7)
	tcesip8 = x(cesi+8)
	tcesip9 = x(cesi+9)
	tcesip10 = x(cesi+10)
	tcesip10 = x(cesi+10)
  end if
  
  delete (xcs)     ;-> delete some variables for computational efficiency
  delete (xcs_avg)
  delete (xces)
  delete (xces_avg)
  delete (csi)
  delete (cesi)
  
;  printVarSummary(tcsi)																	;
;  print(xcs_runningunsmoothed) 																;
;  print(x)
  print("List Tanggal kejadian CS")															;
  print("Tanggal   H-10   H0   H+10")														;
;  print(tcstime+"   "+tcsi_0+"     "+tcsi_10+"   "+tcsi_20)													;
  print("")
  print("List Tanggal kejadian CES")														;
  print("Tanggal   H-10   H0   H+10")														;
;  print(tcestime+"   "+tcesim10+"     "+tcesi+"   "+tcesip10)												;
																							;
;-------------------------------------------------------------------------------------------;
  
;-------------------------------------------------------------------------------------------;
;-----------Variabel selection--------------------------------------------------------------;
;-------------------------------------------------------------------------------------------;

;--------------------------------------------------------
;---Specific humidity (q)--------------------------------
;--------------------------------------------------------

  q0csall             = f->q((/tcsi_0/),:,:,:)       ;-->H-10
  q0cs                = dim_avg_n (q0csall,0)        ;-->Reratakan nilai q utk semua waktu
  q0                  = new(dimsizes(q0csall),typeof(q0csall),q0csall@_FillValue) ;-->array baru
  q0(0:0,:,:,:)       = (/q0cs/)                     ;-->Memasukkan nilai q ke array baru
  q0cs               := q0(0:0,:,:,:)                ;-->Reduksi dimensi waktu
  delete (q0csall)                                   ;-->directly delete variables for memory capacity
  delete (q0)
  q0cs!0                = "time" 
  q0cs!1                = "level"
  q0cs!2                = "lat"
  q0cs!3                = "lon"
;  csarray&level      = q0csall(0,:,0,0)             ;-->salah, bukan gini konsepnya, seharusnya ini memasukkan koordinat variabel bukan nilai kelembapannya
;  csarray&lat        = q0csall(0,0,:,0)             ;-->idem
;  csarray&lon        = q0csall(0,0,0,:)             ;-->idem
;  csarray(:)         = (/ q0cs /)                   ;-->csarray(0:0,:,:,:)  = (/qm10cs/) -> ini yg bener

  q1csall             = f->q((/tcsi_1/),:,:,:)       ;-->H-9
  q1cs                = dim_avg_n (q1csall,0)
  q1                  = new(dimsizes(q1csall),typeof(q1csall),q1csall@_FillValue) 
  q1(0:0,:,:,:)       = (/q1cs/)          
  q1cs               := q1(0:0,:,:,:)      
  delete (q1csall)
  delete (q1)
  
  q2csall             = f->q((/tcsi_2/),:,:,:)       ;-->H-8
  q2cs                = dim_avg_n (q2csall,0)
  q2                  = new(dimsizes(q2csall),typeof(q2csall),q2csall@_FillValue) 
  q2(0:0,:,:,:)       = (/q2cs/)          
  q2cs               := q2(0:0,:,:,:)      
  delete (q2csall)
  delete (q2)
  
  q3csall             = f->q((/tcsi_3/),:,:,:)       ;-->H-7
  q3cs                = dim_avg_n (q3csall,0)
  q3                  = new(dimsizes(q3csall),typeof(q3csall),q3csall@_FillValue) 
  q3(0:0,:,:,:)       = (/q3cs/)          
  q3cs               := q3(0:0,:,:,:)      
  delete (q3csall)
  delete (q3)
  
  q4csall             = f->q((/tcsi_4/),:,:,:)       ;-->H-7
  q4cs                = dim_avg_n (q4csall,0)
  q4                  = new(dimsizes(q4csall),typeof(q4csall),q4csall@_FillValue) 
  q4(0:0,:,:,:)       = (/q4cs/)          
  q4cs               := q4(0:0,:,:,:)      
  delete (q4csall)
  delete (q4)
  
  q5csall             = f->q((/tcsi_5/),:,:,:)       ;-->H-7
  q5cs                = dim_avg_n (q5csall,0)
  q5                  = new(dimsizes(q5csall),typeof(q5csall),q5csall@_FillValue) 
  q5(0:0,:,:,:)       = (/q5cs/)          
  q5cs               := q5(0:0,:,:,:)      
  delete (q5csall)
  delete (q5)
  
  q6csall             = f->q((/tcsi_6/),:,:,:)       ;-->H-7
  q6cs                = dim_avg_n (q6csall,0)
  q6                  = new(dimsizes(q6csall),typeof(q6csall),q6csall@_FillValue) 
  q6(0:0,:,:,:)       = (/q6cs/)          
  q6cs               := q6(0:0,:,:,:)      
  delete (q6csall)
  delete (q6)
  
  q7csall             = f->q((/tcsi_7/),:,:,:)       ;-->H-7
  q7cs                = dim_avg_n (q7csall,0)
  q7                  = new(dimsizes(q7csall),typeof(q7csall),q7csall@_FillValue) 
  q7(0:0,:,:,:)       = (/q7cs/)          
  q7cs               := q7(0:0,:,:,:)      
  delete (q7csall)
  delete (q7)
  
  q8csall             = f->q((/tcsi_8/),:,:,:)       ;-->H-7
  q8cs                = dim_avg_n (q8csall,0)
  q8                  = new(dimsizes(q8csall),typeof(q8csall),q8csall@_FillValue) 
  q8(0:0,:,:,:)       = (/q8cs/)          
  q8cs               := q8(0:0,:,:,:)      
  delete (q8csall)
  delete (q8)
  
  q9csall             = f->q((/tcsi_9/),:,:,:)       ;-->H-7
  q9cs                = dim_avg_n (q9csall,0)
  q9                  = new(dimsizes(q9csall),typeof(q9csall),q9csall@_FillValue) 
  q9(0:0,:,:,:)       = (/q9cs/)          
  q9cs               := q9(0:0,:,:,:)      
  delete (q9csall)
  delete (q9)
  
  q10csall            = f->q((/tcsi_10/),:,:,:)       ;-->H-7
  q10cs               = dim_avg_n (q10csall,0)
  q10                 = new(dimsizes(q10csall),typeof(q10csall),q10csall@_FillValue) 
  q10(0:0,:,:,:)      = (/q10cs/)          
  q10cs              := q10(0:0,:,:,:)      
  delete (q10csall)
  delete (q10)
  
  q11csall            = f->q((/tcsi_11/),:,:,:)       ;-->H-7
  q11cs               = dim_avg_n (q11csall,0)
  q11                 = new(dimsizes(q11csall),typeof(q11csall),q11csall@_FillValue) 
  q11(0:0,:,:,:)      = (/q11cs/)          
  q11cs              := q11(0:0,:,:,:)      
  delete (q11csall)
  delete (q11)
  
  q12csall            = f->q((/tcsi_12/),:,:,:)       ;-->H-7
  q12cs               = dim_avg_n (q12csall,0)
  q12                 = new(dimsizes(q12csall),typeof(q12csall),q12csall@_FillValue) 
  q12(0:0,:,:,:)      = (/q12cs/)          
  q12cs              := q12(0:0,:,:,:)      
  delete (q12csall)
  delete (q12)
  
  q13csall            = f->q((/tcsi_13/),:,:,:)       ;-->H-7
  q13cs               = dim_avg_n (q13csall,0)
  q13                 = new(dimsizes(q13csall),typeof(q13csall),q13csall@_FillValue) 
  q13(0:0,:,:,:)      = (/q13cs/)          
  q13cs              := q13(0:0,:,:,:)      
  delete (q13csall)
  delete (q13)
  
  q14csall            = f->q((/tcsi_14/),:,:,:)       ;-->H-7
  q14cs               = dim_avg_n (q14csall,0)
  q14                 = new(dimsizes(q14csall),typeof(q14csall),q14csall@_FillValue) 
  q14(0:0,:,:,:)      = (/q14cs/)          
  q14cs              := q14(0:0,:,:,:)      
  delete (q14csall)  
  delete (q14)
  
  q15csall            = f->q((/tcsi_15/),:,:,:)       ;-->H-7
  q15cs               = dim_avg_n (q15csall,0)
  q15                 = new(dimsizes(q15csall),typeof(q15csall),q15csall@_FillValue) 
  q15(0:0,:,:,:)      = (/q15cs/)          
  q15cs              := q15(0:0,:,:,:)      
  delete (q15csall)    
  delete (q15)
  
  q16csall            = f->q((/tcsi_16/),:,:,:)       ;-->H-7
  q16cs               = dim_avg_n (q16csall,0)
  q16                 = new(dimsizes(q16csall),typeof(q16csall),q16csall@_FillValue) 
  q16(0:0,:,:,:)      = (/q16cs/)          
  q16cs              := q16(0:0,:,:,:)      
  delete (q16csall)  
  delete (q16)
  
  q17csall            = f->q((/tcsi_17/),:,:,:)       ;-->H-7
  q17cs               = dim_avg_n (q17csall,0)
  q17                 = new(dimsizes(q17csall),typeof(q17csall),q17csall@_FillValue) 
  q17(0:0,:,:,:)      = (/q17cs/)          
  q17cs              := q17(0:0,:,:,:)      
  delete (q17csall)  
  delete (q17)
  
  q18csall            = f->q((/tcsi_18/),:,:,:)       ;-->H-7
  q18cs               = dim_avg_n (q18csall,0)
  q18                 = new(dimsizes(q18csall),typeof(q18csall),q18csall@_FillValue) 
  q18(0:0,:,:,:)      = (/q18cs/)          
  q18cs              := q18(0:0,:,:,:)      
  delete (q18csall)    
  delete (q18)
  
  q19csall            = f->q((/tcsi_19/),:,:,:)       ;-->H-7
  q19cs               = dim_avg_n (q19csall,0)
  q19                 = new(dimsizes(q19csall),typeof(q19csall),q19csall@_FillValue) 
  q19(0:0,:,:,:)      = (/q19cs/)          
  q19cs              := q19(0:0,:,:,:)      
  delete (q19csall)   
  delete (q19)
  
  q20csall            = f->q((/tcsi_20/),:,:,:)       ;-->H-7
  q20cs               = dim_avg_n (q20csall,0)
  q20                 = new(dimsizes(q20csall),typeof(q20csall),q20csall@_FillValue) 
  q20(0:0,:,:,:)      = (/q20cs/)          
  q20cs              := q20(0:0,:,:,:)      
  delete (q20csall)     
  delete (q20)
  
  q_1 = array_append_record(q0cs,q1cs,0)
  q_2 = array_append_record(q_1,q2cs,0)
  delete(q_1)
  q_3 = array_append_record(q_2,q3cs,0)
  delete(q_2)
  q_4 = array_append_record(q_3,q4cs,0)
  delete(q_3)
  q_5 = array_append_record(q_4,q5cs,0)
  delete(q_4)
  q_6 = array_append_record(q_5,q6cs,0)
  delete(q_5)
  q_7 = array_append_record(q_6,q7cs,0)
  delete(q_6)
  q_8 = array_append_record(q_7,q8cs,0)
  delete(q_7)
  q_9 = array_append_record(q_8,q9cs,0)
  delete(q_8)
  q_10 = array_append_record(q_9,q10cs,0)
  delete(q_9)
  q_11 = array_append_record(q_10,q11cs,0)
  delete(q_10)
  q_12 = array_append_record(q_11,q12cs,0)
  delete(q_11)
  q_13 = array_append_record(q_12,q13cs,0)
  delete(q_12)
  q_14 = array_append_record(q_13,q14cs,0)
  delete(q_13)
  q_15 = array_append_record(q_14,q15cs,0)
  delete(q_14)
  q_16 = array_append_record(q_15,q16cs,0)
  delete(q_15)
  q_17 = array_append_record(q_16,q17cs,0)
  delete(q_16)
  q_18 = array_append_record(q_17,q18cs,0)
  delete(q_17)
  q_19 = array_append_record(q_18,q19cs,0)
  delete(q_18)
  q    = array_append_record(q_19,q20cs,0)
  delete(q_19)
  
  timecs      = ispan(0,20,1)
  timecs@units = "days since 2010-01-01 00:00:0.0"
  q&time      = timecs
  q&level     = level
  q&lat       = lat
  q&lon       = lon
  q@long_name = "Specific humidity"
  q@units     = "kg/kg"
  q@info      = "Filtered variable, ready to compute Q1Q2 and moisture budget"
  q@creation_date = systemfunc("date")
  
;  printVarSummary(q)
;  printMinMax(q,1)
;  printVarSummary(q0cs)
;  printMinMax(q0cs,1)
;  printVarSummary(q1cs)
;  printMinMax(q1cs,1)

;------------------------------------
;----------Temperature---------------
;------------------------------------

  t0csall             = f->t((/tcsi_0/),:,:,:)       ;-->H-10
  t0cs                = dim_avg_n (t0csall,0)        ;-->Reratakan nilai t utk semua waktu
  t0                  = new(dimsizes(t0csall),typeof(t0csall),t0csall@_FillValue) ;-->array baru
  t0(0:0,:,:,:)       = (/t0cs/)                     ;-->Memasukkan nilai t ke array baru
  t0cs               := t0(0:0,:,:,:)                ;-->Reduksi dimensi waktu
  delete (t0csall)                                   ;-->directly delete variables for memory capacity
  delete (t0)
  t0cs!0                = "time" 
  t0cs!1                = "level"
  t0cs!2                = "lat"
  t0cs!3                = "lon"

  t1csall             = f->t((/tcsi_1/),:,:,:)       ;-->H-9
  t1cs                = dim_avg_n (t1csall,0)
  t1                  = new(dimsizes(t1csall),typeof(t1csall),t1csall@_FillValue) 
  t1(0:0,:,:,:)       = (/t1cs/)          
  t1cs               := t1(0:0,:,:,:)      
  delete (t1csall)
  delete (t1)
  
  t2csall             = f->t((/tcsi_2/),:,:,:)       ;-->H-8
  t2cs                = dim_avg_n (t2csall,0)
  t2                  = new(dimsizes(t2csall),typeof(t2csall),t2csall@_FillValue) 
  t2(0:0,:,:,:)       = (/t2cs/)          
  t2cs               := t2(0:0,:,:,:)      
  delete (t2csall)
  delete (t2)
  
  t3csall             = f->t((/tcsi_3/),:,:,:)       ;-->H-7
  t3cs                = dim_avg_n (t3csall,0)
  t3                  = new(dimsizes(t3csall),typeof(t3csall),t3csall@_FillValue) 
  t3(0:0,:,:,:)       = (/t3cs/)          
  t3cs               := t3(0:0,:,:,:)      
  delete (t3csall)
  delete (t3)
  
  t4csall             = f->t((/tcsi_4/),:,:,:)       ;-->H-7
  t4cs                = dim_avg_n (t4csall,0)
  t4                  = new(dimsizes(t4csall),typeof(t4csall),t4csall@_FillValue) 
  t4(0:0,:,:,:)       = (/t4cs/)          
  t4cs               := t4(0:0,:,:,:)      
  delete (t4csall)
  delete (t4)
  
  t5csall             = f->t((/tcsi_5/),:,:,:)       ;-->H-7
  t5cs                = dim_avg_n (t5csall,0)
  t5                  = new(dimsizes(t5csall),typeof(t5csall),t5csall@_FillValue) 
  t5(0:0,:,:,:)       = (/t5cs/)          
  t5cs               := t5(0:0,:,:,:)      
  delete (t5csall)
  delete (t5)
  
  t6csall             = f->t((/tcsi_6/),:,:,:)       ;-->H-7
  t6cs                = dim_avg_n (t6csall,0)
  t6                  = new(dimsizes(t6csall),typeof(t6csall),t6csall@_FillValue) 
  t6(0:0,:,:,:)       = (/t6cs/)          
  t6cs               := t6(0:0,:,:,:)      
  delete (t6csall)
  delete (t6)
  
  t7csall             = f->t((/tcsi_7/),:,:,:)       ;-->H-7
  t7cs                = dim_avg_n (t7csall,0)
  t7                  = new(dimsizes(t7csall),typeof(t7csall),t7csall@_FillValue) 
  t7(0:0,:,:,:)       = (/t7cs/)          
  t7cs               := t7(0:0,:,:,:)      
  delete (t7csall)
  delete (t7)
  
  t8csall             = f->t((/tcsi_8/),:,:,:)       ;-->H-7
  t8cs                = dim_avg_n (t8csall,0)
  t8                  = new(dimsizes(t8csall),typeof(t8csall),t8csall@_FillValue) 
  t8(0:0,:,:,:)       = (/t8cs/)          
  t8cs               := t8(0:0,:,:,:)      
  delete (t8csall)
  delete (t8)
  
  t9csall             = f->t((/tcsi_9/),:,:,:)       ;-->H-7
  t9cs                = dim_avg_n (t9csall,0)
  t9                  = new(dimsizes(t9csall),typeof(t9csall),t9csall@_FillValue) 
  t9(0:0,:,:,:)       = (/t9cs/)          
  t9cs               := t9(0:0,:,:,:)      
  delete (t9csall)
  delete (t9)
  
  t10csall            = f->t((/tcsi_10/),:,:,:)       ;-->H-7
  t10cs               = dim_avg_n (t10csall,0)
  t10                 = new(dimsizes(t10csall),typeof(t10csall),t10csall@_FillValue) 
  t10(0:0,:,:,:)      = (/t10cs/)          
  t10cs              := t10(0:0,:,:,:)      
  delete (t10csall)
  delete (t10)
  
  t11csall            = f->t((/tcsi_11/),:,:,:)       ;-->H-7
  t11cs               = dim_avg_n (t11csall,0)
  t11                 = new(dimsizes(t11csall),typeof(t11csall),t11csall@_FillValue) 
  t11(0:0,:,:,:)      = (/t11cs/)          
  t11cs              := t11(0:0,:,:,:)      
  delete (t11csall)
  delete (t11)
  
  t12csall            = f->t((/tcsi_12/),:,:,:)       ;-->H-7
  t12cs               = dim_avg_n (t12csall,0)
  t12                 = new(dimsizes(t12csall),typeof(t12csall),t12csall@_FillValue) 
  t12(0:0,:,:,:)      = (/t12cs/)          
  t12cs              := t12(0:0,:,:,:)      
  delete (t12csall)
  delete (t12)
  
  t13csall            = f->t((/tcsi_13/),:,:,:)       ;-->H-7
  t13cs               = dim_avg_n (t13csall,0)
  t13                 = new(dimsizes(t13csall),typeof(t13csall),t13csall@_FillValue) 
  t13(0:0,:,:,:)      = (/t13cs/)          
  t13cs              := t13(0:0,:,:,:)      
  delete (t13csall)
  delete (t13)
  
  t14csall            = f->t((/tcsi_14/),:,:,:)       ;-->H-7
  t14cs               = dim_avg_n (t14csall,0)
  t14                 = new(dimsizes(t14csall),typeof(t14csall),t14csall@_FillValue) 
  t14(0:0,:,:,:)      = (/t14cs/)          
  t14cs              := t14(0:0,:,:,:)      
  delete (t14csall)  
  delete (t14)
  
  t15csall            = f->t((/tcsi_15/),:,:,:)       ;-->H-7
  t15cs               = dim_avg_n (t15csall,0)
  t15                 = new(dimsizes(t15csall),typeof(t15csall),t15csall@_FillValue) 
  t15(0:0,:,:,:)      = (/t15cs/)          
  t15cs              := t15(0:0,:,:,:)      
  delete (t15csall)    
  delete (t15)
  
  t16csall            = f->t((/tcsi_16/),:,:,:)       ;-->H-7
  t16cs               = dim_avg_n (t16csall,0)
  t16                 = new(dimsizes(t16csall),typeof(t16csall),t16csall@_FillValue) 
  t16(0:0,:,:,:)      = (/t16cs/)          
  t16cs              := t16(0:0,:,:,:)      
  delete (t16csall)  
  delete (t16)
  
  t17csall            = f->t((/tcsi_17/),:,:,:)       ;-->H-7
  t17cs               = dim_avg_n (t17csall,0)
  t17                 = new(dimsizes(t17csall),typeof(t17csall),t17csall@_FillValue) 
  t17(0:0,:,:,:)      = (/t17cs/)          
  t17cs              := t17(0:0,:,:,:)      
  delete (t17csall)  
  delete (t17)
  
  t18csall            = f->t((/tcsi_18/),:,:,:)       ;-->H-7
  t18cs               = dim_avg_n (t18csall,0)
  t18                 = new(dimsizes(t18csall),typeof(t18csall),t18csall@_FillValue) 
  t18(0:0,:,:,:)      = (/t18cs/)          
  t18cs              := t18(0:0,:,:,:)      
  delete (t18csall)    
  delete (t18)
  
  t19csall            = f->t((/tcsi_19/),:,:,:)       ;-->H-7
  t19cs               = dim_avg_n (t19csall,0)
  t19                 = new(dimsizes(t19csall),typeof(t19csall),t19csall@_FillValue) 
  t19(0:0,:,:,:)      = (/t19cs/)          
  t19cs              := t19(0:0,:,:,:)      
  delete (t19csall)   
  delete (t19)
  
  t20csall            = f->t((/tcsi_20/),:,:,:)       ;-->H-7
  t20cs               = dim_avg_n (t20csall,0)
  t20                 = new(dimsizes(t20csall),typeof(t20csall),t20csall@_FillValue) 
  t20(0:0,:,:,:)      = (/t20cs/)          
  t20cs              := t20(0:0,:,:,:)      
  delete (t20csall)     
  delete (t20)
  
  t_1 = array_append_record(t0cs,t1cs,0)
  t_2 = array_append_record(t_1,t2cs,0)
  delete(t_1)
  t_3 = array_append_record(t_2,t3cs,0)
  delete(t_2)
  t_4 = array_append_record(t_3,t4cs,0)
  delete(t_3)
  t_5 = array_append_record(t_4,t5cs,0)
  delete(t_4)
  t_6 = array_append_record(t_5,t6cs,0)
  delete(t_5)
  t_7 = array_append_record(t_6,t7cs,0)
  delete(t_6)
  t_8 = array_append_record(t_7,t8cs,0)
  delete(t_7)
  t_9 = array_append_record(t_8,t9cs,0)
  delete(t_8)
  t_10 = array_append_record(t_9,t10cs,0)
  delete(t_9)
  t_11 = array_append_record(t_10,t11cs,0)
  delete(t_10)
  t_12 = array_append_record(t_11,t12cs,0)
  delete(t_11)
  t_13 = array_append_record(t_12,t13cs,0)
  delete(t_12)
  t_14 = array_append_record(t_13,t14cs,0)
  delete(t_13)
  t_15 = array_append_record(t_14,t15cs,0)
  delete(t_14)
  t_16 = array_append_record(t_15,t16cs,0)
  delete(t_15)
  t_17 = array_append_record(t_16,t17cs,0)
  delete(t_16)
  t_18 = array_append_record(t_17,t18cs,0)
  delete(t_17)
  t_19 = array_append_record(t_18,t19cs,0)
  delete(t_18)
  t    = array_append_record(t_19,t20cs,0)
  delete(t_19)
  
  timecs      = ispan(0,20,1)
  timecs@units = "days since 2010-01-01 00:00:0.0"
  t&time      = timecs
  t&level     = level
  t&lat       = lat
  t&lon       = lon
  t@long_name = "Temperature"
  t@units     = "degK"
  t@info      = "Filtered variable, ready to compute Q1Q2 and moisture budget"
  t@creation_date = systemfunc("date")

;-----------------------------------------
;----------U-wind-------------------------
;-----------------------------------------

  u0csall             = f->u((/tcsi_0/),:,:,:)       ;-->H-10
  u0cs                = dim_avg_n (u0csall,0)        ;-->Reratakan nilai u utk semua waktu
  u0                  = new(dimsizes(u0csall),typeof(u0csall),u0csall@_FillValue) ;-->array baru
  u0(0:0,:,:,:)       = (/u0cs/)                     ;-->Memasukkan nilai u ke array baru
  u0cs               := u0(0:0,:,:,:)                ;-->Reduksi dimensi waktu
  delete (u0csall)                                   ;-->directly delete variables for memory capacity
  delete (u0)
  u0cs!0                = "time" 
  u0cs!1                = "level"
  u0cs!2                = "lat"
  u0cs!3                = "lon"

  u1csall             = f->u((/tcsi_1/),:,:,:)       ;-->H-9
  u1cs                = dim_avg_n (u1csall,0)
  u1                  = new(dimsizes(u1csall),typeof(u1csall),u1csall@_FillValue) 
  u1(0:0,:,:,:)       = (/u1cs/)          
  u1cs               := u1(0:0,:,:,:)      
  delete (u1csall)
  delete (u1)
  
  u2csall             = f->u((/tcsi_2/),:,:,:)       ;-->H-8
  u2cs                = dim_avg_n (u2csall,0)
  u2                  = new(dimsizes(u2csall),typeof(u2csall),u2csall@_FillValue) 
  u2(0:0,:,:,:)       = (/u2cs/)          
  u2cs               := u2(0:0,:,:,:)      
  delete (u2csall)
  delete (u2)
  
  u3csall             = f->u((/tcsi_3/),:,:,:)       ;-->H-7
  u3cs                = dim_avg_n (u3csall,0)
  u3                  = new(dimsizes(u3csall),typeof(u3csall),u3csall@_FillValue) 
  u3(0:0,:,:,:)       = (/u3cs/)          
  u3cs               := u3(0:0,:,:,:)      
  delete (u3csall)
  delete (u3)
  
  u4csall             = f->u((/tcsi_4/),:,:,:)       ;-->H-7
  u4cs                = dim_avg_n (u4csall,0)
  u4                  = new(dimsizes(u4csall),typeof(u4csall),u4csall@_FillValue) 
  u4(0:0,:,:,:)       = (/u4cs/)          
  u4cs               := u4(0:0,:,:,:)      
  delete (u4csall)
  delete (u4)
  
  u5csall             = f->u((/tcsi_5/),:,:,:)       ;-->H-7
  u5cs                = dim_avg_n (u5csall,0)
  u5                  = new(dimsizes(u5csall),typeof(u5csall),u5csall@_FillValue) 
  u5(0:0,:,:,:)       = (/u5cs/)          
  u5cs               := u5(0:0,:,:,:)      
  delete (u5csall)
  delete (u5)
  
  u6csall             = f->u((/tcsi_6/),:,:,:)       ;-->H-7
  u6cs                = dim_avg_n (u6csall,0)
  u6                  = new(dimsizes(u6csall),typeof(u6csall),u6csall@_FillValue) 
  u6(0:0,:,:,:)       = (/u6cs/)          
  u6cs               := u6(0:0,:,:,:)      
  delete (u6csall)
  delete (u6)
  
  u7csall             = f->u((/tcsi_7/),:,:,:)       ;-->H-7
  u7cs                = dim_avg_n (u7csall,0)
  u7                  = new(dimsizes(u7csall),typeof(u7csall),u7csall@_FillValue) 
  u7(0:0,:,:,:)       = (/u7cs/)          
  u7cs               := u7(0:0,:,:,:)      
  delete (u7csall)
  delete (u7)
  
  u8csall             = f->u((/tcsi_8/),:,:,:)       ;-->H-7
  u8cs                = dim_avg_n (u8csall,0)
  u8                  = new(dimsizes(u8csall),typeof(u8csall),u8csall@_FillValue) 
  u8(0:0,:,:,:)       = (/u8cs/)          
  u8cs               := u8(0:0,:,:,:)      
  delete (u8csall)
  delete (u8)
  
  u9csall             = f->u((/tcsi_9/),:,:,:)       ;-->H-7
  u9cs                = dim_avg_n (u9csall,0)
  u9                  = new(dimsizes(u9csall),typeof(u9csall),u9csall@_FillValue) 
  u9(0:0,:,:,:)       = (/u9cs/)          
  u9cs               := u9(0:0,:,:,:)      
  delete (u9csall)
  delete (u9)
  
  u10csall            = f->u((/tcsi_10/),:,:,:)       ;-->H-7
  u10cs               = dim_avg_n (u10csall,0)
  u10                 = new(dimsizes(u10csall),typeof(u10csall),u10csall@_FillValue) 
  u10(0:0,:,:,:)      = (/u10cs/)          
  u10cs              := u10(0:0,:,:,:)      
  delete (u10csall)
  delete (u10)
  
  u11csall            = f->u((/tcsi_11/),:,:,:)       ;-->H-7
  u11cs               = dim_avg_n (u11csall,0)
  u11                 = new(dimsizes(u11csall),typeof(u11csall),u11csall@_FillValue) 
  u11(0:0,:,:,:)      = (/u11cs/)          
  u11cs              := u11(0:0,:,:,:)      
  delete (u11csall)
  delete (u11)
  
  u12csall            = f->u((/tcsi_12/),:,:,:)       ;-->H-7
  u12cs               = dim_avg_n (u12csall,0)
  u12                 = new(dimsizes(u12csall),typeof(u12csall),u12csall@_FillValue) 
  u12(0:0,:,:,:)      = (/u12cs/)          
  u12cs              := u12(0:0,:,:,:)      
  delete (u12csall)
  delete (u12)
  
  u13csall            = f->u((/tcsi_13/),:,:,:)       ;-->H-7
  u13cs               = dim_avg_n (u13csall,0)
  u13                 = new(dimsizes(u13csall),typeof(u13csall),u13csall@_FillValue) 
  u13(0:0,:,:,:)      = (/u13cs/)          
  u13cs              := u13(0:0,:,:,:)      
  delete (u13csall)
  delete (u13)
  
  u14csall            = f->u((/tcsi_14/),:,:,:)       ;-->H-7
  u14cs               = dim_avg_n (u14csall,0)
  u14                 = new(dimsizes(u14csall),typeof(u14csall),u14csall@_FillValue) 
  u14(0:0,:,:,:)      = (/u14cs/)          
  u14cs              := u14(0:0,:,:,:)      
  delete (u14csall)  
  delete (u14)
  
  u15csall            = f->u((/tcsi_15/),:,:,:)       ;-->H-7
  u15cs               = dim_avg_n (u15csall,0)
  u15                 = new(dimsizes(u15csall),typeof(u15csall),u15csall@_FillValue) 
  u15(0:0,:,:,:)      = (/u15cs/)          
  u15cs              := u15(0:0,:,:,:)      
  delete (u15csall)    
  delete (u15)
  
  u16csall            = f->u((/tcsi_16/),:,:,:)       ;-->H-7
  u16cs               = dim_avg_n (u16csall,0)
  u16                 = new(dimsizes(u16csall),typeof(u16csall),u16csall@_FillValue) 
  u16(0:0,:,:,:)      = (/u16cs/)          
  u16cs              := u16(0:0,:,:,:)      
  delete (u16csall)  
  delete (u16)
  
  u17csall            = f->u((/tcsi_17/),:,:,:)       ;-->H-7
  u17cs               = dim_avg_n (u17csall,0)
  u17                 = new(dimsizes(u17csall),typeof(u17csall),u17csall@_FillValue) 
  u17(0:0,:,:,:)      = (/u17cs/)          
  u17cs              := u17(0:0,:,:,:)      
  delete (u17csall)  
  delete (u17)
  
  u18csall            = f->u((/tcsi_18/),:,:,:)       ;-->H-7
  u18cs               = dim_avg_n (u18csall,0)
  u18                 = new(dimsizes(u18csall),typeof(u18csall),u18csall@_FillValue) 
  u18(0:0,:,:,:)      = (/u18cs/)          
  u18cs              := u18(0:0,:,:,:)      
  delete (u18csall)    
  delete (u18)
  
  u19csall            = f->u((/tcsi_19/),:,:,:)       ;-->H-7
  u19cs               = dim_avg_n (u19csall,0)
  u19                 = new(dimsizes(u19csall),typeof(u19csall),u19csall@_FillValue) 
  u19(0:0,:,:,:)      = (/u19cs/)          
  u19cs              := u19(0:0,:,:,:)      
  delete (u19csall)   
  delete (u19)
  
  u20csall            = f->u((/tcsi_20/),:,:,:)       ;-->H-7
  u20cs               = dim_avg_n (u20csall,0)
  u20                 = new(dimsizes(u20csall),typeof(u20csall),u20csall@_FillValue) 
  u20(0:0,:,:,:)      = (/u20cs/)          
  u20cs              := u20(0:0,:,:,:)      
  delete (u20csall)     
  delete (u20)
  
  u_1 = array_append_record(u0cs,u1cs,0)
  u_2 = array_append_record(u_1,u2cs,0)
  delete(u_1)
  u_3 = array_append_record(u_2,u3cs,0)
  delete(u_2)
  u_4 = array_append_record(u_3,u4cs,0)
  delete(u_3)
  u_5 = array_append_record(u_4,u5cs,0)
  delete(u_4)
  u_6 = array_append_record(u_5,u6cs,0)
  delete(u_5)
  u_7 = array_append_record(u_6,u7cs,0)
  delete(u_6)
  u_8 = array_append_record(u_7,u8cs,0)
  delete(u_7)
  u_9 = array_append_record(u_8,u9cs,0)
  delete(u_8)
  u_10 = array_append_record(u_9,u10cs,0)
  delete(u_9)
  u_11 = array_append_record(u_10,u11cs,0)
  delete(u_10)
  u_12 = array_append_record(u_11,u12cs,0)
  delete(u_11)
  u_13 = array_append_record(u_12,u13cs,0)
  delete(u_12)
  u_14 = array_append_record(u_13,u14cs,0)
  delete(u_13)
  u_15 = array_append_record(u_14,u15cs,0)
  delete(u_14)
  u_16 = array_append_record(u_15,u16cs,0)
  delete(u_15)
  u_17 = array_append_record(u_16,u17cs,0)
  delete(u_16)
  u_18 = array_append_record(u_17,u18cs,0)
  delete(u_17)
  u_19 = array_append_record(u_18,u19cs,0)
  delete(u_18)
  u    = array_append_record(u_19,u20cs,0)
  delete(u_19)
  
  timecs      = ispan(0,20,1)
  timecs@units = "days since 2010-01-01 00:00:0.0"
  u&time      = timecs
  u&level     = level
  u&lat       = lat
  u&lon       = lon
  u@long_name = "Zonal wind (u-wind)"
  u@units     = "m/s"
  u@info      = "Filtered variable, ready to compute Q1Q2 and moisture budget"
  u@creation_date = systemfunc("date")
  
;-------------------------------------------
;----------Meridional wind-------------------------
;-------------------------------------------- 

  v0csall             = f->v((/tcsi_0/),:,:,:)       ;-->H-10
  v0cs                = dim_avg_n (v0csall,0)        ;-->Reratakan nilai v utk semua waktu
  v0                  = new(dimsizes(v0csall),typeof(v0csall),v0csall@_FillValue) ;-->array baru
  v0(0:0,:,:,:)       = (/v0cs/)                     ;-->Memasukkan nilai v ke array baru
  v0cs               := v0(0:0,:,:,:)                ;-->Reduksi dimensi waktu
  delete (v0csall)                                   ;-->directly delete variables for memory capacity
  delete (v0)
  v0cs!0                = "time" 
  v0cs!1                = "level"
  v0cs!2                = "lat"
  v0cs!3                = "lon"

  v1csall             = f->v((/tcsi_1/),:,:,:)       ;-->H-9
  v1cs                = dim_avg_n (v1csall,0)
  v1                  = new(dimsizes(v1csall),typeof(v1csall),v1csall@_FillValue) 
  v1(0:0,:,:,:)       = (/v1cs/)          
  v1cs               := v1(0:0,:,:,:)      
  delete (v1csall)
  delete (v1)
  
  v2csall             = f->v((/tcsi_2/),:,:,:)       ;-->H-8
  v2cs                = dim_avg_n (v2csall,0)
  v2                  = new(dimsizes(v2csall),typeof(v2csall),v2csall@_FillValue) 
  v2(0:0,:,:,:)       = (/v2cs/)          
  v2cs               := v2(0:0,:,:,:)      
  delete (v2csall)
  delete (v2)
  
  v3csall             = f->v((/tcsi_3/),:,:,:)       ;-->H-7
  v3cs                = dim_avg_n (v3csall,0)
  v3                  = new(dimsizes(v3csall),typeof(v3csall),v3csall@_FillValue) 
  v3(0:0,:,:,:)       = (/v3cs/)          
  v3cs               := v3(0:0,:,:,:)      
  delete (v3csall)
  delete (v3)
  
  v4csall             = f->v((/tcsi_4/),:,:,:)       ;-->H-7
  v4cs                = dim_avg_n (v4csall,0)
  v4                  = new(dimsizes(v4csall),typeof(v4csall),v4csall@_FillValue) 
  v4(0:0,:,:,:)       = (/v4cs/)          
  v4cs               := v4(0:0,:,:,:)      
  delete (v4csall)
  delete (v4)
  
  v5csall             = f->v((/tcsi_5/),:,:,:)       ;-->H-7
  v5cs                = dim_avg_n (v5csall,0)
  v5                  = new(dimsizes(v5csall),typeof(v5csall),v5csall@_FillValue) 
  v5(0:0,:,:,:)       = (/v5cs/)          
  v5cs               := v5(0:0,:,:,:)      
  delete (v5csall)
  delete (v5)
  
  v6csall             = f->v((/tcsi_6/),:,:,:)       ;-->H-7
  v6cs                = dim_avg_n (v6csall,0)
  v6                  = new(dimsizes(v6csall),typeof(v6csall),v6csall@_FillValue) 
  v6(0:0,:,:,:)       = (/v6cs/)          
  v6cs               := v6(0:0,:,:,:)      
  delete (v6csall)
  delete (v6)
  
  v7csall             = f->v((/tcsi_7/),:,:,:)       ;-->H-7
  v7cs                = dim_avg_n (v7csall,0)
  v7                  = new(dimsizes(v7csall),typeof(v7csall),v7csall@_FillValue) 
  v7(0:0,:,:,:)       = (/v7cs/)          
  v7cs               := v7(0:0,:,:,:)      
  delete (v7csall)
  delete (v7)
  
  v8csall             = f->v((/tcsi_8/),:,:,:)       ;-->H-7
  v8cs                = dim_avg_n (v8csall,0)
  v8                  = new(dimsizes(v8csall),typeof(v8csall),v8csall@_FillValue) 
  v8(0:0,:,:,:)       = (/v8cs/)          
  v8cs               := v8(0:0,:,:,:)      
  delete (v8csall)
  delete (v8)
  
  v9csall             = f->v((/tcsi_9/),:,:,:)       ;-->H-7
  v9cs                = dim_avg_n (v9csall,0)
  v9                  = new(dimsizes(v9csall),typeof(v9csall),v9csall@_FillValue) 
  v9(0:0,:,:,:)       = (/v9cs/)          
  v9cs               := v9(0:0,:,:,:)      
  delete (v9csall)
  delete (v9)
  
  v10csall            = f->v((/tcsi_10/),:,:,:)       ;-->H-7
  v10cs               = dim_avg_n (v10csall,0)
  v10                 = new(dimsizes(v10csall),typeof(v10csall),v10csall@_FillValue) 
  v10(0:0,:,:,:)      = (/v10cs/)          
  v10cs              := v10(0:0,:,:,:)      
  delete (v10csall)
  delete (v10)
  
  v11csall            = f->v((/tcsi_11/),:,:,:)       ;-->H-7
  v11cs               = dim_avg_n (v11csall,0)
  v11                 = new(dimsizes(v11csall),typeof(v11csall),v11csall@_FillValue) 
  v11(0:0,:,:,:)      = (/v11cs/)          
  v11cs              := v11(0:0,:,:,:)      
  delete (v11csall)
  delete (v11)
  
  v12csall            = f->v((/tcsi_12/),:,:,:)       ;-->H-7
  v12cs               = dim_avg_n (v12csall,0)
  v12                 = new(dimsizes(v12csall),typeof(v12csall),v12csall@_FillValue) 
  v12(0:0,:,:,:)      = (/v12cs/)          
  v12cs              := v12(0:0,:,:,:)      
  delete (v12csall)
  delete (v12)
  
  v13csall            = f->v((/tcsi_13/),:,:,:)       ;-->H-7
  v13cs               = dim_avg_n (v13csall,0)
  v13                 = new(dimsizes(v13csall),typeof(v13csall),v13csall@_FillValue) 
  v13(0:0,:,:,:)      = (/v13cs/)          
  v13cs              := v13(0:0,:,:,:)      
  delete (v13csall)
  delete (v13)
  
  v14csall            = f->v((/tcsi_14/),:,:,:)       ;-->H-7
  v14cs               = dim_avg_n (v14csall,0)
  v14                 = new(dimsizes(v14csall),typeof(v14csall),v14csall@_FillValue) 
  v14(0:0,:,:,:)      = (/v14cs/)          
  v14cs              := v14(0:0,:,:,:)      
  delete (v14csall)  
  delete (v14)
  
  v15csall            = f->v((/tcsi_15/),:,:,:)       ;-->H-7
  v15cs               = dim_avg_n (v15csall,0)
  v15                 = new(dimsizes(v15csall),typeof(v15csall),v15csall@_FillValue) 
  v15(0:0,:,:,:)      = (/v15cs/)          
  v15cs              := v15(0:0,:,:,:)      
  delete (v15csall)    
  delete (v15)
  
  v16csall            = f->v((/tcsi_16/),:,:,:)       ;-->H-7
  v16cs               = dim_avg_n (v16csall,0)
  v16                 = new(dimsizes(v16csall),typeof(v16csall),v16csall@_FillValue) 
  v16(0:0,:,:,:)      = (/v16cs/)          
  v16cs              := v16(0:0,:,:,:)      
  delete (v16csall)  
  delete (v16)
  
  v17csall            = f->v((/tcsi_17/),:,:,:)       ;-->H-7
  v17cs               = dim_avg_n (v17csall,0)
  v17                 = new(dimsizes(v17csall),typeof(v17csall),v17csall@_FillValue) 
  v17(0:0,:,:,:)      = (/v17cs/)          
  v17cs              := v17(0:0,:,:,:)      
  delete (v17csall)  
  delete (v17)
  
  v18csall            = f->v((/tcsi_18/),:,:,:)       ;-->H-7
  v18cs               = dim_avg_n (v18csall,0)
  v18                 = new(dimsizes(v18csall),typeof(v18csall),v18csall@_FillValue) 
  v18(0:0,:,:,:)      = (/v18cs/)          
  v18cs              := v18(0:0,:,:,:)      
  delete (v18csall)    
  delete (v18)
  
  v19csall            = f->v((/tcsi_19/),:,:,:)       ;-->H-7
  v19cs               = dim_avg_n (v19csall,0)
  v19                 = new(dimsizes(v19csall),typeof(v19csall),v19csall@_FillValue) 
  v19(0:0,:,:,:)      = (/v19cs/)          
  v19cs              := v19(0:0,:,:,:)      
  delete (v19csall)   
  delete (v19)
  
  v20csall            = f->v((/tcsi_20/),:,:,:)       ;-->H-7
  v20cs               = dim_avg_n (v20csall,0)
  v20                 = new(dimsizes(v20csall),typeof(v20csall),v20csall@_FillValue) 
  v20(0:0,:,:,:)      = (/v20cs/)          
  v20cs              := v20(0:0,:,:,:)      
  delete (v20csall)     
  delete (v20)
  
  v_1 = array_append_record(v0cs,v1cs,0)
  v_2 = array_append_record(v_1,v2cs,0)
  delete(v_1)
  v_3 = array_append_record(v_2,v3cs,0)
  delete(v_2)
  v_4 = array_append_record(v_3,v4cs,0)
  delete(v_3)
  v_5 = array_append_record(v_4,v5cs,0)
  delete(v_4)
  v_6 = array_append_record(v_5,v6cs,0)
  delete(v_5)
  v_7 = array_append_record(v_6,v7cs,0)
  delete(v_6)
  v_8 = array_append_record(v_7,v8cs,0)
  delete(v_7)
  v_9 = array_append_record(v_8,v9cs,0)
  delete(v_8)
  v_10 = array_append_record(v_9,v10cs,0)
  delete(v_9)
  v_11 = array_append_record(v_10,v11cs,0)
  delete(v_10)
  v_12 = array_append_record(v_11,v12cs,0)
  delete(v_11)
  v_13 = array_append_record(v_12,v13cs,0)
  delete(v_12)
  v_14 = array_append_record(v_13,v14cs,0)
  delete(v_13)
  v_15 = array_append_record(v_14,v15cs,0)
  delete(v_14)
  v_16 = array_append_record(v_15,v16cs,0)
  delete(v_15)
  v_17 = array_append_record(v_16,v17cs,0)
  delete(v_16)
  v_18 = array_append_record(v_17,v18cs,0)
  delete(v_17)
  v_19 = array_append_record(v_18,v19cs,0)
  delete(v_18)
  v    = array_append_record(v_19,v20cs,0)
  delete(v_19)
  
  timecs      = ispan(0,20,1)
  timecs@units = "days since 2010-01-01 00:00:0.0"
  v&time      = timecs
  v&level     = level
  v&lat       = lat
  v&lon       = lon
  v@long_name = "Meridional wind (v-wind)"
  v@units     = "m/s"
  v@info      = "Filtered variable, ready to compute Q1Q2 and moisture budget"
  v@creation_date = systemfunc("date")

;------------------------------------
;----------Vertical velocity---------
;------------------------------------

  w0csall             = f->w((/tcsi_0/),:,:,:)       ;-->H-10
  w0cs                = dim_avg_n (w0csall,0)        ;-->Reratakan nilai w utk semua waktu
  w0                  = new(dimsizes(w0csall),typeof(w0csall),w0csall@_FillValue) ;-->array baru
  w0(0:0,:,:,:)       = (/w0cs/)                     ;-->Memasukkan nilai w ke array baru
  w0cs               := w0(0:0,:,:,:)                ;-->Reduksi dimensi waktu
  delete (w0csall)                                   ;-->directly delete variables for memory capacity
  delete (w0)
  w0cs!0                = "time" 
  w0cs!1                = "level"
  w0cs!2                = "lat"
  w0cs!3                = "lon"

  w1csall             = f->w((/tcsi_1/),:,:,:)       ;-->H-9
  w1cs                = dim_avg_n (w1csall,0)
  w1                  = new(dimsizes(w1csall),typeof(w1csall),w1csall@_FillValue) 
  w1(0:0,:,:,:)       = (/w1cs/)          
  w1cs               := w1(0:0,:,:,:)      
  delete (w1csall)
  delete (w1)
  
  w2csall             = f->w((/tcsi_2/),:,:,:)       ;-->H-8
  w2cs                = dim_avg_n (w2csall,0)
  w2                  = new(dimsizes(w2csall),typeof(w2csall),w2csall@_FillValue) 
  w2(0:0,:,:,:)       = (/w2cs/)          
  w2cs               := w2(0:0,:,:,:)      
  delete (w2csall)
  delete (w2)
  
  w3csall             = f->w((/tcsi_3/),:,:,:)       ;-->H-7
  w3cs                = dim_avg_n (w3csall,0)
  w3                  = new(dimsizes(w3csall),typeof(w3csall),w3csall@_FillValue) 
  w3(0:0,:,:,:)       = (/w3cs/)          
  w3cs               := w3(0:0,:,:,:)      
  delete (w3csall)
  delete (w3)
  
  w4csall             = f->w((/tcsi_4/),:,:,:)       ;-->H-7
  w4cs                = dim_avg_n (w4csall,0)
  w4                  = new(dimsizes(w4csall),typeof(w4csall),w4csall@_FillValue) 
  w4(0:0,:,:,:)       = (/w4cs/)          
  w4cs               := w4(0:0,:,:,:)      
  delete (w4csall)
  delete (w4)
  
  w5csall             = f->w((/tcsi_5/),:,:,:)       ;-->H-7
  w5cs                = dim_avg_n (w5csall,0)
  w5                  = new(dimsizes(w5csall),typeof(w5csall),w5csall@_FillValue) 
  w5(0:0,:,:,:)       = (/w5cs/)          
  w5cs               := w5(0:0,:,:,:)      
  delete (w5csall)
  delete (w5)
  
  w6csall             = f->w((/tcsi_6/),:,:,:)       ;-->H-7
  w6cs                = dim_avg_n (w6csall,0)
  w6                  = new(dimsizes(w6csall),typeof(w6csall),w6csall@_FillValue) 
  w6(0:0,:,:,:)       = (/w6cs/)          
  w6cs               := w6(0:0,:,:,:)      
  delete (w6csall)
  delete (w6)
  
  w7csall             = f->w((/tcsi_7/),:,:,:)       ;-->H-7
  w7cs                = dim_avg_n (w7csall,0)
  w7                  = new(dimsizes(w7csall),typeof(w7csall),w7csall@_FillValue) 
  w7(0:0,:,:,:)       = (/w7cs/)          
  w7cs               := w7(0:0,:,:,:)      
  delete (w7csall)
  delete (w7)
  
  w8csall             = f->w((/tcsi_8/),:,:,:)       ;-->H-7
  w8cs                = dim_avg_n (w8csall,0)
  w8                  = new(dimsizes(w8csall),typeof(w8csall),w8csall@_FillValue) 
  w8(0:0,:,:,:)       = (/w8cs/)          
  w8cs               := w8(0:0,:,:,:)      
  delete (w8csall)
  delete (w8)
  
  w9csall             = f->w((/tcsi_9/),:,:,:)       ;-->H-7
  w9cs                = dim_avg_n (w9csall,0)
  w9                  = new(dimsizes(w9csall),typeof(w9csall),w9csall@_FillValue) 
  w9(0:0,:,:,:)       = (/w9cs/)          
  w9cs               := w9(0:0,:,:,:)      
  delete (w9csall)
  delete (w9)
  
  w10csall            = f->w((/tcsi_10/),:,:,:)       ;-->H-7
  w10cs               = dim_avg_n (w10csall,0)
  w10                 = new(dimsizes(w10csall),typeof(w10csall),w10csall@_FillValue) 
  w10(0:0,:,:,:)      = (/w10cs/)          
  w10cs              := w10(0:0,:,:,:)      
  delete (w10csall)
  delete (w10)
  
  w11csall            = f->w((/tcsi_11/),:,:,:)       ;-->H-7
  w11cs               = dim_avg_n (w11csall,0)
  w11                 = new(dimsizes(w11csall),typeof(w11csall),w11csall@_FillValue) 
  w11(0:0,:,:,:)      = (/w11cs/)          
  w11cs              := w11(0:0,:,:,:)      
  delete (w11csall)
  delete (w11)
  
  w12csall            = f->w((/tcsi_12/),:,:,:)       ;-->H-7
  w12cs               = dim_avg_n (w12csall,0)
  w12                 = new(dimsizes(w12csall),typeof(w12csall),w12csall@_FillValue) 
  w12(0:0,:,:,:)      = (/w12cs/)          
  w12cs              := w12(0:0,:,:,:)      
  delete (w12csall)
  delete (w12)
  
  w13csall            = f->w((/tcsi_13/),:,:,:)       ;-->H-7
  w13cs               = dim_avg_n (w13csall,0)
  w13                 = new(dimsizes(w13csall),typeof(w13csall),w13csall@_FillValue) 
  w13(0:0,:,:,:)      = (/w13cs/)          
  w13cs              := w13(0:0,:,:,:)      
  delete (w13csall)
  delete (w13)
  
  w14csall            = f->w((/tcsi_14/),:,:,:)       ;-->H-7
  w14cs               = dim_avg_n (w14csall,0)
  w14                 = new(dimsizes(w14csall),typeof(w14csall),w14csall@_FillValue) 
  w14(0:0,:,:,:)      = (/w14cs/)          
  w14cs              := w14(0:0,:,:,:)      
  delete (w14csall)  
  delete (w14)
  
  w15csall            = f->w((/tcsi_15/),:,:,:)       ;-->H-7
  w15cs               = dim_avg_n (w15csall,0)
  w15                 = new(dimsizes(w15csall),typeof(w15csall),w15csall@_FillValue) 
  w15(0:0,:,:,:)      = (/w15cs/)          
  w15cs              := w15(0:0,:,:,:)      
  delete (w15csall)    
  delete (w15)
  
  w16csall            = f->w((/tcsi_16/),:,:,:)       ;-->H-7
  w16cs               = dim_avg_n (w16csall,0)
  w16                 = new(dimsizes(w16csall),typeof(w16csall),w16csall@_FillValue) 
  w16(0:0,:,:,:)      = (/w16cs/)          
  w16cs              := w16(0:0,:,:,:)      
  delete (w16csall)  
  delete (w16)
  
  w17csall            = f->w((/tcsi_17/),:,:,:)       ;-->H-7
  w17cs               = dim_avg_n (w17csall,0)
  w17                 = new(dimsizes(w17csall),typeof(w17csall),w17csall@_FillValue) 
  w17(0:0,:,:,:)      = (/w17cs/)          
  w17cs              := w17(0:0,:,:,:)      
  delete (w17csall)  
  delete (w17)
  
  w18csall            = f->w((/tcsi_18/),:,:,:)       ;-->H-7
  w18cs               = dim_avg_n (w18csall,0)
  w18                 = new(dimsizes(w18csall),typeof(w18csall),w18csall@_FillValue) 
  w18(0:0,:,:,:)      = (/w18cs/)          
  w18cs              := w18(0:0,:,:,:)      
  delete (w18csall)    
  delete (w18)
  
  w19csall            = f->w((/tcsi_19/),:,:,:)       ;-->H-7
  w19cs               = dim_avg_n (w19csall,0)
  w19                 = new(dimsizes(w19csall),typeof(w19csall),w19csall@_FillValue) 
  w19(0:0,:,:,:)      = (/w19cs/)          
  w19cs              := w19(0:0,:,:,:)      
  delete (w19csall)   
  delete (w19)
  
  w20csall            = f->w((/tcsi_20/),:,:,:)       ;-->H-7
  w20cs               = dim_avg_n (w20csall,0)
  w20                 = new(dimsizes(w20csall),typeof(w20csall),w20csall@_FillValue) 
  w20(0:0,:,:,:)      = (/w20cs/)          
  w20cs              := w20(0:0,:,:,:)      
  delete (w20csall)     
  delete (w20)
  
  w_1 = array_append_record(w0cs,w1cs,0)
  w_2 = array_append_record(w_1,w2cs,0)
  delete(w_1)
  w_3 = array_append_record(w_2,w3cs,0)
  delete(w_2)
  w_4 = array_append_record(w_3,w4cs,0)
  delete(w_3)
  w_5 = array_append_record(w_4,w5cs,0)
  delete(w_4)
  w_6 = array_append_record(w_5,w6cs,0)
  delete(w_5)
  w_7 = array_append_record(w_6,w7cs,0)
  delete(w_6)
  w_8 = array_append_record(w_7,w8cs,0)
  delete(w_7)
  w_9 = array_append_record(w_8,w9cs,0)
  delete(w_8)
  w_10 = array_append_record(w_9,w10cs,0)
  delete(w_9)
  w_11 = array_append_record(w_10,w11cs,0)
  delete(w_10)
  w_12 = array_append_record(w_11,w12cs,0)
  delete(w_11)
  w_13 = array_append_record(w_12,w13cs,0)
  delete(w_12)
  w_14 = array_append_record(w_13,w14cs,0)
  delete(w_13)
  w_15 = array_append_record(w_14,w15cs,0)
  delete(w_14)
  w_16 = array_append_record(w_15,w16cs,0)
  delete(w_15)
  w_17 = array_append_record(w_16,w17cs,0)
  delete(w_16)
  w_18 = array_append_record(w_17,w18cs,0)
  delete(w_17)
  w_19 = array_append_record(w_18,w19cs,0)
  delete(w_18)
  w    = array_append_record(w_19,w20cs,0)
  delete(w_19)
  
  timecs      = ispan(0,20,1)
  timecs@units = "days since 2010-01-01 00:00:0.0"
  w&time      = timecs
  w&level     = level
  w&lat       = lat
  w&lon       = lon
  w@long_name = "Vertical velocity"
  w@units     = "Pa/s"
  w@info      = "Filtered variable, ready to compute Q1Q2 and moisture budget"
  w@creation_date = systemfunc("date")
  
;-------------------------------------------------------------------------------------------;
;----------write output file----------------------------------------------------------------;
;-------------------------------------------------------------------------------------------;

;  field_names = (/ xcs_avg@long_name + " ",\
;                   xces_avg@long_name + " ",\
; 				   lpfcs@long_name + " ",\
; 				   lpfces@long_name + " " /)  
	
;  header = [/str_join(field_names,",")/]
  
;  system("rm " + "filter.nc")     					    ; remove any pre-existing file
;  out = addfile("filter.nc","c")  					    ; open netCDF file
;  
;  system("rm " + "filter.csv")
;  write_table("filter.csv","w",header, "%s")		    ; remove any pre-existing file
;  alist  = [/xcs_avg, xces_avg, lpfcs, lpfces/]		; list berisi list masing-masing indeks
;  format = "%g,%g,%g,%g"
;  write_table("filter.csv", "a", alist, format)
;  out->xcs_avg = xcs_avg
;  out->xces_avg = xces_avg
;  out->lpfcs = lpfcs
;  out->lpfces = lpfces

   
  system("rm " + "q.nc")     ; remove any pre-existing file
  foutq = addfile("q.nc","c")
  foutq@title = "Preliminary data processing"
  foutq@creation_date = systemfunc("date")
  foutq->q = q
  print(foutq)
  
  system("rm " + "t.nc")     ; remove any pre-existing file
  foutt = addfile("t.nc","c")
  foutt@title = "Preliminary data processing"
  foutt@creation_date = systemfunc("date")
  foutt->t = t
  print(foutt)

  system("rm " + "u.nc")     ; remove any pre-existing file
  foutu = addfile("u.nc","c")
  foutu@title = "Preliminary data processing"
  foutu@creation_date = systemfunc("date")
  foutu->u = u
  print(foutu)
  
  system("rm " + "v.nc")     ; remove any pre-existing file
  foutv = addfile("v.nc","c")
  foutv@title = "Preliminary data processing"
  foutv@creation_date = systemfunc("date")
  foutv->v = v
  print(foutv)

  system("rm " + "w.nc")     ; remove any pre-existing file
  foutw = addfile("w.nc","c")
  foutw@title = "Preliminary data processing"
  foutw@creation_date = systemfunc("date")
  foutw->w = w
  print(foutw)  
; if( a(i) .eq. a@_FillValue) then

