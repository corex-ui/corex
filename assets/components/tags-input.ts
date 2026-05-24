import { connect, machine, type Props, type Api } from "@zag-js/tags-input";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component } from "../lib/core";
import { getString, templatesContentRoot } from "../lib/util";
import { syncTagsInputFormForPhoenix } from "../lib/tags-input-form";

type ZagTagsInputTranslations = NonNullable<Props["translations"]>;

export type TagsInputMessageMap = {
  deleteTagTriggerLabel?: string;
  tagEdited?: string;
};

const TAG_PLACEHOLDER = "%{tag}";

const DEFAULT_DELETE_TEMPLATE = "Delete tag %{tag}";
const DEFAULT_TAG_EDITED_TEMPLATE = "Editing tag %{tag}. Press enter to save or escape to cancel.";

function formatTagTemplate(template: string, tag: string): string {
  return template.split(TAG_PLACEHOLDER).join(tag);
}

export function buildZagTagsInputTranslations(m: TagsInputMessageMap): ZagTagsInputTranslations {
  const deleteTemplate = m.deleteTagTriggerLabel ?? DEFAULT_DELETE_TEMPLATE;
  const editTemplate = m.tagEdited ?? DEFAULT_TAG_EDITED_TEMPLATE;
  return {
    deleteTagTriggerLabel: (value: string) => formatTagTemplate(deleteTemplate, value),
    tagEdited: (value: string) => formatTagTemplate(editTemplate, value),
  } as ZagTagsInputTranslations;
}

export function resolveZagTagsInputTranslations(el: HTMLElement): {
  translations: ZagTagsInputTranslations;
} {
  const raw = el.dataset.translation;
  if (!raw) {
    return { translations: buildZagTagsInputTranslations({}) };
  }
  try {
    const m = JSON.parse(raw) as TagsInputMessageMap;
    return { translations: buildZagTagsInputTranslations(m) };
  } catch {
    return { translations: buildZagTagsInputTranslations({}) };
  }
}

function directItemElements(controlEl: HTMLElement): HTMLElement[] {
  return Array.from(
    controlEl.querySelectorAll<HTMLElement>(':scope > [data-scope="tags-input"][data-part="item"]')
  );
}

function itemInputIsEditing(input: HTMLElement | null): boolean {
  if (!input) return false;
  return !input.hidden;
}

export class TagsInput extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  private spreadItemParts(itemEl: HTMLElement, index: number, value: string): void {
    this.spreadProps(itemEl, this.api.getItemProps({ index, value }));
    const previewEl = itemEl.querySelector<HTMLElement>(
      '[data-scope="tags-input"][data-part="item-preview"]'
    );
    if (previewEl) this.spreadProps(previewEl, this.api.getItemPreviewProps({ index, value }));
    const textEl = itemEl.querySelector<HTMLElement>(
      '[data-scope="tags-input"][data-part="item-text"]'
    );
    if (textEl) this.spreadProps(textEl, this.api.getItemTextProps({ index, value }));
    const delEl = itemEl.querySelector<HTMLElement>(
      '[data-scope="tags-input"][data-part="item-delete-trigger"]'
    );
    if (delEl) {
      while (delEl.childElementCount > 1) {
        delEl.removeChild(delEl.lastElementChild!);
      }
      this.spreadProps(delEl, this.api.getItemDeleteTriggerProps({ index, value }));
    }
    const itemInputEl = itemEl.querySelector<HTMLElement>(
      '[data-scope="tags-input"][data-part="item-input"]'
    );
    if (itemInputEl) this.spreadProps(itemInputEl, this.api.getItemInputProps({ index, value }));
    if (textEl && !itemInputIsEditing(itemInputEl)) {
      textEl.textContent = value;
    }
  }

  private renderItems(): void {
    const controlEl = this.el.querySelector<HTMLElement>(
      '[data-scope="tags-input"][data-part="control"]'
    );
    if (!controlEl) return;

    const mainInputEl = controlEl.querySelector<HTMLElement>(
      ':scope > [data-scope="tags-input"][data-part="input"]'
    );
    if (!mainInputEl) return;

    const templatesRoot = templatesContentRoot(this.el, "tags-input");
    if (!templatesRoot) return;

    const template = templatesRoot.querySelector<HTMLElement>(
      '[data-scope="tags-input"][data-part="item"][data-template]'
    );
    if (!template) return;

    const values = this.api.value ?? [];

    let items = directItemElements(controlEl);
    while (items.length > values.length) {
      items[items.length - 1]!.remove();
      items = directItemElements(controlEl);
    }

    for (let index = 0; index < values.length; index++) {
      const value = values[index]!;
      items = directItemElements(controlEl);
      let itemEl = items[index];
      const isItem =
        itemEl?.getAttribute("data-scope") === "tags-input" &&
        itemEl?.getAttribute("data-part") === "item";

      if (!itemEl || !isItem) {
        const fresh = template.cloneNode(true) as HTMLElement;
        fresh.removeAttribute("data-template");
        const ref = items[index] ?? mainInputEl;
        controlEl.insertBefore(fresh, ref);
        items = directItemElements(controlEl);
        itemEl = items[index]!;
      }

      const itemInputEl = itemEl.querySelector<HTMLElement>(
        '[data-scope="tags-input"][data-part="item-input"]'
      );
      const editing = itemInputIsEditing(itemInputEl);

      if (!editing && itemEl.dataset.value !== value) {
        itemEl.dataset.value = value;
      }

      this.spreadItemParts(itemEl, index, value);
    }
  }

  render(): void {
    const rootEl = this.el.querySelector<HTMLElement>(
      '[data-scope="tags-input"][data-part="root"]'
    );
    if (!rootEl) return;
    this.spreadProps(rootEl, this.api.getRootProps());

    const labelEl = this.el.querySelector<HTMLElement>(
      '[data-scope="tags-input"][data-part="label"]'
    );
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());

    const controlEl = this.el.querySelector<HTMLElement>(
      '[data-scope="tags-input"][data-part="control"]'
    );
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());

    this.renderItems();

    const inputEl = this.el.querySelector<HTMLElement>(
      '[data-scope="tags-input"][data-part="input"]'
    );
    if (inputEl) this.spreadProps(inputEl, this.api.getInputProps());

    if (getString(this.el, "submitName")) {
      syncTagsInputFormForPhoenix(this.el, this.api.value ?? []);
    }

    const hiddenEl = this.el.querySelector<HTMLElement>(
      '[data-scope="tags-input"][data-part="hidden-input"]'
    );
    if (hiddenEl) {
      this.spreadProps(hiddenEl, this.api.getHiddenInputProps());
      hiddenEl.removeAttribute("name");
      hiddenEl.removeAttribute("form");
    }
  }
}
