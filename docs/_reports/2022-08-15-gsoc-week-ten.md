---
layout: post
title:  "Week Ten | netboxr package maintenence"
tags: gsoc
author: Sara J
---

## Tasks
        
1. **[Replace cgdsr with cBioPortalData package in netboxr vignette](https://github.com/mil2041/netboxr/issues/14)**
    Status: **In progress**
    Branch: **None**
    PR: **None** 
    
2. **[Initiate (third) PR for netboxr ToolShed upload](https://github.com/bgruening/galaxytools/pull/1233)**
    Status: **Complete**
    Branch: **None**
    PR: **None** 
    

## Progress report

I wrote the following code to calculate the alteration frequency using the cBioPortalData package in place of cgdsr.

```
library(cBioPortalData)
cbio <- cBioPortal(hostname = "www.cbioportal.org", protocol = "https", api. = "/api/api-docs")

# Find available studies, caselists, and geneticProfiles 
studies <- getStudies(cbio)
caselists <- sampleLists(cbio, "gbm_tcga_pub")[, c("name", "sampleListId")]
geneticProfiles <- molecularProfiles(api = cbio, studyId = "gbm_tcga_pub")
geneticProfiles <- geneticProfiles$molecularProfileId

genes <- c("EGFR", "TP53", "ACTB", "GAPDH")
geneticProfiles <- c("gbm_tcga_pub_cna_consensus", "gbm_tcga_pub_mutations")
caseList <- "gbm_tcga_pub_cnaseq"
  
results <- sapply(genes, function(gene) {
  
  error_detect <- suppressWarnings(try(getDataByGenes(cbio, studyId = "gbm_tcga_pub", 
                                      genes = gene, by = "hugoGeneSymbol",
                                      molecularProfileId = "gbm_tcga_pub_mutations",
                                      sampleListId = caseList)))
  
  cna <- getDataByGenes(
  cbio, studyId = "gbm_tcga_pub", 
  genes = gene,
  by = "hugoGeneSymbol",
  molecularProfileId = "gbm_tcga_pub_cna_consensus",
  sampleListId = caseList)
  
  if ("try-error" %in% class(error_detect) | length(cna) == 0) {
    length(NULL)
  } else {
  
  mut <- getDataByGenes(
  cbio, studyId = "gbm_tcga_pub", 
  genes = gene,
  by = "hugoGeneSymbol",
  molecularProfileId = "gbm_tcga_pub_mutations",
  sampleListId = caseList)
  
  cna <- cbind(cna[[1]][5], cna[[1]][8])
  mut <- cbind(mut[[1]][4], mut[[1]][14])
  dat <- merge(cna, mut, by = "sampleId", all = TRUE)
  
  cna <- dat$value
  
  mut <- dat$proteinChange
  
  tmp <- data.frame(cna=cna, mut=mut, stringsAsFactors = FALSE)
  tmp$isAltered <- abs(tmp$cna) == 2 | !is.na(tmp$mut) # Amplification or Deep Deletion or any mutation
  length(which(tmp$isAltered))/nrow(tmp)
  } 
  }, USE.NAMES = TRUE)
# 10 percent alteration frequency cutoff 
geneList <- names(results)[results > 0.1]
```
