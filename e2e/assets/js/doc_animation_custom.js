import { animate } from "motion"

const reducedMotion = () =>
  window.matchMedia("(prefers-reduced-motion: reduce)").matches

function applyClosedHeight(el) {
  el.style.opacity = "0"
  el.style.height = "0px"
  el.style.overflow = "hidden"
}

function applyOpenHeight(el) {
  el.style.opacity = ""
  el.style.height = ""
  el.style.overflow = ""
}

function initCustomCollections() {
  document
    .querySelectorAll('[data-scope="accordion"][data-part="root"][data-animation="custom"]')
    .forEach((rootEl) => {
      rootEl
        .querySelectorAll('[data-scope="accordion"][data-part="item-content"]')
        .forEach((el) => {
          if (el.dataset.state !== "open") applyClosedHeight(el)
        })
    })
  document
    .querySelectorAll('[data-scope="tree-view"][data-part="root"][data-animation="custom"]')
    .forEach((rootEl) => {
      rootEl
        .querySelectorAll('[data-scope="tree-view"][data-part="branch-content"]')
        .forEach((el) => {
          if (el.dataset.state !== "open") applyClosedHeight(el)
        })
    })
}

document.addEventListener("DOMContentLoaded", initCustomCollections)
window.addEventListener("phx:page-loading-stop", initCustomCollections)

function findAccordionContent(root, value) {
  return root.querySelector(
    `[data-scope="accordion"][data-part="item"][data-value="${CSS.escape(value)}"] [data-part="item-content"]`,
  )
}

function findTreeBranch(root, value) {
  return root.querySelector(
    `[data-scope="tree-view"][data-part="branch-content"][data-value="${CSS.escape(value)}"]`,
  )
}

document.addEventListener("my-accordion-changed", (e) => {
  const root = document.getElementById(e.detail.id)
  if (!root) return
  const { added, removed } = e.detail
  if (reducedMotion()) {
    added.forEach((v) => { const el = findAccordionContent(root, v); if (el) applyOpenHeight(el) })
    removed.forEach((v) => { const el = findAccordionContent(root, v); if (el) applyClosedHeight(el) })
    return
  }
  added.forEach((v) => {
    const el = findAccordionContent(root, v)
    if (el) animate(el, { height: ["0px", "auto"], opacity: [0, 1] }, { duration: 0.3, easing: "ease-out" })
  })
  removed.forEach((v) => {
    const el = findAccordionContent(root, v)
    if (el) animate(el, { height: ["auto", "0px"], opacity: [1, 0] }, { duration: 0.3, easing: "ease-out" })
  })
})

document.addEventListener("my-tree-view-changed", (e) => {
  const root = document.getElementById(e.detail.id)
  if (!root) return
  const { added, removed } = e.detail
  if (reducedMotion()) {
    added.forEach((v) => { const el = findTreeBranch(root, v); if (el) applyOpenHeight(el) })
    removed.forEach((v) => { const el = findTreeBranch(root, v); if (el) applyClosedHeight(el) })
    return
  }
  added.forEach((v) => {
    const el = findTreeBranch(root, v)
    if (el) animate(el, { height: ["0px", "auto"], opacity: [0, 1] }, { duration: 0.3, easing: "ease-out" })
  })
  removed.forEach((v) => {
    const el = findTreeBranch(root, v)
    if (el) animate(el, { height: ["auto", "0px"], opacity: [1, 0] }, { duration: 0.3, easing: "ease-out" })
  })
})

document.addEventListener("my-dialog-open-changed", (e) => {
  const { id, open } = e.detail
  const root = document.getElementById(id)
  if (!root) return
  const backdrop = root.querySelector('[data-scope="dialog"][data-part="backdrop"]')
  const content = root.querySelector('[data-scope="dialog"][data-part="content"]')
  if (reducedMotion()) {
    if (backdrop) backdrop.style.opacity = open ? "" : "0"
    if (content) content.style.opacity = open ? "" : "0"
    return
  }
  if (open) {
    if (backdrop) animate(backdrop, { opacity: [0, 1] }, { duration: 0.5, easing: "ease-out" })
    if (content)
      animate(
        content,
        { opacity: [0, 1], scale: [0.7, 1], y: [60, 0], filter: ["blur(12px)", "blur(0px)"] },
        { duration: 0.7, easing: [0.16, 1, 0.3, 1] },
      )
  } else {
    if (backdrop) animate(backdrop, { opacity: [1, 0] }, { duration: 0.4, easing: "ease-in" })
    if (content)
      animate(
        content,
        { opacity: [1, 0], scale: [1, 0.8], y: [0, 40], filter: ["blur(0px)", "blur(12px)"] },
        { duration: 0.35, easing: "ease-in" },
      )
  }
})
