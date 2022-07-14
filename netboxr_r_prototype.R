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
  make_option("--geneList", type="character", help="Tab-delimited list of
genes of interest"),
  make_option("--cutoff", type="double", help="p-value cutoff value"),
  make_option("--networkPlot", type="logical", help="Plot of edge-annotated
netboxr graph"),
  make_option("--neighborList", type="logical", help="File containing the
information of all neighbor nodes")
)
parser <- OptionParser(usage = "%prog [options] file", option_list =
                         option_list)
args = parse_args(parser)
# Vars
geneList = scan(args$geneList, what = character(), sep = "\t")
print(geneList)
cutoff = args$cutoff
networkPlot = args$networkPlot
print(networkPlot)
neighborList = args$neighborList
print(neighborList)
# Network analysis as described in netboxr vignette
sifNetwork <- netbox2010$network
graphReduced <- networkSimplify(sifNetwork, directed = FALSE)
threshold <- cutoff
results <- geneConnector(geneList = geneList, networkGraph = graphReduced,
                         directed = FALSE, pValueAdj = "BH", pValueCutoff = threshold,
                         communityMethod = "ebc", keepIsolatedNodes = FALSE)
edges <- results$netboxOutput
interactionType <- unique(edges[, 2])
interactionTypeColor <- brewer.pal(length(interactionType), name =
                                     "Spectral")
edgeColors <- data.frame(interactionType, interactionTypeColor,
                         stringsAsFactors = FALSE)
colnames(edgeColors) <- c("INTERACTION_TYPE", "COLOR")
netboxGraphAnnotated <- annotateGraph(netboxResults = results, edgeColors =
                                        edgeColors, directed = FALSE, linker = TRUE)
# Check the p-value of the selected linker
linkerDF <- results$neighborData
linkerDF[linkerDF$pValueFDR < threshold, ]
graph_layout <- layout_with_fr(results$netboxGraph)
## Output
# Plot the edge annotated graph
if (networkPlot) {
  pdf("network_plot.pdf", width=8)
  plot(results$netboxCommunity, netboxGraphAnnotated, layout = graph_layout,
       vertex.size = 10, vertex.shape = V(netboxGraphAnnotated)$shape, edge.color
       = E(netboxGraphAnnotated)$interactionColor, edge.width = 3)
  # Add interaction type annotations
  legend(x = -1.8, y = -1, legend = interactionType, col =
           interactionTypeColor, lty = 1, lwd = 2, bty = "n", cex = 1)
  dev.off()
}
# Save neighbor data
if (neighborList) {
  write.table(results$neighborData, file = "neighbor_data.txt", sep = "\t",
              quote = FALSE, col.names = TRUE, row.names = FALSE)
}
