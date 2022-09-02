library(shiny)
library(shiny.emptystate)

ui <- fluidPage(
  use_empty_state(),
  actionButton("show", "Show empty state!"),
  actionButton("hide", "Hide empty state!"),
  reactable::reactableOutput("my_table")
)

server <- function(input, output, session) {
  empty_state_content <- div(
    style = "display: flex; justify-content: center; align-items: center; flex-direction: column",
    img(
      src = "https://gw.alipayobjects.com/zos/antfincdn/ZHrcdLPrvN/empty.svg",
      style = "height: 180px; width: 270px; margin-bottom: 8px;",
    ),
    div(
      style = "font-size: 16px",
      "This is  example empty state content"
    )
  )

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
