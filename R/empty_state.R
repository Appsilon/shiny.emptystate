#' Add empty state dependency
#'
#' @description
#' Empty state dependencies to include anywhere in your UI but ideally at the top.
#'
#' @return a html_dependency object
#'
#' @examples
#' library(shiny)
#' library(shiny.emptystate)
#'
#' if (interactive()) {
#'   ui <- fluidPage(
#'     use_empty_state(),
#'     dataTableOutput("my_table")
#'   )
#' }
#'
#' @importFrom htmltools htmlDependency
#' @importFrom utils packageVersion
#' @export
use_empty_state <- function() {
  htmlDependency(
    name = "shiny.emptystate",
    version = packageVersion("shiny.emptystate"),
    src = "",
    package = "shiny.emptystate",
    script = "emptystate.js",
    stylesheet = "emptystate.css"
  )
}

#' EmptyStateManager R6 class
#' @description
#' Creates an EmptyStateManager to then show or hide content.
#'
#' @details
#' Creates an object to show an empty state content on selected id specified by \code{id} parameter.
#' Then \code{show} or \code{hide} or use \code{is_empty_state_show} to check the status.
#'
#' @return EmptyStateManager R6 class
#'
#' @examples
#' library(shiny)
#' library(shiny.emptystate)
#' library(fontawesome)
#'
#' ui <- fluidPage(
#'   use_empty_state(),
#'   actionButton("show", "Show empty state!"),
#'   actionButton("hide", "Hide empty state!"),
#'   tableOutput("my_table")
#' )
#'
#' server <- function(input, output) {
#'   # Creating a custom empty state component
#'   empty_state_content <- empty_state_component(
#'     content = fa("eye-slash", height = "10rem", fill = "#808000"),
#'     title = "Hide empty state to see table",
#'     subtitle = "This empty state uses a FontAwesome icon."
#'   )
#'
#'   # Initialize a new empty state manager object
#'   manager_object <- EmptyStateManager$new(
#'     id = "my_table",
#'     html_content = empty_state_content
#'   )
#'
#'   observeEvent(input$show, {
#'     # Show empty state
#'     manager_object$show()
#'   })
#'
#'   observeEvent(input$hide, {
#'     # Hide empty state
#'     manager_object$hide()
#'   })
#'
#'   output$my_table <- renderTable(mtcars)
#' }
#'
#' if (interactive()) {
#'   shinyApp(ui = ui, server = server)
#' }
#'
#' @importFrom R6 R6Class
#' @importFrom shiny getDefaultReactiveDomain
#' @importFrom htmltools doRenderTags
#' @export
EmptyStateManager <- R6Class( # nolint: object_name_linter
  classname = "EmptyStateManager",
  public = list(

    #' @description
    #' Creates a new empty state manager object.
    #' @param id id of element which should be covered with `html_content`
    #' @param html_content Content for empty state.
    #' Defaults to `default_empty_state_component()`
    #' @param color Background color of empty state content.
    #' Defaults to `NULL`
    #' @return A new `EmptyStateManager` R6 class object.
    initialize = function(id, html_content = default_empty_state_component(), color = NULL) {
      private$.id <- id
      private$.html_content <- private$process_html(html_content)
      private$.color <- color
    },

    #' @description
    #' Returns the current visibility state of the empty state UI.
    #' Defaults to `FALSE`
    #' @return boolean, `TRUE`/`FALSE`
    is_empty_state_show = function() {
      private$empty_state_shown
    },

    #' @description
    #' Show empty state component.
    #' @return Nothing, it changes state of empty state
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

    #' @description
    #' Hides empty state component.
    #' @return Nothing, it changes state of empty state
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
      getDefaultReactiveDomain()
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
      rendered_tags <- doRenderTags(html)

      as.character(rendered_tags)
    }
  )
)
