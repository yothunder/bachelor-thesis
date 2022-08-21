begin
  
  print("Testing for equivalent sample size")
  print("===")

  print(systemfunc("date"))
  print("===")
  
  f = addfile("../data/daymean_pressurelevel.nc", "r")
  t = f->t
  u = f->u
  v = f->v
  w = f->w
  q = f->q

  ;umean = dim_avg_n(u,0)
  ;vmean = dim_avg_n(v,0)
  ;tmean = dim_avg_n(t,0)
  ;qmean = dim_avg_n(q,0)
  ;wmean = dim_avg_n(w,0)

  uvari = dim_variance_n(u,0)
  ;vvari = dim_variance_n(v,0)
  ;tvari = dim_variance_n(t,0)
  ;qvari = dim_variance_n(q,0)
  ;wvari = dim_variance_n(w,0)

  ;printVarSummary(umean)
  printVarSummary(uvari)

end