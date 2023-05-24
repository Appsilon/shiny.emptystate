extract_content <- function(html_tag, selector) {
  htmltools::tagQuery(html_tag)$find(selector)$selectedTags()[[1]]$children[[1]]
}
