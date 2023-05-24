#' Create an empty state component
#'
#' @param content an HTML, tag object to render
#' @param title a character, main text to describe empty state content
#' @param subtitle a character, supporting details about the empty state;
#' defaults to `NULL`
#'
#' @return a shiny.tag.
#' @export
#'
#' @details
#' `content` works best with [fontawesome::fa()] and [bsicons::bs_icon()].
#' [shiny::icon()] will also work, but this will require loading the
#' html dependencies in the ui, i.e. calling [fontawesome::fa_html_dependency()]
#' to use icons from FontAwesome.Glyphicon does not need any html dependency.
#'
#'
#' @examples
#'
#' library(shiny.emptystate)
#'
#' if (interactive()) {
#'   empty_state_component(
#'     fontawesome::fa(name = "clipboard-question", height = "10rem"),
#'     title = "Content is not available",
#'     subtitle = "Please provide valid inputs to generate content."
#'   )
#'
#'   empty_state_component(
#'     bsicons::bs_icon(
#'       name = "question-square",
#'       height = "15rem"
#'     ),
#'     title = "Content is not available",
#'     subtitle = "Please provide valid inputs to generate content."
#'   )
#' }
empty_state_component <- function(content, title, subtitle = NULL) {
  htmltools::tags$div(
    class = "empty-state-component",
    htmltools::tags$div(class = "empty-state-card", content),
    htmltools::tags$span(class = "empty-state-title", title),
    htmltools::tags$span(class = "empty-state-subtitle", subtitle)
  )
}

default_empty_state_component <- function() {
  empty_state_component(
    fontawesome::fa(
      name = "clipboard-question",
      height = "10rem"
    ),
    title = "Content is not available",
    subtitle = "Please provide valid inputs to generate content."
  )
}
