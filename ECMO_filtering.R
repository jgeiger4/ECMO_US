###ECMO data set filtering

library(tidyverse)
library(tidyREDCap)

mcs<-read.csv("Initial_data/MCSDatabaseOngoing-Vascular_DATA_LABELS_2023-08-04_1632.csv")
View(mcs)

mcs_daily<-mcs[mcs["Repeat.Instrument"]=="Daily ICU",]
mcs_base<-mcs[mcs["Repeat.Instrument"]!="Daily ICU",]
mcs_base <- mcs_base %>% filter(Initial.ECMO.Mode=="V-A ECMO")
dim(mcs_base)
dim(mcs_daily)

mcs_clean<- mcs_daily %>%
  select(all_of(c("Record.ID", "Repeat.Instance",
                  "Fasciotomy"))) %>%
  group_by(Record.ID) %>%
  filter(Fasciotomy == "yes") %>%
  filter(row_number()==1) %>%
  select(-c("Fasciotomy")) %>%
  rename(Days.to.Fasciotomy = Repeat.Instance) %>%
  right_join(mcs_base)
mcs_clean<-mcs_daily %>%
  select(all_of(c("Record.ID", "Repeat.Instance",
                  "Limb.Amputation"))) %>%
  group_by(Record.ID) %>%
  filter(Limb.Amputation == "yes") %>%
  filter(row_number()==1) %>%
  select(-c("Limb.Amputation")) %>%
  rename(Days.to.Limb.Amputation = Repeat.Instance) %>%
  right_join(mcs_clean)
mcs_clean<-mcs_daily %>%
  select(all_of(c("Record.ID", "Repeat.Instance",
                  "Limb.Ischemia.Requiring.Limb.Reperfusion.Cannula"))) %>%
  group_by(Record.ID) %>%
  filter(Limb.Ischemia.Requiring.Limb.Reperfusion.Cannula == "yes") %>%
  filter(row_number()==1) %>%
  select(-c("Limb.Ischemia.Requiring.Limb.Reperfusion.Cannula")) %>%
  rename(Days.to.Limb.Ischemia.Requiring.Limb.Reperfusion.Cannula = Repeat.Instance) %>%
  right_join(mcs_clean)

View(mcs_clean[,-c(257:376)])
View(mcs_clean %>% select(all_of(c("Record.ID",
                                   "Survival.Status..MCS.hospitalization",
                                   "MCS.Length.of.Support",
                              "Days.to.Limb.Ischemia.Requiring.Limb.Reperfusion.Cannula",
                              "Days.to.Limb.Amputation",
                              "Days.to.Fasciotomy",
                              "Outflow.cannula.size",
                              "Distal.Perfusion.Cannula.",
                              "Distal.Perfusion.Cannula..Done.at.the.Time.of.Initial.MCS.Implant."))) %>%
       rename( Days.to.reperfusion.can = Days.to.Limb.Ischemia.Requiring.Limb.Reperfusion.Cannula,
               reperfusion.at.initiation = Distal.Perfusion.Cannula..Done.at.the.Time.of.Initial.MCS.Implant.))

"Outflow.cannula.size"                                                                                                            
"Inflow.Cannulation.Site"                                                                                                         
"Cannulation.Method..Inflow.Cannula"                                                                                              
"Inflow.Cannula.Size"                                                                                                             
"Left.Ventricular.Vent."                                                                                                          
"Distal.Perfusion.Cannula."                                                                                                       
"Distal.Perfusion.Cannula..Done.at.the.Time.of.Initial.MCS.Implant."                                                              
"Distal.Perfusion.Cannula..Location"                                                                                              
"Distal.Perfusion.Cannula..Cannula.Size" 
