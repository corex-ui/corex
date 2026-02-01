import * as combobox from "@zag-js/combobox";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";
import { getString } from "../lib/util";

export class Combobox extends Component<combobox.Props, combobox.Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: combobox.Props): VanillaMachine<any> {
    return new VanillaMachine(combobox.machine, props);
  }

  initApi(): combobox.Api {
    return combobox.connect(this.machine.service, normalizeProps);
  }

  render(): void {
    const rootEl = this.el.querySelector<HTMLElement>('[data-part="root"]') || this.el;
    this.spreadProps(rootEl, this.api.getRootProps());
  
    const labelEl = this.el.querySelector<HTMLElement>('[data-part="label"]');
    if (labelEl) {
      this.spreadProps(labelEl, this.api.getLabelProps());
    }
  
    const controlEl = this.el.querySelector<HTMLElement>('[data-part="control"]');
    if (controlEl) {
      this.spreadProps(controlEl, this.api.getControlProps());
    }
  
    const inputEl = this.el.querySelector<HTMLElement>('[data-part="input"]');
    if (inputEl) {
      this.spreadProps(inputEl, this.api.getInputProps());
    }
  
    const triggerEl = this.el.querySelector<HTMLElement>('[data-part="trigger"]');
    if (triggerEl) {
      this.spreadProps(triggerEl, this.api.getTriggerProps());
    }
  
    const clearTriggerEl = this.el.querySelector<HTMLElement>('[data-part="clear-trigger"]');
    if (clearTriggerEl) {
      this.spreadProps(clearTriggerEl, this.api.getClearTriggerProps());
    }
  
    const positionerEl = this.el.querySelector<HTMLElement>('[data-part="positioner"]');
    if (positionerEl) {
      this.spreadProps(positionerEl, this.api.getPositionerProps());
    }
  
    const contentEl = this.el.querySelector<HTMLElement>('[data-part="content"]');
    if (contentEl) {
      this.spreadProps(contentEl, this.api.getContentProps());

      const visibleGroups = new Set<string>();
  
      const itemEls = contentEl.querySelectorAll<HTMLElement>('[data-part="item"]');
      for (let j = 0; j < itemEls.length; j++) {
        const itemEl = itemEls[j];
        const value = getString(itemEl, "value");
        if (!value) continue;
  
        const item = this.api.collection.find(value);
        if (!item) {
          itemEl.style.display = 'none';
          continue;
        }
        
        itemEl.style.display = '';
        this.spreadProps(itemEl, this.api.getItemProps({ item }));

        const groupEl = itemEl.closest('[data-part="item-group"]') as HTMLElement | null;
        if (groupEl) {
          const groupId = groupEl.getAttribute("data-id");
          if (groupId) visibleGroups.add(groupId);
        }
  
        const indicatorEl = itemEl.querySelector<HTMLElement>('[data-part="item-indicator"]');
        if (indicatorEl) {
          this.spreadProps(indicatorEl, this.api.getItemIndicatorProps({ item }));
        }

        const itemTextEl = itemEl.querySelector<HTMLElement>('[data-part="item-text"]');
        if (itemTextEl) {
          this.spreadProps(itemTextEl, this.api.getItemTextProps({ item }));
        }
      }

      const groupEls = contentEl.querySelectorAll<HTMLElement>('[data-part="item-group"]');
      for (let i = 0; i < groupEls.length; i++) {
        const groupEl = groupEls[i];
        const groupId = groupEl.getAttribute("data-id");
        
        if (groupId && visibleGroups.has(groupId)) {
          groupEl.style.display = '';
          this.spreadProps(groupEl, this.api.getItemGroupProps({ id: groupId }));
        } else {
          groupEl.style.display = 'none';
        }
      }

      const groupLabelEls = contentEl.querySelectorAll<HTMLElement>('[data-part="item-group-label"]');
      for (let i = 0; i < groupLabelEls.length; i++) {
        const labelEl = groupLabelEls[i];
        const groupId = labelEl.getAttribute("data-id");
        
        if (groupId && visibleGroups.has(groupId)) {
          labelEl.style.display = '';
          this.spreadProps(labelEl, this.api.getItemGroupLabelProps({ htmlFor: groupId }));
        } else {
          labelEl.style.display = 'none';
        }
      }
    }
  }
}