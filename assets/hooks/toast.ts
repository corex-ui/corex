import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";

import { createToastGroup, disposeToastGroup, getToastStore } from "../components/toast";
import type { ActionOptions } from "@zag-js/toast";
import type { Placement } from "@zag-js/toast";
import type { Options } from "@zag-js/toast";

import type { RedirectContext } from "../lib/redirect";
import { getString, getBoolean, getNumber, generateId } from "../lib/util";
import { createZagLiveHook } from "../lib/zag-live-hook";

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
  group_id?: string;
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
  group_id?: string;
  loading?: unknown;
  action?: unknown;
  priority?: number | string;
};

type ToastIdPayload = {
  id: string;
  group_id?: string;
};

const loadingMeta = (loading: unknown) =>
  loading === true || loading === "true" ? { meta: { loading: true as const } } : {};

type ToastHookState = {
  groupId: string;
  toastGroup?: ToastGroupHandle;
};

type ToastGroupOptions = NonNullable<Parameters<typeof createToastGroup>[1]> & { id: string };

class ToastGroupHandle {
  constructor(
    private readonly el: HTMLElement,
    private readonly options: ToastGroupOptions
  ) {}

  init(): void {
    createToastGroup(this.el, this.options);
    this.el.setAttribute("data-ready", "");
    this.createFlashToasts();
  }

  destroy(): void {
    disposeToastGroup(this.options.id);
  }

  private createFlashToasts(): void {
    const store = getToastStore(this.options.id);
    if (!store) return;

    for (const { type, body, title, duration, fallbackTitle } of readFlashToasts(this.el)) {
      try {
        store.create({
          title: title || fallbackTitle,
          description: body,
          type,
          id: generateId(undefined, "toast"),
          duration: parseToastDuration(duration ?? undefined),
        });
      } catch (error) {
        console.error(`Failed to create flash ${type} toast:`, error);
      }
    }
  }
}

type FlashToast = {
  type: "info" | "error";
  fallbackTitle: string;
  body: string;
  title: string | null;
  duration: string | null;
};

function readFlashToasts(el: HTMLElement): FlashToast[] {
  const specs: Array<Omit<FlashToast, "body">> = [
    {
      type: "info",
      fallbackTitle: "Success",
      title: el.getAttribute("data-flash-info-title"),
      duration: el.getAttribute("data-flash-info-duration"),
    },
    {
      type: "error",
      fallbackTitle: "Error",
      title: el.getAttribute("data-flash-error-title"),
      duration: el.getAttribute("data-flash-error-duration"),
    },
  ];

  return specs.flatMap((spec) => {
    const body = el.getAttribute(`data-flash-${spec.type}`);
    return body ? [{ ...spec, body }] : [];
  });
}

function parseToastDuration(duration?: number | string): number | undefined {
  if (duration === "Infinity" || duration === Infinity) return Infinity;
  if (typeof duration === "string") return parseInt(duration, 10) || undefined;
  return duration;
}

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

const ToastHook = createZagLiveHook<ToastHookState, ToastGroupHandle>({
  key: "toastGroup",
  mount(hook, { dom, server }) {
    const el = hook.el;

    if (!el.id) {
      el.id = generateId(el, "toast");
    }
    hook.groupId = el.id;

    const parseOffsets = (offsetsString?: string) => {
      if (!offsetsString) return undefined;
      try {
        return offsetsString.includes("{") ? JSON.parse(offsetsString) : offsetsString;
      } catch {
        return offsetsString;
      }
    };

    const parseDuration = parseToastDuration;

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

    const group = new ToastGroupHandle(el, {
      id: hook.groupId,
      placement,
      overlap: getBoolean(el, "overlap"),
      max: getNumber(el, "max"),
      gap: getNumber(el, "gap"),
      offsets: parseOffsets(getString(el, "offset")),
      pauseOnPageIdle: getBoolean(el, "pauseOnPageIdle"),
    });

    const rt = buildRuntime(hook);

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

    const matchesGroup = (payload: { group_id?: string }): payload is { group_id: string } =>
      typeof payload.group_id === "string" && payload.group_id === hook.groupId;

    const handleDismissPayload = (payload: ToastIdPayload) => {
      if (!matchesGroup(payload)) return;
      const st = getToastStore(payload.group_id);
      if (!st) return;
      try {
        st.dismiss(payload.id);
      } catch (error) {
        console.error("Failed to dismiss toast:", error);
      }
    };

    const handleRemovePayload = (payload: ToastIdPayload) => {
      if (!matchesGroup(payload)) return;
      const st = getToastStore(payload.group_id);
      if (!st) return;
      try {
        st.remove(payload.id);
      } catch (error) {
        console.error("Failed to remove toast:", error);
      }
    };

    const createToast = (payload: ToastCreatePayload, trusted: boolean) => {
      if (!matchesGroup(payload)) return;
      const st = getToastStore(payload.group_id);
      if (!st) return;
      try {
        st.create(buildCreateOptions(payload, trusted));
      } catch (error) {
        console.error("Failed to create toast:", error);
      }
    };

    const updateToast = (payload: ToastUpdatePayload, trusted: boolean) => {
      if (!matchesGroup(payload) || !payload.id) return;
      const st = getToastStore(payload.group_id);
      if (!st) return;
      try {
        st.update(payload.id, buildUpdatePatch(payload, trusted));
      } catch (error) {
        console.error("Failed to update toast:", error);
      }
    };

    server.add("toast_create", (payload: ToastCreatePayload) => createToast(payload, true));
    server.add("toast_update", (payload: ToastUpdatePayload) => updateToast(payload, true));
    server.add("toast_dismiss", handleDismissPayload);
    server.add("toast_remove", handleRemovePayload);

    dom.add<CustomEvent<ToastCreatePayload>>("corex:toast:create", (event) =>
      createToast(event.detail, false)
    );
    dom.add<CustomEvent<ToastUpdatePayload>>("corex:toast:update", (event) =>
      updateToast(event.detail, false)
    );
    dom.add<CustomEvent<ToastIdPayload>>("corex:toast:dismiss", (event) =>
      handleDismissPayload(event.detail)
    );
    dom.add<CustomEvent<ToastIdPayload>>("corex:toast:remove", (event) =>
      handleRemovePayload(event.detail)
    );

    return group;
  },
});

export { ToastHook as Toast };
