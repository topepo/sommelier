#' Extract instruction prompt
#'
#' Pull the instruction prompt used by the package into R.
#' @param collapse A logical: should the instructions be returned as a single
#' character string (the default) or a character vector.
#' @return A character vector.
#' @examples
#' substring(get_instructions(), 1, 23)
#' @export
get_instructions <- function(collapse = TRUE) {
  file_nm <- system.file(package = "sommelier", "instruction_promt.md")
  instructions <- readLines(file_nm)
  if (collapse) {
    instructions <- paste0(instructions, collapse = " ")
  }
  instructions
}
