#' Create an empty state component
#'
#' @param content an HTML, tag object to render
#' @param title a character, main text to describe empty state content
#' @param subtitle a character, supporting details about the empty state;
#' defaults to `NULL`
#'
#' @return an shiny.tag.
#' @export
empty_state_component <- function(content, title, subtitle = NULL, ...) {
  htmltools::tags$div(
    class = "empty-state-component",
    content,
    htmltools::tags$span(class = "empty-state-title", title),
    htmltools::tags$span(class = "empty-state-subtitle", subtitle)
  )
}
