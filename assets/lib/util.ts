import type { Direction } from "@zag-js/types";

const DIR_VALUES: Direction[] = ["ltr", "rtl"];

export function getDir(element: HTMLElement): Direction {
  const fromEl = element.dataset.dir;
  if (fromEl !== undefined && DIR_VALUES.includes(fromEl as Direction)) {
    return fromEl as Direction;
  }
  const fromDoc = document.documentElement.getAttribute("dir");
  if (fromDoc === "ltr" || fromDoc === "rtl") return fromDoc as Direction;
  return "ltr";
}

/**
 * Extract a string data attribute with validation for specific type
 * @param element - The HTML element to extract from
 * @param attrName - The data attribute name (without 'data-' prefix)
 * @param validValues - Optional array of allowed values
 * @returns Validated string value or undefined
 */
export const getString = <T extends string>(
  element: HTMLElement,
  attrName: string,
  validValues?: readonly T[]
): T | undefined => {
  const value = element.dataset[attrName];
  if (value !== undefined && (!validValues || (validValues as readonly string[]).includes(value))) {
    return value as T;
  }
  return undefined;
};
/**
 * Extract a list of string values from a data attribute
 * @param element - The HTML element to extract from
 * @param attrName - The data attribute name (without 'data-' prefix)
 * @returns Array of strings or undefined
 */
export const getStringList = (element: HTMLElement, attrName: string): string[] | undefined => {
  const value = element.dataset[attrName];
  if (typeof value !== "string") return undefined;

  const trimmed = value.trim();
  if (trimmed.startsWith("[")) {
    try {
      const parsed = JSON.parse(trimmed) as unknown;
      if (Array.isArray(parsed) && parsed.every((item) => typeof item === "string")) {
        return parsed as string[];
      }
      return [];
    } catch {
      return [];
    }
  }

  return trimmed
    .split(",")
    .map((v) => v.trim())
    .filter((v) => v.length > 0);
};
/**
 * Extract a number data attribute with optional validation
 * @param element - The HTML element to extract from
 * @param attrName - The data attribute name (without 'data-' prefix)
 * @param validValues - Optional array of allowed numeric values
 * @returns Parsed number value or undefined
 */
export const getNumber = (
  element: HTMLElement,
  attrName: string,
  validValues?: readonly number[]
): number | undefined => {
  const raw = element.dataset[attrName];
  if (raw === undefined) return undefined;
  const parsed = Number(raw);
  if (Number.isNaN(parsed)) return undefined;
  if (validValues && !validValues.includes(parsed)) return 0;
  return parsed;
};

/**
 * Extract a boolean data attribute
 * @param element - The HTML element to extract from
 * @param attrName - The data attribute name (without 'data-' prefix)
 * @returns Boolean value (true if attribute exists, false otherwise)
 */

export const getBoolean = (element: HTMLElement, attrName: string): boolean => {
  const dashName = attrName.replace(/([A-Z])/g, "-$1").toLowerCase();
  const key = `data-${dashName}`;
  if (!element.hasAttribute(key)) return false;
  const raw = element.getAttribute(key);
  if (raw === "false" || raw === "0") return false;
  return true;
};

export const getBooleanValue = (element: HTMLElement, attrName: string): boolean | undefined => {
  const raw = element.dataset[attrName];
  return raw === "true" ? true : raw === "false" ? false : undefined;
};

export type CheckedState = boolean | "indeterminate";

export function getCheckedState(
  element: HTMLElement,
  key: "checked" | "defaultChecked"
): CheckedState {
  const raw = element.dataset[key];
  if (raw === "indeterminate") return "indeterminate";
  return raw === "true";
}

export function templatesContentRoot(
  el: Element,
  dataTemplates: string
): DocumentFragment | HTMLElement | null {
  const host = el.querySelector(`[data-templates="${dataTemplates}"]`);
  if (!host) return null;
  if (host instanceof HTMLTemplateElement) return host.content;
  return host as HTMLElement;
}

export function cloneTemplateChildren(
  template: HTMLElement | null | undefined,
  target: HTMLElement
): boolean {
  if (!template || template.childNodes.length === 0) return false;

  const sourceId = template.id;
  if (sourceId && target.dataset.templateSource === sourceId && target.childNodes.length > 0) {
    return true;
  }

  target.replaceChildren(...Array.from(template.childNodes, (node) => node.cloneNode(true)));

  if (sourceId) target.dataset.templateSource = sourceId;
  else delete target.dataset.templateSource;

  return true;
}

/**
 * Generate a random ID if none is provided
 * @param element - Optional HTML element to get an existing id
 * @param fallbackId - Optional fallback base string (e.g. "checkbox")
 * @returns ID string (existing or generated)
 */
export const generateId = (element?: HTMLElement, fallbackId: string = "element"): string => {
  if (element?.id) return element.id;
  return `${fallbackId}-${Math.random().toString(36).substring(2, 9)}`;
};

export function canPushEvent(liveSocket: {
  main: { isDead: boolean; isConnected: () => boolean };
}): boolean {
  return !liveSocket.main.isDead && liveSocket.main.isConnected();
}

export function associateInputWithFormIfOutside(input: HTMLElement, hookEl: HTMLElement): void {
  const formId = getString(hookEl, "form");
  if (!formId) return;
  if (hookEl.closest("form") !== null) return;
  input.setAttribute("form", formId);
}

export function clearFormAssociationWhenNested(input: HTMLElement, hookEl: HTMLElement): void {
  if (hookEl.closest("form") !== null) {
    input.removeAttribute("form");
  }
}

export function syncInputFormAssociation(input: HTMLElement | null, hookEl: HTMLElement): void {
  if (!input) return;
  if (hookEl.closest("form") !== null) {
    input.removeAttribute("form");
  } else {
    associateInputWithFormIfOutside(input, hookEl);
  }
}

export function safeParseJson<T>(raw: string | null | undefined, fallback: T): T {
  if (raw == null || raw === "") return fallback;
  try {
    return JSON.parse(raw) as T;
  } catch (error) {
    console.error("Failed to parse JSON", error);
    return fallback;
  }
}
