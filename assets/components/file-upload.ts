import { connect, machine, type Props, type Api, type ItemType } from "@zag-js/file-upload";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component } from "../lib/core";

const ACCEPTED: ItemType = "accepted";

function toChar(code: number): string {
  return String.fromCharCode(code + (code > 25 ? 39 : 97));
}

function toName(code: number): string {
  let name = "";
  let x: number;
  for (x = Math.abs(code); x > 52; x = (x / 52) | 0) name = toChar(x % 52) + name;
  return toChar(x % 52) + name;
}

function toPhash(h: number, x: string): number {
  let i = x.length;
  while (i) h = (h * 33) ^ x.charCodeAt(--i);
  return h;
}

export function zagFileId(value: string): string {
  return toName(toPhash(5381, value) >>> 0);
}

export function fileKeyFor(file: File): string {
  return zagFileId(`${file.name}-${file.size}`);
}

export function labelFieldNameFor(fieldName: string): string {
  if (fieldName.includes("[")) {
    return fieldName.replace(/\[([^\]]+)\]$/, "[$1_label]");
  }

  return `${fieldName}_label`;
}

function setInputFiles(inputEl: HTMLInputElement, files: File[]): void {
  try {
    if (typeof window.DataTransfer !== "undefined") {
      const dataTransfer = new window.DataTransfer();
      for (const file of files) {
        dataTransfer.items.add(file);
      }
      inputEl.files = dataTransfer.files;
    }
  } catch {
    // ignore unsupported environments
  }
}

export class FileUpload extends Component<Props, Api> {
  private previewCleanup = new Map<HTMLElement, VoidFunction>();
  private sentinelSnapshot = "";

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  cleanupPreviews(): void {
    for (const cleanup of this.previewCleanup.values()) cleanup();
    this.previewCleanup.clear();
  }

  render(): void {
    const rootEl =
      this.el.querySelector<HTMLElement>('[data-scope="file-upload"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const labelEl = this.el.querySelector<HTMLElement>(
      '[data-scope="file-upload"][data-part="label"]'
    );
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());

    const dropzoneEl = this.el.querySelector<HTMLElement>(
      '[data-scope="file-upload"][data-part="dropzone"]'
    );
    if (dropzoneEl) this.spreadProps(dropzoneEl, this.api.getDropzoneProps());

    const triggerEl = this.el.querySelector<HTMLElement>(
      '[data-scope="file-upload"][data-part="trigger"]'
    );
    if (triggerEl) this.spreadProps(triggerEl, this.api.getTriggerProps());

    const hiddenInputEl =
      this.el.querySelector<HTMLElement>('[data-scope="file-upload"][data-part="hidden-input"]') ??
      rootEl.querySelector<HTMLElement>('input[type="file"]');
    if (hiddenInputEl) this.spreadProps(hiddenInputEl, this.api.getHiddenInputProps());

    const acceptedGroup = this.el.querySelector<HTMLElement>(
      'ul[data-scope="file-upload"][data-part="item-group"][data-file-type="accepted"]'
    );
    if (acceptedGroup) {
      this.spreadProps(acceptedGroup, this.api.getItemGroupProps({ type: ACCEPTED }));
      this.syncAcceptedItems(acceptedGroup);
    }

    const itemEls = this.el.querySelectorAll<HTMLElement>(
      '[data-scope="file-upload"][data-part="item"]'
    );
    for (const itemEl of Array.from(itemEls)) {
      const file = this.getAcceptedFileForElement(itemEl);
      if (!file) continue;

      this.spreadProps(itemEl, this.api.getItemProps({ file, type: ACCEPTED }));

      const itemNameEl = itemEl.querySelector<HTMLElement>(
        '[data-scope="file-upload"][data-part="item-name"]'
      );
      if (itemNameEl)
        this.spreadProps(itemNameEl, this.api.getItemNameProps({ file, type: ACCEPTED }));

      const itemPreviewEl = itemEl.querySelector<HTMLElement>(
        '[data-scope="file-upload"][data-part="item-preview"]'
      );
      if (itemPreviewEl)
        this.spreadProps(itemPreviewEl, this.api.getItemPreviewProps({ file, type: ACCEPTED }));

      const itemPreviewImageEl = itemEl.querySelector<HTMLElement>(
        '[data-scope="file-upload"][data-part="item-preview-image"]'
      );
      if (itemPreviewImageEl && file.type.startsWith("image/")) {
        const fk = fileKeyFor(file);
        const needsInit =
          itemPreviewImageEl.dataset.corexPreviewKey !== fk ||
          !itemPreviewImageEl.getAttribute("src");
        if (needsInit) {
          const prev = this.previewCleanup.get(itemPreviewImageEl);
          prev?.();
          itemPreviewImageEl.removeAttribute("src");
          const cleanup = this.api.createFileUrl(file, (url) => {
            this.spreadProps(
              itemPreviewImageEl,
              this.api.getItemPreviewImageProps({
                file,
                type: ACCEPTED,
                url,
              })
            );
          });
          this.previewCleanup.set(itemPreviewImageEl, cleanup);
          itemPreviewImageEl.dataset.corexPreviewKey = fk;
        } else {
          const url = itemPreviewImageEl.getAttribute("src") ?? "";
          if (url) {
            this.spreadProps(
              itemPreviewImageEl,
              this.api.getItemPreviewImageProps({
                file,
                type: ACCEPTED,
                url,
              })
            );
          }
        }
      }

      const itemSizeTextEl = itemEl.querySelector<HTMLElement>(
        '[data-scope="file-upload"][data-part="item-size-text"]'
      );
      if (itemSizeTextEl) {
        this.spreadProps(itemSizeTextEl, this.api.getItemSizeTextProps({ file, type: ACCEPTED }));
        itemSizeTextEl.textContent = this.api.getFileSize(file);
      }

      const itemDeleteTriggerEl = itemEl.querySelector<HTMLElement>(
        '[data-scope="file-upload"][data-part="item-delete-trigger"]'
      );
      if (itemDeleteTriggerEl) {
        this.spreadProps(
          itemDeleteTriggerEl,
          this.api.getItemDeleteTriggerProps({ file, type: ACCEPTED })
        );
      }
    }

    this.syncFormSubmitInputs();
    this.touchSentinel();
  }

  syncFormSubmitInputs(): void {
    const fileInput = this.el.querySelector<HTMLInputElement>(
      '[data-scope="file-upload"][data-part="hidden-input"]'
    );
    const sentinel = this.el.querySelector<HTMLInputElement>('[data-part="hidden-input-sentinel"]');
    const files = this.api.acceptedFiles;
    const name = this.el.dataset.name;

    if (fileInput) {
      setInputFiles(fileInput, files);
    }

    this.syncAcceptedNamesHidden(name, files);

    if (!sentinel) return;

    if (files.length > 0) {
      sentinel.disabled = true;
      sentinel.removeAttribute("name");
      return;
    }

    sentinel.disabled = false;
    if (name) {
      sentinel.setAttribute("name", name);
    }
  }

  private syncAcceptedNamesHidden(fieldName: string | undefined, files: File[]): void {
    if (!fieldName) return;

    const labelFieldName = labelFieldNameFor(fieldName);

    const region =
      this.el.querySelector<HTMLElement>('[data-scope="file-upload"][data-part="region"]') ??
      this.el;

    let labelInput = region.querySelector<HTMLInputElement>(
      '[data-scope="file-upload"][data-part="accepted-names-hidden"]'
    );

    if (!labelInput) {
      labelInput = document.createElement("input");
      labelInput.type = "hidden";
      labelInput.setAttribute("data-scope", "file-upload");
      labelInput.setAttribute("data-part", "accepted-names-hidden");
      region.appendChild(labelInput);
    }

    const names = files
      .map((file) => file.name)
      .filter(Boolean)
      .join(", ");

    if (names === "") {
      labelInput.disabled = true;
      labelInput.removeAttribute("name");
      labelInput.value = "";
      return;
    }

    labelInput.disabled = false;
    labelInput.name = labelFieldName;
    labelInput.value = names;
    const formId = this.el.dataset.form;
    if (formId) {
      labelInput.setAttribute("form", formId);
    } else {
      labelInput.removeAttribute("form");
    }
  }

  private touchSentinel(): void {
    const sentinel = this.el.querySelector<HTMLInputElement>('[data-part="hidden-input-sentinel"]');
    if (!sentinel) return;
    const snap = this.api.acceptedFiles.map((f) => fileKeyFor(f)).join(",");
    if (snap === this.sentinelSnapshot) return;
    this.sentinelSnapshot = snap;
    sentinel.dispatchEvent(new Event("input", { bubbles: true }));
  }

  private syncAcceptedItems(ul: HTMLElement): void {
    this.syncItemList(ul, this.api.acceptedFiles);
  }

  private syncItemList(ul: HTMLElement, files: File[]): void {
    const desiredKeys = files.map((f) => fileKeyFor(f));
    const desiredSet = new Set(desiredKeys);

    const byKey = new Map<string, HTMLLIElement>();
    ul.querySelectorAll<HTMLLIElement>("li[data-corex-file-item]").forEach((li) => {
      const k = li.dataset.fileKey;
      if (k) byKey.set(k, li);
    });

    for (const k of [...byKey.keys()]) {
      if (!desiredSet.has(k)) {
        const li = byKey.get(k);
        if (!li) continue;
        li.querySelectorAll<HTMLElement>('img[data-part="item-preview-image"]').forEach((img) => {
          const c = this.previewCleanup.get(img);
          if (c) {
            c();
            this.previewCleanup.delete(img);
          }
        });
        li.remove();
        byKey.delete(k);
      }
    }

    for (const file of files) {
      const k = fileKeyFor(file);
      let li = byKey.get(k);
      if (!li) {
        li = this.buildItemLi(file, k);
        byKey.set(k, li);
      }
      ul.appendChild(li);
    }
  }

  private buildItemLi(file: File, key: string): HTMLLIElement {
    const doc = this.doc;
    const li = doc.createElement("li");
    li.setAttribute("data-scope", "file-upload");
    li.setAttribute("data-part", "item");
    li.setAttribute("data-corex-file-item", "");
    li.dataset.fileKey = key;
    li.dataset.fileType = ACCEPTED;

    const lead = doc.createElement("div");
    lead.setAttribute("data-scope", "file-upload");
    lead.setAttribute("data-part", "item-lead");
    if (file.type.startsWith("image/")) {
      const prev = doc.createElement("div");
      prev.setAttribute("data-scope", "file-upload");
      prev.setAttribute("data-part", "item-preview");
      const img = doc.createElement("img");
      img.setAttribute("data-scope", "file-upload");
      img.setAttribute("data-part", "item-preview-image");
      prev.appendChild(img);
      lead.appendChild(prev);
    }
    li.appendChild(lead);

    const nameEl = doc.createElement("div");
    nameEl.setAttribute("data-scope", "file-upload");
    nameEl.setAttribute("data-part", "item-name");
    nameEl.textContent = file.name;
    li.appendChild(nameEl);

    const sizeEl = doc.createElement("div");
    sizeEl.setAttribute("data-scope", "file-upload");
    sizeEl.setAttribute("data-part", "item-size-text");
    li.appendChild(sizeEl);

    const del = doc.createElement("button");
    del.setAttribute("data-scope", "file-upload");
    del.setAttribute("data-part", "item-delete-trigger");
    del.type = "button";
    this.fillDeleteTriggerContent(del);
    li.appendChild(del);

    return li;
  }

  private fillDeleteTriggerContent(btn: HTMLElement): void {
    const tpl = this.el.querySelector<HTMLTemplateElement>(
      "[data-file-upload-item-close-template]"
    );
    if (!tpl?.content) return;
    btn.replaceChildren();
    const frag = tpl.content.cloneNode(true);
    for (const node of Array.from(frag.childNodes)) {
      if (node.nodeType === 1) {
        btn.appendChild(node);
      }
    }
  }

  private getAcceptedFileForElement(el: HTMLElement): File | undefined {
    const k = el.dataset.fileKey;
    if (!k) return undefined;
    return this.api.acceptedFiles.find((f) => fileKeyFor(f) === k);
  }
}
