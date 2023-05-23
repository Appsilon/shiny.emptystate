#' Create an empty state component
#'
#' @param content an HTML, tag object to render
#' @param title a character, main text to describe empty state content
#' @param subtitle a character, supporting details about the empty state;
#' defaults to `NULL`
#'
#' @return an shiny.tag.
#' @export
#'
#' @examples
#'
#' library(shiny.emptystate)
#'
#' if (interactive()) {
#'   empty_state_component(
#'     fontawesome::fa(
#'       name = "clipboard-question",
#'       height = "15rem", width = "15rem"
#'     ),
#'     title = "Content is not available",
#'     subtitle = "Please provide valid inputs to generate content."
#'   )
#' }
empty_state_component <- function(content, title, subtitle = NULL) {
  htmltools::tags$div(
    class = "empty-state-component",
    content,
    htmltools::tags$span(class = "empty-state-title", title),
    htmltools::tags$span(class = "empty-state-subtitle", subtitle)
  )
}
