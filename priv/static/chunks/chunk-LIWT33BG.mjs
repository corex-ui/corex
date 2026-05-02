// lib/respond-to.ts
function parseRespondTo(source) {
  if (source && typeof source === "object") {
    const o = source;
    const raw = o.respond_to ?? o.respondTo ?? (typeof o["respond_to"] === "string" ? o["respond_to"] : void 0) ?? (typeof o["respondTo"] === "string" ? o["respondTo"] : void 0);
    if (raw === "server" || raw === "client" || raw === "both") return raw;
  }
  return "server";
}
function idMatches(elId, payloadId) {
  if (payloadId === void 0 || payloadId === null || payloadId === "") return true;
  return elId === payloadId;
}
function readPayloadChecked(payload) {
  if (!payload || typeof payload !== "object") return void 0;
  const o = payload;
  const c = o.checked ?? o["checked"];
  if (c === true || c === "true" || c === 1) return true;
  if (c === false || c === "false" || c === 0) return false;
  return void 0;
}
function readPayloadVisible(payload) {
  if (!payload || typeof payload !== "object") return void 0;
  const o = payload;
  const v = o.visible ?? o["visible"];
  if (v === true || v === "true" || v === 1) return true;
  if (v === false || v === "false" || v === 0) return false;
  return void 0;
}
function readPayloadId(payload) {
  if (!payload || typeof payload !== "object") return;
  const o = payload;
  let generic;
  for (const k of Object.keys(o)) {
    const v = o[k];
    if (typeof v !== "string" || v === "") continue;
    if (k === "id" || k === "Id") {
      generic = v;
    } else if (k.includes("_id") || k.length > 2 && k.endsWith("Id")) {
      return v;
    }
  }
  return generic;
}
function readPayloadValue(payload) {
  if (!payload || typeof payload !== "object") return "";
  const o = payload;
  const v = o.value ?? o["value"];
  if (v === void 0 || v === null) return "";
  return String(v);
}
function notifyChange(args) {
  const { el, canPushServer, pushEvent, payload, serverEventName, clientEventName } = args;
  if (serverEventName && canPushServer) {
    pushEvent(serverEventName, { ...payload });
  }
  if (clientEventName) {
    el.dispatchEvent(
      new CustomEvent(clientEventName, {
        bubbles: true,
        detail: payload
      })
    );
  }
}
function emitResponse(args) {
  const {
    respondTo,
    canPushServer,
    pushEvent,
    serverEventName,
    serverPayload,
    el,
    domEventName,
    domDetail
  } = args;
  if (respondTo !== "client" && canPushServer) {
    pushEvent(serverEventName, serverPayload);
  }
  if (respondTo !== "server") {
    el.dispatchEvent(
      new CustomEvent(domEventName, {
        bubbles: true,
        detail: domDetail
      })
    );
  }
}

export {
  parseRespondTo,
  idMatches,
  readPayloadChecked,
  readPayloadVisible,
  readPayloadId,
  readPayloadValue,
  notifyChange,
  emitResponse
};
