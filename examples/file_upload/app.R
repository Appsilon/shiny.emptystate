library(dplyr)
library(shiny)
library(shiny.emptystate)
library(shinyjs)
library(reactable)

empty_state_content <- div(
  style = "display: flex; justify-content: center; align-items: center; flex-direction: column",
  img(
    src = "https://gw.alipayobjects.com/zos/antfincdn/ZHrcdLPrvN/empty.svg",
    style = "height: 180px; width: 270px; margin-bottom: 8px;",
  ),
  div(
    style = "font-size: 16px",
    "No Dataset Uploaded"
  ),
  actionButton(
    inputId = "upload_trigger",
    label = "Upload Dataset",
    onclick = "document.querySelector('#upload').click();",
    style = "
      margin-top: 16px;
      background-color: #1890ff;
      color: #fff;
      border-color: #1890ff;
      box-shadow: 0 2px #0000000b;
      font-weight: 400;
    ",
  )
)

ui <- fluidPage(
  use_empty_state(),
  useShinyjs(),
  div(
    style = "display: flex; justify-content: center; align-items: center; height: 100vh",
    div(
      id = "table_container",
      reactableOutput("table", width = "1000px", height = "400px")
    ),
    shinyjs::hidden(fileInput("upload", label = "upload"))
  )
)

server <- function(input, output, session) {
  empty_state_manager <- EmptyStateManager$new(
    id = "table_container",
    html_content = empty_state_content
  )

  empty_state_manager$show()

  dataset <- reactiveVal()

  uploaded_dataset <- reactive({
    shiny::req(input$upload)
    readRDS(input$upload$datapath)
  })


  observeEvent(uploaded_dataset(), {
    if (nrow(uploaded_dataset()) > 0) {
      dataset(uploaded_dataset())
      empty_state_manager$hide()
    } else {
      empty_state_manager$show()
    }
  })

  output$table <- renderReactable({
    shiny::req(dataset())
    reactable(dataset())
  })
}

shinyApp(ui, server)
