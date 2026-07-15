import {
  connect,
  machine,
  group,
  createStore,
  type Props,
  type Api,
  type GroupProps,
  type GroupApi,
  type Store,
  type StoreProps,
  type Options,
} from "@zag-js/toast";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component } from "../lib/core";
import { cloneTemplateChildren, getDir } from "../lib/util";

export function actionClassTokens(action: unknown): string[] {
  if (action == null || typeof action !== "object") return [];
  const cn = (action as { className?: unknown }).className;
  if (typeof cn !== "string") return [];
  return cn.trim().split(/\s+/).filter(Boolean);
}

function actionLabelHtml(action: unknown): boolean {
  return (
    action != null &&
    typeof action === "object" &&
    (action as { labelHtml?: unknown }).labelHtml === true
  );
}

export const toastGroups = new Map<string, ToastGroup>();
export const toastStores = new Map<string, Store>();

type ToastItemProps<T = unknown> = Props<T> & {
  parent: unknown;
  index: number;
  meta?: { loading?: boolean };
};

export class ToastItem<T = unknown> extends Component<ToastItemProps<T>, Api> {
  private parts!: {
    title: HTMLElement;
    description: HTMLElement;
    close: HTMLElement;
    action: HTMLElement;
    ghostBefore: HTMLElement;
    ghostAfter: HTMLElement;
    progressbar: HTMLElement;
    loadingSpinner: HTMLElement;
  };

  private latestProps: ToastItemProps<T>;
  private hadAction = false;

  duration?: number | string;
  showLoading: boolean;

  constructor(el: HTMLElement, props: ToastItemProps<T>) {
    super(el, props);

    this.latestProps = props;
    this.duration = props.duration;
    this.showLoading = props.meta?.loading === true;
    this.hadAction = Boolean(props.action?.label);

    this.el.setAttribute("data-scope", "toast");
    this.el.setAttribute("data-part", "root");
    this.el.classList.add("toast-item");

    this.el.innerHTML = `
      <span data-scope="toast" data-part="ghost-before"></span>
      <div data-scope="toast" data-part="progressbar"></div>

      <div data-scope="toast" data-part="content">
        <div data-scope="toast" data-part="header">
          <div data-scope="toast" data-part="loading-spinner" style="display: none;"></div>
          <div data-scope="toast" data-part="title"></div>
          <button type="button" data-scope="toast" data-part="close-trigger"></button>
        </div>
        <div data-scope="toast" data-part="description"></div>
        <div data-scope="toast" data-part="actions">
          <button type="button" data-scope="toast" data-part="action-trigger" hidden></button>
        </div>
      </div>

      <span data-scope="toast" data-part="ghost-after"></span>
    `;

    this.parts = {
      title: this.el.querySelector('[data-part="title"]')!,
      description: this.el.querySelector('[data-part="description"]')!,
      close: this.el.querySelector('[data-part="close-trigger"]')!,
      action: this.el.querySelector('[data-part="action-trigger"]') as HTMLElement,
      ghostBefore: this.el.querySelector('[data-part="ghost-before"]')!,
      ghostAfter: this.el.querySelector('[data-part="ghost-after"]')!,
      progressbar: this.el.querySelector('[data-part="progressbar"]')!,
      loadingSpinner: this.el.querySelector('[data-part="loading-spinner"]')!,
    };
  }

  updateProps = (props: Partial<ToastItemProps<T>> & Record<string, unknown>) => {
    Object.assign(this.latestProps, props);
    super.updateProps(
      props as Props<T> & { parent: unknown; index: number; meta?: { loading?: boolean } }
    );
  };

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props<T>): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render() {
    this.spreadProps(this.el, this.api.getRootProps());
    this.spreadProps(this.parts.close, this.api.getCloseTriggerProps());
    this.spreadProps(this.parts.ghostBefore, this.api.getGhostBeforeProps());
    this.spreadProps(this.parts.ghostAfter, this.api.getGhostAfterProps());

    const toastGroup = this.el.closest('[phx-hook="Toast"]') as HTMLElement;

    // templates
    const loadingIconTemplate = toastGroup?.querySelector(
      "[data-loading-icon-template]"
    ) as HTMLElement;

    const closeIconTemplate = toastGroup?.querySelector(
      "[data-close-icon-template]"
    ) as HTMLElement;

    if (!cloneTemplateChildren(closeIconTemplate, this.parts.close)) {
      if (this.parts.close.childNodes.length === 0 && !this.parts.close.textContent) {
        this.parts.close.textContent = "×";
      }
    }

    // text updates
    if (this.parts.title.textContent !== this.api.title) {
      this.parts.title.textContent = this.api.title ?? "";
    }

    if (this.parts.description.textContent !== this.api.description) {
      this.parts.description.textContent = this.api.description ?? "";
    }

    this.spreadProps(this.parts.title, this.api.getTitleProps());
    this.spreadProps(this.parts.description, this.api.getDescriptionProps());

    const hasAction = Boolean(this.latestProps.action?.label);
    if (this.hadAction && !hasAction) {
      const next = document.createElement("button");
      next.type = "button";
      next.setAttribute("data-scope", "toast");
      next.setAttribute("data-part", "action-trigger");
      next.hidden = true;
      this.parts.action.replaceWith(next);
      this.parts.action = next as HTMLElement;
    }
    this.hadAction = hasAction;

    if (hasAction) {
      this.parts.action.hidden = false;
      this.spreadProps(this.parts.action, this.api.getActionTriggerProps());
      const label = this.latestProps.action?.label ?? "";
      const labelHtml = actionLabelHtml(this.latestProps.action);
      if (labelHtml) {
        if (this.parts.action.innerHTML !== label) {
          this.parts.action.innerHTML = label;
        }
      } else if (this.parts.action.textContent !== label) {
        this.parts.action.textContent = label;
      }
      const extraClasses = actionClassTokens(this.latestProps.action);
      for (const token of [...this.parts.action.classList]) {
        if (token.startsWith("ui-") || token === "button") {
          this.parts.action.classList.remove(token);
        }
      }
      if (extraClasses.length) this.parts.action.classList.add(...extraClasses);
    } else {
      this.parts.action.hidden = true;
      if (this.parts.action.textContent) {
        this.parts.action.textContent = "";
      }
      if (this.parts.action.innerHTML) {
        this.parts.action.innerHTML = "";
      }
    }

    const duration = this.duration;
    const isInfinity =
      duration === "Infinity" || duration === Infinity || duration === Number.POSITIVE_INFINITY;

    if (isInfinity) {
      this.parts.progressbar.style.display = "none";
      this.el.setAttribute("data-duration-infinity", "true");
    } else {
      this.parts.progressbar.style.display = "block";
      this.el.removeAttribute("data-duration-infinity");
    }

    if (this.showLoading) {
      this.parts.loadingSpinner.style.display = "flex";
      cloneTemplateChildren(loadingIconTemplate, this.parts.loadingSpinner);
    } else {
      this.parts.loadingSpinner.style.display = "none";
    }
  }

  destroy = () => {
    this.machine.stop();
    this.el.remove();
  };
}

export class ToastGroup extends Component<GroupProps, GroupApi> {
  private toastComponents = new Map<string, ToastItem>();
  private groupEl: HTMLElement;
  public store: Store;

  constructor(el: HTMLElement, props: GroupProps) {
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
  initMachine(props: GroupProps): VanillaMachine<any> {
    return new VanillaMachine(group.machine, props);
  }

  initApi(): GroupApi {
    return this.zagConnect(group.connect);
  }

  render() {
    this.spreadProps(this.groupEl, this.api.getGroupProps());

    const toasts = this.api
      .getToasts()
      .filter((t): t is Props & { id: string } => typeof t.id === "string");

    const nextIds = new Set(toasts.map((t) => t.id));

    toasts.forEach((toastData, index) => {
      let item = this.toastComponents.get(toastData.id);

      if (!item) {
        const el = document.createElement("div");
        el.classList.add("toast-item");
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
        item.duration = toastData.duration;
        (item as ToastItem).showLoading =
          (toastData as { meta?: { loading?: boolean } }).meta?.loading === true;
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

export function createToastGroup(
  container: HTMLElement,
  options?: Partial<StoreProps> & {
    id?: string;
    store?: Store;
  }
) {
  const groupId = options?.id ?? container.id;

  const store =
    options?.store ??
    createStore({
      placement: options?.placement ?? "bottom",
      overlap: options?.overlap,
      max: options?.max,
      gap: options?.gap,
      offsets: options?.offsets,
      pauseOnPageIdle: options?.pauseOnPageIdle,
    });

  const group = new ToastGroup(container, { id: groupId, store, dir: getDir(container) });
  group.init();

  toastGroups.set(groupId, group);
  toastStores.set(groupId, store);

  container.dataset.toastGroup = "true";
  container.dataset.toastGroupId = groupId;

  return { group, store };
}

export function disposeToastGroup(groupId: string) {
  const group = toastGroups.get(groupId);
  if (!group) return;
  const container = group.el;
  group.destroy();
  toastGroups.delete(groupId);
  toastStores.delete(groupId);
  delete container.dataset.toastGroup;
  delete container.dataset.toastGroupId;
}

export function getToastStore(groupId?: string): Store | undefined {
  if (groupId) return toastStores.get(groupId);

  const el = document.querySelector<HTMLElement>("[data-toast-group]");
  if (!el) return;

  const id = el.dataset.toastGroupId || el.id;
  return id ? toastStores.get(id) : undefined;
}

export function createToast(options: Options & { id: string; groupId?: string }) {
  const { groupId, ...rest } = options;
  const store = getToastStore(groupId);
  if (!store) throw new Error("No toast store found");
  store.create(rest);
}

export function updateToast(id: string, options: Partial<Props>, groupId?: string) {
  getToastStore(groupId)?.update(id, options);
}

export function dismissToast(id: string, groupId?: string) {
  getToastStore(groupId)?.dismiss(id);
}

export function removeToast(id: string, groupId?: string) {
  getToastStore(groupId)?.remove(id);
}
