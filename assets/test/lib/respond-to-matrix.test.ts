import { describe, expect, it, vi } from "vitest";
import {
  emitResponse,
  idMatches,
  notifyChange,
  parseRespondTo,
  readPayloadChecked,
  readPayloadId,
  readPayloadPressed,
  readPayloadStringArray,
  readPayloadValue,
  readPayloadVisible,
} from "../../lib/respond-to";

describe.each([
  [{}, "server"],
  [{ respond_to: "client" }, "client"],
  [{ respondTo: "both" }, "both"],
  [{ respond_to: "invalid" }, "server"],
  [null, "server"],
] as const)("parseRespondTo", (source, expected) => {
  it(`returns ${expected}`, () => {
    expect(parseRespondTo(source)).toBe(expected);
  });
});

describe.each([
  ["empty id does not match", "hook-1", "", false],
  ["null id does not match", "hook-1", null, false],
  ["equal ids", "hook-1", "hook-1", true],
  ["different ids", "hook-1", "hook-2", false],
] as const)("idMatches %s", (_label, elId, payloadId, expected) => {
  it("matches", () => {
    expect(idMatches(elId, payloadId)).toBe(expected);
  });
});

describe.each([
  [{ checked: true }, true],
  [{ checked: "true" }, true],
  [{ checked: 1 }, true],
  [{ checked: false }, false],
  [{ checked: "false" }, false],
  [{ checked: 0 }, false],
  [{}, undefined],
  [null, undefined],
] as const)("readPayloadChecked", (payload, expected) => {
  it(`returns ${String(expected)}`, () => {
    expect(readPayloadChecked(payload)).toBe(expected);
  });
});

describe.each([
  [{ pressed: true }, true],
  [{ pressed: "false" }, false],
  [{}, undefined],
] as const)("readPayloadPressed", (payload, expected) => {
  it(`returns ${String(expected)}`, () => {
    expect(readPayloadPressed(payload)).toBe(expected);
  });
});

describe.each([
  [{ visible: true }, true],
  [{ visible: "false" }, false],
  [{}, undefined],
] as const)("readPayloadVisible", (payload, expected) => {
  it(`returns ${String(expected)}`, () => {
    expect(readPayloadVisible(payload)).toBe(expected);
  });
});

describe.each([
  [{ value: ["a", "b"] }, ["a", "b"]],
  [{ value: [1, 2] }, undefined],
  [{}, undefined],
] as const)("readPayloadStringArray", (payload, expected) => {
  it("reads array", () => {
    expect(readPayloadStringArray(payload)).toEqual(expected);
  });
});

describe.each([
  [{ id: "x" }, "x"],
  [{ checkbox_id: "cb-1" }, "cb-1"],
  [{ value: "v" }, "v"],
  [{}, ""],
] as const)("readPayloadId / readPayloadValue", (payload, expectedId) => {
  it("reads id or value", () => {
    if (
      "id" in (payload as object) ||
      Object.keys(payload as object).some((k) => k.includes("id"))
    ) {
      expect(readPayloadId(payload)).toBe(expectedId);
    } else if (Object.keys(payload as object).length === 0) {
      expect(readPayloadValue(payload)).toBe("");
    } else {
      expect(readPayloadValue(payload)).toBe(expectedId);
    }
  });
});

describe("notifyChange matrix", () => {
  it.each([
    ["server only", true, "srv", undefined],
    ["client only", false, "srv", "client"],
    ["both when connected", true, "srv", "client"],
  ] as const)("%s", (_label, canPush, serverName, clientName) => {
    const el = document.createElement("div");
    const pushEvent = vi.fn();
    const client = vi.fn();
    if (clientName) el.addEventListener(clientName, client as EventListener);
    notifyChange({
      el,
      canPushServer: canPush,
      pushEvent,
      payload: { id: "1" },
      serverEventName: serverName,
      clientEventName: clientName,
    });
    if (canPush && serverName) expect(pushEvent).toHaveBeenCalled();
    else expect(pushEvent).not.toHaveBeenCalled();
    if (clientName) expect(client).toHaveBeenCalled();
  });
});

describe("emitResponse matrix", () => {
  it.each(["server", "client", "both"] as const)("respondTo %s", (respondTo) => {
    const el = document.createElement("div");
    const pushEvent = vi.fn();
    const client = vi.fn();
    el.addEventListener("picked", client as EventListener);
    emitResponse({
      respondTo,
      canPushServer: true,
      pushEvent,
      serverEventName: "srv",
      serverPayload: { id: "1" },
      el,
      domEventName: "picked",
      domDetail: { id: "1" },
    });
    if (respondTo !== "client") expect(pushEvent).toHaveBeenCalled();
    else expect(pushEvent).not.toHaveBeenCalled();
    if (respondTo !== "server") expect(client).toHaveBeenCalled();
  });
});
