# reading libraries
library(readxl)
library(magrittr)
library(dplyr)
library(tidyr)
library(purrr)

# reading XLSX downloaded file
path <- "~/Downloads/br-2019-120520200400.xlsx"

# reading all sheets
tracking_data <-  path %>%
                  excel_sheets() %>%
                  set_names() %>%
                  map_df(read_excel,
                  path = path,
                  .id = "tracking_name")

# getting the number of columns
columns_count <- ncol(tracking_data)

# tidying data
tidy_tracking_data <- tracking_data %>%
  rename("answer" = "...1") %>%
  gather("data", "value", 3:columns_count) %>%
  filter(!is.na(value))

# creating id
tracking_id <- tidy_tracking_data %>%
  distinct(tracking_name) %>%
  mutate(tracking_id = row_number())

# adding id to final dataframe
final_tracking_data <- tidy_tracking_data %>%
  left_join(tracking_id, by = "tracking_name")

# downloading final CSV file
write.csv(final_tracking_data, "final_tracking_data.csv",
          row.names = FALSE)
