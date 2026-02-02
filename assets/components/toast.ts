import * as toast from "@zag-js/toast";
import type { Store } from "@zag-js/toast";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";
import { generateId } from "../lib/util";

/* -------------------------------------------------------------------------------------------------
 * Shared registries
 * -----------------------------------------------------------------------------------------------*/

export const toastGroups = new Map<string, ToastGroup>();
export const toastStores = new Map<string, Store>();

/* -------------------------------------------------------------------------------------------------
 * Toast item
 * -----------------------------------------------------------------------------------------------*/
// eslint-disable-next-line @typescript-eslint/no-explicit-any
type ToastItemProps<T = any> = toast.Props<T> & {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  parent: any;
  index: number;
};

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export class ToastItem<T = any> extends Component<ToastItemProps<T>, toast.Api> {
  private parts!: {
    title: HTMLElement;
    description: HTMLElement;
    close: HTMLElement;
    ghostBefore: HTMLElement;
    ghostAfter: HTMLElement;
  };

  constructor(el: HTMLElement, props: ToastItemProps<T>) {
    super(el, props);

    this.el.setAttribute("data-scope", "toast");
    this.el.setAttribute("data-part", "root");

    this.el.innerHTML = `
      <span data-scope="toast" data-part="ghost-before"></span>
      <div data-scope="toast" data-part="progressbar"></div>

      <div data-scope="toast" data-part="content">
        <div data-scope="toast" data-part="title"></div>
        <div data-scope="toast" data-part="description"></div>
      </div>

      <button data-scope="toast" data-part="close-trigger">
        <svg viewBox="0 0 20 20" aria-hidden="true">
          <path d="M4.293 4.293 10 8.586l5.707-5.707 1.414 1.414L11.414 10l5.707 5.707-1.414 1.414L10 11.414l-5.707 5.707-1.414-1.414L8.586 10 2.879 4.293z"/>
        </svg>
      </button>

      <span data-scope="toast" data-part="ghost-after"></span>
    `;

    this.parts = {
      title: this.el.querySelector('[data-scope="toast"][data-part="title"]')!,
      description: this.el.querySelector('[data-scope="toast"][data-part="description"]')!,
      close: this.el.querySelector('[data-scope="toast"][data-part="close-trigger"]')!,
      ghostBefore: this.el.querySelector('[data-scope="toast"][data-part="ghost-before"]')!,
      ghostAfter: this.el.querySelector('[data-scope="toast"][data-part="ghost-after"]')!,
    };
  }

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: toast.Props<T>): VanillaMachine<any> {
    return new VanillaMachine(toast.machine, props);
  }

  initApi(): toast.Api {
    return toast.connect(this.machine.service, normalizeProps);
  }

  render() {
    this.spreadProps(this.el, this.api.getRootProps());
    this.spreadProps(this.parts.close, this.api.getCloseTriggerProps());

    this.spreadProps(this.parts.ghostBefore, this.api.getGhostBeforeProps());
    this.spreadProps(this.parts.ghostAfter, this.api.getGhostAfterProps());

    if (this.parts.title.textContent !== this.api.title) {
      this.parts.title.textContent = this.api.title ?? "";
    }

    if (this.parts.description.textContent !== this.api.description) {
      this.parts.description.textContent = this.api.description ?? "";
    }

    this.spreadProps(this.parts.title, this.api.getTitleProps());
    this.spreadProps(this.parts.description, this.api.getDescriptionProps());
  }

  destroy = () => {
    this.machine.stop();
    this.el.remove();
  };
}

/* -------------------------------------------------------------------------------------------------
 * Toast group
 * -----------------------------------------------------------------------------------------------*/

export class ToastGroup extends Component<toast.GroupProps, toast.GroupApi> {
  private toastComponents = new Map<string, ToastItem>();
  private groupEl: HTMLElement;
  public store: Store;

  constructor(el: HTMLElement, props: toast.GroupProps) {
    super(el, props);

    this.store = props.store;

    this.groupEl =
      el.querySelector('[data-part="group"]') ??
      (() => {
        const g = document.createElement("div");
        g.setAttribute("data-scope", "toast");
        g.setAttribute("data-part", "group");
        el.appendChild(g);
        return g;
      })();
  }

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: toast.GroupProps): VanillaMachine<any> {
    return new VanillaMachine(toast.group.machine, props);
  }

  initApi(): toast.GroupApi {
    return toast.group.connect(this.machine.service, normalizeProps);
  }

  render() {
    this.spreadProps(this.groupEl, this.api.getGroupProps());

    const toasts = this.api
      .getToasts()
      .filter((t): t is toast.Props & { id: string } => typeof t.id === "string");

    const nextIds = new Set(toasts.map((t) => t.id));

    toasts.forEach((toastData, index) => {
      let item = this.toastComponents.get(toastData.id);

      if (!item) {
        const el = document.createElement("div");
        el.setAttribute("data-scope", "toast");
        el.setAttribute("data-part", "root");
        this.groupEl.appendChild(el);

        item = new ToastItem(el, {
          ...toastData,
          parent: this.machine.service,
          index,
        });

        item.init();
        this.toastComponents.set(toastData.id, item);
      } else {
        item.updateProps({
          ...toastData,
          parent: this.machine.service,
          index,
        });
      }
    });

    for (const [id, comp] of this.toastComponents) {
      if (!nextIds.has(id)) {
        comp.destroy();
        this.toastComponents.delete(id);
      }
    }
  }

  destroy = () => {
    for (const comp of this.toastComponents.values()) {
      comp.destroy();
    }
    this.toastComponents.clear();
    this.machine.stop();
  };
}

/* -------------------------------------------------------------------------------------------------
 * Public helpers
 * -----------------------------------------------------------------------------------------------*/

export function createToastGroup(
  container: HTMLElement,
  options?: Partial<toast.StoreProps> & {
    id?: string;
    store?: Store;
  }
) {
  const groupId = options?.id ?? generateId(container, "toast");

  const store =
    options?.store ??
    toast.createStore({
      placement: options?.placement ?? "bottom",
      overlap: options?.overlap,
      max: options?.max,
      gap: options?.gap,
      offsets: options?.offsets,
      pauseOnPageIdle: options?.pauseOnPageIdle,
    });

  const group = new ToastGroup(container, { id: groupId, store });
  group.init();

  toastGroups.set(groupId, group);
  toastStores.set(groupId, store);

  container.dataset.toastGroup = "true";
  container.dataset.toastGroupId = groupId;

  return { group, store };
}

export function getToastStore(groupId?: string): Store | undefined {
  if (groupId) return toastStores.get(groupId);

  const el = document.querySelector<HTMLElement>("[data-toast-group]");
  if (!el) return;

  const id = el.dataset.toastGroupId || el.id;
  return id ? toastStores.get(id) : undefined;
}

export function createToast(options: toast.Options & { groupId?: string }) {
  const store = getToastStore(options.groupId);
  if (!store) throw new Error("No toast store found");

  store.create({
    ...options,
    id: options.id ?? generateId(undefined, "toast"),
  });
}

export function updateToast(id: string, options: Partial<toast.Props>, groupId?: string) {
  getToastStore(groupId)?.update(id, options);
}

export function dismissToast(id: string, groupId?: string) {
  getToastStore(groupId)?.dismiss(id);
}
