import type { ActionOptions } from "@zag-js/toast";
import type { RedirectContext } from "./redirect";

export type ToastActionSpec = {
  label: string;
  encoded: string;
  className?: string;
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

function parseSingleExecJsEffect(raw: unknown): string | null {
  const o = asRecord(raw);
  if (o.kind !== "exec_js") return null;
  const encoded = o.encoded;
  if (typeof encoded !== "string" || encoded.length === 0) return null;
  return encoded;
}

export function parseActionSpec(raw: unknown): ToastActionSpec | null {
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
  return spec;
}

export function buildZagAction(
  spec: ToastActionSpec,
  rt: ToastHookRuntime
): ActionOptions & { className?: string } {
  const action: ActionOptions & { className?: string } = {
    label: spec.label,
    onClick: () => {
      rt.execJs(spec.encoded);
    },
  };
  if (spec.className) action.className = spec.className;
  return action;
}
