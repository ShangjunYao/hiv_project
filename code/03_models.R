here::i_am("code/03_models.R")

data <- readRDS(
  file = here::here("output/data_clean.rds")
)

library(gtsummary)

mod <- glm(
  ab_resistance ~ shield_glycans + region + env_length,
  data = data
)

primary_regression_table <-
  tbl_regression(mod) |>
  add_global_p()

which_config <- Sys.getenv("which_config")
config_list <- config::get(
  config = which_config
)

binary_mod <- glm(
  I(ab_resistance > config_list$cutpoint) ~ shield_glycans + region + env_length,
  data = data,
  family = binomial()
)

secondary_regression_table <-
tbl_regression(binary_mod, exponentiate = TRUE) |>
  add_global_p()


both_models <- list(
primary = mod,
secondary = binary_mod
)

# E.g., active config is test
# saved file will be called both_models_config_test.rds
both_models_filename <- paste0(
  "both_models_config_",
  which_config,
  ".rds"
)
saveRDS(
  both_models,
  file = here::here("output", both_models_filename)
)

both_regression_tables <- list(
  primary = primary_regression_table,
  sencondary = secondary_regression_table
)

# E.g., if active config is default
# both_regression_tables_config_default.rds
both_regression_tables_filename <- paste0(
  "both_regression_tables_config_",
  which_config,
  ".rds"
)
saveRDS(
  both_regression_tables,
  file = here::here("output", both_regression_tables_filename)
)
