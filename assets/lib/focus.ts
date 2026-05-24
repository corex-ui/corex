export function resolveFocusElement(
  root: HTMLElement,
  id: string | undefined
): HTMLElement | null {
  if (!id) return null;

  const scoped = root.querySelector<HTMLElement>(`#${CSS.escape(id)}`);
  if (scoped) return scoped;

  const byId = document.getElementById(id);
  if (byId && root.contains(byId)) return byId;

  return null;
}
