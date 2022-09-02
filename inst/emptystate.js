const resizeObserver = new ResizeObserver((entries) => {
  entries.forEach(entry => {

    document.querySelectorAll(".empty-state-container").forEach(emptyStateContainer => {
      const parentElement = emptyStateContainer.parentElement;
      emptyStateContainer.style.height = parentElement.offsetHeight + "px";
      emptyStateContainer.style.width = parentElement.offsetWidth + "px";
      emptyStateContainer.style.left = parentElement.offsetLeft + "px";
      emptyStateContainer.style.top = parentElement.offsetTop + "px";
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

  emptyStateContainer.style.position = "absolute";

  emptyStateContainer.style.height = elementToReplace.offsetHeight + "px";
  emptyStateContainer.style.width = elementToReplace.offsetWidth + "px";
  emptyStateContainer.style.left = elementToReplace.offsetLeft + "px";
  emptyStateContainer.style.top = elementToReplace.offsetTop + "px";

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
      const parentElement= emptyStateContainer.parentElement;
      emptyStateContainer.style.height = parentElement.offsetHeight + "px";
      emptyStateContainer.style.width = parentElement.offsetWidth + "px";
      emptyStateContainer.style.left = parentElement.offsetLeft + "px";
      emptyStateContainer.style.top = parentElement.offsetTop + "px";
    })
  })
})
