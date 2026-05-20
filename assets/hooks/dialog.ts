import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Dialog, dialogInitialAriaLabel } from "../components/dialog";
import type { OpenChangeDetails } from "@zag-js/dialog";

import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { readBooleanControlledZagProps, readControlledOrDefaultBoolean } from "../lib/read-props";
import { idMatches, notifyChange, readPayloadId } from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";
import {
  isJsAnimation,
  prepareJsScaleInitialState,
  readScaleAnimationOptions,
  runScaleAnimation,
} from "../lib/animation";
import { type DialogOpenChangedDetail } from "../lib/event-details";

type DialogHookState = {
  dialog?: Dialog;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
  lastOpen?: boolean;
};

const DIALOG_SCALE_SELECTOR =
  '[data-scope="dialog"][data-part="backdrop"], [data-scope="dialog"][data-part="content"]';

export function readDialogLayoutProps(el: HTMLElement) {
  return {
    id: el.id,
    modal: getBoolean(el, "modal"),
    closeOnInteractOutside: getBoolean(el, "closeOnInteractOutside"),
    closeOnEscape: getBoolean(el, "closeOnEscapeKeyDown"),
    preventScroll: getBoolean(el, "preventScroll"),
    restoreFocus: getBoolean(el, "restoreFocus"),
    dir: getDir(el),
  };
}

function runDialogScaleTransitions(el: HTMLElement, isOpen: boolean): void {
  const opts = readScaleAnimationOptions(el);
  const blockRoot = opts.blockInteraction ? el : undefined;
  const backdrop = el.querySelector<HTMLElement>('[data-scope="dialog"][data-part="backdrop"]');
  const content = el.querySelector<HTMLElement>('[data-scope="dialog"][data-part="content"]');
  if (backdrop) runScaleAnimation(backdrop, isOpen, opts, blockRoot);
  if (content) runScaleAnimation(content, isOpen, opts, blockRoot);
}

function runDialogScaleIfJs(el: HTMLElement, isOpen: boolean): void {
  if (!isJsAnimation(el)) return;
  runDialogScaleTransitions(el, isOpen);
}

const DialogHook: Hook<object & DialogHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & DialogHookState) {
    const el = this.el;
    const self = this as object & HookInterface<HTMLElement> & DialogHookState;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);

    self.lastOpen = readControlledOrDefaultBoolean(el, "open", "defaultOpen");

    const dialog = new Dialog(el, {
      ...readDialogLayoutProps(el),
      ...readBooleanControlledZagProps(el, "open", "defaultOpen"),
      "aria-label": dialogInitialAriaLabel(el),

      onOpenChange: (details: OpenChangeDetails) => {
        const previousOpen = self.lastOpen ?? false;
        self.lastOpen = details.open;

        const payload: DialogOpenChangedDetail = {
          id: el.id,
          open: details.open,
          previousOpen,
        };

        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: payload as unknown as Record<string, unknown>,
          serverEventName: getString(el, "onOpenChange"),
          clientEventName: getString(el, "onOpenChangeClient"),
        });

        if (isJsAnimation(el) && !getBoolean(el, "controlled")) {
          runDialogScaleTransitions(el, details.open);
        }
      },
    });

    dialog.init();
    this.dialog = dialog;

    prepareJsScaleInitialState(el, DIALOG_SCALE_SELECTOR, (sub) => {
      if (sub.dataset.part === "backdrop") return { scale: false };
    });

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add<CustomEvent<{ open: boolean }>>("corex:dialog:set-open", (event) => {
      const { open } = event.detail;
      dialog.api.setOpen(open);
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add("dialog_set_open", (payload: unknown) => {
      if (!payload || typeof payload !== "object") return;
      const o = payload as { open?: boolean };
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (typeof o.open === "boolean") dialog.api.setOpen(o.open);
    });

    registry.add("dialog_open", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      this.pushEvent("dialog_open_response", {
        id: el.id,
        value: dialog.api.open,
      });
    });
  },

  updated(this: object & HookInterface<HTMLElement> & DialogHookState) {
    const { el } = this;
    const layout = readDialogLayoutProps(el);

    if (!getBoolean(el, "controlled")) {
      this.dialog?.updateProps(layout);
      return;
    }

    const nextOpen = getBoolean(el, "open") ?? false;
    const prevOpen = this.lastOpen ?? false;
    this.lastOpen = nextOpen;

    if (nextOpen !== prevOpen) {
      runDialogScaleIfJs(el, nextOpen);
    }

    this.dialog?.updateProps({ ...layout, open: nextOpen });
  },

  destroyed(this: object & HookInterface<HTMLElement> & DialogHookState) {
    this.dialog?.updateProps({
      ...readDialogLayoutProps(this.el),
      ...readBooleanControlledZagProps(this.el, "open", "defaultOpen"),
    });
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.dialog?.destroy();
  },
};

export { DialogHook as Dialog };
