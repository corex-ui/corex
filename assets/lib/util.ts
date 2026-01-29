/**
 * Corex utility functions for working with Zag.js components.
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
  if (typeof value === "string") {
    return value
      .split(",")
      .map((v) => v.trim())
      .filter((v) => v.length > 0);
  }
  return undefined;
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
  return element.hasAttribute(`data-${attrName}`);
};
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

/**
 * Options for getPartIds function
 */
export interface GetPartIdsOptions {
  /** The attribute name used for value identification (default: "value") */
  valueAttr?: string;
}

/**
 * Auto-detect part IDs from the DOM and return them in the correct format.
 *
 * Uses the presence of data-value (or custom valueAttr) to determine if a part
 * is function-based (multiple) or string-based (single). No config needed!
 *
 * @param root - The root element containing the parts
 * @param options - Optional configuration
 * @returns ElementIds object with correct types, or undefined if no IDs found
 *
 * @example
 * import type { ElementIds } from "@zag-js/accordion";
 *
 * // No config needed - auto-detects from DOM structure
 * const ids = getPartIds<ElementIds>(el);
 *
 * // Custom value attribute if needed
 * const ids = getPartIds<ElementIds>(el, { valueAttr: "index" });
 */
export function getPartIds<T extends Partial<Record<string, string | ((value: string) => string)>>>(
  root: HTMLElement,
  options: GetPartIdsOptions = {}
): Partial<T> | undefined {
  const { valueAttr = "value" } = options;
  const ids: Partial<T> = {} as Partial<T>;
  let hasAnyId = false;

  const allParts = root.querySelectorAll<HTMLElement>("[data-part]");

  const partGroups = new Map<string, HTMLElement[]>();
  allParts.forEach((el) => {
    const partName = el.dataset.part;
    if (partName) {
      if (!partGroups.has(partName)) {
        partGroups.set(partName, []);
      }
      partGroups.get(partName)!.push(el);
    }
  });

  for (const [kebabKey, elements] of partGroups) {
    // Convert kebab-case to camelCase for the result
    const camelKey = kebabKey.replace(/-([a-z])/g, (_, c) => c.toUpperCase());
    const key = camelKey as keyof T;

    const elementsWithIds = elements.filter((el) => el.dataset.id || el.id);
    if (elementsWithIds.length === 0) continue;

    const getValueFromElement = (el: HTMLElement): string | undefined => {
      if (el.dataset[valueAttr] !== undefined) {
        return el.dataset[valueAttr];
      }
      const parentItem = el.closest<HTMLElement>('[data-part="item"]');
      if (parentItem?.dataset[valueAttr] !== undefined) {
        return parentItem.dataset[valueAttr];
      }
      return undefined;
    };

    const hasMultipleElements = elementsWithIds.length > 1;
    const hasValueAnywhere = elementsWithIds.some((el) => getValueFromElement(el) !== undefined);

    if (hasMultipleElements || hasValueAnywhere) {
      const valueToIdMap = new Map<string, string>();
      elementsWithIds.forEach((el) => {
        const value = getValueFromElement(el);
        const id = el.dataset.id || el.id;
        if (value && id) {
          valueToIdMap.set(value, id);
        }
      });

      if (valueToIdMap.size > 0) {
        (ids as Record<keyof T, string | ((value: string) => string)>)[key] = (
          value: string
        ): string => valueToIdMap.get(value) || "";
        hasAnyId = true;
      }
    } else {
      const id = elementsWithIds[0].dataset.id || elementsWithIds[0].id;
      if (id) {
        (ids as Record<keyof T, string | ((value: string) => string)>)[key] = id;
        hasAnyId = true;
      }
    }
  }

  return hasAnyId ? ids : undefined;
}
