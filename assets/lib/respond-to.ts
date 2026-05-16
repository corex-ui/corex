export type RespondTo = "server" | "client" | "both";

export function parseRespondTo(source: unknown): RespondTo {
  if (source && typeof source === "object") {
    const o = source as Record<string, unknown>;
    const raw =
      o.respond_to ??
      o.respondTo ??
      (typeof o["respond_to"] === "string" ? o["respond_to"] : undefined) ??
      (typeof o["respondTo"] === "string" ? o["respondTo"] : undefined);
    if (raw === "server" || raw === "client" || raw === "both") return raw;
  }
  return "server";
}

type EmitResponseArgs<TPayload extends Record<string, unknown>> = {
  respondTo: RespondTo;
  canPushServer: boolean;
  pushEvent: (name: string, payload: TPayload) => void;
  serverEventName: string;
  serverPayload: TPayload;
  el: HTMLElement;
  domEventName: string;
  domDetail: TPayload;
};

export function idMatches(elId: string, payloadId: string | undefined | null): boolean {
  if (payloadId === undefined || payloadId === null || payloadId === "") return true;
  return elId === payloadId;
}

export function readPayloadChecked(payload: unknown): boolean | undefined {
  if (!payload || typeof payload !== "object") return undefined;
  const o = payload as Record<string, unknown>;
  const c = o.checked ?? o["checked"];
  if (c === true || c === "true" || c === 1) return true;
  if (c === false || c === "false" || c === 0) return false;
  return undefined;
}

export function readPayloadPressed(payload: unknown): boolean | undefined {
  if (!payload || typeof payload !== "object") return undefined;
  const o = payload as Record<string, unknown>;
  const p = o.pressed ?? o["pressed"];
  if (p === true || p === "true" || p === 1) return true;
  if (p === false || p === "false" || p === 0) return false;
  return undefined;
}

export function readPayloadStringArray(payload: unknown): string[] | undefined {
  if (!payload || typeof payload !== "object") return undefined;
  const o = payload as Record<string, unknown>;
  const v = o.value ?? o["value"];
  if (Array.isArray(v) && v.every((x) => typeof x === "string")) return v as string[];
  return undefined;
}

export function readPayloadVisible(payload: unknown): boolean | undefined {
  if (!payload || typeof payload !== "object") return undefined;
  const o = payload as Record<string, unknown>;
  const v = o.visible ?? o["visible"];
  if (v === true || v === "true" || v === 1) return true;
  if (v === false || v === "false" || v === 0) return false;
  return undefined;
}

export function readPayloadId(payload: unknown): string | undefined {
  if (!payload || typeof payload !== "object") return;
  const o = payload as Record<string, unknown>;
  let generic: string | undefined;
  for (const k of Object.keys(o)) {
    const v = o[k];
    if (typeof v !== "string" || v === "") continue;
    if (k === "id" || k === "Id") {
      generic = v;
    } else if (k.includes("_id") || (k.length > 2 && k.endsWith("Id"))) {
      return v;
    }
  }
  return generic;
}

export function readPayloadValue(payload: unknown): string {
  if (!payload || typeof payload !== "object") return "";
  const o = payload as Record<string, unknown>;
  const v = o.value ?? o["value"];
  if (v === undefined || v === null) return "";
  return String(v);
}

type NotifyChangeArgs<TPayload extends Record<string, unknown>> = {
  el: HTMLElement;
  canPushServer: boolean;
  pushEvent: (name: string, payload: TPayload) => void;
  payload: TPayload;
  serverEventName?: string | null;
  clientEventName?: string | null;
};

export function notifyChange<TPayload extends Record<string, unknown>>(
  args: NotifyChangeArgs<TPayload>
): void {
  const { el, canPushServer, pushEvent, payload, serverEventName, clientEventName } = args;

  if (serverEventName && canPushServer) {
    pushEvent(serverEventName, { ...payload });
  }
  if (clientEventName) {
    el.dispatchEvent(
      new CustomEvent(clientEventName, {
        bubbles: true,
        detail: payload,
      })
    );
  }
}

export function emitResponse<TPayload extends Record<string, unknown>>(
  args: EmitResponseArgs<TPayload>
): void {
  const {
    respondTo,
    canPushServer,
    pushEvent,
    serverEventName,
    serverPayload,
    el,
    domEventName,
    domDetail,
  } = args;

  if (respondTo !== "client" && canPushServer) {
    pushEvent(serverEventName, serverPayload);
  }
  if (respondTo !== "server") {
    el.dispatchEvent(
      new CustomEvent(domEventName, {
        bubbles: true,
        detail: domDetail,
      })
    );
  }
}
