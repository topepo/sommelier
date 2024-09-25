
return_chat <- function(x, model = "unknown") {
  res <- purrr::map_dfr(x$messages(), msg_format)
  res$order <- 1:nrow(res)
  res$model <- model
  res$date <- date()
  res[order(res$order), c("role", "message", "model", "date", "order")]
}

msg_format <- function(x) {
  tibble::new_tibble(list(role = x$role, message = x$content))
}

.stash_last_result <- function(x) {
  if (! "org:r-lib" %in% search()) {
    do.call("attach", list(new.env(), pos = length(search()),
                           name = "org:r-lib"))
  }
  env <- as.environment("org:r-lib")
  env$.Last.chat.result <- x
  invisible(NULL)
}
