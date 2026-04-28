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
  closePointerT?: ReturnType<typeof setTimeout>;
  lastOpen?: boolean;
};

function getDialogUpdatePropsFromEl(el: HTMLElement) {
  const softLock = el.dataset.animInteractionLocked === "true";
  return {
    id: el.id,
    ...(getBoolean(el, "controlled")
      ? { open: getBoolean(el, "open") }
      : { defaultOpen: getBoolean(el, "defaultOpen") }),
    modal: getBoolean(el, "modal"),
    closeOnInteractOutside: softLock ? false : getBoolean(el, "closeOnInteractOutside"),
    closeOnEscape: softLock ? false : getBoolean(el, "closeOnEscapeKeyDown"),
    preventScroll: getBoolean(el, "preventScroll"),
    restoreFocus: getBoolean(el, "restoreFocus"),
    dir: getDir(el),
  };
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
        if (!details.open && (el.dataset.animation === "js" || el.dataset.animation === "custom")) {
          if (self.closePointerT !== undefined) clearTimeout(self.closePointerT);
          el.setAttribute("data-exit-anim", "running");

          if (el.dataset.animation === "js") {
            const closeOpts = readScaleAnimationOptions(el);
            self.closePointerT = window.setTimeout(
              () => {
                el.setAttribute("data-exit-anim", "complete");
                const backdrop = el.querySelector<HTMLElement>(
                  '[data-scope="dialog"][data-part="backdrop"]'
                );
                const positioner = el.querySelector<HTMLElement>(
                  '[data-scope="dialog"][data-part="positioner"]'
                );
                if (backdrop) backdrop.style.pointerEvents = "none";
                if (positioner) positioner.style.pointerEvents = "none";
                self.closePointerT = undefined;
                dialog.render();
              },
              Math.max(0, closeOpts.duration * 1000)
            );
          } else {
            self.closePointerT = window.setTimeout(() => {
              el.setAttribute("data-exit-anim", "complete");
              self.closePointerT = undefined;
              dialog.render();
            }, 0);
          }
        } else if (details.open) {
          if (self.closePointerT !== undefined) {
            clearTimeout(self.closePointerT);
            self.closePointerT = undefined;
          }
          el.removeAttribute("data-exit-anim");
          el.removeAttribute("data-anim-interaction-locked");
          dialog.updateProps(getDialogUpdatePropsFromEl(el));
          dialog.render();
        }

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

        if (el.dataset.animation === "js") {
          const animOpts = readScaleAnimationOptions(el);
          if (animOpts.blockInteraction) {
            el.dataset.animInteractionLocked = "true";
            dialog.updateProps(getDialogUpdatePropsFromEl(el));
            dialog.render();
          }
          const backdrop = el.querySelector<HTMLElement>(
            '[data-scope="dialog"][data-part="backdrop"]'
          );
          const content = el.querySelector<HTMLElement>(
            '[data-scope="dialog"][data-part="content"]'
          );
          const a1 = backdrop ? runScaleAnimation(backdrop, details.open, animOpts) : null;
          const a2 = content ? runScaleAnimation(content, details.open, animOpts) : null;
          const onDone = () => {
            if (animOpts.blockInteraction) {
              el.removeAttribute("data-anim-interaction-locked");
              dialog.updateProps(getDialogUpdatePropsFromEl(el));
              dialog.render();
            }
          };
          const promises: Promise<Animation | void>[] = [];
          if (a1) promises.push(a1.finished);
          if (a2) promises.push(a2.finished);
          if (promises.length > 0) {
            void Promise.all(promises).then(onDone, onDone);
          } else {
            onDone();
          }
        }
        // "custom" mode: external animator handles everything via on_open_change_client event
      },
    });

    dialog.init();
    this.dialog = dialog;

    // Only prepare initial scale state for "js" mode
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
    if (getBoolean(this.el, "controlled")) {
      this.lastOpen = getBoolean(this.el, "open") ?? false;
    }
    this.dialog?.updateProps(getDialogUpdatePropsFromEl(this.el));
  },

  destroyed(this: object & HookInterface<HTMLElement> & DialogHookState) {
    const self = this as object & HookInterface<HTMLElement> & DialogHookState;
    if (self.closePointerT !== undefined) {
      clearTimeout(self.closePointerT);
      self.closePointerT = undefined;
    }
    this.el.removeAttribute("data-exit-anim");
    this.el.removeAttribute("data-anim-interaction-locked");
    this.dialog?.updateProps(getDialogUpdatePropsFromEl(this.el));
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.dialog?.destroy();
  },
};

export { DialogHook as Dialog };
