import { connect, machine, type Props, type Api } from "@zag-js/accordion";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component } from "../lib/core";
import { stripHiddenFromProps } from "../lib/animation";

export class Accordion extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const rootEl =
      this.el.querySelector<HTMLElement>('[data-scope="accordion"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());
    const scopeId = this.el.id;
    const itemPrefix = scopeId ? `accordion:${scopeId}:item:` : "";
    const itemEls = rootEl.querySelectorAll<HTMLElement>(
      '[data-scope="accordion"][data-part="item"]'
    );

    const animation = this.el.dataset.animation ?? "instant";

    for (const itemEl of itemEls) {
      if (itemPrefix && !itemEl.id.startsWith(itemPrefix)) continue;
      const value = itemEl.dataset.value;
      if (!value) continue;

      const disabled = itemEl.dataset.disabled === "";

      this.spreadProps(itemEl, this.api.getItemProps({ value, disabled }));

      const triggerEl = itemEl.querySelector<HTMLElement>(
        '[data-scope="accordion"][data-part="item-trigger"]'
      );
      if (triggerEl) {
        this.spreadProps(triggerEl, this.api.getItemTriggerProps({ value, disabled }));
      }

      const indicatorEl = itemEl.querySelector<HTMLElement>(
        '[data-scope="accordion"][data-part="item-indicator"]'
      );
      if (indicatorEl) {
        this.spreadProps(indicatorEl, this.api.getItemIndicatorProps({ value, disabled }));
      }

      const contentEl = itemEl.querySelector<HTMLElement>(
        '[data-scope="accordion"][data-part="item-content"]'
      );
      if (contentEl) {
        if (animation === "instant") {
          this.spreadProps(contentEl, this.api.getItemContentProps({ value, disabled }));
        } else if (animation === "js" || animation === "custom") {
          this.spreadProps(
            contentEl,
            stripHiddenFromProps(
              this.api.getItemContentProps({ value, disabled }) as Record<string, unknown>
            )
          );
          contentEl.removeAttribute("hidden");
        }
      }
    }
  }
}
