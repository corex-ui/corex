import {
  hasProp,
  isEqual,
  isObject
} from "./chunk-AG6DB4N6.mjs";

// ../node_modules/.pnpm/@zag-js+collection@1.33.1/node_modules/@zag-js/collection/dist/index.mjs
var __defProp = Object.defineProperty;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __publicField = (obj, key, value) => __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);
var fallback = {
  itemToValue(item) {
    if (typeof item === "string") return item;
    if (isObject(item) && hasProp(item, "value")) return item.value;
    return "";
  },
  itemToString(item) {
    if (typeof item === "string") return item;
    if (isObject(item) && hasProp(item, "label")) return item.label;
    return fallback.itemToValue(item);
  },
  isItemDisabled(item) {
    if (isObject(item) && hasProp(item, "disabled")) return !!item.disabled;
    return false;
  }
};
var ListCollection = class _ListCollection {
  constructor(options) {
    this.options = options;
    __publicField(this, "items");
    __publicField(this, "indexMap", null);
    __publicField(this, "copy", (items) => {
      return new _ListCollection({ ...this.options, items: items ?? [...this.items] });
    });
    __publicField(this, "isEqual", (other) => {
      return isEqual(this.items, other.items);
    });
    __publicField(this, "setItems", (items) => {
      return this.copy(items);
    });
    __publicField(this, "getValues", (items = this.items) => {
      const values = [];
      for (const item of items) {
        const value = this.getItemValue(item);
        if (value != null) values.push(value);
      }
      return values;
    });
    __publicField(this, "find", (value) => {
      if (value == null) return null;
      const index = this.indexOf(value);
      return index !== -1 ? this.at(index) : null;
    });
    __publicField(this, "findMany", (values) => {
      const result = [];
      for (const value of values) {
        const item = this.find(value);
        if (item != null) result.push(item);
      }
      return result;
    });
    __publicField(this, "at", (index) => {
      if (!this.options.groupBy && !this.options.groupSort) {
        return this.items[index] ?? null;
      }
      let idx = 0;
      const groups = this.group();
      for (const [, items] of groups) {
        for (const item of items) {
          if (idx === index) return item;
          idx++;
        }
      }
      return null;
    });
    __publicField(this, "sortFn", (valueA, valueB) => {
      const indexA = this.indexOf(valueA);
      const indexB = this.indexOf(valueB);
      return (indexA ?? 0) - (indexB ?? 0);
    });
    __publicField(this, "sort", (values) => {
      return [...values].sort(this.sortFn.bind(this));
    });
    __publicField(this, "getItemValue", (item) => {
      if (item == null) return null;
      return this.options.itemToValue?.(item) ?? fallback.itemToValue(item);
    });
    __publicField(this, "getItemDisabled", (item) => {
      if (item == null) return false;
      return this.options.isItemDisabled?.(item) ?? fallback.isItemDisabled(item);
    });
    __publicField(this, "stringifyItem", (item) => {
      if (item == null) return null;
      return this.options.itemToString?.(item) ?? fallback.itemToString(item);
    });
    __publicField(this, "stringify", (value) => {
      if (value == null) return null;
      return this.stringifyItem(this.find(value));
    });
    __publicField(this, "stringifyItems", (items, separator = ", ") => {
      const strs = [];
      for (const item of items) {
        const str = this.stringifyItem(item);
        if (str != null) strs.push(str);
      }
      return strs.join(separator);
    });
    __publicField(this, "stringifyMany", (value, separator) => {
      return this.stringifyItems(this.findMany(value), separator);
    });
    __publicField(this, "has", (value) => {
      return this.indexOf(value) !== -1;
    });
    __publicField(this, "hasItem", (item) => {
      if (item == null) return false;
      return this.has(this.getItemValue(item));
    });
    __publicField(this, "group", () => {
      const { groupBy, groupSort } = this.options;
      if (!groupBy) return [["", [...this.items]]];
      const groups = /* @__PURE__ */ new Map();
      this.items.forEach((item, index) => {
        const groupKey = groupBy(item, index);
        if (!groups.has(groupKey)) {
          groups.set(groupKey, []);
        }
        groups.get(groupKey).push(item);
      });
      let entries = Array.from(groups.entries());
      if (groupSort) {
        entries.sort(([a], [b]) => {
          if (typeof groupSort === "function") return groupSort(a, b);
          if (Array.isArray(groupSort)) {
            const indexA = groupSort.indexOf(a);
            const indexB = groupSort.indexOf(b);
            if (indexA === -1) return 1;
            if (indexB === -1) return -1;
            return indexA - indexB;
          }
          if (groupSort === "asc") return a.localeCompare(b);
          if (groupSort === "desc") return b.localeCompare(a);
          return 0;
        });
      }
      return entries;
    });
    __publicField(this, "getNextValue", (value, step = 1, clamp = false) => {
      let index = this.indexOf(value);
      if (index === -1) return null;
      index = clamp ? Math.min(index + step, this.size - 1) : index + step;
      while (index <= this.size && this.getItemDisabled(this.at(index))) index++;
      return this.getItemValue(this.at(index));
    });
    __publicField(this, "getPreviousValue", (value, step = 1, clamp = false) => {
      let index = this.indexOf(value);
      if (index === -1) return null;
      index = clamp ? Math.max(index - step, 0) : index - step;
      while (index >= 0 && this.getItemDisabled(this.at(index))) index--;
      return this.getItemValue(this.at(index));
    });
    __publicField(this, "indexOf", (value) => {
      if (value == null) return -1;
      if (!this.options.groupBy && !this.options.groupSort) {
        return this.items.findIndex((item) => this.getItemValue(item) === value);
      }
      if (!this.indexMap) {
        this.indexMap = /* @__PURE__ */ new Map();
        let idx = 0;
        const groups = this.group();
        for (const [, items] of groups) {
          for (const item of items) {
            const itemValue = this.getItemValue(item);
            if (itemValue != null) {
              this.indexMap.set(itemValue, idx);
            }
            idx++;
          }
        }
      }
      return this.indexMap.get(value) ?? -1;
    });
    __publicField(this, "getByText", (text, current) => {
      const currentIndex = current != null ? this.indexOf(current) : -1;
      const isSingleKey = text.length === 1;
      for (let i = 0; i < this.items.length; i++) {
        const item = this.items[(currentIndex + i + 1) % this.items.length];
        if (isSingleKey && this.getItemValue(item) === current) continue;
        if (this.getItemDisabled(item)) continue;
        if (match(this.stringifyItem(item), text)) return item;
      }
      return void 0;
    });
    __publicField(this, "search", (queryString, options2) => {
      const { state, currentValue, timeout = 350 } = options2;
      const search = state.keysSoFar + queryString;
      const isRepeated = search.length > 1 && Array.from(search).every((char) => char === search[0]);
      const query = isRepeated ? search[0] : search;
      const item = this.getByText(query, currentValue);
      const value = this.getItemValue(item);
      function cleanup() {
        clearTimeout(state.timer);
        state.timer = -1;
      }
      function update(value2) {
        state.keysSoFar = value2;
        cleanup();
        if (value2 !== "") {
          state.timer = +setTimeout(() => {
            update("");
            cleanup();
          }, timeout);
        }
      }
      update(search);
      return value;
    });
    __publicField(this, "update", (value, item) => {
      let index = this.indexOf(value);
      if (index === -1) return this;
      return this.copy([...this.items.slice(0, index), item, ...this.items.slice(index + 1)]);
    });
    __publicField(this, "upsert", (value, item, mode = "append") => {
      let index = this.indexOf(value);
      if (index === -1) {
        const fn = mode === "append" ? this.append : this.prepend;
        return fn(item);
      }
      return this.copy([...this.items.slice(0, index), item, ...this.items.slice(index + 1)]);
    });
    __publicField(this, "insert", (index, ...items) => {
      return this.copy(insert(this.items, index, ...items));
    });
    __publicField(this, "insertBefore", (value, ...items) => {
      let toIndex = this.indexOf(value);
      if (toIndex === -1) {
        if (this.items.length === 0) toIndex = 0;
        else return this;
      }
      return this.copy(insert(this.items, toIndex, ...items));
    });
    __publicField(this, "insertAfter", (value, ...items) => {
      let toIndex = this.indexOf(value);
      if (toIndex === -1) {
        if (this.items.length === 0) toIndex = 0;
        else return this;
      }
      return this.copy(insert(this.items, toIndex + 1, ...items));
    });
    __publicField(this, "prepend", (...items) => {
      return this.copy(insert(this.items, 0, ...items));
    });
    __publicField(this, "append", (...items) => {
      return this.copy(insert(this.items, this.items.length, ...items));
    });
    __publicField(this, "filter", (fn) => {
      const filteredItems = this.items.filter((item, index) => fn(this.stringifyItem(item), index, item));
      return this.copy(filteredItems);
    });
    __publicField(this, "remove", (...itemsOrValues) => {
      const values = itemsOrValues.map(
        (itemOrValue) => typeof itemOrValue === "string" ? itemOrValue : this.getItemValue(itemOrValue)
      );
      return this.copy(
        this.items.filter((item) => {
          const value = this.getItemValue(item);
          if (value == null) return false;
          return !values.includes(value);
        })
      );
    });
    __publicField(this, "move", (value, toIndex) => {
      const fromIndex = this.indexOf(value);
      if (fromIndex === -1) return this;
      return this.copy(move(this.items, [fromIndex], toIndex));
    });
    __publicField(this, "moveBefore", (value, ...values) => {
      let toIndex = this.items.findIndex((item) => this.getItemValue(item) === value);
      if (toIndex === -1) return this;
      let indices = values.map((value2) => this.items.findIndex((item) => this.getItemValue(item) === value2)).sort((a, b) => a - b);
      return this.copy(move(this.items, indices, toIndex));
    });
    __publicField(this, "moveAfter", (value, ...values) => {
      let toIndex = this.items.findIndex((item) => this.getItemValue(item) === value);
      if (toIndex === -1) return this;
      let indices = values.map((value2) => this.items.findIndex((item) => this.getItemValue(item) === value2)).sort((a, b) => a - b);
      return this.copy(move(this.items, indices, toIndex + 1));
    });
    __publicField(this, "reorder", (fromIndex, toIndex) => {
      return this.copy(move(this.items, [fromIndex], toIndex));
    });
    __publicField(this, "compareValue", (a, b) => {
      const indexA = this.indexOf(a);
      const indexB = this.indexOf(b);
      if (indexA < indexB) return -1;
      if (indexA > indexB) return 1;
      return 0;
    });
    __publicField(this, "range", (from, to) => {
      let keys = [];
      let key = from;
      while (key != null) {
        let item = this.find(key);
        if (item) keys.push(key);
        if (key === to) return keys;
        key = this.getNextValue(key);
      }
      return [];
    });
    __publicField(this, "getValueRange", (from, to) => {
      if (from && to) {
        if (this.compareValue(from, to) <= 0) {
          return this.range(from, to);
        }
        return this.range(to, from);
      }
      return [];
    });
    __publicField(this, "toString", () => {
      let result = "";
      for (const item of this.items) {
        const value = this.getItemValue(item);
        const label = this.stringifyItem(item);
        const disabled = this.getItemDisabled(item);
        const itemString = [value, label, disabled].filter(Boolean).join(":");
        result += itemString + ",";
      }
      return result;
    });
    __publicField(this, "toJSON", () => {
      return {
        size: this.size,
        first: this.firstValue,
        last: this.lastValue
      };
    });
    this.items = [...options.items];
  }
  /**
   * Returns the number of items in the collection
   */
  get size() {
    return this.items.length;
  }
  /**
   * Returns the first value in the collection
   */
  get firstValue() {
    let index = 0;
    while (this.getItemDisabled(this.at(index))) index++;
    return this.getItemValue(this.at(index));
  }
  /**
   * Returns the last value in the collection
   */
  get lastValue() {
    let index = this.size - 1;
    while (this.getItemDisabled(this.at(index))) index--;
    return this.getItemValue(this.at(index));
  }
  *[Symbol.iterator]() {
    yield* this.items;
  }
};
var match = (label, query) => {
  return !!label?.toLowerCase().startsWith(query.toLowerCase());
};
function insert(items, index, ...values) {
  return [...items.slice(0, index), ...values, ...items.slice(index)];
}
function move(items, indices, toIndex) {
  indices = [...indices].sort((a, b) => a - b);
  const itemsToMove = indices.map((i) => items[i]);
  for (let i = indices.length - 1; i >= 0; i--) {
    items = [...items.slice(0, indices[i]), ...items.slice(indices[i] + 1)];
  }
  toIndex = Math.max(0, toIndex - indices.filter((i) => i < toIndex).length);
  return [...items.slice(0, toIndex), ...itemsToMove, ...items.slice(toIndex)];
}

export {
  ListCollection
};
