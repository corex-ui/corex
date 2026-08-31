import {
  canPushEvent
} from "./chunk-JPQZXVRQ.mjs";

// lib/redirect.ts
var REDIRECT_MODES = ["href", "patch", "navigate"];
var SCHEME_PREFIX = /^[a-zA-Z][a-zA-Z0-9+.-]*:/;
function stripLeadingC0AndSpace(destination) {
  let i = 0;
  while (i < destination.length && destination.charCodeAt(i) <= 32) {
    i += 1;
  }
  return destination.slice(i);
}
function containsNulOrNewline(destination) {
  return /[\0\r\n]/.test(destination);
}
function sanitizeRedirectDestination(destination) {
  const trimmed = stripLeadingC0AndSpace(destination);
  if (!trimmed) return null;
  if (containsNulOrNewline(trimmed)) return null;
  if (trimmed.startsWith("//")) return null;
  const schemeMatch = SCHEME_PREFIX.exec(trimmed);
  if (schemeMatch) {
    const scheme = schemeMatch[0].slice(0, -1).toLowerCase();
    if (scheme !== "http" && scheme !== "https") return null;
  }
  return trimmed;
}
function isAllowedRedirectDestination(destination) {
  return sanitizeRedirectDestination(destination) !== null;
}
function readDomItemRedirect(itemEl, fallback) {
  if (!itemEl) {
    const destination2 = fallback ? sanitizeRedirectDestination(fallback) : null;
    if (!destination2) return null;
    return { destination: destination2 };
  }
  const dataRedirect = itemEl.getAttribute("data-redirect");
  if (dataRedirect === "false") return null;
  const raw = itemEl.getAttribute("data-to") || fallback || itemEl.getAttribute("data-value") || "";
  const destination = sanitizeRedirectDestination(raw);
  if (!destination) return null;
  const mode = REDIRECT_MODES.includes(dataRedirect) ? dataRedirect : void 0;
  const newTab = itemEl.hasAttribute("data-new-tab");
  return { destination, mode, newTab };
}
function performRedirect(input, ctx) {
  if (!input || !input.destination) return false;
  const destination = sanitizeRedirectDestination(input.destination);
  if (!destination) return false;
  const { newTab, mode } = input;
  if (newTab) {
    window.open(destination, "_blank", "noopener,noreferrer");
    return true;
  }
  const connected = canPushEvent(ctx.liveSocket);
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
