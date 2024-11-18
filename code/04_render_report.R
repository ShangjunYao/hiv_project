here::i_am("code/04_render_report.R")

which_config <- Sys.getenv("which_config")
config_list <- config::get(
  config = which_config
)

library(rmarkdown)
report_filename <- paste0(
  "hiv_report_config_",
  which_config,
  ".html"
)
# rendering a report in production mode
render(
  "hiv_report.Rmd",
  output_file = report_filename)

