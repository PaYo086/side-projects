Years_Download <- function(years, station, stationID){
  for (year in as.character(years)) {
    m.data <- NULL
    y.data <- data.frame("ObsTime" = NA, "StnPres" = NA, "SeaPres" = NA, "StnPresMax" = NA, "StnPresMaxTime" = NA, "StnPresMin" = NA, "StnPresMinTime" = NA, "Tem" = NA, "TMax" = NA, "TMaxTime" = NA, "TMin" = NA ,"TMinTime" = NA, "Tddewpoint" = NA, "RH" = NA, "RHMin" = NA, "RHMinTime" = NA, "WS" = NA, "WD" = NA, "WSGust" = NA, "WDGust" = NA, "WGustTime" = NA, "Precp" = NA, "PrecpHour" = NA, "PrecpMax10" = NA, "PrecpMax10Time" = NA, "PrecpHrMax" = NA, "PrecpHrMaxTime" = NA, "SunShine" = NA, "SunShineRate" = NA, "GloblRad" = NA, "VisbMean" = NA, "EvapA" = NA, "UVIMax" = NA, "UVIMaxTime" = NA, "CloudAmount" = NA, stringsAsFactors = F)
    for (month in c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12")) {
      m.data <- Station_Month_Download(year, month, stationID)
      y.data <- rbind(y.data, m.data)
      Sys.sleep(1.5) #AVOID being blocked
    }
    y.data <- y.data[-1,]
    write.table(y.data, file = paste0("data/", station, year, ".csv"), sep = ",", row.names = FALSE)
    dia.data <- Calculate_Ayear(y.data)
    write.table(dia.data, file = paste0("data/", station, year, "dia", ".csv"), sep = ",", row.names = FALSE)
  }
}