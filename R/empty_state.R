#' Use empty state
#'
#' @export
use_empty_state <- function() {
  htmltools::htmlDependency(
    name = "shiny.emptystate",
    version = utils::packageVersion("shiny.emptystate"),
    src = "",
    package = "shiny.emptystate",
    script = "emptystate.js",
    stylesheet = "emptystate.css"
  )
}

#' EmptyStateManager class
#'
#' @importFrom R6 R6Class
#' @importFrom shiny getDefaultReactiveDomain
#' @importFrom fontawesome fa
#' @importFrom htmltools doRenderTags
#'
#' @export
EmptyStateManager <- R6::R6Class( # nolint: object_name_linter
  classname = "EmptyStateManager",
  public = list(
    #' @param id id
    #' @param html_content html_content
    #' @param color color
    initialize = function(id, html_content = default_empty_state_component(), color = NULL) {
      private$.id <- id
      private$.html_content <- private$process_html(html_content)
      private$.color <- color
    },
    #' Returns the current visibility state of the empty state UI
    is_empty_state_show = function() {
      private$empty_state_shown
    },
    #' Show empty state
    show = function() {
      session <- private$get_session()

      message <- private$create_show_message()

      if (!private$empty_state_shown) {
        private$empty_state_shown <- TRUE
        session$sendCustomMessage(
          "showEmptyState",
          message
        )
      }
    },

    #' Hide empty state
    hide = function() {
      session <- private$get_session()

      message <- private$create_hide_message()

      if (private$empty_state_shown) {
        private$empty_state_shown <- FALSE
        session$sendCustomMessage(
          "hideEmptyState",
          message
        )
      }
    }
  ),
  private = list(
    .id = NA,
    .html_content = NA,
    .color = NA,
    empty_state_shown = FALSE,
    get_session = function() {
      shiny::getDefaultReactiveDomain()
    },
    create_show_message = function() {
      list(
        id = private$.id,
        html_content = private$.html_content,
        color = private$.color
      )
    },
    create_hide_message = function() {
      list(
        id = private$.id
      )
    },
    process_html = function(html) {
      rendered_tags <- htmltools::doRenderTags(html)

      as.character(rendered_tags)
    }
  )
)
