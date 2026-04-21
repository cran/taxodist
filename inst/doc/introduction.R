## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)
library(taxodist)

## ----lineage------------------------------------------------------------------
# lin <- get_lineage("Tyrannosaurus")
# tail(lin, 8)
# #> [1] "Avetheropoda"     "Coelurosauria"    "Tyrannoraptora"   "Tyrannosauroidea"
# #> [5] "Tyrannosauridae"  "Tyrannosaurinae"  "Tyrannosaurini"   "Tyrannosaurus"

## ----lineage-species----------------------------------------------------------
# lin <- get_lineage("Drosophila melanogaster")
# tail(lin, 4)
# #> [1] "Ephydroidea"             "Drosophilidae"           "Drosophilinae"
# #> [4] "Drosophila melanogaster"

## ----distance-----------------------------------------------------------------
# result <- taxo_distance("Tyrannosaurus", "Velociraptor")
# print(result)
# #> -- Taxonomic Distance --
# #>
# #> * Tyrannosaurus vs Velociraptor
# #>   Distance : 0.0153846153846154
# #>   MRCA : Tyrannoraptora (depth 65)
# #>   Depth A : 70
# #>   Depth B : 73

## ----distance-far-------------------------------------------------------------
# taxo_distance("Tyrannosaurus", "Homo")$distance        # 0.02777778
# taxo_distance("Tyrannosaurus", "Drosophila")$distance  # 0.06666667
# taxo_distance("Tyrannosaurus", "Quercus")$distance     # 0.25
# taxo_distance("Escherichia", "Homo")$distance          # 1

## ----mrca---------------------------------------------------------------------
# mrca("Tyrannosaurus", "Velociraptor")  # "Tyrannoraptora"
# mrca("Tyrannosaurus", "Triceratops")   # "Dinosauria"
# mrca("Tyrannosaurus", "Homo")          # "Amniota"
# mrca("Tyrannosaurus", "Drosophila")    # "Nephrozoa"
# mrca("Tyrannosaurus", "Quercus")       # "discaria"

## ----matrix-------------------------------------------------------------------
# taxa <- c(
#   "Tyrannosaurus", "Carnotaurus", "Triceratops",
#   "Parasaurolophus", "Stegosaurus", "Brachiosaurus",
#   "Homo sapiens", "Homo neanderthalensis", "Pan troglodytes",
#   "Panthera leo", "Canis lupus",
#   "Ornithorhynchus anatinus",
#   "Loxodonta africana",
#   "Struthio camelus",
#   "Aptenodytes forsteri",
#   "Ara ararauna",
#   "Crocodylus niloticus",
#   "Chelonia mydas",
#   "Ambystoma mexicanum",
#   "Octopus vulgaris",
#   "Carcharodon carcharias",
#   "Balaenoptera musculus",
#   "Drosophila melanogaster",
#   "Apis mellifera",
#   "Arabidopsis thaliana",
#   "Quercus robur",
#   "Ginkgo biloba",
#   "Welwitschia mirabilis",
#   "Saccharomyces cerevisiae",
#   "Escherichia coli",
#   "Bacillus subtilis",
#   "Plasmodium falciparum"
# )
# mat <- distance_matrix(taxa)
# print(mat)

## ----clustering---------------------------------------------------------------
# cl <- taxo_cluster(taxa)
# plot(cl)

## ----PCoA---------------------------------------------------------------------
# ord <- taxo_ordinate(taxa)
# summary(ord)
# plot(ord)

## -----------------------------------------------------------------------------
# taxo_heatmap(taxa)

## ----closest------------------------------------------------------------------
# closest_relative(
#   "Carnotaurus",
#   c("Aucasaurus", "Velociraptor", "Triceratops",
#     "Brachiosaurus", "Homo sapiens", "Apis mellifera")
# )
# #>            taxon   distance
# #> 1     Aucasaurus 0.01515152
# #> 2   Velociraptor 0.01666667
# #> 4  Brachiosaurus 0.01754386
# #> 3    Triceratops 0.01818182
# #> 5   Homo sapiens 0.02777778
# #> 6 Apis mellifera 0.06666667

## ----compare------------------------------------------------------------------
# compare_lineages("Carnotaurus", "Tyrannosaurus")
# #> -- Lineage Comparison --
# #> MRCA: Averostra at depth 60
# #>
# #> Shared lineage (60 nodes):
# #>   Biota ... Theropoda
# #>
# #> Carnotaurus only (7 nodes):
# #> Ceratosauria
# #> Neoceratosauria
# #> Abelisauroidea
# #> Abelisauria
# #> Abelisauridae
# #> Carnotaurinae
# #> Carnotaurus
# #>
# #> Tyrannosaurus only (10 nodes):
# #> Tetanurae
# #> Orionides
# #> ...

## ----shared-------------------------------------------------------------------
# # what do a fly and a beetle have in common?
# shared_clades("Drosophila melanogaster", "Tribolium castaneum")
# # returns their shared lineage from Biota down to their MRCA
# 
# # what do T. rex and a rose share?
# shared_clades("Tyrannosaurus rex", "Rosa agrestis")

## ----membership---------------------------------------------------------------
# is_member("Tyrannosaurus", "Theropoda")          # TRUE
# is_member("Carnotaurus", "Abelisauridae")        # TRUE
# is_member("Triceratops", "Theropoda")            # FALSE
# is_member("Homo sapiens", "Amniota")             # TRUE
# is_member("Drosophila melanogaster", "Insecta")  # TRUE
# is_member("Quercus robur", "Animalia")           # FALSE

## ----filter-------------------------------------------------------------------
# taxa <- c("Tyrannosaurus", "Carnotaurus", "Triceratops",
#           "Velociraptor", "Homo sapiens", "Drosophila melanogaster",
#           "Quercus robur", "Saccharomyces cerevisiae")
# 
# filter_clade(taxa, "Dinosauria")
# #> [1] "Tyrannosaurus" "Carnotaurus"   "Triceratops"   "Velociraptor"
# 
# filter_clade(taxa, "Theropoda")
# #> [1] "Tyrannosaurus" "Carnotaurus"   "Velociraptor"
# 
# filter_clade(taxa, "Animalia")
# #> [1] "Tyrannosaurus"          "Carnotaurus"
# #> [3] "Triceratops"            "Velociraptor"
# #> [5] "Homo sapiens"           "Drosophila melanogaster"

## ----coverage-----------------------------------------------------------------
# taxa <- c("Tyrannosaurus", "Velociraptor", "Apis mellifera", "Fakeosaurus")
# check_coverage(taxa)
# #>  Tyrannosaurus  Velociraptor  Apis mellifera    Fakeosaurus
# #>           TRUE          TRUE            TRUE          FALSE

## ----cache--------------------------------------------------------------------
# clear_cache()

## ----save-cache---------------------------------------------------------------
# save_cache("my_taxa_cache.rds") # at the end of a session
# 
# load_cache("my_taxa_cache.rds") # at the start of the next session, before any distance calls

