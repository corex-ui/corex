import { animate } from "motion"
import {
  findAccordionContent,
  findTreeBranch,
  findDialogBackdrop,
  findDialogContent,
  animateHeightOpen,
  animateHeightClose,
  animateScaleOpen,
  animateScaleClose,
} from "../../../"

const reducedMotion = () =>
  window.matchMedia("(prefers-reduced-motion: reduce)").matches

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
  const backdrop = findDialogBackdrop(root)
  const content = findDialogContent(root)
  if (open) {
    if (backdrop)
      animateScaleOpen(backdrop, { animator: animate, duration: 0.5, easing: "ease-out" })
    if (content) {
      animateScaleOpen(content, {
        animator: animate,
        duration: 0.7,
        easing: [0.16, 1, 0.3, 1],
        scaleStart: 0.7,
        scaleEnd: 1,
      })
      if (!reducedMotion())
        animate(
          content,
          { y: [60, 0], filter: ["blur(12px)", "blur(0px)"] },
          { duration: 0.7, easing: [0.16, 1, 0.3, 1] },
        )
    }
  } else {
    if (backdrop)
      animateScaleClose(backdrop, { animator: animate, duration: 0.4, easing: "ease-in" })
    if (content) {
      animateScaleClose(content, {
        animator: animate,
        duration: 0.35,
        easing: "ease-in",
        scaleStart: 0.8,
        scaleEnd: 1,
      })
      if (!reducedMotion())
        animate(
          content,
          { y: [0, 40], filter: ["blur(0px)", "blur(12px)"] },
          { duration: 0.35, easing: "ease-in" },
        )
    }
  }
})
