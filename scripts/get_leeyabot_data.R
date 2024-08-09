# Script to import data from the hector-run-archive and format the subset of data
# to be used by leeyabot to generate reports. 
# For now this is set to version 3.2.0

# Imports and constants
library(hector)
library(tidyr)

SCENARIOS <- c("ssp119", "ssp245", "ssp585", "1pctCO2", "abruptx4CO2")
VARIABLES <- c(GLOBAL_TAS(), RF_TOTAL(), CONCENTRATIONS_CO2(), SST(), 
               HEAT_FLUX())
OUTPUT_FILE <- here::here("output", "leeyabot-data.csv")

# Import data from zenodo
# This may not work on the PNNL wifi/VPN
base_url <- "https://zenodo.org/records/13285854"
url <- paste0(base_url, "/files/output-V3.2.0.csv?download=1?raw=TRUE")
data <- read.csv(url)

# Getting runs and variables of interest and switching to long form data
data %>%
  subset(scenario %in% SCENARIOS & variable %in% VARIABLES) %>%
  pivot_longer(!(c(version, commit, scenario, variable, units)), 
               names_to = "year") -> long_data

# Cleaning up data frame
long_data$year <- substring(long_data$year, 2)

# Outputting data to csv
write.csv(long_data, OUTPUT_FILE, row.names = FALSE)
