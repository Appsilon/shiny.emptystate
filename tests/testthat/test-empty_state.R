describe("EmptyStateManager", {
  test_class <- EmptyStateManager$new("test_id")

  # function for type check
  class_type_tests <- function(manager_class){
    expect_true(R6::is.R6(manager_class))
    expect_s3_class(manager_class, "EmptyStateManager")
  }

  # function to test sanity of public members
  public_member_tests <- function(manager_class){
    expect_true(exists("show", manager_class))
    expect_true(exists("hide", manager_class))
    expect_true(exists("clone", manager_class))
    expect_true(exists("initialize", manager_class))
    expect_true(exists("is_empty_state_show", manager_class))
    expect_false(manager_class$is_empty_state_show())
  }

  # function to test sanity of private members
  private_member_tests <- function(manager_class, id_attr,
                                   html_attr = default_empty_state_component(),
                                   color_attr = NULL){
    expect_equal(manager_class$.__enclos_env__$private$.id, id_attr)
    expect_equal(manager_class$.__enclos_env__$private$.html_content,
                 as.character(html_attr))
    expect_equal(manager_class$.__enclos_env__$private$.color,
                 color_attr)
  }

  test_that("manager class can be instantiated", {
    class_type_tests(manager_class = test_class)
  })

  test_that("manager class's public components exists", {
    public_member_tests(manager_class = test_class)
  })

  test_that("manager class's private components exists", {
    test_class <- EmptyStateManager$new("test_id",
                                        color = "navy")

    private_member_tests(manager_class = test_class,
                         id_attr = "test_id",
                         color_attr = "navy")
  })

  test_that("manager class can be cloned properly", {
    test_class_cloned <- test_class$clone(deep = TRUE)

    class_type_tests(manager_class = test_class_cloned)
    public_member_tests(manager_class = test_class_cloned)
    private_member_tests(manager_class = test_class_cloned,
                         id_attr = "test_id")
  })

  test_that("manager class object cannot be modified (class should be locked)", {
    expect_error(test_class$new_member <- 1)
    expect_error(test_class$is_empty_state_show <- function() TRUE)
    expect_error(test_class$hide <- function() FALSE)
    expect_error(test_class$show <- function() TRUE)
  })
})

describe("use_empty_state()", {
  test_func <- use_empty_state()
  src_files <- list("emptystate.css",
                    "emptystate.js")

  test_that("source files are added properly", {
    expect <- paste(
      '<link href=\"/', src_files[[1]],
      '\" rel=\"stylesheet\" />\n<script src=\"/',
      src_files[[2]],'\"></script>',
      sep = "")
    test_dep <- htmltools::renderDependencies(list(test_func))
    expect_equal(!!as.character(test_dep), !!expect)
  })

  test_that("dependencies are added properly", {
    expect_equal(test_func$name, "shiny.emptystate")
    expect_equal(test_func$package, "shiny.emptystate")
    expect_equal(test_func$script, src_files[[2]])
    expect_equal(test_func$stylesheet, src_files[[1]])
  })
})
