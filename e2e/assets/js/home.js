import { animate } from "motion"

function prefersReducedMotion() {
  return window.matchMedia("(prefers-reduced-motion: reduce)").matches
}

function setRevealed(el) {
  el.style.opacity = "1"
  el.style.transform = "none"
}

function animateHero(hero) {
  const items = hero.querySelectorAll("[data-home-anim]")

  if (prefersReducedMotion()) {
    items.forEach(setRevealed)
    hero.querySelectorAll("[data-home-float]").forEach(setRevealed)
    return
  }

  items.forEach((el) => {
    el.style.opacity = "0"
    el.style.transform = "translateY(14px)"
  })

  items.forEach((el, i) => {
    animate(
      el,
      {
        opacity: [0, 1],
        transform: ["translateY(14px)", "translateY(0px)"],
      },
      { duration: 0.6, delay: i * 0.08, easing: [0.16, 1, 0.3, 1] }
    )
  })

  const cards = hero.querySelectorAll("[data-home-float]")
  if (cards.length === 0) return

  const lgUp = window.matchMedia("(min-width: 64rem)")

  if (!lgUp.matches) {
    cards.forEach(setRevealed)
    return
  }

  cards.forEach((card) => {
    const rotate = Number(card.dataset.rotate || 0)
    card.style.opacity = "0"
    card.style.transform = `translateY(24px) rotate(${rotate}deg) scale(0.96)`
  })

  cards.forEach((card, i) => {
    const rotate = Number(card.dataset.rotate || 0)
    animate(
      card,
      {
        opacity: [0, 1],
        transform: [
          `translateY(24px) rotate(${rotate}deg) scale(0.96)`,
          `translateY(0px) rotate(${rotate}deg) scale(1)`,
        ],
      },
      { duration: 0.8, delay: 0.25 + i * 0.1, easing: [0.16, 1, 0.3, 1] }
    )
  })
}

function bindCompositionParallax(hero) {
  const composition = hero.querySelector("[data-home-composition]")
  if (!composition) return
  if (prefersReducedMotion()) return

  const parallaxCards = Array.from(composition.querySelectorAll("[data-home-float]"))
  if (parallaxCards.length === 0) return

  const lgUp = window.matchMedia("(min-width: 64rem)")
  if (!lgUp.matches) return

  const depths = [12, 8, 16, 10]

  const onMove = (event) => {
    const rect = composition.getBoundingClientRect()
    const cx = rect.left + rect.width / 2
    const cy = rect.top + rect.height / 2
    const nx = (event.clientX - cx) / (rect.width / 2)
    const ny = (event.clientY - cy) / (rect.height / 2)

    parallaxCards.forEach((card, i) => {
      const rotate = Number(card.dataset.rotate || 0)
      const depth = depths[i % depths.length]
      const tx = -nx * depth
      const ty = -ny * depth
      animate(
        card,
        {
          transform: `translate(${tx}px, ${ty}px) rotate(${rotate}deg) scale(1)`,
        },
        { type: "spring", stiffness: 90, damping: 18, mass: 0.6 }
      )
    })
  }

  const onLeave = () => {
    parallaxCards.forEach((card) => {
      const rotate = Number(card.dataset.rotate || 0)
      animate(
        card,
        { transform: `translate(0px, 0px) rotate(${rotate}deg) scale(1)` },
        { type: "spring", stiffness: 80, damping: 20, mass: 0.7 }
      )
    })
  }

  composition.addEventListener("pointermove", onMove)
  composition.addEventListener("pointerleave", onLeave)
}

export function initHomeHero() {
  const hero = document.querySelector("[data-home-hero]")
  if (!hero) return
  if (hero.dataset.homeMotionInitialized === "true") return
  hero.dataset.homeMotionInitialized = "true"
  animateHero(hero)
  bindCompositionParallax(hero)
}
