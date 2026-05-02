import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Dialog } from "../components/dialog";
import type { OpenChangeDetails } from "@zag-js/dialog";

import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { idMatches, notifyChange, readPayloadId } from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";
import {
  prepareInitialScaleState,
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

function getDialogUpdatePropsFromEl(el: HTMLElement) {
  return {
    id: el.id,
    ...(getBoolean(el, "controlled")
      ? { open: getBoolean(el, "open") }
      : { defaultOpen: getBoolean(el, "defaultOpen") }),
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

const DialogHook: Hook<object & DialogHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & DialogHookState) {
    const el = this.el;
    const self = this as object & HookInterface<HTMLElement> & DialogHookState;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);

    self.lastOpen = getBoolean(el, "controlled")
      ? (getBoolean(el, "open") ?? false)
      : (getBoolean(el, "defaultOpen") ?? false);

    const dialog = new Dialog(el, {
      id: el.id,
      ...(getBoolean(el, "controlled")
        ? { open: getBoolean(el, "open") }
        : { defaultOpen: getBoolean(el, "defaultOpen") }),
      modal: getBoolean(el, "modal"),
      closeOnInteractOutside: getBoolean(el, "closeOnInteractOutside"),
      closeOnEscape: getBoolean(el, "closeOnEscapeKeyDown"),
      preventScroll: getBoolean(el, "preventScroll"),
      restoreFocus: getBoolean(el, "restoreFocus"),
      dir: getDir(el),

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

        if (el.dataset.animation === "js" && !getBoolean(el, "controlled")) {
          runDialogScaleTransitions(el, details.open);
        }
      },
    });

    dialog.init();
    this.dialog = dialog;

    if (el.dataset.animation === "js") {
      const opts = readScaleAnimationOptions(el);
      prepareInitialScaleState(
        el,
        '[data-scope="dialog"][data-part="backdrop"], [data-scope="dialog"][data-part="content"]',
        opts,
        (sub) => {
          if (sub.dataset.part === "backdrop") return { scale: false };
        }
      );
    }

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
    const el = this.el;
    const controlled = getBoolean(el, "controlled");
    if (controlled) {
      const nextOpen = getBoolean(el, "open") ?? false;
      const prevOpen = this.lastOpen ?? false;
      this.lastOpen = nextOpen;
      if (el.dataset.animation === "js" && nextOpen !== prevOpen) {
        runDialogScaleTransitions(el, nextOpen);
      }
    }
    this.dialog?.updateProps(getDialogUpdatePropsFromEl(el));
  },

  destroyed(this: object & HookInterface<HTMLElement> & DialogHookState) {
    this.dialog?.updateProps(getDialogUpdatePropsFromEl(this.el));
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.dialog?.destroy();
  },
};

export { DialogHook as Dialog };
