data_notes <- function(predictors, outcome = NULL, original_call) {
  notes <- task_note(predictors, outcome,original_call)
  notes <- c(notes, zv_notes(predictors))
  notes <- c(notes, quant_notes(predictors))

  notes
}

add_notes <- function(x, notes) {
  num_rows <- length(x)
  note_ind <- grep("^DATANOTES", x)
  if (length(notes) > 0) {
    x <- c(x[1:(note_ind - 1)], notes, x[(note_ind + 1):num_rows])
  } else {
    x <- x[-note_ind]
  }
  x
}

check_data_name <- function(x) {
  alt_x <- make.names(x)
  flag <- !identical(x, alt_x)
  flag <- flag | identical(x, ".")
  if (flag) {
    cli::cli_warn("The dataset name passed to the function was {.val {x}}. This
                  does not appear to be a valid object name. The chat output
                  will refer to the data frame as {.val unknown_name} in the
                  output.")
    x <- "unknown_name"
  }
  x
}

task_note <- function(predictors, outcome, original_call) {
  data_name <- deparse(original_call$data)
  data_name <- check_data_name(data_name)
  outcome_name <- names(outcome)
  y <- outcome[[outcome_name]]

  if (inherits(y, "factor")) {
    lvls <- levels(y)
    num_lvls <- length(lvls)
    type <- paste("a classification model (with", num_lvls, "classes)")

  } else if (inherits(y, "Surv")) {
    type <- paste("a censored regression model")
  } else {
    type <- paste("a regression model")
  }

  cli::format_inline("The goal of this task is to produce {type} using the
                      {.val {data_name}} data frame that contains an  outcome
                      column called {.val {outcome_name}} and {ncol(predictors)}
                      predictors. Please confine your answers to this specific
                      data set and outcome column.", keep_whitespace = FALSE)
}

var_msg <- function(cols, msg = character(0)) {
  count <- length(cols)
  cols <- cli::cli_vec(cols, style = list("vec-trunc" = Inf))
  cli::format_inline("{count} predictor{?s} {msg}: {cols}.", keep_whitespace = FALSE)
}


zv_notes <- function(predictors) {
  # initial exclusions for having a single unique value

  zv_cols <- purrr::map_lgl(predictors, is_zv)
  if (any(zv_cols)) {
    zv_names <- names(predictors)[zv_cols]
    zv_ind <- which(zv_cols)
    zv_note <-
      var_msg(zv_names, "has a single unique value and should be excluded
                         from the data")
  } else {
    zv_note <- character(0)
  }
  zv_note
}

quant_notes <- function(predictors, skew = 1, max_miss = 0.3, pca_threshold = .9) {
  notes <- character(0)
  zv_cols <- purrr::map_lgl(predictors, is_zv)
  predictors <- predictors[, !zv_cols]
  num_vars <- ncol(predictors)

  quant_cols <- quant_predictor_find(predictors)
  quant_info <- quant_univariate(predictors[, quant_cols])

  # TODO note to convert binary ind to factor for naive bayes?

  # ------------------------------------------------------------------------------
  # check for skewness

  high_skew <- quant_info$skewness > skew
  if (any(high_skew)) {
    skew_cols <- quant_info$column[high_skew]
    skew_note <- var_msg(skew_cols, "exhibit very skewed distributions")
    notes <- c(notes, skew_note)
  }

  # ------------------------------------------------------------------------------
  # Missigness. A definitive task is given for very incomplete data and otherwise
  # a note is shown.

  has_miss <- quant_info$pct_missing > 0
  if (any(has_miss)) {
    high_miss <- quant_info$pct_missing > max_miss
    if (any(high_miss)) {
      high_miss_cols <- quant_info$column[high_miss]
      high_miss_note <-
        var_msg(high_miss_cols,
                "have too much missing data and should be removed from the analysis.")
      notes <- c(notes, high_miss_note)
    }

    low_miss <- has_miss & !high_miss
    if (any(low_miss)) {
      low_miss_cols <- quant_info$column[low_miss]
      low_miss_note <- var_msg(low_miss_cols, "contain missing values.")
      notes <- c(notes, low_miss_note)
    }
  }

  # ------------------------------------------------------------------------------
  # High correlation between predictors

  pca_cumulative <- quant_cor(predictors[, quant_cols])
  num_comp <- which.min(pca_cumulative > pca_threshold)
  pct_comp <- num_comp / num_vars
  if (pct_comp < 3 / 4) {
    corr_adjective <-
      dplyr::case_when(
        pct_comp <= 0.1 ~ "extreme",
        pct_comp >  0.1 & pct_comp < 0.3 ~ "severe",
        TRUE ~ "moderate"
      )
    cor_note <-
      cli::format_inline("There is {corr_adjective} multicollinearity in the numeric predictors.")
    notes <- c(notes, cor_note)
  }

  notes
}
