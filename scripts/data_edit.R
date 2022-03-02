# install.packages("openxlsx")
# install.packages("readxl")

library(openxlsx)
library(readxl)
library(tidyr)

#### Data: Hiramatsu et al., 2017 ####

# Data provided by the authors in a PDF form, thus the TXT file had to be created manually by converting the PDF to an XLSX file using ilovepdf.com then editing the output to have a clean TXT file

# Import the TXT data frame
data_jp <- read.table("data/16-1575-TECHAPP1.txt", header = T, sep = "\t")

# Formate it
data_jp$prn.allele[data_jp$prn.allele == "ND"] <- NA
data_jp$Pertactin.production[data_jp$Pertactin.production == "–"] <- "-" # Japanese "–" in the file is different from classical "-"
data_jp$Pertactin.production[data_jp$Pertactin.production == "+"] <- "+" # Japanese "+" in the file is different from classical "+"

# Create the final data frame
data_jp <- data.frame(strain_id = data_jp$Isolate,
                      year_isolated = data_jp$Isolation.year,
                      country = "Japan",
                      region = data_jp$Origin..district.,
                      prn = data_jp$prn.allele,
                      prn_def = data_jp$Pertactin.production,
                      ptxP = NA,
                      ptxA = NA,
                      fim2 = NA,
                      fim3 = NA,
                      FIM_sero = NA)

# Export it
write.table(data_jp, file = "data/data_jp.txt", quote = F, sep = "\t")

#### Data: Otsuka et al., 2012 ####

# Note that part of this strains (year >= 2005) are included in Hiramatsu et al., 2017 but with less information.

# Import the XLSX data frame
data_jp2 <- read.xlsx("https://doi.org/10.1371/journal.pone.0031985.s003", colNames = T, startRow = 2)

# Clean it
data_jp2 <- data_jp2[-(122:123), ]
data_jp2$`Alleles.(prn/ptxA)` <- gsub("[a-zA-Z]", "", data_jp2$`Alleles.(prn/ptxA)`)
data_jp2 <- separate(data = data_jp2, col = `Alleles.(prn/ptxA)`, into = c("prn_allele", "ptxA_allele"), sep = "/") # Separate the column with the alleles to a column with two alleles.
for (x in c(2, 3)) {
  data_jp2[paste0("Fim", x)] <- gsub("-", "", data_jp2[, paste0("Fim", x)])
  data_jp2[paste0("Fim", x)] <- gsub("\\+", x, data_jp2[, paste0("Fim", x)])
}
data_jp2$FIM_sero <- paste0(data_jp2$Fim2, data_jp2$Fim3)
data_jp2$FIM_sero[data_jp2$FIM_sero == ""] <- "-"
data_jp2$FIM_sero[data_jp2$FIM_sero == "23"] <- "2,3"

# Create the final data frame
data_jp2 <- data.frame(strain_id = data_jp2$Isolate,
                       year_isolated = data_jp2$Isolation.year,
                       country = "Japan",
                       region = data_jp2$`Origin.(District)`,
                       prn = data_jp2$prn_allele,
                       prn_def = data_jp2$Prn,
                       ptxP = NA,
                       ptxA = data_jp2$ptxA_allele,
                       fim2 = NA,
                       fim3 = NA,
                       FIM_sero = data_jp2$FIM_sero)

# Export it
write.table(data_jp2, file = "data/data_jp2.txt", quote = F, sep = "\t")

#### Data: Schmidtke et al., 2012 ####

# Import the raw XLSX table
data_us <- read.xlsx("https://wwwnc.cdc.gov/eid/article/18/8/12-0082-techapp1.xlsx", colNames = T, startRow = 2)

# Clean it
data_us = data_us[-662, ]
data_us$ptxS1 = as.character(match(data_us$ptxS1, LETTERS))
data_us$fim3 = as.character(match(gsub("\\*", "", data_us$fim3), LETTERS))

# Create the final table 
data_us <- data.frame(strain_id = data_us$Strain.Number, 
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

#### Data: Dakic et al., 2010 ####

# Import data from the XLS file. Note that the data is not open-access and thus cannot be directly downloaded
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
