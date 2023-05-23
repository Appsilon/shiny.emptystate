describe("empty_state_component()", {
  test_component <- empty_state_component(
    fontawesome::fa(
      name = "clipboard-question",
      height = "15rem", width = "15rem"
    ),
    title = "Content is not available",
    subtitle = "Please provide valid inputs to generate content."
  )

  it("should return a shiny.tag object", {
    expect_s3_class(test_component, "shiny.tag")
  })
  it("should return the expected empty state component", {
    expect_snapshot(test_component, cran = FALSE)
  })
})
