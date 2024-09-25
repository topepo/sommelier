#' Invoke a chatbot to help write tidymodels code
#'
#' This function uses a large language model (LLM) to process a user's questions
#' and return instructions and code.
#'
#' @param model A character string for the LLM model.
#' @return Nothing since users have to quit the discussion. However, the history
#' of the chat is saved in `.Last.chat.result`.
#' @export
tm_chat <- function(model = "gpt-4o-mini") {
  # TODO This needs a better name
  # TODO Use anthropic instead
  chat <- elmer::new_chat_openai(
    model = model,
    system_prompt = get_instructions(),
    echo = TRUE
  )

  tryCatch(
    chat$console(),
    interrupt = function(cnd) NULL
  )

  invisible(chat)
}

# TODO
# - general human factors/user interaction issues thought out
