---
layout: post
title:  "Week One | Work on GitHub Actions and module parametrization"
tags: gsoc
author: Sara J
---


## Tasks

1. **[Setup GitHub Actions](https://github.com/mil2041/netboxr/issues/7)**
    Status: **In progress**
    Branch: **None**
        PR: **None**
        
2. **[Add methods for module size parametrization](https://github.com/mil2041/netboxr/issues)**
    Status: **In progress**
    Branch: **None**
        PR: **None**
        
3. **[Fix cgdsr package issue](https://github.com/mil2041/netboxr/issues/14)**
    Status: **Complete**
    Branch: **None**
    PR: **None**
        
4. **Meeting with supervisors**
    Status: **Complete**
    Branch: **None**
    PR: **None**
    
5. **R package creation crash course**
    Status: **In progress**
    Branch: **None**
    PR: **None** 
    
    
To fix the cgdsr package issue, a (temporary) solution I implemented in the netboxr vignette was removing any cgdsr-related code and uploading a table containing the identical cgdsr data ("vignette_data.txt") that I stored in the "inst" directory. 

The code I removed (with the exception of the `genes <- c("EGFR", "TP53", "ACTB", "GAPDH")` line) can be found below:

```
library(cgdsr)
mycgds <- CGDS("http://www.cbioportal.org/")
# Find available studies, caselists, and geneticProfiles
studies <- getCancerStudies(mycgds)
caselists <- getCaseLists(mycgds,'gbm_tcga_pub')
geneticProfiles <- getGeneticProfiles(mycgds,'gbm_tcga_pub')
genes <- c("EGFR", "TP53", "ACTB", "GAPDH")
results <- sapply(genes, function(gene) {
  geneticProfiles <- c("gbm_tcga_pub_cna_consensus", "gbm_tcga_pub_mutations")
  caseList <- "gbm_tcga_pub_cnaseq"
  dat <- getProfileData(mycgds, genes=gene, geneticProfiles=geneticProfiles, caseList=caseList)
  head(dat) [...] }
```

The added code can be found below:

```
results <- sapply(genes, function(gene) {
dat <- read.table(system.file("vignette_data.txt", package = "netboxr"),
header=TRUE, sep="\t",
stringsAsFactors=FALSE) [...] }
```

In addition to this, I added the name of the file to .Rbuildignore, and removed 'cgdsr' from the DESCRIPTION file.
    
To add module parametrization features to netboxr, I made updates to the geneConnector function as follows:

```
geneConnector <- function(geneList, networkGraph, directed = FALSE, pValueAdj = "BH", pValueCutoff = 0.05, 
communityMethod = "ebc", resolutionParam = 1, weightsInput = NULL, keepIsolatedNodes = FALSE) { [...]

if (communityMethod == "louvain") { 
message(sprintf("Detecting modules using \"Louvain\" method\n"))
community <- cluster_louvain(graphOutput, weights = weightsInput, resolution = resolutionParam)
moduleMembership <- membership(community)
}

if (communityMethod == "leiden") {
message(sprintf("Detecting modules using \"Leiden\" method\n"))
community <- cluster_leiden(graphOutput, weights = weightsInput, resolution = resolutionParam)
moduleMembership <- membership(community)
} 
[...] }
```

I’ve also made the following additions to the roxygen documentation in that same function:

```
#' @param communityMethod string for community detection method c("ebc","lec", "leiden", "louvain") 
as described in the details section (default = "ebc") [...]
#' @param resolutionParam numeric value that determines community size, where higher resolutions 
leads to more smaller communities (default = 1)
#' @param weightsInput numeric vector for edge weights (default = NULL)
```

To test whether the function still works, and whether changing the parameters results in the expected outcome (i.e. different community sizes), I reran the example in the vignette using the new community methods and different resolutionParam values as follows:

```
results <- geneConnector(geneList = geneList, networkGraph = graphReduced, directed = FALSE,  pValueAdj = "BH",
pValueCutoff = threshold,  communityMethod = "leiden", resolutionParam = 2, keepIsolatedNodes = FALSE)
```

The graphs I obtained can be found below:

**Louvain, resolution = 1**
<img src = "https://user-images.githubusercontent.com/28693536/175822369-4a9a2702-e26a-48a4-a9f4-e33a416ac78e.png" width = "400" height = "400">

**Louvain, resolution = 2**
<img src = "https://user-images.githubusercontent.com/28693536/175822380-2ffc2661-c1a0-4a03-b1d9-48ad9cc8c076.png" width = "400" height = "400">

**Louvain, resolution = 3**
<img src = "https://user-images.githubusercontent.com/28693536/175822704-d3239a06-e2b6-426e-a8cf-8bfb3278f332.png" width = "400" height = "400">

**Louvain, resolution = 5**
<img src = "https://user-images.githubusercontent.com/28693536/175822716-0556da05-1ea9-4c1e-89ef-ee673c7ea0b5.png" width = "400" height = "400">

**Louvain, resolution = 10**
<img src = "https://user-images.githubusercontent.com/28693536/175822727-a6af2c56-3d7a-4691-95d6-aaed9c46d686.png" width = "400" height = "400">

**Louvain, resolution = 20**
<img src = "https://user-images.githubusercontent.com/28693536/175822733-f2ad7571-c13c-4023-8bfc-060f62aa23f8.png" width = "400" height = "400">

**Louvain, resolution = 100**
<img src = "https://user-images.githubusercontent.com/28693536/175822879-567cad76-a016-4ce0-bc73-2515ccaa701b.png" width = "400" height = "400">

**Louvain, resolution = 500**
<img src = "https://user-images.githubusercontent.com/28693536/175822965-23c4cc9e-4f13-4a5e-8229-5f3cdd370703.png" width = "400" height = "400">

Using the following R code:

```
table(results$moduleMembership$membership)
```

I was able to observe that the number of communities does indeed change as the resolution increases (even when it may not be apparent in the graphs), indicating that the parameter is being implemented as expected. The tables for communities (top row) and number of members (bottom row) of the networks generated using resolution values 1, 2, 3, and 5 can be found in the figures below. The maximum number of communities for this network appears to be 72.

**Louvain, resolution = 1**
<img src = "https://user-images.githubusercontent.com/28693536/175823401-a89a3c8f-0df7-486a-9e41-87b280ba8117.png">

**Louvain, resolution = 2**
<img src = "https://user-images.githubusercontent.com/28693536/175823405-26a5f81c-834c-4685-b01b-8c01d0b2b8f6.png">

**Louvain, resolution = 3**
<img src = "https://user-images.githubusercontent.com/28693536/175823407-f86673e1-6174-4c0f-9fbc-e845318eb537.png">

**Louvain, resolution = 5**
<img src = "https://user-images.githubusercontent.com/28693536/175823408-3c2e5b61-b439-4b60-8e1c-f20ce7b1f63b.png">

The Leiden method consistently outputs a network with 72 communities regardless of which resolution parameter is used in the geneConnector function. In line with this, I’m still trying to figure out what may be going wrong. I will most likely try to use the cgsdr data to test this clustering method further.

I have not tested whether the “weights” parameter works as expected, but will do so at a later time point. Lastly, it is important to note that the previously described changes in the netboxr code are currently implemented only in my forked repository, and will only be merged once the GitHub Actions bugs are resolved.



