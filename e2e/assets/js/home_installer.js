const CHANGE_EVENT = "home-installer-changed"
const DEFAULT_ON = ["design", "mcp", "usage-rules"]
const OPT_IN = ["mode", "theme", "a11y", "lang"]
const DEFAULT_NAMES = {phoenix: "my_app", tableau: "my_site"}

function sanitizeName(raw, generator) {
  const fallback = DEFAULT_NAMES[generator] || DEFAULT_NAMES.phoenix
  const cleaned = String(raw || "")
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9_]/g, "")
  return cleaned || fallback
}

function buildFlags(selected) {
  const set = new Set(selected || [])
  const flags = []

  for (const token of DEFAULT_ON) {
    if (!set.has(token)) flags.push(`--no-${token}`)
  }

  for (const token of OPT_IN) {
    if (set.has(token)) flags.push(`--${token}`)
  }

  return flags
}

function buildCommand(generator, name, selectedFlags) {
  const task = generator === "tableau" ? "mix corex.tableau.new" : "mix corex.new"
  const flags = buildFlags(selectedFlags)
  return [task, name, ...flags].join(" ")
}

function setCodeContent(rootEl, value) {
  if (!rootEl) return
  const content = rootEl.querySelector('[data-scope="code"][data-part="content"]')
  if (content) {
    content.textContent = value
    return
  }
  rootEl.textContent = value
}

function dispatchClipboardValue(clipboardEl, value) {
  if (!clipboardEl) return
  clipboardEl.dispatchEvent(
    new CustomEvent("corex:clipboard:set-value", {
      bubbles: false,
      detail: {value},
    }),
  )
}

function parseListAttr(raw) {
  if (!raw) return []
  try {
    const parsed = JSON.parse(raw)
    return Array.isArray(parsed) ? parsed.map(String) : []
  } catch {
    return String(raw)
      .split(",")
      .map((s) => s.trim())
      .filter(Boolean)
  }
}

function readToggleValue(el) {
  if (!el) return []
  const selected = el.querySelectorAll('[data-part="item"][data-state="on"]')
  if (selected.length > 0) {
    return Array.from(selected)
      .map((item) => item.getAttribute("data-value"))
      .filter(Boolean)
  }

  return parseListAttr(
    el.getAttribute("data-default-value") || el.getAttribute("data-value"),
  )
}

const HomeInstaller = {
  mounted() {
    this.generatorEl = document.getElementById("home-installer-generator")
    this.defaultsEl = document.getElementById("home-installer-defaults")
    this.addonsEl = document.getElementById("home-installer-addons")
    this.nameEl =
      document.getElementById("home-installer-name-input") ||
      document.querySelector('#home-installer-name [data-part="input"]')
    this.commandEl = document.getElementById("home-installer-command")
    this.clipboardEl = document.getElementById("home-installer-clipboard")
    this.archivesEl = document.getElementById("home-installer-archives")
    this.archivesClipboardEl = document.getElementById("home-installer-archives-clipboard")
    this.archives = {
      phoenix:
        this.el.getAttribute("data-archives-phoenix") ||
        "mix archive.install hex phx_new\nmix archive.install hex corex_new",
      tableau:
        this.el.getAttribute("data-archives-tableau") ||
        "mix archive.install hex tableau_new\nmix archive.install hex corex_new",
    }

    this.generator = "phoenix"
    this.defaults = [...DEFAULT_ON]
    this.addons = []
    this.syncFromDom()

    this.onChange = (event) => {
      const id = event.detail?.id
      const value = event.detail?.value
      if (!Array.isArray(value)) return

      if (id === "home-installer-generator") {
        const next = value[0] === "tableau" ? "tableau" : "phoenix"
        this.maybeSwapDefaultName(this.generator, next)
        this.generator = next
      } else if (id === "home-installer-defaults") {
        this.defaults = value
      } else if (id === "home-installer-addons") {
        this.addons = value
      }

      this.update()
    }

    this.onNameInput = () => this.update()

    this.el.addEventListener(CHANGE_EVENT, this.onChange)
    this.nameEl?.addEventListener("input", this.onNameInput)

    // Defer so nested Clipboard / ToggleGroup hooks are mounted.
    queueMicrotask(() => this.update())
  },

  destroyed() {
    if (this.onChange) this.el.removeEventListener(CHANGE_EVENT, this.onChange)
    if (this.onNameInput) this.nameEl?.removeEventListener("input", this.onNameInput)
  },

  syncFromDom() {
    const generators = readToggleValue(this.generatorEl)
    if (generators[0] === "tableau" || generators[0] === "phoenix") {
      this.generator = generators[0]
    }

    const defaults = readToggleValue(this.defaultsEl)
    if (defaults.length > 0 || this.defaultsEl) this.defaults = defaults

    const addons = readToggleValue(this.addonsEl)
    this.addons = addons
  },

  maybeSwapDefaultName(prev, next) {
    if (!this.nameEl || prev === next) return
    const current = String(this.nameEl.value || "").trim()
    if (!current || current === DEFAULT_NAMES[prev]) {
      this.nameEl.value = DEFAULT_NAMES[next]
    }
  },

  selectedFlags() {
    return [...this.defaults, ...this.addons]
  },

  update() {
    const name = sanitizeName(this.nameEl?.value, this.generator)
    const command = buildCommand(this.generator, name, this.selectedFlags())
    const archives = this.archives[this.generator] || this.archives.phoenix

    if (this.commandEl) setCodeContent(this.commandEl, command)
    dispatchClipboardValue(this.clipboardEl, command)

    if (this.archivesEl) setCodeContent(this.archivesEl, archives)
    dispatchClipboardValue(this.archivesClipboardEl, archives)
  },
}

export default HomeInstaller
