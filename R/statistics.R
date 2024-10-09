
# placeholders to replace once we enable case weights

stat_num_unique <- vctrs::vec_unique_count
stat_skew <- e1071::skewness
stat_missingness <- function(x) mean(is.na(x))

xtab <- function(x, wts = NULL) sort(table(x), decreasing = TRUE) # recipes:::weighted_table
stat_class_skew <- function(tab, wts = NULL) {
  if (length(tab) == 1) {
    res <- 0.0
  } else {
    res <- tab[1] / tab[2]
  }
  res
}


is_zv <- function(x) {
  vctrs::vec_unique_count(x) == 1
}
