## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.align = "center"
)

library(taxodist)

vegan_available <- requireNamespace("vegan", quietly = TRUE)
ape_available <- requireNamespace("ape", quietly = TRUE)

if (is.null(taxobase$statistical_matrix)) {
  stop(
    "The installed taxobase object does not contain statistical_matrix. ",
    "Rebuild data/taxobase.rda before building this vignette."
  )
}

## ----data---------------------------------------------------------------------
taxa <- taxobase$statistical_taxa
mat <- taxobase$statistical_matrix

taxobase$metadata
length(taxa)
inherits(mat, "dist")
identical(attr(mat, "Labels"), taxa)

## ----taxa---------------------------------------------------------------------
taxa

## ----matrix-summary-----------------------------------------------------------
summary(as.vector(mat))
range(mat)

round(
  as.matrix(mat)[1:6, 1:6],
  digits = 5
)

## ----clustering, fig.width=7, fig.height=5------------------------------------
clustering <- taxo_cluster(mat, method = "average")

clustering$hclust
summary(clustering$hclust$height)

plot(
  clustering,
  main = "Average-linkage clustering of taxonomic hierarchy distances",
  xlab = "",
  sub = ""
)

## ----ape-tree, eval=ape_available, fig.width=7, fig.height=5------------------
tree <- ape::as.phylo(clustering$hclust)

plot(
  tree,
  main = "Tree representation of a taxonomic distance dendrogram",
  cex = 0.8
)

## ----ape-export, eval=FALSE---------------------------------------------------
# ape::write.tree(tree, file = "taxonomic-distance-dendrogram.nwk")

## ----pcoa---------------------------------------------------------------------
ordination <- taxo_ordinate(mat, k = 2)

positive_eigenvalues <- ordination$eig[ordination$eig > 0]
variance_percent <- 100 * positive_eigenvalues / sum(positive_eigenvalues)

ordination_summary <- data.frame(
  Axis = c("PC1", "PC2"),
  Eigenvalue = ordination$eig[1:2],
  Variance_percent = variance_percent[1:2],
  Cumulative_percent = cumsum(variance_percent)[1:2]
)

ordination_summary
100 * ordination$GOF[1]
sum(ordination$eig < -sqrt(.Machine$double.eps))

## ----pcoa-plot, fig.width=7, fig.height=5-------------------------------------
plot(
  ordination,
  main = "PCoA of taxonomic hierarchy distances"
)

## ----community----------------------------------------------------------------
comm <- matrix(
  c(
    1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,1,1,1,1,1
  ),
  nrow = 3,
  byrow = TRUE,
  dimnames = list(
    c("community_A", "community_B", "community_C"),
    taxa
  )
)

comm

## ----taxondive, eval=vegan_available------------------------------------------
taxonomic_diversity <- vegan::taxondive(comm, mat)

taxonomic_diversity_table <- data.frame(
  Species = taxonomic_diversity$Species,
  Delta = taxonomic_diversity$D,
  Delta_star = taxonomic_diversity$Dstar,
  Lambda_plus = taxonomic_diversity$Lambda,
  Delta_plus = taxonomic_diversity$Dplus,
  SD_Delta_plus = taxonomic_diversity$sd.Dplus
)

taxonomic_diversity_table

## ----mantel, eval=vegan_available---------------------------------------------
set.seed(42)

coordinates <- matrix(
  rnorm(2 * length(taxa)),
  ncol = 2,
  dimnames = list(taxa, c("x", "y"))
)

geographic_distance <- stats::dist(coordinates)

mantel_result <- vegan::mantel(
  mat,
  geographic_distance,
  method = "pearson",
  permutations = 999
)

mantel_result

## ----groups-------------------------------------------------------------------
groups <- factor(c(
  "xenarthran", "xenarthran",
  "carnivoran",
  "ungulate",
  "marsupial",
  "primate", "primate",
  "carnivoran", "carnivoran", "carnivoran",
  "cetacean", "cetacean",
  "sirenian",
  "ungulate", "ungulate"
))

table(groups)

## ----permanova, eval=vegan_available------------------------------------------
set.seed(42)

permanova_result <- vegan::adonis2(
  mat ~ groups,
  permutations = 999
)

permanova_result

## ----dispersion, eval=vegan_available-----------------------------------------
dispersion <- vegan::betadisper(mat, groups)

anova(dispersion)

set.seed(42)
vegan::permutest(
  dispersion,
  permutations = 999
)

## ----live-workflow, eval=FALSE------------------------------------------------
# library(taxodist)
# 
# taxa <- c(
#   "Tyrannosaurus",
#   "Velociraptor",
#   "Spinosaurus",
#   "Allosaurus"
# )
# 
# coverage <- check_coverage(taxa)
# stopifnot(all(coverage))
# 
# mat <- distance_matrix(taxa)
# 
# clustering <- taxo_cluster(mat, method = "average")
# ordination <- taxo_ordinate(mat, k = 2)
# 
# plot(clustering)
# plot(ordination)

## ----citations, eval=FALSE----------------------------------------------------
# citation("taxodist")
# citation("vegan")
# citation("ape")

