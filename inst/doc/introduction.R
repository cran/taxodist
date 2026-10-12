## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.align = "center"
)

library(taxodist)

if (is.null(taxobase$matrix)) {
  stop(
    "The installed taxobase object does not contain the reference matrix. ",
    "Rebuild data/taxobase.rda before building this vignette."
  )
}

## ----methodology-link, eval=FALSE---------------------------------------------
# vignette("methodological-notes", package = "taxodist")

## ----taxobase-----------------------------------------------------------------
names(taxobase)
taxobase$metadata

## ----stored-lineages----------------------------------------------------------
tail(taxobase$lineage_tyrannosaurus)
tail(taxobase$lineage_homo)

## ----stored-pairwise----------------------------------------------------------
taxobase$pairwise

## ----result-structure---------------------------------------------------------
class(taxobase$pairwise)
names(taxobase$pairwise)

## ----reference-matrix---------------------------------------------------------
reference_matrix <- taxobase$matrix

inherits(reference_matrix, "dist")
attr(reference_matrix, "Size")
head(attr(reference_matrix, "Labels"))

round(
  as.matrix(reference_matrix)[1:6, 1:6],
  digits = 4
)

## ----live-lineage, eval=FALSE-------------------------------------------------
# get_lineage("Tyrannosaurus")
# get_lineage("Drosophila melanogaster")

## ----lineage-id, eval=FALSE---------------------------------------------------
# get_lineage("67263")

## ----live-distance, eval=FALSE------------------------------------------------
# result <- taxo_distance(
#   "Tyrannosaurus",
#   "Velociraptor"
# )
# 
# result
# result$distance
# result$mrca

## ----live-mrca, eval=FALSE----------------------------------------------------
# mrca("Tyrannosaurus", "Velociraptor")
# mrca("Tyrannosaurus", "Triceratops")
# mrca("Tyrannosaurus", "Homo")

## ----live-path, eval=FALSE----------------------------------------------------
# taxo_path(
#   "Tyrannosaurus",
#   "Triceratops"
# )
# 
# taxo_path(
#   "Dinosauria",
#   "Tyrannosaurus"
# )

## ----live-matrix, eval=FALSE--------------------------------------------------
# taxa <- c(
#   "Tyrannosaurus",
#   "Velociraptor",
#   "Spinosaurus",
#   "Allosaurus"
# )
# 
# mat <- distance_matrix(
#   taxa,
#   progress = TRUE
# )
# 
# mat

## ----cross-distances----------------------------------------------------------
community <- taxo_from_lineages(list(
  Tyrannosaurus = c("Biota", "Dinosauria", "Theropoda", "Tyrannosaurus"),
  Triceratops = c("Biota", "Dinosauria", "Ornithischia", "Triceratops")
))
reference <- taxo_from_lineages(list(
  Velociraptor = c("Biota", "Dinosauria", "Theropoda", "Velociraptor"),
  Homo = c("Biota", "Mammalia", "Homo")
))

cross_distances(community, reference)

## ----stored-closest-----------------------------------------------------------
taxobase$closest

## ----live-closest, eval=FALSE-------------------------------------------------
# closest_relative(
#   "Carnotaurus",
#   c(
#     "Aucasaurus",
#     "Velociraptor",
#     "Triceratops",
#     "Brachiosaurus"
#   )
# )

## ----live-focal, eval=FALSE---------------------------------------------------
# focal_distances(
#   focal = "Tyrannosaurus",
#   community = c(
#     "Velociraptor",
#     "Triceratops",
#     "Spinosaurus"
#   )
# )

## ----live-membership, eval=FALSE----------------------------------------------
# is_member("Tyrannosaurus", "Dinosauria")
# is_member("Tyrannosaurus", "Theropoda")
# is_member("Tyrannosaurus", "Ornithischia")

## ----stored-filter------------------------------------------------------------
taxobase$filter

## ----live-filter, eval=FALSE--------------------------------------------------
# taxa <- c(
#   "Tyrannosaurus",
#   "Carnotaurus",
#   "Triceratops",
#   "Velociraptor",
#   "Homo",
#   "Drosophila"
# )
# 
# filter_clade(taxa, "Dinosauria")
# filter_clade(taxa, "Theropoda")

## ----live-comparison, eval=FALSE----------------------------------------------
# shared_clades(
#   "Tyrannosaurus",
#   "Triceratops"
# )
# 
# compare_lineages(
#   "Carnotaurus",
#   "Tyrannosaurus"
# )

## ----analysis-matrix----------------------------------------------------------
labels <- attr(reference_matrix, "Labels")[1:8]

example_matrix <- stats::as.dist(
  as.matrix(reference_matrix)[labels, labels]
)

example_matrix

## ----clustering, fig.width=7, fig.height=5------------------------------------
clustering <- taxo_cluster(
  example_matrix,
  method = "average"
)

plot(
  clustering,
  main = "Taxonomic hierarchy distance clustering",
  xlab = "",
  sub = ""
)

## ----taxo-tree, eval=requireNamespace("ape", quietly = TRUE), fig.width=7, fig.height=4----
lineages <- taxo_from_lineages(list(
  Tyrannosaurus = c("Biota", "Dinosauria", "Theropoda", "Tyrannosaurus"),
  Velociraptor = c("Biota", "Dinosauria", "Theropoda", "Velociraptor"),
  Triceratops = c("Biota", "Dinosauria", "Ornithischia", "Triceratops"),
  Homo = c("Biota", "Mammalia", "Homo")
))

tree <- taxo_tree(lineages)
tree$node.label

plot(tree, show.node.label = TRUE, main = "Classification tree")

tree_distances <- distance_matrix(lineages, progress = FALSE)
all.equal(
  ape::cophenetic.phylo(tree)[labels(tree_distances), labels(tree_distances)],
  as.matrix(tree_distances)
)

## ----ordination, fig.width=7, fig.height=5------------------------------------
ordination <- taxo_ordinate(
  example_matrix,
  k = 2
)

summary(ordination)
plot(
  ordination,
  main = "Taxonomic hierarchy distance space"
)

## ----heatmap, fig.width=7, fig.height=6---------------------------------------
taxo_heatmap(
  example_matrix,
  main = "Taxonomic hierarchy distance matrix",
  col = hcl.colors(12, "YlOrRd", rev = TRUE)
)

## ----statistics-link, eval=FALSE----------------------------------------------
# vignette("statistical-applications", package = "taxodist")

## ----live-search, eval=FALSE--------------------------------------------------
# taxo_search("Panthera")
# taxo_search("Bacteria")

## ----live-resolve, eval=FALSE-------------------------------------------------
# resolved <- taxo_resolve(
#   c("Tyrannosaurus", "Nereis", "Not_a_real_taxon"),
#   within = "Animalia"
# )
# resolved
# distance_matrix(resolved)

## ----live-coverage, eval=FALSE------------------------------------------------
# taxa <- c(
#   "Tyrannosaurus",
#   "Velociraptor",
#   "Quercus",
#   "Not_a_real_taxon"
# )
# 
# check_coverage(taxa)

## ----live-cache, eval=FALSE---------------------------------------------------
# cache_info()
# clear_cache()

## ----persistent-cache, eval=FALSE---------------------------------------------
# save_cache("taxodist-cache.rds")
# clear_cache()
# load_cache("taxodist-cache.rds")

## ----default-cache, eval=FALSE------------------------------------------------
# save_cache()
# # In a later session:
# load_cache()

## ----live-bundles, eval=FALSE-------------------------------------------------
# before <- read_taxodist_bundle("analysis-2026.json")
# after <- taxo_bundle(before$resolution$input)
# compare_bundles(before, after)

## ----citation, eval=FALSE-----------------------------------------------------
# citation("taxodist")

