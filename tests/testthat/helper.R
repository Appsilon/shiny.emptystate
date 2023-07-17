extract_content <- function(html_tag, selector) {
  htmltools::tagQuery(html_tag)$find(selector)$selectedTags()[[1]]$children[[1]]
}

test_app <- function() {
  shiny::shinyApp(
    ui =
      shiny::fluidPage(
        use_empty_state(),
        shiny::actionButton("show", "Show empty state!"),
        shiny::actionButton("hide", "Hide empty state!"),
        shiny::tableOutput("my_table")
      ),
    server =
      function(input, output) {
        empty_state_content <- htmltools::div(class = "myDiv")
        empty_state_manager <-
          EmptyStateManager$new(
            id = "my_table",
            html_content = empty_state_content)
        shiny::observeEvent(input$show, {
          empty_state_manager$show()
        })
        shiny::observeEvent(input$hide, {
          empty_state_manager$hide()
        })
        output$my_table <- shiny::renderTable(data.frame(NA))
      }
  )
}
