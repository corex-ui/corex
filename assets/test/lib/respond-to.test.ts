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

describe("parseRespondTo", () => {
  it("defaults to server", () => {
    expect(parseRespondTo(undefined)).toBe("server");
  });

  it("reads respond_to snake_case", () => {
    expect(parseRespondTo({ respond_to: "client" })).toBe("client");
  });

  it("reads respondTo camelCase", () => {
    expect(parseRespondTo({ respondTo: "both" })).toBe("both");
  });
});

describe("idMatches", () => {
  it("does not match when payload id is empty", () => {
    expect(idMatches("carousel:1", "")).toBe(false);
    expect(idMatches("carousel:1", undefined)).toBe(false);
  });

  it("matches empty payload id when broadcast is opted in", () => {
    expect(idMatches("carousel:1", "", { broadcast: true })).toBe(true);
    expect(idMatches("carousel:1", undefined, { broadcast: true })).toBe(true);
  });

  it("requires equality when payload id is set", () => {
    expect(idMatches("carousel:1", "carousel:1")).toBe(true);
    expect(idMatches("carousel:1", "carousel:2")).toBe(false);
  });
});

describe("readPayloadId", () => {
  it("returns generic id", () => {
    expect(readPayloadId({ id: "a" })).toBe("a");
  });

  it("prefers compound id keys", () => {
    expect(readPayloadId({ carouselId: "c1", id: "ignored" })).toBe("c1");
    expect(readPayloadId({ carousel_id: "c2" })).toBe("c2");
  });
});

describe("readPayloadChecked", () => {
  it("coerces truthy and falsy values", () => {
    expect(readPayloadChecked({ checked: true })).toBe(true);
    expect(readPayloadChecked({ checked: "true" })).toBe(true);
    expect(readPayloadChecked({ checked: false })).toBe(false);
    expect(readPayloadChecked({ checked: 0 })).toBe(false);
  });
});

describe("readPayloadPressed", () => {
  it("coerces pressed", () => {
    expect(readPayloadPressed({ pressed: 1 })).toBe(true);
    expect(readPayloadPressed({ pressed: "false" })).toBe(false);
  });
});

describe("readPayloadVisible", () => {
  it("coerces visible", () => {
    expect(readPayloadVisible({ visible: "true" })).toBe(true);
    expect(readPayloadVisible({ visible: 0 })).toBe(false);
  });
});

describe("readPayloadValue", () => {
  it("stringifies value", () => {
    expect(readPayloadValue({ value: 42 })).toBe("42");
    expect(readPayloadValue({})).toBe("");
  });
});

describe("readPayloadStringArray", () => {
  it("returns string arrays only", () => {
    expect(readPayloadStringArray({ value: ["a", "b"] })).toEqual(["a", "b"]);
    expect(readPayloadStringArray({ value: [1] })).toBeUndefined();
  });
});

describe("notifyChange", () => {
  it("pushes server and dispatches client events", () => {
    const el = document.createElement("div");
    const pushEvent = vi.fn();
    const detail: { id: string } = { id: "x" };
    el.addEventListener("changed", ((e: CustomEvent) => {
      expect(e.detail).toEqual(detail);
    }) as EventListener);

    notifyChange({
      el,
      canPushServer: true,
      pushEvent,
      payload: detail,
      serverEventName: "on_change",
      clientEventName: "changed",
    });

    expect(pushEvent).toHaveBeenCalledWith("on_change", detail);
  });

  it("dispatches client only when canPushServer is false", () => {
    const el = document.createElement("div");
    const pushEvent = vi.fn();
    const received = vi.fn();
    el.addEventListener("changed", received as EventListener);

    notifyChange({
      el,
      canPushServer: false,
      pushEvent,
      payload: { id: "x" },
      serverEventName: "on_change",
      clientEventName: "changed",
    });

    expect(pushEvent).not.toHaveBeenCalled();
    expect(received).toHaveBeenCalled();
  });
});

describe("emitResponse", () => {
  it("emits client only when respondTo is client", () => {
    const el = document.createElement("div");
    const pushEvent = vi.fn();
    const received = vi.fn();
    el.addEventListener("picked", received as EventListener);

    emitResponse({
      respondTo: "client",
      canPushServer: true,
      pushEvent,
      serverEventName: "srv",
      serverPayload: { id: "1" },
      el,
      domEventName: "picked",
      domDetail: { id: "1" },
    });

    expect(pushEvent).not.toHaveBeenCalled();
    expect(received).toHaveBeenCalled();
  });

  it("pushes server when respondTo is server", () => {
    const el = document.createElement("div");
    const pushEvent = vi.fn();

    emitResponse({
      respondTo: "server",
      canPushServer: true,
      pushEvent,
      serverEventName: "srv",
      serverPayload: { id: "1" },
      el,
      domEventName: "picked",
      domDetail: { id: "1" },
    });

    expect(pushEvent).toHaveBeenCalledWith("srv", { id: "1" });
  });

  it("pushes server and emits client when respondTo is both", () => {
    const el = document.createElement("div");
    const pushEvent = vi.fn();
    const received = vi.fn();
    el.addEventListener("picked", received as EventListener);

    emitResponse({
      respondTo: "both",
      canPushServer: true,
      pushEvent,
      serverEventName: "srv",
      serverPayload: { id: "1" },
      el,
      domEventName: "picked",
      domDetail: { id: "1" },
    });

    expect(pushEvent).toHaveBeenCalled();
    expect(received).toHaveBeenCalled();
  });
});
