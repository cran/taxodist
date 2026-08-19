## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(taxodist)

## ----ultrametric-check--------------------------------------------------------
m <- as.matrix(taxobase$statistical_matrix)
tolerance <- sqrt(.Machine$double.eps)

ultrametric_ok <- function(index) {
  i <- index[1]
  j <- index[2]
  k <- index[3]

  d_ij <- m[i, j]
  d_ik <- m[i, k]
  d_jk <- m[j, k]

  d_ij <= max(d_ik, d_jk) + tolerance &&
    d_ik <= max(d_ij, d_jk) + tolerance &&
    d_jk <= max(d_ij, d_ik) + tolerance
}

all(combn(seq_len(nrow(m)), 3, FUN = ultrametric_ok))

