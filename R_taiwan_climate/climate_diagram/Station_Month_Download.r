#For test
#year <- "2010"
#month <- "02"
#stationID <- "467490&stname=%25E8%2587%25BA%25E4%25B8%25AD&" #include &stname=......

#Input String
#Output data.frame
Station_Month_Download = function(year, month, stationID) {

  library(xml2)
  library(rvest)

  webpage <- read_html(paste0("http://e-service.cwb.gov.tw/HistoryDataQuery/MonthDataController.do?command=viewMain&station=", stationID, "datepicker=", year, "-", month)) #Download
  data <- html_nodes(webpage, "#MyTable td , .second_tr th") #Select
  data_text <- html_text(data) #extract as string in a vector

#make data.frame
  ObsTime <- c(); StnPres <- c(); SeaPres <- c(); StnPresMax <- c(); StnPresMaxTime <- c()
  StnPresMin <- c(); StnPresMinTime <- c(); Tem <- c(); TMax <- c(); TMaxTime <- c()
  TMin <- c(); TMinTime <- c(); Tddewpoint <- c(); RH <- c(); RHMin <- c()
  RHMinTime <- c(); WS <- c(); WD <- c(); WSGust <- c(); WDGust <- c(); WGustTime <- c()
  Precp <- c(); PrecpHour <- c(); PrecpMax10 <- c(); PrecpMax10Time <- c(); PrecpHrMax <- c()
  PrecpHrMaxTime <- c(); SunShine <- c(); SunShineRate <- c(); GloblRad <- c()
  VisbMean <- c(); EvapA <- c(); UVIMax <- c(); UVIMaxTime <- c(); CloudAmount <- c()

  for (i in 71:length(data_text)) {
    if (i %% 35 == 1) {
      ObsTime <- c(ObsTime, paste(year, month, data_text[i], sep = "-"))
    } else if (i %% 35 == 2) {
      StnPres <- c(StnPres, data_text[i])
    } else if (i %% 35 == 3) {
      SeaPres <- c(SeaPres, data_text[i])
    } else if (i %% 35 == 4) {
      StnPresMax <- c(StnPresMax, data_text[i])
    } else if (i %% 35 == 5) {
      StnPresMaxTime  <- c(StnPresMaxTime, data_text[i])
    } else if (i %% 35 == 6) {
      StnPresMin <- c(StnPresMin, data_text[i])
    } else if (i %% 35 == 7) {
      StnPresMinTime <- c(StnPresMinTime, data_text[i])
    } else if (i %% 35 == 8) {
      Tem <- c(Tem, data_text[i])
    } else if (i %% 35 == 9) {
      TMax <- c(TMax, data_text[i])
    } else if (i %% 35 == 10) {
      TMaxTime <- c(TMaxTime, data_text[i])
    } else if (i %% 35 == 11) {
      TMin <- c(TMin, data_text[i])
    } else if (i %% 35 == 12) {
      TMinTime <- c(TMinTime, data_text[i])
    } else if (i %% 35 == 13) {
      Tddewpoint <- c(Tddewpoint, data_text[i])
    } else if (i %% 35 == 14) {
      RH <- c(RH, data_text[i])
    } else if (i %% 35 == 15) {
      RHMin <- c(RHMin, data_text[i])
    } else if (i %% 35 == 16) {
      RHMinTime <- c(RHMinTime, data_text[i])
    } else if (i %% 35 == 17) {
      WS <- c(WS, data_text[i])
    } else if (i %% 35 == 18) {
      WD <- c(WD, data_text[i])
    } else if (i %% 35 == 19) {
      WSGust <- c(WSGust, data_text[i])
    } else if (i %% 35 == 20) {
      WDGust <- c(WDGust, data_text[i])
    } else if (i %% 35 == 21) {
      WGustTime <- c(WGustTime, data_text[i])
    } else if (i %% 35 == 22) {
      Precp <- c(Precp, data_text[i])
    } else if (i %% 35 == 23) {
      PrecpHour <- c(PrecpHour, data_text[i])
    } else if (i %% 35 == 24) {
      PrecpMax10 <- c(PrecpMax10, data_text[i])
    } else if (i %% 35 == 25) {
      PrecpMax10Time <- c(PrecpMax10Time, data_text[i])
    } else if (i %% 35 == 26) {
      PrecpHrMax <- c(PrecpHrMax, data_text[i])
    } else if (i %% 35 == 27) {
      PrecpHrMaxTime <- c(PrecpHrMaxTime, data_text[i])
    } else if (i %% 35 == 28) {
      SunShine <- c(SunShine, data_text[i])
    } else if (i %% 35 == 29) {
      SunShineRate <- c(SunShineRate, data_text[i])
    } else if (i %% 35 == 30) {
      GloblRad <- c(GloblRad,data_text[i])
    } else if (i %% 35 == 31) { 
      VisbMean <- c(VisbMean, data_text[i])
    } else if (i %% 35 == 32) {
      EvapA <- c(EvapA, data_text[i])
    } else if (i %% 35 == 33) {
      UVIMax <- c(UVIMax, data_text[i])
    } else if (i %% 35 == 34) {
      UVIMaxTime <- c(UVIMaxTime, data_text[i])
    } else if (i %% 35 == 0) {
      CloudAmount <- c(CloudAmount, data_text[i])
    }
  }

# delete <U+00A0> and convert into num except time
  StnPres <- as.numeric(gsub("\u00a0", "", StnPres))
  SeaPres <- as.numeric(gsub("\u00a0", "", SeaPres))
  StnPresMax <- as.numeric(gsub("\u00a0", "", StnPresMax))
  StnPresMaxTime <- gsub("\u00a0", "", StnPresMaxTime)
  StnPresMin <- as.numeric(gsub("\u00a0", "", StnPresMin))
  StnPresMinTime <- gsub("\u00a0", "", StnPresMinTime)
  Tem <- as.numeric(gsub("\u00a0", "", Tem))
  TMax <- as.numeric(gsub("\u00a0", "", TMax))
  TMaxTime <- gsub("\u00a0", "", TMaxTime)
  TMin <- as.numeric(gsub("\u00a0", "", TMin))
  TMinTime <- gsub("\u00a0", "", TMinTime)
  Tddewpoint <- as.numeric(gsub("\u00a0", "", Tddewpoint))
  RH <- as.numeric(gsub("\u00a0", "", RH))
  RHMin <- as.numeric(gsub("\u00a0", "", RHMin))
  RHMinTime <- gsub("\u00a0", "", RHMinTime)
  WS <- as.numeric(gsub("\u00a0", "", WS))
  WD <- as.numeric(gsub("\u00a0", "", WD))
  WSGust <- as.numeric(gsub("\u00a0", "", WSGust))
  WDGust <- as.numeric(gsub("\u00a0", "", WDGust))
  WGustTime <- gsub("\u00a0", "", WGustTime)
  Precp <- as.numeric(gsub("\u00a0", "", Precp))
  PrecpHour <- as.numeric(gsub("\u00a0", "", PrecpHour))
  PrecpMax10 <- as.numeric(gsub("\u00a0", "", PrecpMax10))
  PrecpMax10Time <- gsub("\u00a0", "", PrecpMax10Time)
  PrecpHrMax <- as.numeric(gsub("\u00a0", "", PrecpHrMax))
  PrecpHrMaxTime <- gsub("\u00a0", "", PrecpHrMaxTime)
  SunShine <- gsub("\u00a0", "", SunShine) # X means no data
  SunShineRate <- as.numeric(gsub("\u00a0", "", SunShineRate))
  GloblRad <- as.numeric(gsub("\u00a0", "", GloblRad))
  VisbMean <- as.numeric(gsub("\u00a0", "", VisbMean))
  EvapA <- as.numeric(gsub("\u00a0", "", EvapA))
  UVIMax <- as.numeric(gsub("\u00a0", "", UVIMax))
  UVIMaxTime <- gsub("\u00a0", "", UVIMaxTime)
  CloudAmount <- as.numeric(gsub("\u00a0", "", CloudAmount))
  
  data_rearrange <- data.frame("ObsTime" = ObsTime, "StnPres" = StnPres, "SeaPres" = SeaPres, "StnPresMax" = StnPresMax, "StnPresMaxTime" = StnPresMaxTime, "StnPresMin" = StnPresMin, "StnPresMinTime" = StnPresMinTime, "Tem" = Tem, "TMax" = TMax, "TMaxTime" = TMaxTime, "TMin" = TMin, "TMinTime" = TMinTime, "Tddewpoint" = Tddewpoint, "RH" = RH, "RHMin" = RHMin, "RHMinTime" = RHMinTime, "WS" = WS, "WD" = WD, "WSGust" = WSGust, "WDGust" = WDGust, "WGustTime" = WGustTime, "Precp" = Precp, "PrecpHour" = PrecpHour, "PrecpMax10" = PrecpMax10, "PrecpMax10Time" = PrecpMax10Time, "PrecpHrMax" = PrecpHrMax, "PrecpHrMaxTime" = PrecpHrMaxTime, "SunShine" = SunShine, "SunShineRate" = SunShineRate, "GloblRad" = GloblRad, "VisbMean" = VisbMean, "EvapA" = EvapA, "UVIMax" = UVIMax, "UVIMaxTime" = UVIMaxTime, "CloudAmount" = CloudAmount, stringsAsFactors = F)

  return(data_rearrange)
}