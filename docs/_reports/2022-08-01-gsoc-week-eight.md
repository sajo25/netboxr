---
layout: post
title:  "Week Eight | Adding weights parameter to geneConnector function"
tags: gsoc
author: Sara J
---

## Tasks
        
1. **[Testing weights for module stability](https://github.com/mil2041/netboxr/issues/36)**
    Status: **In progress**
    Branch: **None**
    PR: **None** 
    
2. **[Initiate (third) PR for netboxr ToolShed upload](https://github.com/bgruening/galaxytools/pull/1233)**
    Status: **Complete**
    Branch: **None**
    PR: **None** 
    
3. **Fix issues with netboxr tests**
    Status: **In progress**
    Branch: **None**
    PR: **None** 
    
4. **Initiate PR with parent repository to merge netboxr updates**
    Status: **[Complete](https://github.com/mil2041/netboxr/pull/38)**
    Branch: **None**
    PR: **None**     
             
5. **Meeting with supervisors**
    Status: **Thursday**
    Branch: **None**
    PR: **None** 

## Progress report

```
library(readr)
library(netboxr)

# PARAMETERS ----
stringdb_dir <- "C:/Users/s_ara/Downloads/9606.protein.links.detailed.v11.5.txt"
stringdb_dir2 <- "C:/Users/s_ara/Downloads/9606.protein.info.v11.5.txt/"

# DATA ----
## Read Interactions
# From: https://string-db.org/cgi/download?species_text=Homo+sapiens
dat_stringdb <- read_delim(file.path(stringdb_dir, "9606.protein.links.detailed.v11.5.txt"), delim=" ", col_types = cols(
  protein1 = col_character(),
  protein2 = col_character(),
  neighborhood = col_double(),
  fusion = col_double(),
  cooccurence = col_double(),
  coexpression = col_double(),
  experimental = col_double(),
  database = col_double(),
  textmining = col_double(),
  combined_score = col_double()
))
head(dat_stringdb)


## Read Mapping Information
dat_stringdb_info <- read_tsv(file.path(stringdb_dir2, "9606.protein.info.v11.5.txt"), col_types=cols(
  `#string_protein_id` = col_character(),
  preferred_name = col_character(),
  protein_size = col_double(),
  annotation = col_character()
))
head(dat_stringdb_info)

tmp_dat <- dat_stringdb

tmp_dat_stringdb <- merge(tmp_dat, dat_stringdb_info[, c("#string_protein_id", "preferred_name")], 
                          by.x = "protein1", by.y="#string_protein_id")
colnames(tmp_dat_stringdb)[colnames(tmp_dat_stringdb) == "preferred_name"] <- "protein1_symbol"
tmp_dat_stringdb <- merge(tmp_dat_stringdb, dat_stringdb_info[, c("#string_protein_id", "preferred_name")], 
                          by.x = "protein2", by.y="#string_protein_id")
colnames(tmp_dat_stringdb)[colnames(tmp_dat_stringdb) == "preferred_name"] <- "protein2_symbol"
tmp_dat_stringdb[,13] = paste(tmp_dat_stringdb[,11], tmp_dat_stringdb[,12], sep = "")


# netbox2010

netbox2010_network <- netbox2010$network
netbox2010_network[,5] <- paste(netbox2010_network[,1], netbox2010_network[,3], sep = "")
netbox2010_network[,6] <- seq(1:nrow(netbox2010_network))


tmp_dat_stringdb_netbox2010 <- merge(netbox2010_network, tmp_dat_stringdb[, c("protein1", "protein2", "combined_score", "V13")], 
                                     by.x = "V5", by.y= "V13", all.x = TRUE)
colnames(tmp_dat_stringdb_netbox2010)[colnames(tmp_dat_stringdb_netbox2010) == "combined_score"] <- "weights"

duplicates <- tmp_dat_stringdb_netbox2010[duplicated(tmp_dat_stringdb_netbox2010$V6),]
duplicates <- as.numeric(rownames(duplicates))
tmp_dat_stringdb_netbox2010 <- tmp_dat_stringdb_netbox2010[-duplicates,]

tmp_dat_stringdb_netbox2010 <- tmp_dat_stringdb_netbox2010[order(tmp_dat_stringdb_netbox2010$V6),]

tmp_dat_stringdb_netbox2010 <- tmp_dat_stringdb_netbox2010[,c("V1", "V2", "V3", "V4", "weights")]

for (i in 1:nrow(netbox2010_network)) {
  original <- paste(netbox2010_network[i,1], 
                    netbox2010_network[i,2],
                    netbox2010_network[i,3],
                    netbox2010_network[i,4], sep = "") 
  second <- paste(tmp_dat_stringdb_netbox2010[i,1],
                  tmp_dat_stringdb_netbox2010[i,2],
                  tmp_dat_stringdb_netbox2010[i,3],
                  tmp_dat_stringdb_netbox2010[i,4], sep = "")
  if (original != second) {
    print(i)
    break
  }
}

na_mask <- is.na(tmp_dat_stringdb_netbox2010$weights)
tmp_dat_stringdb_netbox2010$weights[na_mask] <- 1
netbox2010_weights_vector <- tmp_dat_stringdb_netbox2010$weights

netbox2010_weights <- netbox2010
netbox2010_weights$network[,5] <- netbox2010_weights_vector
colnames(netbox2010_weights$network)[colnames(netbox2010_weights$network) == "V5"] <- "weights"
save(netbox2010_weights, file = "netbox2010_weights.rda")


# pathway_commons_v8_reactome

pathway_commons_network <- pathway_commons_v8_reactome$network
pathway_commons_network[,4] <- paste(pathway_commons_network[,1], pathway_commons_network[,3], sep = "")
pathway_commons_network[,5] <- seq(1:nrow(pathway_commons_network))

tmp_dat_stringdb_pathway_commons <- merge(pathway_commons_network, tmp_dat_stringdb[, c("protein1", "protein2", "combined_score", "V13")], 
                                          by.x = "V4", by.y= "V13", all.x = TRUE)
colnames(tmp_dat_stringdb_pathway_commons)[colnames(tmp_dat_stringdb_pathway_commons) == "combined_score"] <- "weights"


duplicates <- tmp_dat_stringdb_pathway_commons[duplicated(tmp_dat_stringdb_pathway_commons$V5),]
duplicates <- as.numeric(rownames(duplicates))
tmp_dat_stringdb_pathway_commons <- tmp_dat_stringdb_pathway_commons[-duplicates,]

tmp_dat_stringdb_pathway_commons <- tmp_dat_stringdb_pathway_commons[order(tmp_dat_stringdb_pathway_commons$V5),]

tmp_dat_stringdb_pathway_commons <- tmp_dat_stringdb_pathway_commons[,c("PARTICIPANT_A", "INTERACTION_TYPE", "PARTICIPANT_B", "weights")]


for (i in 1:nrow(pathway_commons_network)) {
  original <- paste(pathway_commons_network[i,1], 
                    pathway_commons_network[i,2],
                    pathway_commons_network[i,3], sep = "") 
  second <- paste(tmp_dat_stringdb_pathway_commons[i,1],
                  tmp_dat_stringdb_pathway_commons[i,2],
                  tmp_dat_stringdb_pathway_commons[i,3], sep = "")
  if (original != second) {
    print(i)
    break
  }
}

na_mask <- is.na(tmp_dat_stringdb_pathway_commons$weights)
tmp_dat_stringdb_pathway_commons$weights[na_mask] <- 1
pathway_commons_weights_vector <- tmp_dat_stringdb_pathway_commons$weights

pathway_commons_v8_reactome_weights <- pathway_commons_v8_reactome
pathway_commons_v8_reactome_weights$network[,4] <- pathway_commons_weights_vector
colnames(pathway_commons_v8_reactome_weights$network)[colnames(pathway_commons_v8_reactome_weights$network) == "V4"] <- "weights"
save(pathway_commons_v8_reactome_weights, file = "pathway_commons_v8_reactome_weights.rda")
```
