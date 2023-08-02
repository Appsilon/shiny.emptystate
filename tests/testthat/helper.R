extract_content <- function(html_tag, selector) {
  htmltools::tagQuery(html_tag)$find(selector)$selectedTags()[[1]]$children[[1]]
}

test_app <- function() {
  shiny::shinyApp(
    ui = shiny::fluidPage(
      use_empty_state(),
      shiny::actionButton("show", "Show empty state!"),
      shiny::actionButton("hide", "Hide empty state!"),
      shiny::tableOutput("my_table")
    ),
    server = function(input, output) {
      empty_state_content <- htmltools::div(class = "myDiv")
      empty_state_manager <- EmptyStateManager$new(
        id = "my_table",
        html_content = empty_state_content
      )
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

test_slider_app <- function() {
  shiny::shinyApp(
    ui = shiny::fillPage(
      use_empty_state(),
      shiny::actionButton(
        "toggle_pannel",
        "Toggle panel",
        class = "btn btn-primary",
        onClick = "$('#container1').toggle(anim = 'slide',
        function(){shiny_emptystate_updatePosition('container2')});"
      ),
      shiny::div(
        style = "width: 300px",
        class = "d-flex flex-column gap-5",
        shiny::div(
          id = "container1",
          shiny::div(
            shiny::h1("Card 1"),
            "Card content"
          )
        ),
        shiny::div(
          id = "container2",
          shiny::div(
            shiny::h1("Card 2"),
            "Card content"
          )
        )
      )
    ),
    server = function(input, output) {
      empty_state_content <- shiny::div(
        "This is example empty state content"
      )
      empty_state_manager <- EmptyStateManager$new(
        id = "container2",
        html_content = empty_state_content
      )
      empty_state_manager$show()
    }
  )
}
