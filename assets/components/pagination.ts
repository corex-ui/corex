import { connect, machine, type Api, type Props } from "@zag-js/pagination";
import type { IntlTranslations } from "@zag-js/pagination";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component } from "../lib/core";
import { getString } from "../lib/util";

export class Pagination extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const rootEl = this.el.querySelector<HTMLElement>(
      '[data-scope="pagination"][data-part="root"]'
    );
    if (rootEl) this.spreadProps(rootEl, this.api.getRootProps());

    const prevEl = this.el.querySelector<HTMLElement>(
      '[data-scope="pagination"][data-part="prev-trigger"]'
    );
    if (prevEl) this.spreadProps(prevEl, this.api.getPrevTriggerProps());

    const nextEl = this.el.querySelector<HTMLElement>(
      '[data-scope="pagination"][data-part="next-trigger"]'
    );
    if (nextEl) this.spreadProps(nextEl, this.api.getNextTriggerProps());

    this.syncPages();
    applyPhoenixLinkAttrsToNavigableParts(this.el);
  }

  private directPageElements(list: HTMLElement): HTMLElement[] {
    return Array.from(list.querySelectorAll<HTMLElement>(':scope > [data-pagination-part="page"]'));
  }

  private syncPages(): void {
    const nextLi = this.el.querySelector<HTMLElement>('[data-pagination-part="next"]');
    const list = nextLi?.parentElement;
    if (!list || !nextLi) return;

    const ellipsisTemplate = this.el.querySelector<HTMLElement>(
      "[data-pagination-ellipsis-template]"
    );
    const ellipsisHtml = ellipsisTemplate?.innerHTML ?? "&#8230;";
    const triggerType = getString(this.el, "type") ?? "button";
    const pages = this.api.pages;

    let items = this.directPageElements(list);
    while (items.length > pages.length) {
      items[items.length - 1]!.remove();
      items = this.directPageElements(list);
    }

    for (let index = 0; index < pages.length; index++) {
      const page = pages[index]!;
      items = this.directPageElements(list);
      let li = items[index];

      if (!li) {
        li = document.createElement("li");
        li.setAttribute("data-pagination-part", "page");
        list.insertBefore(li, nextLi);
        items = this.directPageElements(list);
        li = items[index]!;
      }

      const itemEl = li.querySelector<HTMLElement>('[data-scope="pagination"][data-part="item"]');
      const ellipsisEl = li.querySelector<HTMLElement>(
        '[data-scope="pagination"][data-part="ellipsis"]'
      );

      if (page.type === "page") {
        if (ellipsisEl) ellipsisEl.remove();

        let control = itemEl;
        if (!control) {
          control =
            triggerType === "link" ? document.createElement("a") : document.createElement("button");
          if (control instanceof HTMLButtonElement) control.type = "button";
          li.appendChild(control);
        }

        const label = String(page.value);
        if (control.textContent !== label) control.textContent = label;
        this.spreadProps(control, this.api.getItemProps(page));
        applyPhoenixLinkAttrs(this.el, control);
      } else {
        if (itemEl) itemEl.remove();

        let span = ellipsisEl;
        if (!span) {
          span = document.createElement("span");
          span.innerHTML = ellipsisHtml;
          li.appendChild(span);
        }

        this.spreadProps(span, this.api.getEllipsisProps({ index }));
      }
    }
  }
}

export function parsePaginationTranslations(el: HTMLElement): IntlTranslations | undefined {
  const raw = el.dataset.translation;
  if (!raw) return undefined;

  try {
    const o = JSON.parse(raw) as Record<string, string>;
    const translations: IntlTranslations = {};

    if (typeof o.rootLabel === "string" && o.rootLabel.length > 0) {
      translations.rootLabel = o.rootLabel;
    }
    if (typeof o.prevTriggerLabel === "string" && o.prevTriggerLabel.length > 0) {
      translations.prevTriggerLabel = o.prevTriggerLabel;
    }
    if (typeof o.nextTriggerLabel === "string" && o.nextTriggerLabel.length > 0) {
      translations.nextTriggerLabel = o.nextTriggerLabel;
    }
    if (typeof o.itemLabel === "string" && o.itemLabel.length > 0) {
      const tpl = o.itemLabel;
      translations.itemLabel = (details) =>
        tpl
          .replace("%{page}", String(details.page))
          .replace("%{total_pages}", String(details.totalPages));
    }

    return Object.keys(translations).length > 0 ? translations : undefined;
  } catch {
    return undefined;
  }
}

export function applyPhoenixLinkAttrs(rootEl: HTMLElement, anchorEl: HTMLElement): void {
  if (getString(rootEl, "type") !== "link") return;
  if (anchorEl.tagName !== "A") return;

  const redirect = getString(rootEl, "redirect", ["href", "patch", "navigate"]);

  if (redirect === "patch") {
    anchorEl.setAttribute("data-phx-link", "patch");
    anchorEl.setAttribute("data-phx-link-state", "push");
  } else if (redirect === "navigate") {
    anchorEl.setAttribute("data-phx-link", "redirect");
    anchorEl.setAttribute("data-phx-link-state", "push");
  } else {
    anchorEl.removeAttribute("data-phx-link");
    anchorEl.removeAttribute("data-phx-link-state");
  }
}

export function applyPhoenixLinkAttrsToNavigableParts(rootEl: HTMLElement): void {
  const selectors = [
    '[data-scope="pagination"][data-part="item"]',
    '[data-scope="pagination"][data-part="prev-trigger"]',
    '[data-scope="pagination"][data-part="next-trigger"]',
  ];

  for (const selector of selectors) {
    rootEl.querySelectorAll<HTMLElement>(selector).forEach((el) => {
      applyPhoenixLinkAttrs(rootEl, el);
    });
  }
}

export function buildGetPageUrl(el: HTMLElement): Props["getPageUrl"] | undefined {
  const triggerType = getString(el, "type");
  const base = el.dataset.to;
  if (triggerType !== "link" || !base) return undefined;

  const pageParam = el.dataset.pageParam ?? "page";
  const pageSizeParam = el.dataset.pageSizeParam ?? "page_size";

  return ({ page, pageSize }) => {
    const sep = base.includes("?") ? "&" : "?";
    return `${base}${sep}${encodeURIComponent(pageParam)}=${page}&${encodeURIComponent(pageSizeParam)}=${pageSize}`;
  };
}
