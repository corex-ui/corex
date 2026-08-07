const MAX_EVENT_ROWS = 20
const ACCORDION_EVENT = "hero-accordion-changed"
const EVENT_FLASH_MS = 800
const ROTATOR_DEFAULT_MS = 2800

function formatOpen(value) {
  if (value == null) return " - "
  if (Array.isArray(value) && value.length === 0) return " - "
  if (Array.isArray(value)) return value.join(", ")
  return String(value)
}

function formatTime() {
  return new Date().toTimeString().slice(0, 8)
}

function eventsTbody() {
  const root = document.getElementById("hero-events-table")
  if (!root) return null
  if (root.getAttribute("data-part") === "tbody") return root
  return root.querySelector('[data-part="tbody"]')
}

function dispatchAccordionValue(accordionEl, value) {
  if (!accordionEl) return
  accordionEl.dispatchEvent(
    new CustomEvent("corex:accordion:set-value", {
      bubbles: false,
      detail: {value},
    }),
  )
}

const HomeHero = {
  mounted() {
    this.accordionEl = document.getElementById("hero-accordion")
    this.eventsBadge = document.getElementById("hero-events-badge")
    this.flashTimer = null
    this.rotatorTimer = null

    this.onAccordionChange = (event) => {
      const detail = event.detail ?? {}
      this.prependEventRow(formatTime(), formatOpen(detail.value))
      this.flashEventsBadge()
    }

    this.el.addEventListener(ACCORDION_EVENT, this.onAccordionChange)

    this.el.querySelectorAll("[data-hero-accordion-value]").forEach((button) => {
      button.addEventListener("click", () => {
        const raw = button.getAttribute("data-hero-accordion-value")
        if (!raw) return
        let value
        try {
          value = JSON.parse(raw)
        } catch {
          return
        }
        dispatchAccordionValue(this.accordionEl, value)
      })
    })

    this.startRotator()
  },

  destroyed() {
    if (this.onAccordionChange) {
      this.el.removeEventListener(ACCORDION_EVENT, this.onAccordionChange)
    }
    if (this.flashTimer) {
      clearTimeout(this.flashTimer)
      this.flashTimer = null
    }
    if (this.rotatorTimer) {
      clearInterval(this.rotatorTimer)
      this.rotatorTimer = null
    }
  },

  startRotator() {
    const root = document.getElementById("home-hero-rotator")
    if (!root) return
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return

    const words = Array.from(root.querySelectorAll(".home-hero-rotator__word"))
    if (words.length < 2) return

    let index = words.findIndex((word) => word.hasAttribute("data-active"))
    if (index < 0) index = 0

    const interval = Number(root.getAttribute("data-interval-ms")) || ROTATOR_DEFAULT_MS

    this.rotatorTimer = setInterval(() => {
      words[index].removeAttribute("data-active")
      index = (index + 1) % words.length
      words[index].setAttribute("data-active", "")
    }, interval)
  },

  flashEventsBadge() {
    const badge = this.eventsBadge
    if (!badge) return

    badge.classList.add("ui-success")
    badge.classList.remove("ui-ghost")

    if (this.flashTimer) clearTimeout(this.flashTimer)
    this.flashTimer = setTimeout(() => {
      badge.classList.remove("ui-success")
      badge.classList.add("ui-ghost")
      this.flashTimer = null
    }, EVENT_FLASH_MS)
  },

  prependEventRow(time, open) {
    const tbody = eventsTbody()
    if (!tbody) return

    const emptyRow = tbody.querySelector('[data-part="empty-row"]')
    if (emptyRow) emptyRow.remove()

    const row = document.createElement("tr")
    row.setAttribute("data-scope", "data-table")
    row.setAttribute("data-part", "row")

    const timeCell = document.createElement("td")
    timeCell.setAttribute("data-scope", "data-table")
    timeCell.setAttribute("data-part", "cell")
    timeCell.textContent = time

    const openCell = document.createElement("td")
    openCell.setAttribute("data-scope", "data-table")
    openCell.setAttribute("data-part", "grow-cell")
    openCell.textContent = open

    row.append(timeCell, openCell)
    tbody.insertBefore(row, tbody.firstChild)

    const rows = tbody.querySelectorAll('[data-part="row"]')
    for (let i = rows.length - 1; i >= MAX_EVENT_ROWS; i--) {
      rows[i].remove()
    }
  },
}

export default HomeHero
