begin
  
  start = systemfunc("date")
  print(start)
  
  singlelevel = False
  sst         = True


  f = addfile("../data/daymean_singlelevel.nc", "r")
  fsst = addfile("../data/daymean_sst.nc", "r")

  if (singlelevel)
    e = short2flt(f->e)
    printVarSummary(e)
    tp = short2flt(f->tp)
    printVarSummary(tp)
    slhf = short2flt(f->slhf)
    printVarSummary(slhf)
    sshf = short2flt(f->sshf)
    printVarSummary(sshf)


    diro    = "./"
    filo    = "short2float.nc"
    ptho    = diro+filo
    system("/bin/rm -f "+ptho)  ;-> delete the existing file
    ncdf    = addfile(ptho,"c")

    fAtt                = True
    fAtt@title          = "Single Pressure - convert data type from short to float"
    fAtt@source_name    = "ECMWF Reanalysis v5 (ERA5)"
    fAtt@source_URL     = "https://climate.copernicus.eu/climate-reanalysis"
    fAtt@source         = "ECMWF"
    fAtt@Conventions    = "None"
    fAtt@creation_date = systemfunc("date")
    fileattdef(ncdf,fAtt)            ; copy file attributes
   
    filedimdef(ncdf,"time",-1,True) ; make time an UNLIMITED dimension
    ncdf->e     = e
    ncdf->tp    = tp
    ncdf->slhf  = slhf
    ncdf->sshf  = sshf
  end if

  if (sst)
    sst = short2flt(fsst->analysed_sst)
    printVarSummary(sst)


    diro    = "./"
    filo    = "short2float.nc"
    ptho    = diro+filo
    system("/bin/rm -f "+ptho)  ;-> delete the existing file
    ncdf    = addfile(ptho,"c")

    fAtt                = True
    fAtt@title          = "Sea Surface Temperature - Variable selection, ready for compute the main process"
    fAtt@source_name    = "Sea surface temperature daily data from 1981 to present derived from satellite observations"
    fAtt@source_URL     = "https://cds.climate.copernicus.eu/cdsapp#!/dataset/satellite-sea-surface-temperature"
    fAtt@source         = "ATSR<1,2>-ESACCI-L3U-v2.0, AATSR-ESACCI-L3U-v2.0, AVHRR<07,09,11,12,14,15,16,17,18,19>_G-ESACCI-L3U-v2.0, AVHRRMTA_G-ESACCI-L3U-v2.0"
    fAtt@Conventions    = "None"
    fAtt@creation_date = systemfunc("date")
    fileattdef(ncdf,fAtt)            ; copy file attributes
   
    filedimdef(ncdf,"time",-1,True) ; make time an UNLIMITED dimension
    ncdf->sst     = sst
  end if

  finish = systemfunc("date")
  
  print("Program start : "+ start +" ")
  print("Program end   : "+ finish +" ")


end