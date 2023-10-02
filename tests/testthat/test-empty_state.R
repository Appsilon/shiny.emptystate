describe("EmptyStateManager", {
  it("should be R6 & EmptyStateManager class", {
    test_class <- EmptyStateManager$new("test_id")
    expect_true(R6::is.R6(test_class))
    expect_s3_class(test_class, "EmptyStateManager")
  })

  it("should initialize with is_empty_state_show FALSE", {
    test_class <- EmptyStateManager$new("test_id")
    expect_false(test_class$is_empty_state_show())
  })

  it("should contain default_empty_state_component when no content is passed", {
    test_class <- EmptyStateManager$new("test_id")
    expect_equal(
      test_class$.__enclos_env__$private$.html_content,
      as.character(default_empty_state_component())
    )
  })

  it("should contain passed color", {
    test_class <- EmptyStateManager$new("test_id", color = "navy")
    expect_equal(test_class$.__enclos_env__$private$.color, "navy")
  })

  it("checks if manager class object cannot be modified (class should be locked)", {
    test_class <- EmptyStateManager$new("test_id")
    expect_error(test_class$new_member <- 1)
    expect_error(test_class$is_empty_state_show <- function() TRUE)
    expect_error(test_class$hide <- function() FALSE)
    expect_error(test_class$show <- function() TRUE)
  })

  it("checks the empty state component is visible when triggered", {
    skip_on_cran()
    expected_div <-
      "<div class=\"empty-state-content\"><div class=\"myDiv\"></div></div>"
    app <- shinytest2::AppDriver$new(test_app(), name = "test")
    app$click("show")
    expect_equal(
      app$get_html(selector = ".empty-state-content"),
      as.character(expected_div)
    )
    app$stop()
  })

  it("checks the empty state component is hidden when not triggered", {
    skip_on_cran()
    app <- shinytest2::AppDriver$new(test_app(), name = "test")
    expect_null(app$get_html(selector = ".empty-state-content"))
    app$stop()
  })

  it("checks the empty state component is hidden when triggered", {
    skip_on_cran()
    app <- shinytest2::AppDriver$new(test_app(), name = "test")
    app$click("show")
    app$click("hide")
    expect_null(app$get_html(selector = ".empty-state-content"))
    app$stop()
  })

  it("checks the empty state component follows slider from id", {
    app <- shinytest2::AppDriver$new(test_slider_app(), name = "slide_tag")
    position_1 <- app$get_html(selector = "#container2")
    app$click("toggle_pannel")
    position_2 <- app$get_html(selector = "#container2")
    expect_false(position_1 == position_2)
    app$stop()
  })
})

describe("use_empty_state()", {
  test_func <- use_empty_state()
  src_files <- list(
    "emptystate.css",
    "emptystate.js"
  )

  it("should add source files properly", {
    expect <- paste0(
      '<link href=\"/', src_files[[1]],
      '\" rel=\"stylesheet\" />\n<script src=\"/',
      src_files[[2]], '\"></script>'
    )
    test_dep <- htmltools::renderDependencies(list(test_func))
    expect_equal(!!as.character(test_dep), !!expect)
  })

  it("should add dependencies properly", {
    expect_equal(test_func$name, "shiny.emptystate")
    expect_equal(test_func$package, "shiny.emptystate")
    expect_equal(test_func$script, src_files[[2]])
    expect_equal(test_func$stylesheet, src_files[[1]])
  })
})
