
qual_predictor_find <- function(x) {
  is_nom <- purrr::map_lgl(x, ~ is.factor(.x) | is.character(.x))
  names(is_nom)[is_nom]
}

qual_skew <- function(x) {
  if (length(x) == 1) {
    res <- 0.0
  } else {
    res <- x[1] / x[2]
  }
  res
}

qual_predictor_descr <- function(x) {
  n <- nrow(x)
  tbl <- purrr::map(x, ~ sort(table(.x), decreasing = TRUE))
  lvls <- purrr::map_int(x, vctrs::vec_unique_count)
  minor <- purrr::map_dbl(tbl, ~ min(.x) / n)
  major <- purrr::map_dbl(tbl, ~ max(.x) / n)
  skew <- purrr::map_dbl(tbl, qual_skew)
  miss <- purrr::map_int(x, ~ mean(is.na(.x)))
  tibble::new_tibble(
    list(
      column = names(x),
      skewness = skew,
      num_unique = lvls,
      minor_pct = minor,
      major_pct = major,
      pct_missing = miss
    )
  )
}
