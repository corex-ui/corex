/**
 * Shared redirect helper used by tree-view, menu, select, listbox, and combobox hooks.
 *
 * The caller picks the navigation kind per item via `mode`. JS never tries to
 * detect whether a URL belongs to the same LiveView mount; the hook only
 * executes what was declared on the item via DOM attributes.
 */

export type RedirectMode = "href" | "patch" | "navigate";

const REDIRECT_MODES: readonly RedirectMode[] = ["href", "patch", "navigate"];

export interface RedirectInput {
  destination: string;
  newTab?: boolean;
  mode?: RedirectMode;
}

export interface RedirectContext {
  liveSocket: {
    main: { isDead: boolean; isConnected: () => boolean };
    js: () => { patch: (url: string) => void; navigate: (url: string) => void };
  };
}

/**
 * Build a RedirectInput from an item element's data attributes.
 *
 * - Returns `null` if the element has `data-redirect="false"` (opt-out).
 * - `destination = data-to || fallback || data-value`.
 * - `mode` is read from `data-redirect` when its value is one of "href",
 *   "patch", "navigate". Anything else (including missing) leaves it
 *   unset so `performRedirect` falls back to its `"href"` default.
 * - `newTab` mirrors the presence of `data-new-tab`.
 */
export function readDomItemRedirect(
  itemEl: HTMLElement | null | undefined,
  fallback?: string
): RedirectInput | null {
  if (!itemEl) {
    if (!fallback) return null;
    return { destination: fallback };
  }

  const dataRedirect = itemEl.getAttribute("data-redirect");
  if (dataRedirect === "false") return null;

  const destination =
    itemEl.getAttribute("data-to") || fallback || itemEl.getAttribute("data-value") || "";
  if (!destination) return null;

  const mode = REDIRECT_MODES.includes(dataRedirect as RedirectMode)
    ? (dataRedirect as RedirectMode)
    : undefined;
  const newTab = itemEl.hasAttribute("data-new-tab");

  return { destination, mode, newTab };
}

/**
 * Execute a redirect described by `input`.
 *
 * Behavior:
 * - No-op (returns false) when `input` is null or has empty destination.
 * - `newTab === true`     -> always `window.open(_, "_blank", noopener,noreferrer)`.
 * - LV not connected      -> `window.location.href = destination` regardless of mode.
 * - LV connected:
 *   - `mode === "patch"`    -> `liveSocket.js().patch(destination)`
 *   - `mode === "navigate"` -> `liveSocket.js().navigate(destination)`
 *   - `mode === "href"` (default) -> `window.location.href = destination`
 *
 * Returns true when a redirect was attempted, false otherwise.
 */
export function performRedirect(input: RedirectInput | null, ctx: RedirectContext): boolean {
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
