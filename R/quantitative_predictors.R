quant_predictor_find <- function(x) {
  is_num <- purrr::map_lgl(x, is.numeric)
  names(is_num)[is_num]
}

quant_univariate <- function(x) {
  skew <- purrr::map_dbl(x, stat_skew)
  uni <- purrr::map_int(x, stat_num_unique)
  miss <- purrr::map_int(x, ~ stat_missingness)
  tibble::new_tibble(
    list(
      column = names(x),
      skewness = skew,
      num_unique = uni,
      pct_missing = miss
    )
  )
}

# pca or pair-wise correlations
quant_corr <- function(x) x
