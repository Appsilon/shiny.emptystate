const resizeObserver = new ResizeObserver((entries) => {
  entries.forEach(entry => {

    document.querySelectorAll(".empty-state-container").forEach(emptyStateContainer => {
      const parentElementDimensions = emptyStateContainer.parentElement.getBoundingClientRect();
      emptyStateContainer.style.height = parentElementDimensions.height + "px";
      emptyStateContainer.style.width = parentElementDimensions.width + "px";
      emptyStateContainer.style.left = parentElementDimensions.left + "px";
      emptyStateContainer.style.top = parentElementDimensions.top + "px";
    })
  })
});

function createEmptyStateContentElement(htmlContent) {
  const emptyStateContentElement = document.createElement("div");
  emptyStateContentElement.innerHTML = htmlContent;

  emptyStateContentElement.classList.add("empty-state-content");

  return emptyStateContentElement;
}

function createEmptyStateContainer(elementToReplace) {
  const emptyStateContainer = document.createElement("div");

  const elementToReplaceDimensions = elementToReplace.getBoundingClientRect();
  emptyStateContainer.style.position = "absolute";

  const fieldsToCopy = ["bottom", "height", "left", "right", "top", "width"];
  for (const field of fieldsToCopy) {
    emptyStateContainer.style[field] = elementToReplaceDimensions[field] + "px";
  }

  emptyStateContainer.classList.add("empty-state-container");

  return emptyStateContainer;
}

function findElementById(elementId) {
  const element = document.querySelector(`#${elementId}`);

  if (element === null) {
    throw `Unable to find element #${elementId}`;
  }

  return element;
}

function showEmptyState(message) {
  const elementId = message.id;
  const emptyStateContent = message.html_content;

  const white = "#FFFFFF"
  const backgroundColor = (message.color === null) ? white : message.color;

  elementToReplace = findElementById(elementId);

  const emptyStateContainer = createEmptyStateContainer(elementToReplace);
  const emptyStateContentElement = createEmptyStateContentElement(emptyStateContent);
  emptyStateContainer.appendChild(emptyStateContentElement);

  emptyStateContainer.style.backgroundColor = backgroundColor;

  elementToReplace.appendChild(emptyStateContainer);

  resizeObserver.observe(elementToReplace);
}

function hideEmptyState(message) {
  const elementId = message.id;

  const elementWithEmptyState = findElementById(elementId);
  const emptyStateContainer = elementWithEmptyState.querySelector(".empty-state-container");

  emptyStateContainer.remove();
  resizeObserver.unobserve(elementToReplace);
}

$(function() {
  Shiny.addCustomMessageHandler("showEmptyState", showEmptyState)
  Shiny.addCustomMessageHandler("hideEmptyState", hideEmptyState)

  window.addEventListener("resize", function() {
    document.querySelectorAll(".empty-state-container").forEach(emptyStateContainer => {
      const parentElementDimensions = emptyStateContainer.parentElement.getBoundingClientRect();
      emptyStateContainer.style.height = parentElementDimensions.height + "px";
      emptyStateContainer.style.width = parentElementDimensions.width + "px";
      emptyStateContainer.style.left = parentElementDimensions.left + "px";
      emptyStateContainer.style.top = parentElementDimensions.top + "px";
    })
  })
})
