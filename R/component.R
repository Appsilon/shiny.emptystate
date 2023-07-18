#' Create an empty state component
#'
#' @description
#' Function to create a custom empty state component.
#'
#' @param content An HTML tag object used to render & provides main content for the empty state.
#' @param title A character string representing the main text that describes the empty state content.
#' @param subtitle A character string providing supporting details about the empty state.
#' Defaults to `NULL`
#'
#' @return a shiny.tag.
#'
#' @details
#' `content` works best with [fontawesome::fa()] and [bsicons::bs_icon()].
#' [shiny::icon()] will also work, but this will require loading the
#' html dependencies in the ui, i.e. calling [fontawesome::fa_html_dependency()]
#' to use icons from FontAwesome.Glyphicon does not need any html dependency.
#'
#' @examples
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
#'       size = "15rem"
#'     ),
#'     title = "Content is not available",
#'     subtitle = "Please provide valid inputs to generate content."
#'   )
#' }
#'
#' @importFrom htmltools tags
#' @export
empty_state_component <- function(content, title, subtitle = NULL) {
  tags$div(
    class = "empty-state-component",
    tags$div(class = "empty-state-card", content),
    tags$span(class = "empty-state-title", title),
    tags$span(class = "empty-state-subtitle", subtitle)
  )
}

#' Default empty state component
#'
#' @description
#' Default empty state component, used when user doesn't provide
#' any value while initializing new EmptyStateManager object.
#' @returns a shiny.tag.
#' @importFrom fontawesome fa
default_empty_state_component <- function() {
  empty_state_component(
    fa(
      name = "clipboard-question",
      height = "10rem"
    ),
    title = "Content is not available",
    subtitle = "Please provide valid inputs to generate content."
  )
}
