library(shiny)
library(shiny.emptystate)
library(bslib)

ui <- page(
  theme = bs_theme(version = 5),
  use_empty_state(),
  tags$button(
    "Toggle panel",
    class = "btn btn-primary",
    onClick = "$('#container1').toggle(anim = 'slide', function(){shiny_emptystate_updatePosition('container2')});"
  ),
  div(
    style = "width: 300px",
    class = "d-flex flex-column gap-5",
    div(
      id = "container1",
      div(
        h1("Card 1"),
        "Card content"
      )
    ),
    div(
      id = "container2",
      div(
        h1("Card 2"),
        "Card content"
      )
    )
  )
)

server <- function(input, output, session) {
  empty_state_content <- div(
    "This is example empty state content"
  )
  empty_state_manager <- EmptyStateManager$new(
    id = "container2",
    html_content = empty_state_content
  )
  empty_state_manager$show()
}

shinyApp(ui, server)
