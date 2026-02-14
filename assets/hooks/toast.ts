import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";

import { createToastGroup, getToastStore } from "../components/toast";
import type { Placement } from "@zag-js/toast";

import { getString, getBoolean, getNumber, generateId } from "../lib/util";

type ToastPayload = {
  title: string;
  description?: string;
  type?: "info" | "success" | "error";
  id?: string;
  duration?: number | string;
  groupId?: string;
};

type ToastHookState = {
  groupId: string;
  handlers?: Array<CallbackRef>;
};

const ToastHook: Hook<object & ToastHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & ToastHookState) {
    const el = this.el;

    if (!el.id) {
      el.id = generateId(el, "toast");
    }
    this.groupId = el.id;

    const parseOffsets = (offsetsString?: string) => {
      if (!offsetsString) return undefined;
      try {
        return offsetsString.includes("{") ? JSON.parse(offsetsString) : offsetsString;
      } catch {
        return offsetsString;
      }
    };

    const parseDuration = (duration?: number | string): number | undefined => {
      if (duration === "Infinity" || duration === Infinity) {
        return Infinity;
      }
      if (typeof duration === "string") {
        return parseInt(duration, 10) || undefined;
      }
      return duration;
    };

    const placement =
      getString<Placement>(el, "placement", [
        "top-start",
        "top",
        "top-end",
        "bottom-start",
        "bottom",
        "bottom-end",
      ]) ?? "bottom-end";

    createToastGroup(el, {
      id: this.groupId,
      placement,
      overlap: getBoolean(el, "overlap"),
      max: getNumber(el, "max"),
      gap: getNumber(el, "gap"),
      offsets: parseOffsets(getString(el, "offset")),
      pauseOnPageIdle: getBoolean(el, "pauseOnPageIdle"),
    });

    const store = getToastStore(this.groupId);
    const flashInfo = el.getAttribute("data-flash-info");
    const flashInfoTitle = el.getAttribute("data-flash-info-title");
    const flashError = el.getAttribute("data-flash-error");
    const flashErrorTitle = el.getAttribute("data-flash-error-title");
    const flashInfoDuration = el.getAttribute("data-flash-info-duration");
    const flashErrorDuration = el.getAttribute("data-flash-error-duration");

    if (store && flashInfo) {
      try {
        store.create({
          title: flashInfoTitle || "Success",
          description: flashInfo,
          type: "info",
          id: generateId(undefined, "toast"),
          duration: parseDuration(flashInfoDuration ?? undefined),
        });
      } catch (error) {
        console.error("Failed to create flash info toast:", error);
      }
    }

    if (store && flashError) {
      try {
        store.create({
          title: flashErrorTitle || "Error",
          description: flashError,
          type: "error",
          id: generateId(undefined, "toast"),
          duration: parseDuration(flashErrorDuration ?? undefined),
        });
      } catch (error) {
        console.error("Failed to create flash error toast:", error);
      }
    }

    this.handlers = [];

    this.handlers.push(
      this.handleEvent("toast-create", (payload: ToastPayload) => {
        const store = getToastStore(payload.groupId || this.groupId);
        if (!store) return;

        try {
          store.create({
            title: payload.title,
            description: payload.description,
            type: payload.type || "info",
            id: payload.id || generateId(undefined, "toast"),
            duration: parseDuration(payload.duration),
          });
        } catch (error) {
          console.error("Failed to create toast:", error);
        }
      })
    );

    this.handlers.push(
      this.handleEvent("toast-update", (payload: Omit<ToastPayload, "duration">) => {
        const store = getToastStore(payload.groupId || this.groupId);
        if (!store) return;

        try {
          store.update(payload.id!, {
            title: payload.title,
            description: payload.description,
            type: payload.type,
          });
        } catch (error) {
          console.error("Failed to update toast:", error);
        }
      })
    );

    this.handlers.push(
      this.handleEvent("toast-dismiss", (payload: { id: string; groupId?: string }) => {
        const store = getToastStore(payload.groupId || this.groupId);
        if (!store) return;

        try {
          store.dismiss(payload.id);
        } catch (error) {
          console.error("Failed to dismiss toast:", error);
        }
      })
    );

    el.addEventListener("toast:create", ((event: CustomEvent<ToastPayload>) => {
      const { detail } = event;
      const store = getToastStore(detail.groupId || this.groupId);
      if (!store) return;

      try {
        store.create({
          title: detail.title,
          description: detail.description,
          type: detail.type || "info",
          id: detail.id || generateId(undefined, "toast"),
          duration: parseDuration(detail.duration),
        });
      } catch (error) {
        console.error("Failed to create toast:", error);
      }
    }) as EventListener);
  },

  destroyed(this: object & HookInterface<HTMLElement> & ToastHookState) {
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }
  },
};

export { ToastHook as Toast };
