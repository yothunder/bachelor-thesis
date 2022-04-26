begin

; specify file names (input&output, netCDF)
  pathin = "../data/#/"                  ; directory
  fin1 = pathin+"var_YANAI_Q1Q2.nc"        ; input file name #1
  fin2 = pathin+"monmean_YANAI_Q1Q2.nc"  ; input file name #2
  fout = "signif"      ; output file name
  foutnc = fout+".nc"

; open input files
  in1 = addfile(fin1,"r")
  in2 = addfile(fin2,"r")
  
  level = 925
; read data
  q1pcpcsavg   = in1->Q1percpcsmean(1,:,:,:)
  q1pcpcsvar   = in1->Q1percpcsvari(1,:,:,:)
  q1pcp        = in2->Q1percp(:,:,:,:)

  q1pcpavg     = dim_avg_n(q1pcp,0)
  q1pcpvar     = dim_variance_n(q1pcp,0)
  
  printVarSummary(q1pcpcsavg)
  printVarSummary(q1pcpcsvar)
  printVarSummary(q1pcpavg)
  printVarSummary(q1pcpvar)

; read data
  ;xv = v1(lev|:,lat|:,lon|:,timecs|:)
  ;yv = v2(level|:,latitude|:,longitude|:,time|:)
  ;Xave = dim_avg_Wrap(xv)
  ;Yave = dim_avg_Wrap(yv)
  ;Xvar = dim_variance(xv)
  ;Yvar = dim_variance(yv)

  ;sigr = 0.05
  ;xEqv = equiv_sample_size (xv, sigr, 0)
  ;yEqv = equiv_sample_size (yv, sigr, 0)
  ;printMinMax(xEqv,0)
  ;printMinMax(yEqv,0)

  iflag    = False  ; population variance similar
  tval_opt = False  ; p-value only
  prob = ttest(q1pcpcsavg,q1pcpcsvar,31,q1pcpavg,q1pcpvar,53,iflag,tval_opt)
  printVarSummary(prob)

; calc. the difference
  diff = q1pcpcsavg
  diff = q1pcpavg - q1pcpcsavg
  pval = q1pcpcsavg
  pval = (/prob/)
  diff@long_name = "difference of the means"
  pval@long_name = "probability"

; write output file
  system("rm " + foutnc)     ; remove any pre-existing file
  out = addfile(foutnc,"c")  ; open netCDF file
  out->diff = diff
  out->pval = pval

end