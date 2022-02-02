# install.packages("openxlsx")
# install.packages("readxl")

library(openxlsx)
library(readxl)

# Import the raw .xlsx table from Schmidtke et al., 2012
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


# Import data from Dakic et al, 2010. Note that the data is not open-access and thus cannot be directly downloaded
data_serbia <- as.data.frame(read_excel("data/1-s2.0-S0264410X09018118-mmc1.xls"))

# Clean it
colnames(data_serbia) = data_serbia[1, ]
data_serbia = data_serbia[-c(1, 76:80), ]
data_serbia$PtxS1 = as.character(match(data_serbia$PtxS1, LETTERS))

# Create the final table
data_serbia <- data.frame(strain_id = data_serbia$code,
                          year_isolated = data_serbia$isolation,
                          country = "Serbia",
                          region = NA,
                          prn = data_serbia$Prn,
                          prn_def = NA,
                          ptxP = NA,
                          ptxA = data_serbia$PtxS1,
                          fim2 = NA,
                          fim3 = NA,
                          FIM_sero = data_serbia$Serotype)

# Export it
write.table(data_serbia, file = "data/data_serbia.txt", quote = F, sep = "\t")
