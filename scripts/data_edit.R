# install.packages("openxlsx")
# install.packages("readxl")

library(openxlsx)
library(readxl)
library(tidyr)

#### Data: Hiramatsu et al., 2017 ####

# Data provided by the authors in a PDF form, thus the TXT file had to be created manually by converting the PDF to an XLSX file using ilovepdf.com then editing the output to have a clean TXT file

# Import the TXT data frame
data_hiramatsu_2017 <- read.table("data/data_raw/16-1575-TECHAPP1.txt", header = T, sep = "\t")

# Formate it
data_hiramatsu_2017$prn.allele[data_hiramatsu_2017$prn.allele == "ND"] <- NA
data_hiramatsu_2017$Pertactin.production[data_hiramatsu_2017$Pertactin.production == "–"] <- "-" # Japanese "–" in the file is different from classical "-"
data_hiramatsu_2017$Pertactin.production[data_hiramatsu_2017$Pertactin.production == "+"] <- "+" # Japanese "+" in the file is different from classical "+"

# Create the final data frame
data_hiramatsu_2017 <- data.frame(strain_id = data_hiramatsu_2017$Isolate,
                      year_isolated = data_hiramatsu_2017$Isolation.year,
                      country = "Japan",
                      region = data_hiramatsu_2017$Origin..district.,
                      prn = data_hiramatsu_2017$prn.allele,
                      prn_def = data_hiramatsu_2017$Pertactin.production,
                      ptxP = NA,
                      ptxA = NA,
                      fim2 = NA,
                      fim3 = NA,
                      FIM_sero = NA)

# Export it
write.table(data_hiramatsu_2017, file = "data/data_edited/data_hiramatsu_2017.txt", quote = F, sep = "\t")

#### Data: Otsuka et al., 2012 ####

# Note that part of this strains (year >= 2005) are included in Hiramatsu et al., 2017 but with less information.

# Import the XLSX data frame
data_otsuka_2012 <- read.xlsx("https://doi.org/10.1371/journal.pone.0031985.s003", colNames = T, startRow = 2)

# Clean it
data_otsuka_2012 <- data_otsuka_2012[-(122:123), ]
data_otsuka_2012$`Alleles.(prn/ptxA)` <- gsub("[a-zA-Z]", "", data_otsuka_2012$`Alleles.(prn/ptxA)`)
data_otsuka_2012 <- separate(data = data_otsuka_2012, col = `Alleles.(prn/ptxA)`, into = c("prn_allele", "ptxA_allele"), sep = "/") # Separate the column with the alleles to a column with two alleles.
for (x in c(2, 3)) {
  data_otsuka_2012[paste0("Fim", x)] <- gsub("-", "", data_otsuka_2012[, paste0("Fim", x)])
  data_otsuka_2012[paste0("Fim", x)] <- gsub("\\+", x, data_otsuka_2012[, paste0("Fim", x)])
}
data_otsuka_2012$FIM_sero <- paste0(data_otsuka_2012$Fim2, data_otsuka_2012$Fim3)
data_otsuka_2012$FIM_sero[data_otsuka_2012$FIM_sero == ""] <- "-"
data_otsuka_2012$FIM_sero[data_otsuka_2012$FIM_sero == "23"] <- "2,3"

# Create the final data frame
data_otsuka_2012 <- data.frame(strain_id = data_otsuka_2012$Isolate,
                       year_isolated = data_otsuka_2012$Isolation.year,
                       country = "Japan",
                       region = data_otsuka_2012$`Origin.(District)`,
                       prn = data_otsuka_2012$prn_allele,
                       prn_def = data_otsuka_2012$Prn,
                       ptxP = NA,
                       ptxA = data_otsuka_2012$ptxA_allele,
                       fim2 = NA,
                       fim3 = NA,
                       FIM_sero = data_otsuka_2012$FIM_sero)

# Export it
write.table(data_otsuka_2012, file = "data/data_edited/data_otsuka_2012.txt", quote = F, sep = "\t")

#### Data: Schmidtke et al., 2012 ####

# Import the raw XLSX table
data_schmidtke_2012 <- read.xlsx("https://wwwnc.cdc.gov/eid/article/18/8/12-0082-techapp1.xlsx", colNames = T, startRow = 2)

# Clean it
data_schmidtke_2012 = data_schmidtke_2012[-662, ]
data_schmidtke_2012$ptxS1 = as.character(match(data_schmidtke_2012$ptxS1, LETTERS))
data_schmidtke_2012$fim3 = as.character(match(gsub("\\*", "", data_schmidtke_2012$fim3), LETTERS))

# Create the final table 
data_schmidtke_2012 <- data.frame(strain_id = data_schmidtke_2012$Strain.Number, 
                      year_isolated = data_schmidtke_2012$Year_Isolated, 
                      country = "US",
                      region = data_schmidtke_2012$Source,
                      prn = data_schmidtke_2012$prn,
                      prn_def = NA,
                      ptxP = data_schmidtke_2012$ptxP,
                      ptxA = data_schmidtke_2012$ptxS1,
                      fim2 = NA,
                      fim3 = data_schmidtke_2012$fim3,
                      FIM_sero = NA)

# Export it
write.table(data_schmidtke_2012, file = "data/data_edited/data_schmidtke_2012.txt", quote = F, sep = "\t")

#### Data: Dakic et al., 2010 ####

# Import data from the XLS file. Note that the data is not open-access and thus cannot be directly downloaded
data_dakic_2010 <- as.data.frame(read_excel("data/data_raw/1-s2.0-S0264410X09018118-mmc1.xls"))

# Clean it
colnames(data_dakic_2010) = data_dakic_2010[1, ]
data_dakic_2010 = data_dakic_2010[-c(1, 76:80), ]
data_dakic_2010$PtxS1 = as.character(match(data_dakic_2010$PtxS1, LETTERS))

# Create the final table
data_dakic_2010 <- data.frame(strain_id = data_dakic_2010$code,
                          year_isolated = data_dakic_2010$isolation,
                          country = "Serbia",
                          region = NA,
                          prn = data_dakic_2010$Prn,
                          prn_def = NA,
                          ptxP = NA,
                          ptxA = data_dakic_2010$PtxS1,
                          fim2 = NA,
                          fim3 = NA,
                          FIM_sero = data_dakic_2010$Serotype)

# Export it
write.table(data_dakic_2010, file = "data/data_edited/data_dakic_2010.txt", quote = F, sep = "\t")

#### Data: Bart et al., 2014 ####

data_bart_2014 <- read_excel("data/data_raw/mbo002141804sd1.xlsx", sheet = 2)

data_bart_2014$prn <- gsub(pattern = "prn", replacement = "", x = data_bart_2014$prn)
data_bart_2014$ptxP <- gsub(pattern = "ptxP", replacement = "", x = data_bart_2014$ptxP)
data_bart_2014$ptxA <- gsub(pattern = "ptxA", replacement = "", x = data_bart_2014$ptxA)
data_bart_2014$fim2 <- gsub(pattern = "fim2-", replacement = "", x = data_bart_2014$fim2)
data_bart_2014$fim3 <- gsub(pattern = "fim3-", replacement = "", x = data_bart_2014$fim3)

data_bart_2014 <- data.frame(strain_id = data_bart_2014$Strain_no,
                             year_isolated = data_bart_2014$Isolation_year,
                             country = data_bart_2014$Country,
                             region = NA,
                             prn = data_bart_2014$prn,
                             prn_def = NA,
                             ptxP = data_bart_2014$ptxP,
                             ptxA = data_bart_2014$ptxA,
                             fim2 = data_bart_2014$fim2,
                             fim3 = data_bart_2014$fim3,
                             FIM_sero = NA)

write.table(data_bart_2014, file = "data/data_edited/data_bart_2014.txt", row.names = F, quote = F, sep = "\t")


