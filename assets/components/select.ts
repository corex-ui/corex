import { connect, machine, collection, type Props, type Api } from "@zag-js/select";
import type { ListCollection } from "@zag-js/collection";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";
import { getString } from "../lib/util";

type Item = {
  id?: string;
  value?: string;
  label: string;
  disabled?: boolean;
  group?: string;
};

export class Select extends Component<Props, Api> {
  private _options: Item[] = [];
  hasGroups: boolean = false;
  private placeholder: string = "";

  constructor(el: HTMLElement | null, props: Props) {
    super(el, props);
    const collectionFromProps = (props as Props & { collection?: { items: Item[] } }).collection;
    this._options = collectionFromProps?.items ?? [];
    this.placeholder = getString(this.el, "placeholder") || "";
  }

  get options(): Item[] {
    return Array.isArray(this._options) ? this._options : [];
  }

  setOptions(options: Item[]) {
    this._options = Array.isArray(options) ? options : [];
  }

  getCollection(): ListCollection<Item> {
    const items = this.options;

    if (this.hasGroups) {
      return collection({
        items: items,
        itemToValue: (item) => item.id ?? item.value ?? "",
        itemToString: (item) => item.label,
        isItemDisabled: (item) => !!item.disabled,
        groupBy: (item: Item) => item.group ?? "",
      });
    }

    return collection({
      items: items,
      itemToValue: (item) => item.id ?? item.value ?? "",
      itemToString: (item) => item.label,
      isItemDisabled: (item) => !!item.disabled,
    });
  }

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    const getCollection = this.getCollection.bind(this);
    const collectionFromProps = (props as Props & { collection?: ListCollection<Item> }).collection;

    return new VanillaMachine(machine, {
      ...props,
      get collection() {
        return collectionFromProps ?? getCollection();
      },
    });
  }

  initApi(): Api {
    return connect(this.machine.service, normalizeProps);
  }

  init = (): void => {
    this.machine.start();
    this.render();
    this.machine.subscribe(() => {
      this.api = this.initApi();
      this.render();
    });
  };

  applyItemProps(): void {
    const contentEl = this.el.querySelector<HTMLElement>(
      '[data-scope="select"][data-part="content"]'
    );
    if (!contentEl) return;

    contentEl
      .querySelectorAll<HTMLElement>('[data-scope="select"][data-part="item-group"]')
      .forEach((groupEl) => {
        const groupId = groupEl.dataset.id ?? "";
        this.spreadProps(groupEl, this.api.getItemGroupProps({ id: groupId }));
        const labelEl = groupEl.querySelector<HTMLElement>(
          '[data-scope="select"][data-part="item-group-label"]'
        );
        if (labelEl) {
          this.spreadProps(labelEl, this.api.getItemGroupLabelProps({ htmlFor: groupId }));
        }
      });

    contentEl
      .querySelectorAll<HTMLElement>('[data-scope="select"][data-part="item"]')
      .forEach((itemEl) => {
        const value = itemEl.dataset.value ?? "";
        const item = this.options.find((i) => String(i.id ?? i.value ?? "") === String(value));
        if (!item) return;
        this.spreadProps(itemEl, this.api.getItemProps({ item }));
        const textEl = itemEl.querySelector<HTMLElement>(
          '[data-scope="select"][data-part="item-text"]'
        );
        if (textEl) {
          this.spreadProps(textEl, this.api.getItemTextProps({ item }));
        }
        const indicatorEl = itemEl.querySelector<HTMLElement>(
          '[data-scope="select"][data-part="item-indicator"]'
        );
        if (indicatorEl) {
          this.spreadProps(indicatorEl, this.api.getItemIndicatorProps({ item }));
        }
      });
  }

  render(): void {
    const root =
      this.el.querySelector<HTMLElement>('[data-scope="select"][data-part="root"]') ?? this.el;

    this.spreadProps(root, this.api.getRootProps());

    const hiddenSelect = this.el.querySelector<HTMLSelectElement>(
      '[data-scope="select"][data-part="hidden-select"]'
    );

    const valueInput = this.el.querySelector<HTMLInputElement>(
      '[data-scope="select"][data-part="value-input"]'
    );
    if (valueInput) {
      if (!this.api.value || this.api.value.length === 0) {
        valueInput.value = "";
      } else if (this.api.value.length === 1) {
        valueInput.value = String(this.api.value[0]);
      } else {
        valueInput.value = this.api.value.map(String).join(",");
      }
    }

    if (hiddenSelect) {
      this.spreadProps(hiddenSelect, this.api.getHiddenSelectProps());
    }

    ["label", "control", "trigger", "indicator", "clear-trigger", "positioner"].forEach((part) => {
      const el = this.el.querySelector<HTMLElement>(`[data-scope="select"][data-part="${part}"]`);
      if (!el) return;

      const method =
        "get" +
        part
          .split("-")
          .map((s) => s[0].toUpperCase() + s.slice(1))
          .join("") +
        "Props";

      // @ts-expect-error zag dynamic api
      this.spreadProps(el, this.api[method]());
    });

    const valueText = this.el.querySelector<HTMLElement>(
      '[data-scope="select"][data-part="item-text"]'
    );
    if (valueText) {
      const valueAsString = this.api.valueAsString;
      if (this.api.value && this.api.value.length > 0 && !valueAsString) {
        const selectedValue = this.api.value[0];
        const selectedItem = this.options.find((item: Item) => {
          const itemValue = item.id ?? item.value ?? "";
          return String(itemValue) === String(selectedValue);
        });
        if (selectedItem) {
          valueText.textContent = selectedItem.label;
        } else {
          valueText.textContent = this.placeholder || "";
        }
      } else {
        valueText.textContent = valueAsString || this.placeholder || "";
      }
    }

    const contentEl = this.el.querySelector<HTMLElement>(
      '[data-scope="select"][data-part="content"]'
    );
    if (contentEl) {
      this.spreadProps(contentEl, this.api.getContentProps());
      this.applyItemProps();
    }
  }
}
