## merge datasets

ecmo <- read.csv("merge/VascularECMOdataset_10_27_23_mrn.csv") %>%
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

#### merge new redcap

test1 <- mcs_clean %>%
  select(-record_id) %>%
  right_join(ecmo, by = join_by(e_mrn == e_mrn_x))

write_csv(test1, "merge/test1_new_redcap_merge.csv")


ecmo %>%
  select(c(starts_with("etiology_of_shock_choice"), study_record_id)) %>%
  pivot_longer(cols = starts_with("etiology_of_shock_choice"), names_to = "etiology_of_shock",
               names_prefix = "etiology_of_shock_choice_") %>%
  filter(value == 1) %>%
  right_join(ecmo)

ecmo <- ecmo %>%
  select(c(starts_with("indication_for_ecmo_choice"), study_record_id)) %>%
  pivot_longer(cols = starts_with("indication_for_ecmo_choice"), names_to = "indication_for_ecmo",
               names_prefix = "indication_for_ecmo_choice_") %>%
  filter(value == 1) %>%
  right_join(ecmo)
