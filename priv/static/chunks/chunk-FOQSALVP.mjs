// lib/redirect.ts
var REDIRECT_MODES = ["href", "patch", "navigate"];
function readDomItemRedirect(itemEl, fallback) {
  if (!itemEl) {
    if (!fallback) return null;
    return { destination: fallback };
  }
  const dataRedirect = itemEl.getAttribute("data-redirect");
  if (dataRedirect === "false") return null;
  const destination = itemEl.getAttribute("data-to") || fallback || itemEl.getAttribute("data-value") || "";
  if (!destination) return null;
  const mode = REDIRECT_MODES.includes(dataRedirect) ? dataRedirect : void 0;
  const newTab = itemEl.hasAttribute("data-new-tab");
  return { destination, mode, newTab };
}
function performRedirect(input, ctx) {
  if (!input || !input.destination) return false;
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
  readDomItemRedirect,
  performRedirect
};
