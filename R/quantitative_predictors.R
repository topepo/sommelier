quant_predictor_find <- function(x) {
  is_num <- purrr::map_lgl(x, is.numeric)
  names(is_num)[is_num]
}

quant_univariate <- function(x) {
  skew <- purrr::map_dbl(x, stat_skew)
  uni <- purrr::map_int(x, stat_num_unique)
  miss <- purrr::map_dbl(x, stat_missingness)
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


quant_cor <- function(x, wts = NULL, threshold = 0.9) {
  num_vars <- ncol(x)

  if (num_vars == 1) {
    return(0.0)
  }
  if (is.null(wts)) {
    cor_mat <- cor(x, use = "pairwise.complete.obs")
  } else {
    no_na <- complete.cases(x)
    x <- x[no_na, ]
    wts <- wts[no_na]
    cor_mat <- stats::cov.wt(x, wt = wts, cor = TRUE)$cor
  }

  e_vals <- eigen(cor_mat)
  variance_val <- e_vals$values
  variance_cum <- cumsum(variance_val) / sum(variance_val)
  variance_cum
}
