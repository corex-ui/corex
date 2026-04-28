import { animate } from "motion"
import {
  initCustomCollections,
  findAccordionContent,
  findTreeBranch,
  animateHeightOpen,
  animateHeightClose,
} from "../../../"

const reducedMotion = () =>
  window.matchMedia("(prefers-reduced-motion: reduce)").matches

document.addEventListener("DOMContentLoaded", initCustomCollections)
window.addEventListener("phx:page-loading-stop", initCustomCollections)

document.addEventListener("my-accordion-changed", (e) => {
  const root = document.getElementById(e.detail.id)
  if (!root) return
  e.detail.added.forEach((v) => {
    const el = findAccordionContent(root, v)
    if (!el) return
    animateHeightOpen(el, { animator: animate, duration: 0.55, easing: [0.16, 1, 0.3, 1] })
    if (!reducedMotion()) {
      animate(
        el,
        { filter: ["blur(12px)", "blur(0px)"], scale: [0.96, 1] },
        { duration: 0.6, easing: [0.16, 1, 0.3, 1] },
      )
    }
  })
  e.detail.removed.forEach((v) => {
    const el = findAccordionContent(root, v)
    if (!el) return
    animateHeightClose(el, { animator: animate, duration: 0.32, easing: [0.7, 0, 0.84, 0] })
    if (!reducedMotion()) {
      animate(
        el,
        { filter: ["blur(0px)", "blur(10px)"], scale: [1, 0.97] },
        { duration: 0.3, easing: "ease-in" },
      )
    }
  })
})

document.addEventListener("my-tree-view-changed", (e) => {
  const root = document.getElementById(e.detail.id)
  if (!root) return
  e.detail.added.forEach((v) => {
    const el = findTreeBranch(root, v)
    if (!el) return
    animateHeightOpen(el, { animator: animate, duration: 0.5, easing: [0.16, 1, 0.3, 1] })
    if (!reducedMotion()) {
      animate(
        el,
        { filter: ["blur(8px)", "blur(0px)"], y: [-10, 0] },
        { duration: 0.55, easing: [0.16, 1, 0.3, 1] },
      )
    }
  })
  e.detail.removed.forEach((v) => {
    const el = findTreeBranch(root, v)
    if (!el) return
    animateHeightClose(el, { animator: animate, duration: 0.28, easing: "ease-in" })
    if (!reducedMotion()) {
      animate(
        el,
        { filter: ["blur(0px)", "blur(8px)"], y: [0, -8] },
        { duration: 0.26, easing: "ease-in" },
      )
    }
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
