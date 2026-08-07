import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Dialog, dialogInitialAriaLabel } from "../components/dialog";
import type { OpenChangeDetails } from "@zag-js/dialog";

import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { readBooleanControlledZagProps, readControlledOrDefaultBoolean } from "../lib/read-props";
import { idMatches, notifyChange, readPayloadId } from "../lib/respond-to";
import {
  isJsAnimation,
  prepareJsScaleInitialState,
  readScaleAnimationOptions,
  runScaleAnimation,
} from "../lib/animation";
import { resolveFocusElement } from "../lib/focus";
import { type DialogOpenChangedDetail } from "../lib/event-details";
import { createZagLiveHook } from "../lib/zag-live-hook";

type DialogHookState = {
  dialog?: Dialog;
  lastOpen?: boolean;
  previousOpen?: boolean;
};

const DIALOG_SCALE_SELECTOR =
  '[data-scope="dialog"][data-part="backdrop"], [data-scope="dialog"][data-part="content"]';

export function readDialogLayoutProps(el: HTMLElement) {
  const role = getString(el, "role", ["dialog", "alertdialog"] as const) ?? "dialog";
  const initialFocusId = getString(el, "initialFocus");
  const finalFocusId = getString(el, "finalFocus");

  return {
    id: el.id,
    role,
    modal: getBoolean(el, "modal"),
    closeOnInteractOutside: getBoolean(el, "closeOnInteractOutside"),
    closeOnEscape: getBoolean(el, "closeOnEscapeKeyDown"),
    preventScroll: getBoolean(el, "preventScroll"),
    restoreFocus: getBoolean(el, "restoreFocus"),
    dir: getDir(el),
    initialFocusEl: initialFocusId ? () => resolveFocusElement(el, initialFocusId) : undefined,
    finalFocusEl: finalFocusId ? () => resolveFocusElement(el, finalFocusId) : undefined,
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

const DialogHook = createZagLiveHook<DialogHookState, Dialog>({
  key: "dialog",
  mount(hook, { dom, server }) {
    const el = hook.el;
    const self = hook as object & HookInterface<HTMLElement> & DialogHookState;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);

    self.lastOpen = readControlledOrDefaultBoolean(el, "open", "defaultOpen");

    const dialog = new Dialog(el, {
      ...readDialogLayoutProps(el),
      ...readBooleanControlledZagProps(el, "open", "defaultOpen"),
      "aria-label": dialogInitialAriaLabel(el),

      onOpenChange: (details: OpenChangeDetails) => {
        const controlled = getBoolean(el, "controlled");
        const previousOpen = controlled
          ? readControlledOrDefaultBoolean(el, "open", "defaultOpen")
          : (self.lastOpen ?? false);

        if (!controlled) {
          self.lastOpen = details.open;
        }

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

    prepareJsScaleInitialState(el, DIALOG_SCALE_SELECTOR, (sub) => {
      if (sub.dataset.part === "backdrop") return { scale: false };
    });

    dom.add<CustomEvent<{ open: boolean }>>("corex:dialog:set-open", (event) => {
      const { open } = event.detail;
      dialog.api.setOpen(open);
    });

    server.add("dialog_set_open", (payload: unknown) => {
      if (!payload || typeof payload !== "object") return;
      const o = payload as { open?: boolean };
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (typeof o.open === "boolean") dialog.api.setOpen(o.open);
    });

    server.add("dialog_open", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      hook.pushEvent("dialog_open_response", {
        id: el.id,
        value: dialog.api.open,
      });
    });

    return dialog;
  },

  beforeUpdate(hook) {
    const { el } = hook;
    if (getBoolean(el, "controlled") && isJsAnimation(el)) {
      hook.previousOpen = getBoolean(el, "open");
    }
  },

  update(hook, dialog) {
    const { el } = hook;
    const layout = readDialogLayoutProps(el);

    if (!getBoolean(el, "controlled")) {
      dialog.updateProps(layout);
      return;
    }

    const nextOpen = getBoolean(el, "open") ?? false;
    const prevOpen = hook.previousOpen ?? hook.lastOpen ?? false;
    hook.previousOpen = undefined;
    hook.lastOpen = nextOpen;

    dialog.updateProps({ ...layout, open: nextOpen });

    if (nextOpen !== prevOpen) {
      runDialogScaleIfJs(el, nextOpen);
    }
  },
});

export { DialogHook as Dialog };
