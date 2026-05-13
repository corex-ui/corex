import { performRedirect, type RedirectContext } from "./redirect";
import type { ActionOptions } from "@zag-js/toast";

export type ToastEffect =
  | { kind: "push"; event: string; value?: Record<string, unknown> }
  | { kind: "redirect"; to: string; redirect?: "href" | "patch" | "navigate"; newTab?: boolean }
  | { kind: "exec_js"; encoded: string };

export type ToastActionSpec = {
  label: string;
  effects: ToastEffect[];
};

export type ToastHookRuntime = {
  pushEvent: (event: string, payload?: Record<string, unknown>) => void;
  execJs: (encoded: string) => void;
  redirectCtx: RedirectContext;
};

function asRecord(v: unknown): Record<string, unknown> {
  return v != null && typeof v === "object" && !Array.isArray(v)
    ? (v as Record<string, unknown>)
    : {};
}

function parseEffect(raw: unknown): ToastEffect | null {
  const o = asRecord(raw);
  const kind = o.kind;
  if (kind !== "push" && kind !== "redirect" && kind !== "exec_js") return null;
  if (kind === "push") {
    const event = o.event;
    if (typeof event !== "string") return null;
    const value = asRecord(o.value);
    return { kind: "push", event, value };
  }
  if (kind === "redirect") {
    const to = o.to;
    if (typeof to !== "string") return null;
    const redirect = o.redirect;
    const r =
      redirect === "patch" || redirect === "navigate" || redirect === "href" ? redirect : "href";
    return { kind: "redirect", to, redirect: r, newTab: Boolean(o.newTab) };
  }
  const encoded = o.encoded;
  if (typeof encoded !== "string") return null;
  return { kind: "exec_js", encoded };
}

export function parseActionSpec(raw: unknown): ToastActionSpec | null {
  const o = asRecord(raw);
  const label = o.label;
  if (typeof label !== "string" || label.length === 0) return null;
  const effectsRaw = o.effects;
  if (!Array.isArray(effectsRaw)) return null;
  const effects = effectsRaw.map(parseEffect).filter((e): e is ToastEffect => e != null);
  if (effects.length === 0) return null;
  return { label, effects };
}

function runEffects(effects: ToastEffect[], rt: ToastHookRuntime) {
  for (const eff of effects) {
    if (eff.kind === "push") {
      rt.pushEvent(eff.event, eff.value ?? {});
    } else if (eff.kind === "redirect") {
      performRedirect(
        {
          destination: eff.to,
          mode: eff.redirect ?? "href",
          newTab: eff.newTab,
        },
        rt.redirectCtx
      );
    } else {
      rt.execJs(eff.encoded);
    }
  }
}

export function buildZagAction(spec: ToastActionSpec, rt: ToastHookRuntime): ActionOptions {
  return {
    label: spec.label,
    onClick: () => {
      runEffects(spec.effects, rt);
    },
  };
}
