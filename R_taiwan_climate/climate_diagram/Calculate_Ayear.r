Calculate_Ayear <- function(data){
  # load packages -----
  library(dplyr)
  library(tidyr)
  
  # remain need data -----
  data <- data[, c("ObsTime", "Tem", "TMax", "TMin", "Precp")]
  data <- separate(data, col = "ObsTime", into = c("Year", "Month", "Day"), sep = "-")
  
  # calculate -----
  Prec. <- data %>% group_by(Month) %>% summarise(Prec. = sum(Precp, na.rm = T))
  Mean.t <- data %>% group_by(Month) %>% summarise(Mean.t = mean(Tem, na.rm = T))
  Max.t <- data %>% group_by(Month) %>% summarise(Max.t = mean(TMax, na.rm = T))
  Min.t <- data %>% group_by(Month) %>% summarise(Min.t = mean(TMin, na.rm = T))
  Ab.max.t <- data %>% group_by(Month) %>% summarise(Ab.max.t = max(TMax, na.rm = T))
  Ab.min.t <- data %>% group_by(Month) %>% summarise(Ab.min.t = min(TMin, na.rm = T))
  
  # aggregate -----
  fin.data <- left_join(Prec., Mean.t, by = "Month") %>% left_join(., Max.t, by = "Month") %>% left_join(., Min.t, by = "Month") %>% left_join(., Ab.max.t, by = "Month") %>% left_join(., Ab.min.t, by = "Month")
  
  # final adjust -----
  fin.data <- t(fin.data)
  colnames(fin.data) <- fin.data["Month",]
  fin.data <- fin.data[-1,]
  return(fin.data)
}