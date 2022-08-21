begin

f = addfile("../data/daymean_sst.nc","r")

name	= "var"

"sst+$name$"= f->analysed_sst

printVarSummary("sst+$name$")

end