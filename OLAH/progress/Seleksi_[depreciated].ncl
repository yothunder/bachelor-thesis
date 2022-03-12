;===========================================================================================;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;																							;
; Progres_v1.1 - first time writing code => Wednesday, 5 Jan 2021 - 14.57 WIB (07.57 UTC)  ;
; 																							;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;===========================================================================================;
; Note : This script is not used, see the Progres_v1.2
;===========================================================================================;
;;------------------------------------------------------------------------------------------:
;	  Cold surge and cross equatorial surge identification : use function for conveniece	;
;;------------------------------------------------------------------------------------------:
;===========================================================================================;
																							;
undef("variable_selection")																	;
function variable_selection(f,time[*]:numeric,ntime,xcs,q,treshold)								;
begin
																							;
;-for cs index---																			;
;  xcs               = f->v(:,{level},{lat1:lat2},{lon1:lon2}) ; convert data type from short to float (https://www.ncl.ucar.edu/Document/Functions/type_convert.shtml)
  xcs_avg           = wgt_areaave(xcs, 1.0, 1.0, 1) ; area average meridional wind for cs index
;  xcs_avg@long_name = "areal avg v-wind for cs"												;
																							;
;-for ces index---																			;
;  xces               = f->v(:,{level},{lat1:latNces},{lonLces:lonRces}) ; convert data type from short to float (https://www.ncl.ucar.edu/Document/Functions/type_convert.shtml)
;  xces_avg           = wgt_areaave(xces, 1.0, 1.0, 1) ; area average meridional wind for cs index
;  xces_avg@long_name = "areal avg v-wind for ces"											;
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
  xcs_runningunsmoothed  = runave_n(xcs_avg,6,0,0) ;---> Ini yang dipakai filter 6 harian	;
;  xces_runningunsmoothed = runave_n(xces_avg,4,0,0) ;---> Ini yang dipakai filter 4 harian	;
																							;
;---Remove the first and the last ten days. Fill with missing value---						;
																							;
  do i = 0, 9																				;
    xcs_runningunsmoothed(i) = -32767														;
	;xces_runningunsmoothed(i) = -32767														;
  end do																					;
  do i = ntime-10, ntime-1																	;
    xcs_runningunsmoothed(i) = -32767														;
	;xces_runningunsmoothed(i) = -32767														;
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
  cs    = treshold ; index treshold for cs
;  ces	= -5 ; index treshold for ces

;---create an array index for cs and ces---

  csi  = ind(.not.ismissing(xcs_runningunsmoothed) .and. xcs_runningunsmoothed.le.cs)
;  cesi  = ind(.not.ismissing(xces_runningunsmoothed) .and. xces_runningunsmoothed.le.ces)

;---Index selection for lead-lag or time lag analysis---
  
  x = ispan (0,ntime,1) ; array for time selection
  if (.not.all(ismissing(csi)) .and. .not.all(ismissing(x))) then
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
  end if
  
  
;  printVarSummary(tcsi)																	;
;  print(xcs_runningunsmoothed) 																;
;  print(x)
  print("List Tanggal kejadian CS")															;
  print("Tanggal   H-10   H0   H+10")														;
  print(tcstime+"   "+tcsi_0+"     "+tcsi_10+"   "+tcsi_20)													;
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
  printVarSummary(q19cs)
  
  q20csall            = f->q((/tcsi_20/),:,:,:)       ;-->H-7
  q20cs               = dim_avg_n (q20csall,0)
  q20                 = new(dimsizes(q20csall),typeof(q20csall),q20csall@_FillValue) 
  q20(0:0,:,:,:)      = (/q20cs/)          
  q20cs              := q20(0:0,:,:,:)      
  delete (q20csall)     
  delete (q20)
  printVarSummary(q20cs)
  
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
  printVarSummary(q_18)
  q_19 = array_append_record(q_18,q19cs,0)
  delete(q_18)
  printVarSummary(q_19)
  qall = array_append_record(q_19,q20cs,0)
  delete(q_19)
  
  timecs      = ispan(0,20,1)
  timecs@units = "days since 2010-01-01 00:00:0.0"
  qall&time      = timecs
;  qall&level     = level
;  qall&lat       = lat
;  qall&lon       = lon
  qall@info      = "Filtered variable, ready to compute Q1Q2 and moisture budget"
  qall@creation_date = systemfunc("date")
  
  printVarSummary(qall)
;  printMinMax(q,1)
;  printVarSummary(q0cs)
;  printMinMax(q0cs,1)
;  printVarSummary(q1cs)
;  printMinMax(q1cs,1)


  return( [/qall/] )
end

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

;===========================================================================================;
;;------------------------------------------------------------------------------------------:
;                                         MAIN CODE											;
;;------------------------------------------------------------------------------------------:
;===========================================================================================;

  netCDF  = True                                       ; Write netCDF 

;---Import file---																			;
																							;
  f      = addfile("daymean_20102020.nc","r" ) ; import file, "r" means just for "read"			;
  time1  = f->time																			;
  time   = cd_calendar(time1,-2) ; Human readable (https://www.ncl.ucar.edu/Document/Functions/date.shtml)
  ntime  = dimsizes(time)																	;
; yrfrac = yyyymmdd_to_yyyyfrac(time(:),0)													;
; print(ntime)																				;

;  level = f->level
;  lat   = f->latitude
;  lon   = f->longitude
  xcs   = f->v(:,{925},{8:15},{110:116})
  
  tfile = f->t
  
  seleksics   = variable_selection(f,time,ntime,xcs,tfile,-8)
;  seleksicens = variable_selection
  
  t = seleksics[0]
  
  printVarSummary(t)


;***********************************************
;---Save to a netcdf file
;***********************************************

  if (netCDF) 
      diro = "./"
      filo = "#cs.nc"
      ptho = diro+filo
      system("/bin/rm -f "+ptho)
      ncdf = addfile(ptho,"c")
    
      fAtt = True
      fAtt@title          = "Variable selection based on Cold Surge"
      fAtt@source_name    = "ECMWF Reanalysis v.5"
	  fAtt@info			  = "Ready for calculate Q1Q2 and Moisture Budget"
      ;fAtt@source_URL    = "https://www.esrl.noaa.gov/psd/data/gridded/data.ncep.reanalysis2.html"
      fAtt@source         = "Copernicus ECMWF"
      fAtt@Conventions    = "None"
      fAtt@creation_date = systemfunc("date")
      fileattdef(ncdf,fAtt)            ; copy file attributes
     
      filedimdef(ncdf,"time",-1,True)  ; make time an UNLIMITED dimension
      ncdf->tcs   = t                  ; tcs = variabel yang akan tampil di file nc, t = variabel yang didefinisikan di script ini
      ;ncdf->qcs   = q
	  ;ncdf->ucs   = u
	  ;ncdf->vcs   = v
	  ;ncdf->wcs   = w
  end if
 
;  system("rm " + "#q.nc")     ; remove any pre-existing file
;  foutq = addfile("#q.nc","c")
;  foutq@title = "Preliminary data processing"
;  foutq@creation_date = systemfunc("date")
;  foutq->q = q
;  print(foutq)
;  
;  system("rm " + "#t.nc")     ; remove any pre-existing file
;  foutt = addfile("#t.nc","c")
;  foutt@title = "Preliminary data processing"
;  foutt@creation_date = systemfunc("date")
;  foutt->t = t
;  print(foutt)
;
;  system("rm " + "#u.nc")     ; remove any pre-existing file
;  foutu = addfile("#u.nc","c")
;  foutu@title = "Preliminary data processing"
;  foutu@creation_date = systemfunc("date")
;  foutu->u = u
;  print(foutu)
;  
;  system("rm " + "#v.nc")     ; remove any pre-existing file
;  foutv = addfile("#v.nc","c")
;  foutv@title = "Preliminary data processing"
;  foutv@creation_date = systemfunc("date")
;  foutv->v = v
;  print(foutv)
;
;  system("rm " + "#w.nc")     ; remove any pre-existing file
;  foutw = addfile("#w.nc","c")
;  foutw@title = "Preliminary data processing"
;  foutw@creation_date = systemfunc("date")
;  foutw->w = w
;  print(foutw)  
;; if( a(i) .eq. a@_FillValue) then

;===========================================================================================;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;																							;
; Progres_v1 - last save => Wednesday, 05 Jan 2022 - 20.44 WIB (13.44 UTC)				    ;
;																							;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
;===========================================================================================;