import {
  collection,
  connect,
  machine,
  type Props,
  type Api,
  type OpenChangeDetails,
  type InputValueChangeDetails,
} from "@zag-js/combobox";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component } from "../lib/core";
import { stripZagSubmitNames } from "../lib/form-field-array-submit";
import { getString } from "../lib/util";
import { itemValue, zagListCollectionConfig } from "../lib/list-collection";
import { templatesContentRoot } from "../lib/util";

export type ComboboxItem = {
  value?: string;
  label: string;
  disabled?: boolean;
  group?: string;
};

export class Combobox extends Component<Props, Api> {
  options!: ComboboxItem[];
  allOptions!: ComboboxItem[];
  hasGroups!: boolean;

  constructor(el: HTMLElement | null, props: Props, allItems: ComboboxItem[], hasGroups: boolean) {
    super(el, props, (self) => {
      const c = self as Combobox;
      c.allOptions = allItems;
      c.options = allItems;
      c.hasGroups = hasGroups;
    });
    this.allOptions = allItems;
    this.options = allItems;
    this.hasGroups = hasGroups;
  }

  setAllOptions(options: ComboboxItem[]) {
    this.allOptions = options;
    this.options = options;
  }

  restoreFilteredOptions() {
    this.options = this.allOptions;
  }

  private activeItems(): ComboboxItem[] {
    return this.options.length > 0 ? this.options : this.allOptions;
  }

  getCollection() {
    const items = this.activeItems();
    return collection(zagListCollectionConfig(items, this.hasGroups));
  }

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    const getCollection = () => this.getCollection();

    return new VanillaMachine(machine, {
      ...props,
      get collection() {
        return getCollection();
      },
      onOpenChange: (details: OpenChangeDetails) => {
        if (details.open && details.reason !== "input-change") {
          this.options = this.allOptions;
        }
        if (props.onOpenChange) {
          props.onOpenChange(details);
        }
      },
      onInputValueChange: (details: InputValueChangeDetails) => {
        if (props.onInputValueChange) {
          props.onInputValueChange(details);
        }
        if (this.el.hasAttribute("data-filter")) {
          const q = String(details.inputValue ?? "").toLowerCase();
          const filtered = this.allOptions.filter((item: ComboboxItem) => {
            const label = String(item.label ?? "").toLowerCase();
            const value = String(itemValue(item)).toLowerCase();
            return label.includes(q) || value.includes(q);
          });
          this.options = filtered.length > 0 ? filtered : this.allOptions;
        } else {
          this.options = this.allOptions;
        }
      },
    });
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  private getItemValue(item: ComboboxItem): string {
    const v = this.api.collection.getItemValue?.(item) as string | undefined;
    return v ?? itemValue(item);
  }

  private buildOrderedBlocks(
    items: ComboboxItem[]
  ): (
    | { type: "default"; items: ComboboxItem[] }
    | { type: "group"; groupId: string; items: ComboboxItem[] }
  )[] {
    const blocks: (
      | { type: "default"; items: ComboboxItem[] }
      | { type: "group"; groupId: string; items: ComboboxItem[] }
    )[] = [];
    let current:
      | { type: "default"; items: ComboboxItem[] }
      | { type: "group"; groupId: string; items: ComboboxItem[] }
      | null = null;

    for (const item of items) {
      const groupKey = item.group ?? "";
      if (groupKey === "") {
        if (current?.type !== "default") {
          current = { type: "default", items: [] };
          blocks.push(current);
        }
        current.items.push(item);
      } else {
        if (current?.type !== "group" || current.groupId !== groupKey) {
          current = { type: "group", groupId: groupKey, items: [] };
          blocks.push(current);
        }
        current.items.push(item);
      }
    }
    return blocks;
  }

  private isOwnedByList(listEl: HTMLElement, el: Element): boolean {
    return el.closest('[data-scope="combobox"][data-part="list"]') === listEl;
  }

  private listPartElements(listEl: HTMLElement, part: string): HTMLElement[] {
    return Array.from(
      listEl.querySelectorAll<HTMLElement>(
        `[data-scope="combobox"][data-part="${part}"]:not([data-template])`
      )
    ).filter((el) => this.isOwnedByList(listEl, el));
  }

  private directListPartElements(listEl: HTMLElement, part: string): HTMLElement[] {
    return Array.from(listEl.children).filter(
      (el): el is HTMLElement =>
        el instanceof HTMLElement &&
        el.getAttribute("data-scope") === "combobox" &&
        el.getAttribute("data-part") === part &&
        !el.hasAttribute("data-template")
    );
  }

  private removeListParts(listEl: HTMLElement, parts: readonly string[]): void {
    for (const part of parts) {
      this.listPartElements(listEl, part).forEach((el) => el.remove());
    }
  }

  private cloneItemFromTemplate(
    templatesRoot: DocumentFragment | HTMLElement,
    value: string
  ): HTMLElement | null {
    const template = templatesRoot.querySelector<HTMLElement>(
      `:scope > [data-scope="combobox"][data-part="item"][data-value="${CSS.escape(value)}"][data-template]`
    );
    if (!template) return null;
    const itemEl = template.cloneNode(true) as HTMLElement;
    itemEl.removeAttribute("data-template");
    return itemEl;
  }

  private cloneGroupFromTemplate(
    templatesRoot: DocumentFragment | HTMLElement,
    groupId: string
  ): HTMLElement | null {
    const groupTemplate = templatesRoot.querySelector<HTMLElement>(
      `[data-scope="combobox"][data-part="item-group"][data-id="${CSS.escape(groupId)}"][data-template]`
    );
    if (!groupTemplate) return null;
    const groupEl = groupTemplate.cloneNode(true) as HTMLElement;
    groupEl.removeAttribute("data-template");
    groupEl
      .querySelectorAll<HTMLElement>("[data-template]")
      .forEach((e) => e.removeAttribute("data-template"));
    return groupEl;
  }

  private syncFlatItems(
    listEl: HTMLElement,
    templatesRoot: DocumentFragment | HTMLElement,
    items: ComboboxItem[]
  ): void {
    const desiredValues = items.map((item) => this.getItemValue(item));
    const desiredSet = new Set(desiredValues);

    this.listPartElements(listEl, "item").forEach((itemEl) => {
      const value = itemEl.dataset.value ?? "";
      if (!desiredSet.has(value)) itemEl.remove();
    });

    const byValue = new Map<string, HTMLElement>();
    this.listPartElements(listEl, "item").forEach((itemEl) => {
      byValue.set(itemEl.dataset.value ?? "", itemEl);
    });

    for (let index = 0; index < desiredValues.length; index += 1) {
      const value = desiredValues[index]!;
      let itemEl = byValue.get(value);
      if (!itemEl) {
        itemEl = this.cloneItemFromTemplate(templatesRoot, value) ?? undefined;
        if (!itemEl) continue;
        listEl.appendChild(itemEl);
        byValue.set(value, itemEl);
      }
      const ref = listEl.children[index] ?? null;
      if (listEl.children[index] !== itemEl) {
        listEl.insertBefore(itemEl, ref);
      }
    }

    while (listEl.children.length > desiredValues.length) {
      listEl.lastElementChild?.remove();
    }
  }

  private syncGroupItems(
    groupEl: HTMLElement,
    blockItems: ComboboxItem[],
    templatesRoot: DocumentFragment | HTMLElement
  ): void {
    const ul = groupEl.querySelector("ul");
    if (!ul) return;

    const desiredValues = blockItems.map((item) => this.getItemValue(item));
    const desiredSet = new Set(desiredValues);
    const groupId = groupEl.dataset.id ?? "";

    Array.from(
      ul.querySelectorAll<HTMLElement>(
        '[data-scope="combobox"][data-part="item"]:not([data-template])'
      )
    ).forEach((itemEl) => {
      const value = itemEl.dataset.value ?? "";
      if (!desiredSet.has(value)) itemEl.remove();
    });

    const byValue = new Map<string, HTMLElement>();
    Array.from(ul.children).forEach((child) => {
      if (!(child instanceof HTMLElement)) return;
      if (child.getAttribute("data-part") !== "item") return;
      byValue.set(child.dataset.value ?? "", child);
    });

    for (let index = 0; index < desiredValues.length; index += 1) {
      const value = desiredValues[index]!;
      let itemEl = byValue.get(value);
      if (!itemEl) {
        const groupTemplate = templatesRoot.querySelector<HTMLElement>(
          `[data-scope="combobox"][data-part="item-group"][data-id="${CSS.escape(groupId)}"][data-template]`
        );
        const itemTemplate = groupTemplate?.querySelector<HTMLElement>(
          `[data-scope="combobox"][data-part="item"][data-value="${CSS.escape(value)}"]`
        );
        if (!itemTemplate) continue;
        itemEl = itemTemplate.cloneNode(true) as HTMLElement;
        itemEl.removeAttribute("data-template");
        ul.appendChild(itemEl);
        byValue.set(value, itemEl);
      }
      const ref = ul.children[index] ?? null;
      if (ul.children[index] !== itemEl) {
        ul.insertBefore(itemEl, ref);
      }
    }

    while (ul.children.length > desiredValues.length) {
      ul.lastElementChild?.remove();
    }
  }

  private syncGroupedItems(
    listEl: HTMLElement,
    templatesRoot: DocumentFragment | HTMLElement,
    items: ComboboxItem[]
  ): void {
    const blocks = this.buildOrderedBlocks(items).filter(
      (block): block is { type: "group"; groupId: string; items: ComboboxItem[] } =>
        block.type === "group"
    );
    const desiredGroupIds = new Set(blocks.map((block) => block.groupId));

    this.listPartElements(listEl, "item-group").forEach((groupEl) => {
      const groupId = groupEl.dataset.id ?? "";
      if (!desiredGroupIds.has(groupId)) groupEl.remove();
    });

    const groupsById = new Map<string, HTMLElement>();
    this.listPartElements(listEl, "item-group").forEach((groupEl) => {
      groupsById.set(groupEl.dataset.id ?? "", groupEl);
    });

    for (let index = 0; index < blocks.length; index += 1) {
      const block = blocks[index]!;
      let groupEl = groupsById.get(block.groupId);
      if (!groupEl) {
        groupEl = this.cloneGroupFromTemplate(templatesRoot, block.groupId) ?? undefined;
        if (!groupEl) continue;
        listEl.appendChild(groupEl);
        groupsById.set(block.groupId, groupEl);
      }
      const ref = listEl.children[index] ?? null;
      if (listEl.children[index] !== groupEl) {
        listEl.insertBefore(groupEl, ref);
      }
      this.syncGroupItems(groupEl, block.items, templatesRoot);
    }

    while (listEl.children.length > blocks.length) {
      listEl.lastElementChild?.remove();
    }
  }

  private syncEmptyState(listEl: HTMLElement, templatesRoot: DocumentFragment | HTMLElement): void {
    this.removeListParts(listEl, ["item", "item-group"]);
    if (this.listPartElements(listEl, "empty").length > 0) return;

    const emptyTemplate = templatesRoot.querySelector<HTMLElement>(
      '[data-scope="combobox"][data-part="empty"][data-template]'
    );
    if (!emptyTemplate) return;

    const emptyEl = emptyTemplate.cloneNode(true) as HTMLElement;
    emptyEl.removeAttribute("data-template");
    listEl.appendChild(emptyEl);
  }

  renderItems(): void {
    const listEl = this.el.querySelector<HTMLElement>('[data-scope="combobox"][data-part="list"]');
    if (!listEl) return;

    const templatesRoot = templatesContentRoot(this.el, "combobox");
    if (!templatesRoot) return;

    const items = this.activeItems();

    if (items.length === 0) {
      this.syncEmptyState(listEl, templatesRoot);
      return;
    }

    this.removeListParts(listEl, ["empty"]);

    if (this.hasGroups) {
      this.directListPartElements(listEl, "item").forEach((el) => el.remove());
      this.syncGroupedItems(listEl, templatesRoot, items);
    } else {
      this.removeListParts(listEl, ["item-group"]);
      this.syncFlatItems(listEl, templatesRoot, items);
    }
  }

  applyItemProps(): void {
    const listEl = this.el.querySelector<HTMLElement>('[data-scope="combobox"][data-part="list"]');
    if (!listEl) return;

    const isOwnedByList = (el: Element) =>
      el.closest('[data-scope="combobox"][data-part="list"]') === listEl;

    listEl
      .querySelectorAll<HTMLElement>('[data-scope="combobox"][data-part="item-group"]')
      .forEach((groupEl) => {
        if (!isOwnedByList(groupEl)) return;
        const groupId = groupEl.dataset.id ?? "";
        this.spreadProps(groupEl, this.api.getItemGroupProps({ id: groupId }));
        const labelEl = groupEl.querySelector<HTMLElement>(
          '[data-scope="combobox"][data-part="item-group-label"]'
        );
        if (labelEl) {
          this.spreadProps(labelEl, this.api.getItemGroupLabelProps({ htmlFor: groupId }));
        }
      });

    const sourceItems = this.activeItems();
    const byValue = new Map<string, ComboboxItem>();
    for (const item of sourceItems) {
      byValue.set(this.getItemValue(item), item);
    }
    for (const item of this.allOptions) {
      const v = this.getItemValue(item);
      if (!byValue.has(v)) byValue.set(v, item);
    }

    listEl
      .querySelectorAll<HTMLElement>('[data-scope="combobox"][data-part="item"]')
      .forEach((itemEl) => {
        if (!isOwnedByList(itemEl)) return;
        const value = itemEl.dataset.value ?? "";
        const item = byValue.get(value);
        if (!item) return;
        this.spreadProps(itemEl, this.api.getItemProps({ item }));
        const textEl = itemEl.querySelector<HTMLElement>(
          '[data-scope="combobox"][data-part="item-text"]'
        );
        if (textEl) {
          this.spreadProps(textEl, this.api.getItemTextProps({ item }));
        }
        const indicatorEl = itemEl.querySelector<HTMLElement>(
          '[data-scope="combobox"][data-part="item-indicator"]'
        );
        if (indicatorEl) {
          this.spreadProps(indicatorEl, this.api.getItemIndicatorProps({ item }));
        }
      });
  }

  private hiddenInputValue(): string {
    let values = (this.api.value ?? []).map(String);
    if (values.length === 0) {
      const fallback = this.el.dataset.defaultValue;
      if (fallback) values = fallback.split(",").filter(Boolean);
    }
    const multiple = this.el.hasAttribute("data-multiple");
    return values.length === 0 ? "" : multiple ? values.join(",") : (values[0] ?? "");
  }

  render(): void {
    const root = this.el.querySelector<HTMLElement>('[data-scope="combobox"][data-part="root"]');
    if (!root) return;
    this.spreadProps(root, this.api.getRootProps());

    const hiddenInput = this.el.querySelector<HTMLInputElement>(
      '[data-scope="combobox"][data-part="hidden-input"]'
    );
    if (hiddenInput) {
      const valueStr = this.hiddenInputValue();
      if (hiddenInput.value !== valueStr) hiddenInput.value = valueStr;
      if (getString(this.el, "submitName")) {
        hiddenInput.removeAttribute("name");
        hiddenInput.removeAttribute("form");
      }
    }

    stripZagSubmitNames(this.el, "combobox", ["hidden-input", "input"]);

    [
      "label",
      "control",
      "input",
      "trigger",
      "clear-trigger",
      "positioner",
      "content",
      "list",
    ].forEach((part) => {
      const el = this.el.querySelector<HTMLElement>(`[data-scope="combobox"][data-part="${part}"]`);
      if (!el) return;

      const apiMethod =
        "get" +
        part
          .split("-")
          .map((s) => s[0].toUpperCase() + s.slice(1))
          .join("") +
        "Props";

      // @ts-expect-error dynamic
      this.spreadProps(el, this.api[apiMethod]());
    });

    this.renderItems();
    this.applyItemProps();
  }
}
