const intersectionObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    const emptyStateContainer = entry.target.querySelector(".empty-state-container");
    const parentElement = emptyStateContainer.parentElement;
    const isVisible = entry.isIntersecting;

    if (isVisible) {
      emptyStateContainer.style.height = parentElement.offsetHeight + "px";
      emptyStateContainer.style.width = parentElement.offsetWidth + "px";
      emptyStateContainer.style.left = parentElement.offsetLeft + "px";
      emptyStateContainer.style.top = parentElement.offsetTop + "px";
    }
  });
}, {
  root: null,
  rootMargin: '0px',
  threshold: 1.0 // Fully visible
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

  // Observe the emptyStateContainer with the IntersectionObserver
  intersectionObserver.observe(elementToReplace);

  return emptyStateContainer;
}

function findElementById(elementId) {
  const element = document.querySelector(`#${elementId}`);

  if (element === null) {
    throw `Unable to find element #${elementId}`;
  }

  return element;
}

function showEmptyState(elementId, htmlContent, color) {
  const emptyStateContent = htmlContent;

  const white = "#FFFFFF"
  const backgroundColor = (color === null) ? white : color;

  const elementToReplace = document.getElementById(elementId);
  let emptyStateContainer = elementToReplace.querySelector(".empty-state-container");

  if (!emptyStateContainer) {
    // If the element doesn't have an empty state container, create one
    emptyStateContainer = createEmptyStateContainer(elementToReplace);
    elementToReplace.parentElement.insertBefore(emptyStateContainer, elementToReplace.nextSibling);
  }

  const emptyStateContentElement = createEmptyStateContentElement(emptyStateContent);
  emptyStateContainer.innerHTML = ''; // Clear existing content
  emptyStateContainer.appendChild(emptyStateContentElement);

  emptyStateContainer.style.backgroundColor = backgroundColor;
}

function hideEmptyState(message) {
  const elementId = message.id;
  const elementWithEmptyState = findElementById(elementId);
  const emptyStateContainer = elementWithEmptyState.querySelector(".empty-state-container");

  if (emptyStateContainer) {
    emptyStateContainer.remove();
  }
}

function repositionEmptyState() {
  const emptyStateContainers = document.querySelectorAll(".empty-state-container");

  emptyStateContainers.forEach(emptyStateContainer => {
    const parentElement = emptyStateContainer.parentElement;
    emptyStateContainer.style.height = parentElement.offsetHeight + "px";
    emptyStateContainer.style.width = parentElement.offsetWidth + "px";
    emptyStateContainer.style.left = parentElement.offsetLeft + "px";
    emptyStateContainer.style.top = parentElement.offsetTop + "px";
  });
}

function observeDOMChanges() {
  const targetNode = document.getElementById("container-wrapper");

  const mutationObserver = new MutationObserver(mutationsList => {
    repositionEmptyState();
  });

  const config = { attributes: true, childList: true, subtree: true };

  mutationObserver.observe(targetNode, config);
}

$(function() {
  debugger;
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

  observeDOMChanges();
})
