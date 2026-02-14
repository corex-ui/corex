/**
 * Corex utility functions for working with Zag.js components.
 */

import type { Direction } from "@zag-js/types";

const DIR_VALUES: Direction[] = ["ltr", "rtl"];

/**
 * Read dir for a component: element data-dir, else <html dir="...">, else "ltr".
 * Dir is set server-side; JS only reads the attribute.
 */
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
  const dashName = attrName.replace(/([A-Z])/g, "-$1").toLowerCase();
  return element.hasAttribute(`data-${dashName}`);
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
