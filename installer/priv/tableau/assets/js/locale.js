const STORAGE_KEY = "data-locale"
const CONTROL_ID = "corex-language-switch"

const documentRoot = () => document.documentElement

const parseList = (attr) => {
  const raw = documentRoot().getAttribute(attr) || ""
  return raw
    .split(",")
    .map((s) => s.trim())
    .filter(Boolean)
}

const whenControlReady = (id, run) => {
  const iv = window.setInterval(() => {
    const root = document.getElementById(id)
    if (root && !root.hasAttribute("data-loading")) {
      window.clearInterval(iv)
      run()
    }
  }, 10)
  window.setTimeout(() => window.clearInterval(iv), 10_000)
}

const firstDetailValue = (event) => {
  const value = event.detail?.value
  return Array.isArray(value) && value[0] ? value[0] : null
}

const validLocales = () => parseList("data-locales")

const rtlLocales = () => new Set(parseList("data-rtl-locales"))

const directionForLocale = (loc) =>
  loc && rtlLocales().has(loc) ? "rtl" : "ltr"

const publicPathPrefix = () => {
  const raw = documentRoot().getAttribute("data-public-path-prefix") || ""
  return raw.replace(/\/+$/, "")
}

const localeFromPathname = () => {
  let pathname = window.location.pathname
  const prefix = publicPathPrefix()
  if (prefix && pathname.startsWith(prefix)) {
    pathname = pathname.slice(prefix.length) || "/"
  }
  const first = pathname.split("/").filter(Boolean)[0] || ""
  return validLocales().includes(first) ? first : ""
}

const resolvedLocale = () => {
  const pathLocale = localeFromPathname()
  if (pathLocale) return pathLocale
  const docLocale = documentRoot().getAttribute("data-locale")
  if (docLocale && validLocales().includes(docLocale)) return docLocale
  const stored = localStorage.getItem(STORAGE_KEY)
  if (stored && validLocales().includes(stored)) return stored
  return ""
}

const persistLocale = (loc) => {
  const allowed = validLocales()
  if (!loc || !allowed.includes(loc)) return
  localStorage.setItem(STORAGE_KEY, loc)
}

const applyDocumentLocale = (loc) => {
  const allowed = validLocales()
  if (!loc || !allowed.includes(loc)) return
  const root = documentRoot()
  root.setAttribute("lang", loc)
  root.setAttribute("data-locale", loc)
  root.setAttribute("dir", directionForLocale(loc))
}

const syncDocumentLocale = () => {
  applyDocumentLocale(resolvedLocale())
}

const syncLangSelect = () => {
  const path = documentRoot().getAttribute("data-locale-selected-path")
  const root = document.getElementById(CONTROL_ID)
  if (!root || !path) return
  root.dispatchEvent(
    new CustomEvent("corex:select:set-value", {detail: {value: [path]}}),
  )
}

const syncControls = () => {
  syncDocumentLocale()
  syncLangSelect()
}

const pathLocale = localeFromPathname()
if (pathLocale) persistLocale(pathLocale)

syncDocumentLocale()

whenControlReady(CONTROL_ID, syncControls)

window.addEventListener("storage", (event) => {
  if (event.key === STORAGE_KEY && event.newValue) {
    persistLocale(event.newValue)
    syncDocumentLocale()
  }
})

window.addEventListener("corex:set-locale", (event) => {
  const raw = firstDetailValue(event)
  const segment =
    (raw != null ? String(raw) : "")
      .replace(/^\/+|\/+$/g, "")
      .split("/")[0] || ""
  if (!validLocales().includes(segment)) return
  persistLocale(segment)
  applyDocumentLocale(segment)
})

window.addEventListener("pageshow", syncControls)
