library(dplyr)
source("R/compute_rci.R")

df_raw <- haven::read_dta("data/raw/ces_2021/ces_2021.dta", encoding = "latin1")

df_clean <- data.frame(
  id = paste0("ces_2021_", 1:nrow(df_raw))
)

attributes(df_raw$cps21_genderid)
table(df_raw$cps21_genderid)
df_clean$ses_gender <- dplyr::case_when(
  df_raw$cps21_genderid == 1 ~ "male",
  df_raw$cps21_genderid == 2 ~ "female",
  TRUE ~ NA_character_
)
table(df_clean$ses_gender)

attributes(df_raw$cps21_yob)
table(df_raw$cps21_yob)
ages <- 2021 - (1919 + df_raw$cps21_yob)

df_clean$ses_age_numeric <- ages

df_clean$ses_age <- cut(
  ages,
  breaks = c(18, 20, seq(25, 100, by = 5), Inf),
  labels = c(
    "18_19", "20_24", "25_29", "30_34", "35_39",
    "40_44", "45_49", "50_54", "55_59", "60_64",
    "65_69", "70_74", "75_79", "80_84", "85_89",
    "90_94", "95_99", "100+"
  ),
  right = FALSE,
  include.lowest = TRUE
)
table(df_clean$ses_age)

attributes(df_raw$cps21_education)
table(df_raw$cps21_education)
df_clean$ses_education <- dplyr::case_when(
  df_raw$cps21_education %in% 1:4 ~ "below_highschool",
  df_raw$cps21_education %in% 5:7 ~ "college",
  df_raw$cps21_education %in% 8:11 ~ "university",
  df_raw$cps21_education == 12 ~ NA_character_,
  TRUE ~ NA_character_
)
table(df_clean$ses_education)

attributes(df_raw$cps21_income_number)
table(df_raw$cps21_income_number, useNA = "always")
attributes(df_raw$cps21_income_cat)
table(df_raw$cps21_income_cat, useNA = "always")

income_num <- df_raw$cps21_income_number
income_num[income_num > 500000 | income_num < 0] <- NA

income_num_cat <- cut(
  income_num,
  breaks = c(-Inf, 30000, 60000, 90000, 110000, Inf),
  labels = c("0_30k", "30k_60k", "60k_90k", "90_110k", "110k_plus"),
  right = FALSE
)

income_cat <- dplyr::case_when(
  df_raw$cps21_income_cat %in% c(1, 2) ~ "0_30k",
  df_raw$cps21_income_cat == 3 ~ "30k_60k",
  df_raw$cps21_income_cat == 4 ~ "60k_90k",
  df_raw$cps21_income_cat == 5 ~ "90_110k",
  df_raw$cps21_income_cat %in% c(6, 7, 8) ~ "110k_plus",
  df_raw$cps21_income_cat == 9 ~ NA_character_,
  TRUE ~ NA_character_
)

df_clean$ses_income <- coalesce(income_cat, income_num_cat)

table(df_clean$ses_income)

attributes(df_raw$cps21_language_1)
attributes(df_raw$cps21_language_2)
table(df_raw$cps21_language_1, useNA = "always")
table(df_raw$cps21_language_2, useNA = "always")

df_clean$ses_language <- dplyr::case_when(
  !is.na(df_raw$cps21_language_2) & is.na(df_raw$cps21_language_1) ~ "french",
  is.na(df_raw$cps21_language_2) & !is.na(df_raw$cps21_language_1) ~ "english",
  !is.na(df_raw$cps21_language_2) & !is.na(df_raw$cps21_language_1) ~ "english",
  TRUE ~ "other"
)
table(df_clean$ses_language)

attributes(df_raw$cps21_province)
table(df_raw$cps21_province)
df_clean$ses_province <- case_when(
  df_raw$cps21_province == 5 ~ "nfld",
  df_raw$cps21_province == 10 ~ "pei",
  df_raw$cps21_province == 7 ~ "ns",
  df_raw$cps21_province == 4 ~ "nb",
  df_raw$cps21_province == 11 ~ "quebec",
  df_raw$cps21_province == 9 ~ "ontario",
  df_raw$cps21_province == 3 ~ "manitoba",
  df_raw$cps21_province == 12 ~ "sask",
  df_raw$cps21_province == 1 ~ "alberta",
  df_raw$cps21_province == 2 ~ "bc",
  df_raw$cps21_province == 13 ~ "yukon",
  df_raw$cps21_province == 6 ~ "nwt",
  df_raw$cps21_province == 8 ~ "nunavut",
  TRUE ~ NA_character_
)
table(df_clean$ses_province)

attributes(df_raw$cps21_fed_id)
table(df_raw$cps21_fed_id, useNA = "always")

df_clean$id_partisane <- dplyr::case_when(
  df_raw$cps21_fed_id == 1 ~ "liberal",
  df_raw$cps21_fed_id == 2 ~ "conservative",
  df_raw$cps21_fed_id == 3 ~ "ndp",
  df_raw$cps21_fed_id == 4 ~ "bloc",
  df_raw$cps21_fed_id == 5 ~ "green",
  df_raw$cps21_fed_id == 6 ~ "peoples_party",
  df_raw$cps21_fed_id == 7 ~ "other",
  df_raw$cps21_fed_id == 8 ~ "none",
  df_raw$cps21_fed_id == 9 ~ NA_character_,
  TRUE ~ NA_character_
)
table(df_clean$id_partisane, useNA = "always")

df_clean$weight <- df_raw$pes21_weight_general_all

cat("SES variables cleaned successfully\n")
cat("Variables created: ses_gender, ses_age, ses_age_numeric, ses_education, ses_income, ses_language, ses_province, id_partisane, weight\n")

# RACIAL IDENTITY VARIABLES TO CLEAN:
# cps21_vismin_1: Arab
# cps21_vismin_2: Asian
# cps21_vismin_3: Black
# cps21_vismin_4: Indigenous (First Nations, Métis, Inuit, etc.)
# cps21_vismin_5: Latino/Latina
# cps21_vismin_6: South Asian (East Indian, Pakistani, Sri Lankan, etc.)
# cps21_vismin_7: Southeast Asian (Vietnamese, Cambodian, Laotian, Thai, etc.)
# cps21_vismin_8: West Asian (Iranian, Afghan, etc.)
# cps21_vismin_9: White
# cps21_vismin_10: Other (cps21_vismin_10_TEXT)
# cps21_vismin_11: None of the above
# cps21_vismin_12: Prefer not to answer
# pes21_ethid_1: Importance of being Canadian to identity (1-5 scale)
# pes21_ethid_2: Importance of ethnicity to identity (1-5 scale)
# pes21_ethid_3: Importance of language to identity (1-5 scale)
# cps21_origin_1 to cps21_origin_5: Ethnic/cultural origins of ancestors (up to 5)
# cps21_bornin_canada: Born in Canada (1=Yes, 2=No, 3=Don't know/Prefer not to say)
# cps21_bornin_other: Country of birth (if not born in Canada)
# cps21_imm_year: Year of immigration
# cps21_immig_status: Immigration category (1=Skilled worker principal, 2=Skilled worker dependent, 3=Family class, etc.)
# cps21_citizenship: Citizenship status (1=Canadian citizen, 2=Permanent resident, 3=Other)

saveRDS(df_clean, "data/clean/ces_2021.rds")
cat("Data saved to data/clean/ces_2021.rds\n")
