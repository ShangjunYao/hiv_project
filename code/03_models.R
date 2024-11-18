here::i_am("code/03_models.R")

data <- readRDS(
  file = here::here("output/data_clean.rds")
)

library(gtsummary)
library(config)


mod <- glm(
  ab_resistance ~ shield_glycans + region + env_length,
  data = data
)

primary_regression_table <- 
  tbl_regression(mod) |>
  add_global_p()

which_config <- Sys.getenv("which_config")
config_list <- config::get(
  config= which_config
)

binary_mod <- glm(
  I(ab_resistance > 1) ~ shield_glycans + region + env_length,
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

both_models_filename <- paste0(
  "both_models_config_",
  ".rds"
)
saveRDS(
  both_models,
  file = here::here("output",both_models_filename)
)

both_regression_tables <- list(
  primary = primary_regression_table,
  secondary = secondary_regression_table
)
saveRDS(
  both_regression_tables,
  file = here::here("output",both_regression_tables_filename)
)

