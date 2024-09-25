#' @export
get_instructions <- function(collapse = TRUE) {
  file_nm <- system.file(package = "sommelier", "instruction_promt.md")
  instructions <- readLines(file_nm)
  if (collapse) {
    instructions <- paste0(instructions, collapse = " ")
  }
  instructions
}
