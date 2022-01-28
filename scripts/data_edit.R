# install.packages("openxlsx")

library(openxlsx)

# Import the raw .xlsx table from Schmidtke et al., 201é
data_us <- as.data.frame(read.xlsx("https://wwwnc.cdc.gov/eid/article/18/8/12-0082-techapp1.xlsx"))

# Clean it
colnames(data_us) = data_us[1, ]
data_us = na.omit(data_us)
data_us = data_us[-1, ]
data_us$ptxS1 = as.character(match(data_us$ptxS1, LETTERS))
data_us$fim3 = as.character(match(gsub("\\*", "", data_us$fim3), LETTERS))

# Create the final table 
data_us <- data.frame(strain_id = data_us$`Strain Number`, 
                      year_isolated = data_us$Year_Isolated, 
                      country = "US",
                      region = data_us$Source,
                      prn = data_us$prn,
                      prn_def = NA,
                      ptxP = data_us$ptxP,
                      ptxA = data_us$ptxS1,
                      fim2 = NA,
                      fim3 = data_us$fim3,
                      FIM_sero = NA)

# Export it
write.table(data_us, file = "data/data_us.txt", quote = F, sep = "\t")