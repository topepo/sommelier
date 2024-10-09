#' Invoke a chatbot to help write tidymodels code
#'
#' This function uses a large language model (LLM) to process a user's questions
#' and return instructions and code.
#'
#' @details
#'
#' The function specifically uses Antropic's Claude tools. You will need an API
#' key for that system. To set it, create an environmental variable named
#' `ANTHROPIC_API_KEY` or declare it in your local projects `.Renviron` file.
#' We suggest the latter using [usethis::edit_r_environ()].
#'
#' @return An object of class `Chat` (and `R6`) with the conversation.
#' @export
recommend <- function() {
  chat <- elmer::chat_claude(
    system_prompt = get_instructions(),
    echo = TRUE
  )

  elmer::live_browser(chat)

  invisible(chat)
}

