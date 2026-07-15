import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";

import { createToastGroup, disposeToastGroup, getToastStore } from "../components/toast";
import type { ActionOptions } from "@zag-js/toast";
import type { Placement } from "@zag-js/toast";
import type { Options } from "@zag-js/toast";

import type { RedirectContext } from "../lib/redirect";
import { getString, getBoolean, getNumber, generateId } from "../lib/util";

type ToastActionSpec = {
  label: string;
  encoded: string;
  className?: string;
  labelHtml?: boolean;
};

type ToastHookRuntime = {
  pushEvent: (event: string, payload?: Record<string, unknown>) => void;
  execJs: (encoded: string) => void;
  redirectCtx: RedirectContext;
};

function asRecord(v: unknown): Record<string, unknown> {
  return v != null && typeof v === "object" && !Array.isArray(v)
    ? (v as Record<string, unknown>)
    : {};
}

export function parseSingleExecJsEffect(raw: unknown): string | null {
  const o = asRecord(raw);
  if (o.kind !== "exec_js") return null;
  const encoded = o.encoded;
  if (typeof encoded !== "string" || encoded.length === 0) return null;
  return encoded;
}

export function parseServerActionSpec(raw: unknown): ToastActionSpec | null {
  const o = asRecord(raw);
  const label = o.label;
  if (typeof label !== "string" || label.length === 0) return null;
  const effectsRaw = o.effects;
  if (!Array.isArray(effectsRaw) || effectsRaw.length !== 1) return null;
  const encoded = parseSingleExecJsEffect(effectsRaw[0]);
  if (encoded == null) return null;
  const spec: ToastActionSpec = { label, encoded };
  const className = o.class;
  if (typeof className === "string" && className.trim()) {
    spec.className = className.trim();
  }
  if (o.labelHtml === true) {
    spec.labelHtml = true;
  }
  return spec;
}

export function parseDomActionSpec(_raw: unknown): ToastActionSpec | null {
  return null;
}

export const parseActionSpec = parseServerActionSpec;

function buildZagAction(
  spec: ToastActionSpec,
  rt: ToastHookRuntime
): ActionOptions & { className?: string; labelHtml?: boolean } {
  const action: ActionOptions & { className?: string; labelHtml?: boolean } = {
    label: spec.label,
    onClick: () => {
      rt.execJs(spec.encoded);
    },
  };
  if (spec.className) action.className = spec.className;
  if (spec.labelHtml) action.labelHtml = true;
  return action;
}

type ToastCreatePayload = {
  title?: string;
  description?: string;
  type?: "info" | "success" | "error" | "warning" | "loading" | string;
  id?: string;
  duration?: number | string;
  groupId?: string;
  loading?: unknown;
  action?: unknown;
  priority?: number | string;
};

type ToastUpdatePayload = {
  id: string;
  title?: string;
  description?: string;
  type?: "info" | "success" | "error" | "warning" | "loading" | string;
  duration?: number | string;
  groupId?: string;
  loading?: unknown;
  action?: unknown;
  priority?: number | string;
};

type ToastIdPayload = {
  id: string;
  groupId?: string;
};

const loadingMeta = (loading: unknown) =>
  loading === true || loading === "true" ? { meta: { loading: true as const } } : {};

type DomListener = { el: HTMLElement; name: string; fn: EventListener };

type ToastHookState = {
  groupId: string;
  handlers?: Array<CallbackRef>;
  domListeners?: DomListener[];
};

function buildRuntime(self: HookInterface<HTMLElement>): ToastHookRuntime {
  return {
    pushEvent: (event, payload) => {
      self.pushEvent(event, payload ?? {});
    },
    execJs: (encoded) => {
      self.js().exec(encoded);
    },
    redirectCtx: { liveSocket: self.liveSocket },
  };
}

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

    const parsePriority = (raw: number | string | undefined): Options["priority"] | undefined => {
      if (raw === undefined || raw === null) return undefined;
      const n = typeof raw === "string" ? parseInt(raw, 10) : raw;
      if (!Number.isFinite(n) || n < 1 || n > 8) return undefined;
      return n as Options["priority"];
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

    el.setAttribute("data-ready", "");

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

    const rt = buildRuntime(this);

    const buildCreateOptions = (payload: ToastCreatePayload, trusted: boolean): Options => {
      const spec = trusted
        ? parseServerActionSpec(payload.action)
        : parseDomActionSpec(payload.action);
      const base: Options = {
        title: payload.title ?? "",
        description: payload.description,
        type: (payload.type as Options["type"]) || "info",
        id: payload.id || generateId(undefined, "toast"),
        duration: parseDuration(payload.duration),
        ...loadingMeta(payload.loading),
      };
      if (spec) {
        base.action = buildZagAction(spec, rt);
      }
      const pr = parsePriority(payload.priority);
      if (pr !== undefined) base.priority = pr;
      return base;
    };

    const buildUpdatePatch = (payload: ToastUpdatePayload, trusted: boolean): Partial<Options> => {
      const patch: Partial<Options> = {};
      if (payload.title !== undefined) patch.title = payload.title;
      if (payload.description !== undefined) patch.description = payload.description;
      if (payload.type !== undefined) patch.type = payload.type as Options["type"];
      if (payload.duration !== undefined) patch.duration = parseDuration(payload.duration);
      if (payload.loading === true || payload.loading === "true") {
        patch.meta = { loading: true };
      } else if (payload.loading === false || payload.loading === "false") {
        patch.meta = { loading: false };
      }
      const spec = trusted
        ? parseServerActionSpec(payload.action)
        : parseDomActionSpec(payload.action);
      if (spec) {
        patch.action = buildZagAction(spec, rt);
      } else if (payload.action === null) {
        patch.action = undefined;
      }
      const pr = parsePriority(payload.priority);
      if (pr !== undefined) patch.priority = pr;
      return patch;
    };

    const matchesGroup = (payload: { groupId?: string }): payload is { groupId: string } =>
      typeof payload.groupId === "string" && payload.groupId === this.groupId;

    const handleDismissPayload = (payload: ToastIdPayload) => {
      if (!matchesGroup(payload)) return;
      const st = getToastStore(payload.groupId);
      if (!st) return;
      try {
        st.dismiss(payload.id);
      } catch (error) {
        console.error("Failed to dismiss toast:", error);
      }
    };

    const handleRemovePayload = (payload: ToastIdPayload) => {
      if (!matchesGroup(payload)) return;
      const st = getToastStore(payload.groupId);
      if (!st) return;
      try {
        st.remove(payload.id);
      } catch (error) {
        console.error("Failed to remove toast:", error);
      }
    };

    this.handlers = [];

    this.handlers.push(
      this.handleEvent("toast-create", (payload: ToastCreatePayload) => {
        if (!matchesGroup(payload)) return;
        const st = getToastStore(payload.groupId);
        if (!st) return;
        try {
          st.create(buildCreateOptions(payload, true));
        } catch (error) {
          console.error("Failed to create toast:", error);
        }
      })
    );

    this.handlers.push(
      this.handleEvent("toast-update", (payload: ToastUpdatePayload) => {
        if (!matchesGroup(payload) || !payload.id) return;
        const st = getToastStore(payload.groupId);
        if (!st) return;
        try {
          st.update(payload.id, buildUpdatePatch(payload, true));
        } catch (error) {
          console.error("Failed to update toast:", error);
        }
      })
    );

    this.handlers.push(this.handleEvent("toast-dismiss", handleDismissPayload));

    this.handlers.push(this.handleEvent("toast-remove", handleRemovePayload));

    const onToastCreate = ((event: CustomEvent<ToastCreatePayload>) => {
      const { detail } = event;
      if (!matchesGroup(detail)) return;
      const st = getToastStore(detail.groupId);
      if (!st) return;
      try {
        st.create(buildCreateOptions(detail, false));
      } catch (error) {
        console.error("Failed to create toast:", error);
      }
    }) as EventListener;

    const onCorexToastCreate = ((event: CustomEvent<ToastCreatePayload>) => {
      const { detail } = event;
      if (!matchesGroup(detail)) return;
      const st = getToastStore(detail.groupId);
      if (!st) return;
      try {
        st.create(buildCreateOptions(detail, false));
      } catch (error) {
        console.error("Failed to create toast:", error);
      }
    }) as EventListener;

    const onToastUpdate = ((event: CustomEvent<ToastUpdatePayload>) => {
      const { detail } = event;
      if (!matchesGroup(detail) || !detail.id) return;
      const st = getToastStore(detail.groupId);
      if (!st) return;
      try {
        st.update(detail.id, buildUpdatePatch(detail, false));
      } catch (error) {
        console.error("Failed to update toast:", error);
      }
    }) as EventListener;

    const onToastDismiss = ((event: CustomEvent<ToastIdPayload>) => {
      handleDismissPayload(event.detail);
    }) as EventListener;

    const onToastRemove = ((event: CustomEvent<ToastIdPayload>) => {
      handleRemovePayload(event.detail);
    }) as EventListener;

    const domListeners: DomListener[] = [];
    const addDom = (name: string, fn: EventListener) => {
      el.addEventListener(name, fn);
      domListeners.push({ el, name, fn });
    };
    (this as object & ToastHookState).domListeners = domListeners;

    addDom("corex:toast:create", onCorexToastCreate);
    addDom("toast:create", onToastCreate);
    addDom("toast:update", onToastUpdate);
    addDom("toast:dismiss", onToastDismiss);
    addDom("toast:remove", onToastRemove);
  },

  destroyed(this: object & HookInterface<HTMLElement> & ToastHookState) {
    for (const { el, name, fn } of this.domListeners ?? []) {
      el.removeEventListener(name, fn);
    }
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }
    if (this.groupId) {
      disposeToastGroup(this.groupId);
    }
  },
};

export { ToastHook as Toast };
