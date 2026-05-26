export type PartSpec = {
  part: string;
  attrs?: Record<string, string>;
  children?: PartSpec[];
  text?: string;
};

export function scopeTree(scope: string, parts: PartSpec[]): HTMLElement {
  const root = document.createElement("div");
  root.dataset.scope = scope;

  const append = (parent: HTMLElement, spec: PartSpec) => {
    const el = document.createElement("div");
    el.dataset.scope = scope;
    el.dataset.part = spec.part;
    if (spec.attrs) {
      for (const [key, value] of Object.entries(spec.attrs)) {
        el.setAttribute(key, value);
      }
    }
    if (spec.text) el.textContent = spec.text;
    parent.appendChild(el);
    for (const child of spec.children ?? []) {
      append(el, child);
    }
  };

  for (const spec of parts) {
    append(root, spec);
  }

  return root;
}
