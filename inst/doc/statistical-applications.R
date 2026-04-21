## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)
library(taxodist)

## ----taxa---------------------------------------------------------------------
# taxa_brazil <- c(
#   "Priodontes", "Myrmecophaga", "Chrysocyon", "Tapirus", "Didelphis",
#   "Leontopithecus", "Brachyteles",
#   "Panthera", "Pteronura", "Puma",
#   "Sotalia", "Pontoporia",
#   "Trichechus", "Mazama", "Blastocerus"
# )

## ----matrix-------------------------------------------------------------------
# library(taxodist)
# mat <- distance_matrix(taxa_brazil)
# print(mat)
# #>                Priodontes Myrmecophaga Chrysocyon    Tapirus  Didelphis
# #> Myrmecophaga   0.01639344
# #> Chrysocyon     0.01694915   0.01694915
# #> Tapirus        0.01694915   0.01694915 0.01587302
# #> Didelphis      0.01754386   0.01754386 0.01754386 0.01754386
# #> Leontopithecus 0.01694915   0.01694915 0.01666667 0.01666667 0.01754386
# #> Brachyteles    0.01694915   0.01694915 0.01666667 0.01666667 0.01754386
# #> Panthera       0.01694915   0.01694915 0.01492537 0.01587302 0.01754386
# #> Pteronura      0.01694915   0.01694915 0.01470588 0.01587302 0.01754386
# #> Puma           0.01694915   0.01694915 0.01492537 0.01587302 0.01754386
# #> Sotalia        0.01694915   0.01694915 0.01587302 0.01562500 0.01754386
# #> Pontoporia     0.01694915   0.01694915 0.01587302 0.01562500 0.01754386
# #> Trichechus     0.01666667   0.01666667 0.01694915 0.01694915 0.01754386
# #> Mazama         0.01694915   0.01694915 0.01587302 0.01562500 0.01754386
# #> Blastocerus    0.01694915   0.01694915 0.01587302 0.01562500 0.01754386

## ----ape, fig.width = 7, fig.height = 5---------------------------------------
# library(ape)
# 
# cl   <- taxo_cluster(taxa_brazil)
# tree <- ape::as.phylo(cl$hclust)
# 
# plot(tree,
#      main      = "Threatened Mammals of Brazil",
#      cex       = 0.85,
#      tip.color = "gray20")

## ----ape-newick---------------------------------------------------------------
# ape::write.tree(tree, file = "taxa_brazil.nwk")

## ----taxondive----------------------------------------------------------------
# set.seed(123)
# library(vegan)
# 
# comm <- matrix(c(
#   1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,   # xenarthrans + marsupial
#   0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,   # primates + carnivores
#   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1    # cetaceans + sirenian + ungulates
# ), nrow = 3, byrow = TRUE)
# 
# colnames(comm) <- taxa_brazil
# rownames(comm) <- c("community_A", "community_B", "community_C")
# 
# vegan::taxondive(comm, mat)
# #>               Species      Delta       Delta*     Lambda+     Delta+     S Delta+
# #> community_A  3.0000e+00  1.7160e-02  1.7160e-02  2.9410e-07  1.7160e-02   0.0515
# #> community_B  5.0000e+00  1.5905e-02  1.5905e-02  8.8325e-07  1.5905e-02   0.0795
# #> community_C  5.0000e+00  1.5750e-02  1.5750e-02  1.1834e-06  1.5750e-02   0.0788
# #> Expected                -9.9265e-02  1.6544e-02              1.6457e-02

## ----mantel-------------------------------------------------------------------
# set.seed(42)
# coords <- matrix(rnorm(30), ncol = 2)
# rownames(coords) <- taxa_brazil
# geo_dist <- dist(coords)
# 
# vegan::mantel(mat, geo_dist)
# #> Mantel statistic based on Pearson's product-moment correlation
# #>
# #> Call:
# #> vegan::mantel(xdis = mat, ydis = geo_dist)
# #>
# #> Mantel statistic r: -0.0569
# #>       Significance: 0.653
# #>
# #> Upper quantiles of permutations (null model):
# #>   90%   95% 97.5%   99%
# #> 0.188 0.237 0.272 0.336
# #> Permutation: free
# #> Number of permutations: 999

## ----mantel-spearman----------------------------------------------------------
# vegan::mantel(mat, geo_dist, method = "spearman", permutations = 9999)
# #> Mantel statistic based on Spearman's rank correlation rho
# #>
# #> Call:
# #> vegan::mantel(xdis = mat, ydis = geo_dist, method = "spearman",
# #>     permutations = 9999)
# #>
# #> Mantel statistic r: -0.07405
# #>       Significance: 0.672
# #>
# #> Upper quantiles of permutations (null model):
# #>   90%   95% 97.5%   99%
# #> 0.189 0.244 0.293 0.353
# #> Permutation: free
# #> Number of permutations: 9999

## ----permanova----------------------------------------------------------------
# groups <- c(
#   "xenarthra", "xenarthra", "carnivore", "ungulate",  "marsupial",
#   "primate",   "primate",
#   "carnivore", "carnivore", "carnivore",
#   "cetacean",  "cetacean",
#   "sirenian",  "ungulate",  "ungulate"
# )
# 
# vegan::adonis2(mat ~ groups)
# #> Permutation test for adonis under reduced model
# #> Permutation: free
# #> Number of permutations: 999
# #>
# #> vegan::adonis2(formula = mat ~ groups)
# #>          Df  SumOfSqs      R2      F Pr(>F)
# #> Model     6 0.00100049 0.52646 1.4823  0.001 ***
# #> Residual  8 0.00089992 0.47354
# #> Total    14 0.00190041 1.00000
# #> ---
# #> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

## ----workflow-----------------------------------------------------------------
# library(taxodist)
# library(vegan)
# library(ape)
# 
# # 1. define taxa
# taxa_brazil <- c(
#   "Priodontes", "Myrmecophaga", "Chrysocyon", "Tapirus", "Didelphis",
#   "Leontopithecus", "Brachyteles",
#   "Panthera", "Pteronura", "Puma",
#   "Sotalia", "Pontoporia",
#   "Trichechus", "Mazama", "Blastocerus"
# )
# 
# # 2. compute distance matrix
# mat <- distance_matrix(taxa_brazil)
# 
# # 3. hierarchical clustering and phylo plot
# cl   <- taxo_cluster(taxa_brazil)
# tree <- ape::as.phylo(cl$hclust)
# plot(tree, main = "Threatened Mammals of Brazil", cex = 0.85)
# 
# # 4. PCoA ordination
# ord <- taxo_ordinate(mat)
# plot(ord, main = "PCoA: Taxonomic Distance Space")
# 
# # 5. PERMANOVA
# groups <- c(
#   "xenarthra", "xenarthra", "carnivore", "ungulate",  "marsupial",
#   "primate",   "primate",
#   "carnivore", "carnivore", "carnivore",
#   "cetacean",  "cetacean",
#   "sirenian",  "ungulate",  "ungulate"
# )
# vegan::adonis2(mat ~ groups)

