# Script to import data from Zenodo for v3.2.0

# Imports and constants
library(hector)
library(tidyr)

SCENARIOS <- c("ssp119", "ssp245", "ssp585")
VARIABLES <- c(GMST(), GLOBAL_TAS(), RF_TOTAL(), CONCENTRATIONS_CO2())
OUTPUT_FILE <- here::here("v3.2.0.csv")

# Import data from zenodo
# This may not work on the PNNL wifi/VPN
data <- read.csv("https://zenodo.org/records/12696520/files/output-V3.2.0.csv?download=1?raw=TRUE")

# Getting runs and variables of interest and switching to long form data
data %>%
  subset(scenario %in% SCENARIOS & variable %in% VARIABLES) %>%
  pivot_longer(!(c(version, commit, scenario, variable, units)), 
               names_to = "year") -> long_data

# Cleaning up data frame
long_data$year <- substring(long_data$year, 2)

# Outputting data to csv
write.csv(long_data, OUTPUT_FILE, row.names = FALSE)