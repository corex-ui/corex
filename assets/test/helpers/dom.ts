export function el(attrs: Record<string, string | boolean | number>): HTMLElement {
  const node = document.createElement("div");
  for (const [key, value] of Object.entries(attrs)) {
    if (value === false || value === undefined || value === null) continue;
    const name = key.startsWith("data-")
      ? key
      : `data-${key.replace(/([A-Z])/g, "-$1").toLowerCase()}`;
    node.setAttribute(name, value === true ? "" : String(value));
  }
  return node;
}
