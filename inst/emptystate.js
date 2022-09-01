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
}

function hideEmptyState(message) {
  const elementId = message.id;

  const elementWithEmptyState = findElementById(elementId);
  const emptyStateContainer = elementWithEmptyState.querySelector(".empty-state-container");

  emptyStateContainer.remove();
}

$(function() {
  Shiny.addCustomMessageHandler("showEmptyState", showEmptyState)
  Shiny.addCustomMessageHandler("hideEmptyState", hideEmptyState)
})
