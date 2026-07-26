import { describe, expect, it, vi } from "vitest";
import {
  hiddenInputPropsWithoutValue,
  syncHiddenInputValue,
} from "../../lib/value-form-sync";
import { el } from "../helpers/dom";

describe("hiddenInputPropsWithoutValue", () => {
  it("strips value and defaultValue", () => {
    expect(
      hiddenInputPropsWithoutValue({
        name: "amount",
        value: "1",
        defaultValue: "0",
        id: "n",
      })
    ).toEqual({ name: "amount", id: "n" });
  });
});

describe("syncHiddenInputValue", () => {
  it("spreads props when present, sets value, and associates form", () => {
    const host = el({ form: "f2" });
    const input = document.createElement("input");
    input.type = "hidden";
    host.appendChild(input);
    document.body.appendChild(host);

    const spreadProps = vi.fn();
    syncHiddenInputValue(input, host, "42", spreadProps, {
      name: "amount",
      value: "0",
    });

    expect(spreadProps).toHaveBeenCalledWith(input, { name: "amount" });
    expect(input.value).toBe("42");
    expect(input.getAttribute("form")).toBe("f2");

    host.remove();
  });

  it("skips spread when hidden props are empty", () => {
    const host = document.createElement("div");
    const input = document.createElement("input");
    host.appendChild(input);
    const spreadProps = vi.fn();

    syncHiddenInputValue(input, host, "7", spreadProps, {});

    expect(spreadProps).not.toHaveBeenCalled();
    expect(input.value).toBe("7");
  });
});
