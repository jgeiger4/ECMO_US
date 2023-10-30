## merge datasets

ecmo <- read.csv("merge/MCSDatabase_PSV_collection_MRN_dl.csv") %>%
  clean_names()
ecmo <- ecmo[1:833,]
old.match <- read.csv("merge/ECMODatabase-VascularECMOdataset_DATA_LABELS_2023-10-27_1256_key_eMRNs_match.csv") %>%
  clean_names()
old.free <- read.csv("merge/ECMODatabase-VascularECMOdataset_DATA_LABELS_2023-10-27_1256_key_eMRNs_free.csv") %>%
  clean_names()

old <- read.csv("merge/ECMODatabase-VascularECMOdataset_DATA_LABELS_2023-10-27_1256_key_eMRNs.csv") %>%
  clean_names()
old <- old %>%
  select(-record_id)

names(old)[1] <-"e_mrn"
key <- read_xlsx("merge/ECMO_data_key.xlsx") %>% clean_names()



test <- left_join(ecmo, old.match, by = join_by(record_id))
test <- left_join(test, old.free, by = join_by(e_mrn.x == e_mrn))

write.csv(test, "merge/test.csv")

glimpse(test)

length(unique(old$e_mrn))

length(unique(ecmo$e_mrn))

filter(old, e_mrn %in% ecmo$e_mrn)
