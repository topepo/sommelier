data_notes <- function(predictors, outcome = NULL) {
  notes <- character(0)
  notes <- c(notes, zv_notes(predictors))

  notes
}

zv_notes <- function(predictors) {
  # initial exclusions for having a single unique value

  zv_cols <- purrr::map_lgl(predictors, is_zv)
  if (any(zv_cols)) {
    zv_names <- names(predictors)[zv_cols]
    zv_ind <- which(zv_cols)
    zv_count <- sum(zv_cols)
    zv_note <-
      cli::format_inline("There are {zv_count} predictor{?s} that have a single
                          unique value and should be excluded from the data:
                          {zv_names}.")
  } else {
    zv_note <- character(0)
  }
  zv_note
}

quant_col_notes <- function(predictors) {
  notes <- character(0)

  quant_cols <- quant_predictor_find(predictors)




}
