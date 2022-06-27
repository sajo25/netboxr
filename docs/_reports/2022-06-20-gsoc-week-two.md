---
layout: post
title:  "Week Two | GitHub Actions bugs and Galaxy tool interface"
tags: gsoc
author: Sara J
---

## Tasks

1. **[Fix remaining GitHub Actions bugs](https://github.com/mil2041/netboxr/issues/7)**
    Status: **In progress**
    Branch: **None**
    PR: **None**
        
      1a. [Add tests to netboxr for existing examples](https://github.com/mil2041/netboxr/issues/22)

      1b. [The Date field is over a month old](https://github.com/mil2041/netboxr/issues/21)

      1c. [Use of orphaned gtools?](https://github.com/mil2041/netboxr/issues/19)

      1d. [Non-Standard Files Found](https://github.com/mil2041/netboxr/issues/18)

      1e. [Example Taking Too Long](https://github.com/mil2041/netboxr/issues/17)

      1f. [Fix: Namespace in Imports field not imported from: 'gtools'](https://github.com/mil2041/netboxr/issues/16)
        
2. **Make detailed plan for Galaxy tool interface**
    Status: **In progress**
    Branch: **None**
    PR: **None** 
        
3. **Meeting with supervisors**
    Status: **Thursday**
    Branch: **None**
    PR: **None** 

## Progress report

Load Human Interactions Network (HIN) network
Load altered gene list
Map altered gene list on HIN network
- Implemented option for different community discovery methods and resolution
- Implemented option for multiple outputs (community membership, node type, etc.)
- Implemented statistical analysis options

Alternative Module Discovery Methods
Statistical Significance of Discovered Network
    Global Network Null Model
    Local Network Null Model
Write NetBox Output to Files

Term Enrichment in Modules using Gene Ontology (GO) Analysis
Alternative Pathway Data   
    Using Tabular Simple Interaction Format (SIF)-Based Network Data
    Using PaxtoolsR for Pathway Commons Data
Selecting Input Gene Lists for use with NetBox
+ weights


<img src = "https://user-images.githubusercontent.com/28693536/175997315-48cddc0f-7ae1-4c59-9b56-ad866186a699.png" width = "350" height = "350">


```
# Set up R error handling to go to stderr
options(show.error.messages=F,
        error=function(){cat(geterrmessage(),file=stderr());q("no",1,F)})

# Avoid crashing Galaxy with an UTF8 error on German LC settings
loc <- Sys.setlocale("LC_MESSAGES", "en_US.UTF-8")

# Import required libraries and data
suppressPackageStartupMessages({
  library(optparse)
  library(netboxr)
  library(igraph)
  library(RColorBrewer)
})

data(netbox2010)

option_list <- list(
  make_option("--geneList", type="character", help="Tab-delimited list of genes of interest"),
  make_option("--cutoff", type="double", help="p-value cutoff value"),
  make_option("--communityMethod", type="character", help="commumanity detection method"),
  make_option("--resolutionParam", type="integer", help="community size"),
  #make_option("--networkType", type="character", help="edge weights"),
  #make_option("--weightsInput", type="", help="edge weights"),
  make_option("--globalModel", type="logical", help="Used to assess the global connectivity 
              (number of nodes and edges) of the largest module in the identified network 
              compared with the same number but randomly selected gene list"),
  make_option("--localModel", type="logical", help="Used to assess the network modularity in 
              the identified network compared with random re-wired network"),
  
  make_option("--networkPlot", type="logical", help="Plot of edge-annotated netboxr graph"),
  make_option("--outputSIF", type="logical", help="NetBox algorithm output in SIF format"),
  make_option("--neighborList", type="logical", help="Contains information of all neighbor nodes"),
  make_option("--moduleMembership", type="logical", help="Identified pathway module numbers"),
  make_option("--nodeType", type="logical", help="Indicates whether node is linker or candidate")
)
parser <- OptionParser(usage = "%prog [options] file", option_list = option_list)
args = parse_args(parser)

# Vars
geneList = scan(args$geneList, what = character(), sep = "\t")
cutoff = args$cutoff
communityMethod = args$communityMethod
resolutionParam = args$resolutionParam
#networkType = args$networkType
#weightsInput = args$weightsInput
globalModel = args$globalModel
localModel = args$localModel
networkPlot = args$networkPlot
outputSIF = args$outputSIF
neighborList = args$neighborList
moduleMembership = args$moduleMembership
nodeType = args$nodeType

# Network analysis as described in netboxr vignette
sifNetwork <- netbox2010$network
graphReduced <- networkSimplify(sifNetwork, directed = FALSE)
threshold <- cutoff
results <- geneConnector(geneList = geneList, networkGraph = graphReduced,
                         directed = FALSE, pValueAdj = "BH", pValueCutoff = threshold,
                         resolutionParam = resolutionParam, #weightsInput = weightsInput,
                         communityMethod = communityMethod, keepIsolatedNodes = FALSE)

# Check the p-value of the selected linker
linkerDF <- results$neighborData
linkerDF[linkerDF$pValueFDR < threshold, ]
graph_layout <- layout_with_fr(results$netboxGraph)

# Global Network Null Model
if (globalModel) {
  globalTest <- globalNullModel(netboxGraph = results$netboxGraph, networkGraph = graphReduced,
                                iterations = 10, numOfGenes = 274)
}

# Local Network Null Model
if (localModel) {
  localTest <- localNullModel(netboxGraph = results$netboxGraph, iterations = 10)
}

## Output
# Plot the edge annotated graph
if (networkPlot) {

  edges <- results$netboxOutput
  interactionType <- unique(edges[, 2])
  interactionTypeColor <- brewer.pal(length(interactionType), name = "Spectral")
  edgeColors <- data.frame(interactionType, interactionTypeColor, stringsAsFactors = FALSE)
  colnames(edgeColors) <- c("INTERACTION_TYPE", "COLOR")
  netboxGraphAnnotated <- annotateGraph(netboxResults = results, edgeColors =
                                        edgeColors, directed = FALSE, linker = TRUE)
  pdf("network_plot.pdf", width=8)
  plot(results$netboxCommunity, netboxGraphAnnotated, layout = graph_layout,
       vertex.size = 10, vertex.shape = V(netboxGraphAnnotated)$shape, edge.color
       = E(netboxGraphAnnotated)$interactionColor, edge.width = 3)

# Add interaction type annotations
  legend(x = -1.8, y = -1, legend = interactionType, col =
           interactionTypeColor, lty = 1, lwd = 2, bty = "n", cex = 1)
  dev.off()
}

# Local Network Null Model
#if (localModel) {
#  h <- hist(localTest$randomModularityScore, breaks = 35, plot = FALSE)
#  h$density = h$counts/sum(h$counts)
#  plot(h, freq = FALSE, ylim = c(0, 0.1), xlim = c(0.1, 0.6), col = "lightblue")
#  abline(v = localTest$modularityScoreObs, col = "red")
#  dev.off()
#}

# NetBox algorithm output in SIF format.
if (outputSIF) {
  write.table(results$netboxOutput, file = "network.sif", sep = "\t", quote = FALSE,
              col.names = FALSE, row.names = FALSE)
}

# Save neighbor data
if (neighborList) {
  write.table(results$neighborData, file = "neighbor_data.txt", sep = "\t",
              quote = FALSE, col.names = TRUE, row.names = FALSE)
}

# Save identified pathway module numbers
if (moduleMembership) {
  write.table(results$moduleMembership, file = "community.membership.txt", sep = "\t",
              quote = FALSE, col.names = FALSE, row.names = FALSE)
}

# Save file that indicates whether the node is a 'linker' or 'candidate'
if (nodeType) {
  write.table(results$nodeType, file = "nodeType.txt", sep = "\t", quote = FALSE, col.names = FALSE,
              row.names = FALSE)
}
```


```
Rscript.exe galaxy_r.R --geneList "genes.txt" --cutoff 0.05 --communityMethod "ebc" --resolutionParam 3 
--globalModel TRUE --localModel TRUE --networkPlot TRUE --outputSIF TRUE --neighborList TRUE 
--moduleMembership TRUE --nodeType TRUE
```


**Remaining tasks**
- Weekly email for report?
- On Monday, ask supervisors whether Go Analysis should be part of Galaxy tool
- Writing examples/tests for Louvain and Leiden community detection methods, and resolution and weights parameters
- Does R output show up anywhere on Galaxy? 
- Cutoff value - selected via drop-down menu, slider? How many options?
- Finish and test neboxr Galaxy R file via command line
- Start working on netboxr Galaxy XML file
- Learn about Galaxy tool deployment
- number of iterations for local and global null models? What does the number of genes mean? Plotting – should we let users choose their own dimensions? Making everything as customizable as possible but avoiding giving users decision fatigue
What should be, at minimum, the preselected Galaxy tool output?
For the cagsr package, should I start uploading the datasets?
For the R code, short form of args? Necessary or not? Also, having different names?
Should graphical output be pdf?



**Discussion points for next meeting**
- What should the input options for the Galaxy tool be? Give multiple options vs force specific format? 
- How would the input change if the list of genes is generated using method described in vignette (cgdsr package)?
- Plotting for local network null model - histogram?
- Should we also generate a meta file containing summary of selected parameteers and relevant R (console) output? What else would that file contain?
- Separate options T/F for analysis and plots? Eg. local null model. How many options to give users?


