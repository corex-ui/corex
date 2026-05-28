const MAX_EVENT_ROWS = 20
const ACCORDION_EVENT = "hero-accordion-changed"

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

    this.onAccordionChange = (event) => {
      const detail = event.detail ?? {}
      this.prependEventRow(formatTime(), formatOpen(detail.value))
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
  },

  destroyed() {
    if (this.onAccordionChange) {
      this.el.removeEventListener(ACCORDION_EVENT, this.onAccordionChange)
    }
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
