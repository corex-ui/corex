import { connect, machine, type Props, type Api } from "@zag-js/menu";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class Menu extends Component<Props, Api> {
  children: Menu[] = [];

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return connect(this.machine.service, normalizeProps);
  }

  setChild(child: Menu) {
    this.api.setChild(child.machine.service);
    if (!this.children.includes(child)) {
      this.children.push(child);
    }
  }

  setParent(parent: Menu) {
    this.api.setParent(parent.machine.service);
  }

  /**
   * Check if an element belongs to THIS menu instance.
   * Uses the nearest phx-hook="Menu" ancestor to determine ownership.
   */
  private isOwnElement(el: HTMLElement): boolean {
    const nearestHook = el.closest('[phx-hook="Menu"]');
    return nearestHook === this.el;
  }

  renderSubmenuTriggers() {
    const contentEl = this.el.querySelector<HTMLElement>(
      '[data-scope="menu"][data-part="content"]'
    );
    if (!contentEl) return;

    const triggerItems = contentEl.querySelectorAll<HTMLElement>(
      '[data-scope="menu"][data-nested-menu]'
    );

    for (const triggerEl of triggerItems) {
      if (!this.isOwnElement(triggerEl)) continue;

      const nestedMenuId = triggerEl.dataset.nestedMenu;
      if (!nestedMenuId) continue;

      const childMenu = this.children.find(
        (child) => child.el.id === `menu:${nestedMenuId}`
      );
      if (!childMenu) continue;

      const applyProps = () => {
        const triggerProps = this.api.getTriggerItemProps(childMenu.api);
        this.spreadProps(triggerEl, triggerProps);
      };

      applyProps();
      this.machine.subscribe(applyProps);
      childMenu.machine.subscribe(applyProps);
    }
  }

  render(): void {
    const triggerEl = this.el.querySelector<HTMLElement>(
      '[data-scope="menu"][data-part="trigger"]'
    );
    if (triggerEl) {
      this.spreadProps(triggerEl, this.api.getTriggerProps());
    }

    const positionerEl = this.el.querySelector<HTMLElement>(
      '[data-scope="menu"][data-part="positioner"]'
    );
    const contentEl = this.el.querySelector<HTMLElement>(
      '[data-scope="menu"][data-part="content"]'
    );

    if (positionerEl && contentEl) {
      // Always apply positioner and content props so Zag can manage visibility,
      // keyboard handlers, aria-activedescendant, etc. across state transitions.
      // getContentProps() includes hidden: !open which controls content visibility.
      this.spreadProps(positionerEl, this.api.getPositionerProps());
      this.spreadProps(contentEl, this.api.getContentProps());

      // Also manage positioner hidden state for rendering optimization
      positionerEl.hidden = !this.api.open;

      if (this.api.open) {
        // Handle menu items - only process items belonging to THIS menu
        const items = contentEl.querySelectorAll<HTMLElement>(
          '[data-scope="menu"][data-part="item"]'
        );
        items.forEach((itemEl) => {
          if (!this.isOwnElement(itemEl)) return;

          const value = itemEl.dataset.value;
          if (value) {
            const disabled = itemEl.hasAttribute("data-disabled");
            this.spreadProps(
              itemEl,
              this.api.getItemProps({ value, disabled: disabled || undefined })
            );
          }
        });

        // Handle option items (checkbox/radio)
        const optionItems = contentEl.querySelectorAll<HTMLElement>(
          '[data-scope="menu"][data-part="option-item"]'
        );
        optionItems.forEach((optionItemEl) => {
          if (!this.isOwnElement(optionItemEl)) return;

          const value = optionItemEl.dataset.value;
          const type = optionItemEl.dataset.type as "checkbox" | "radio" | undefined;
          if (value && type) {
            const checked = optionItemEl.hasAttribute("data-checked");
            const disabled = optionItemEl.hasAttribute("data-disabled");
            this.spreadProps(
              optionItemEl,
              this.api.getOptionItemProps({
                value,
                type,
                checked: checked,
                disabled: disabled || undefined,
              })
            );
          }
        });

        // Handle item groups
        const itemGroups = contentEl.querySelectorAll<HTMLElement>(
          '[data-scope="menu"][data-part="item-group"]'
        );
        itemGroups.forEach((groupEl) => {
          if (!this.isOwnElement(groupEl)) return;

          const groupId = groupEl.id;
          if (groupId) {
            this.spreadProps(groupEl, this.api.getItemGroupProps({ id: groupId }));
          }
        });

        // Handle separators
        const separators = contentEl.querySelectorAll<HTMLElement>(
          '[data-scope="menu"][data-part="separator"]'
        );
        separators.forEach((separatorEl) => {
          if (!this.isOwnElement(separatorEl)) return;
          this.spreadProps(separatorEl, this.api.getSeparatorProps());
        });
      }
    }

    const indicatorEl = this.el.querySelector<HTMLElement>(
      '[data-scope="menu"][data-part="indicator"]'
    );
    if (indicatorEl) {
      this.spreadProps(indicatorEl, this.api.getIndicatorProps());
    }
  }
}
