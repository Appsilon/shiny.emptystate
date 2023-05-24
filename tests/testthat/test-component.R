describe("empty_state_component()", {
  test_component <- empty_state_component(
    fontawesome::fa(name = "clipboard-question", height = "10rem"),
    title = "Content is not available",
    subtitle = "Please provide valid inputs to generate content."
  )

  it("should return a shiny.tag object", {
    expect_s3_class(test_component, "shiny.tag")
  })

  it("should return the expected empty state component", {
    expect_snapshot(test_component, cran = FALSE)
  })

  it("should include the title in the created element", {
    component_title <- "My Title"
    empty_state_title <- empty_state_component(content = "", title = component_title)
    expect_identical(extract_content(empty_state_title, ".empty-state-title"), component_title)
  })

  it("should include the subtitle in the created element", {
    component_subtitle <- "My Subtitle"
    empty_state_subtitle <-
      empty_state_component(content = "", title = NULL, subtitle = component_subtitle)
    expect_identical(
      extract_content(empty_state_subtitle, ".empty-state-subtitle"), component_subtitle
    )
  })

  it("should include the provided content", {
    component_blank <- shiny::tags$div(class = "myDiv")
    component <- empty_state_component(content = component_blank, title = NULL)
    expect_identical(extract_content(component, ".empty-state-card"), component_blank)

    component_icon <- fontawesome::fa("clipboard-question", height = "10rem")
    empty_state_icon <- empty_state_component(content = component_icon, title = NULL)
    expect_identical(extract_content(empty_state_icon, ".empty-state-card"), component_icon)
  })
})
