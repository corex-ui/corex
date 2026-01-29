import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";

import { createToastGroup, getToastStore } from "../components/toast";
import type { Placement } from "@zag-js/toast";

import { getString, getBoolean, getNumber, generateId } from "../lib/util";

function onDisconnect(groupId: string) {
  const store = getToastStore(groupId);
  if (!store) return;

  store.create({
    title: "Disconnected",
    description: "You have been disconnected from the server.",
    type: "info",
  });
}

function onConnect(groupId: string) {
  const store = getToastStore(groupId);
  if (!store) return;

  store.create({
    title: "Connected",
    description: "You have been connected to the server.",
    type: "success",
  });
}

const ToastHook: Hook<object, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement>) {
    const el = this.el;

    if (!el.id) {
      el.id = generateId(el, "toast");
    }
    const groupId = el.id;

    const placement =
      getString<Placement>(el, "placement", [
        "top-start",
        "top",
        "top-end",
        "bottom-start",
        "bottom",
        "bottom-end",
      ]) || "bottom-end";

    const overlap = getBoolean(el, "overlap");
    const max = getNumber(el, "max");
    const gap = getNumber(el, "gap");
    const offsets = getString(el, "offset");
    const pauseOnPageIdle = getBoolean(el, "pause-on-page-idle");

    let parsedOffsets: string | Record<"left" | "right" | "bottom" | "top", string> | undefined;
    if (offsets) {
      try {
        parsedOffsets = offsets.includes("{") ? JSON.parse(offsets) : offsets;
      } catch {
        parsedOffsets = offsets;
      }
    }

    createToastGroup(el, {
      id: groupId,
      placement,
      overlap,
      max,
      gap,
      offsets: parsedOffsets,
      pauseOnPageIdle,
    });

    this.handleEvent(
      "toast-create",
      (payload: {
        title: string;
        description?: string;
        type?: "info" | "success" | "error" | "warning" | "loading";
        id?: string;
        duration?: number;
        groupId?: string;
      }) => {
        const store = getToastStore(payload.groupId || groupId);
        if (!store) return;

        try {
          store.create({
            title: payload.title,
            description: payload.description,
            type: payload.type || "info",
            id: payload.id || generateId(undefined, "toast"),
            duration: payload.duration,
          });
        } catch (error) {
          console.error("Failed to create toast:", error);
        }
      }
    );

    this.handleEvent(
      "toast-update",
      (payload: {
        id: string;
        title?: string;
        description?: string;
        type?: "info" | "success" | "error" | "warning" | "loading";
        groupId?: string;
      }) => {
        const store = getToastStore(payload.groupId || groupId);
        if (!store) return;

        try {
          store.update(payload.id, {
            title: payload.title,
            description: payload.description,
            type: payload.type,
          });
        } catch (error) {
          console.error("Failed to update toast:", error);
        }
      }
    );

    this.handleEvent("toast-dismiss", (payload: { id: string; groupId?: string }) => {
      const store = getToastStore(payload.groupId || groupId);
      if (!store) return;

      try {
        store.dismiss(payload.id);
      } catch (error) {
        console.error("Failed to dismiss toast:", error);
      }
    });

    el.addEventListener("toast:create", ((
      event: CustomEvent<{
        title: string;
        description?: string;
        type?: "info" | "success" | "error" | "warning" | "loading";
        id?: string;
        duration?: number;
        groupId?: string;
      }>
    ) => {
      const { detail } = event;
      const store = getToastStore(detail.groupId || groupId);
      if (!store) return;

      try {
        store.create({
          title: detail.title,
          description: detail.description,
          type: detail.type || "info",
          id: detail.id || generateId(undefined, "toast"),
          duration: detail.duration,
        });
      } catch (error) {
        console.error("Failed to create toast:", error);
      }
    }) as EventListener);

    const store = getToastStore(groupId);
    const flashInfo = el.dataset.flashInfo;
    const flashError = el.dataset.flashError;

    if (store && flashInfo) {
      try {
        store.create({
          title: flashInfo,
          type: "info",
          id: generateId(undefined, "toast"),
        });
      } catch (error) {
        console.error("Failed to create flash info toast:", error);
      }
    }

    if (store && flashError) {
      try {
        store.create({
          title: flashError,
          type: "error",
          id: generateId(undefined, "toast"),
        });
      } catch (error) {
        console.error("Failed to create flash error toast:", error);
      }
    }
    const handleDisconnect = () => onDisconnect(groupId);
    const handleConnect = () => onConnect(groupId);
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    (this as any)._toastDisconnect = handleDisconnect;
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    (this as any)._toastConnect = handleConnect;

    window.addEventListener("phx:disconnect", handleDisconnect);
    window.addEventListener("phx:connect", handleConnect);
  },

  destroyed(this: object & HookInterface<HTMLElement>) {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const anyThis = this as any;

    if (anyThis._toastDisconnect) {
      window.removeEventListener("phx:disconnect", anyThis._toastDisconnect);
    }

    if (anyThis._toastConnect) {
      window.removeEventListener("phx:connect", anyThis._toastConnect);
    }
  },
};

export { ToastHook as Toast };
