// lib/redirect.ts
var REDIRECT_MODES = ["href", "patch", "navigate"];
var SCHEME_PREFIX = /^[a-zA-Z][a-zA-Z0-9+.-]*:/;
function isAllowedRedirectDestination(destination) {
  const trimmed = destination.trim();
  if (!trimmed) return false;
  if (trimmed.startsWith("//")) return false;
  const schemeMatch = SCHEME_PREFIX.exec(trimmed);
  if (schemeMatch) {
    const scheme = schemeMatch[0].slice(0, -1).toLowerCase();
    return scheme === "http" || scheme === "https";
  }
  return true;
}
function readDomItemRedirect(itemEl, fallback) {
  if (!itemEl) {
    if (!fallback || !isAllowedRedirectDestination(fallback)) return null;
    return { destination: fallback };
  }
  const dataRedirect = itemEl.getAttribute("data-redirect");
  if (dataRedirect === "false") return null;
  const destination = itemEl.getAttribute("data-to") || fallback || itemEl.getAttribute("data-value") || "";
  if (!destination || !isAllowedRedirectDestination(destination)) return null;
  const mode = REDIRECT_MODES.includes(dataRedirect) ? dataRedirect : void 0;
  const newTab = itemEl.hasAttribute("data-new-tab");
  return { destination, mode, newTab };
}
function performRedirect(input, ctx) {
  if (!input || !input.destination || !isAllowedRedirectDestination(input.destination))
    return false;
  const { destination, newTab, mode } = input;
  if (newTab) {
    window.open(destination, "_blank", "noopener,noreferrer");
    return true;
  }
  const main = ctx.liveSocket.main;
  const connected = !main.isDead && main.isConnected();
  if (!connected || !mode || mode === "href") {
    window.location.href = destination;
    return true;
  }
  const js = ctx.liveSocket.js();
  if (mode === "patch") {
    js.patch(destination);
  } else {
    js.navigate(destination);
  }
  return true;
}

export {
  isAllowedRedirectDestination,
  readDomItemRedirect,
  performRedirect
};
