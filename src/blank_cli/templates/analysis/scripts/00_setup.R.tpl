# 00_setup.R
# Shared setup for analysis scripts.

message("[setup] loading configuration")

cfg <- list(
  project_name = "{{project_name}}",
  generated_on = "{{today}}"
)
