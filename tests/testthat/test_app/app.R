library(shiny)
library(shiny.emptystate)

ui <- fluidPage(
  use_empty_state(),
  actionButton("show", "Show empty state!"),
  actionButton("hide", "Hide empty state!"),
  reactable::reactableOutput("my_table")
)

server <- function(input, output, session) {
  empty_state_content <- div(class = "myDiv")

  empty_state_manager <- EmptyStateManager$new(
    id = "my_table",
    html_content = empty_state_content
  )

  observeEvent(input$show, {
    empty_state_manager$show()
  })

  observeEvent(input$hide, {
    empty_state_manager$hide()
  })

  output$my_table <- reactable::renderReactable({
    reactable::reactable(iris)
  })
}

shinyApp(ui, server)
