import { describe, expect, it, vi } from "vitest";
import {
  hiddenInputPropsWithoutChecked,
  syncCheckableHiddenInput,
} from "../../lib/checkable-form-sync";
import { el } from "../helpers/dom";

describe("hiddenInputPropsWithoutChecked", () => {
  it("strips checked and defaultChecked", () => {
    expect(
      hiddenInputPropsWithoutChecked({
        name: "agree",
        checked: true,
        defaultChecked: false,
        id: "x",
      })
    ).toEqual({ name: "agree", id: "x" });
  });
});

describe("syncCheckableHiddenInput", () => {
  it("spreads props, sets checked, and associates form", () => {
    const host = el({ form: "f1" });
    const input = document.createElement("input");
    input.type = "checkbox";
    host.appendChild(input);
    document.body.appendChild(host);

    const spreadProps = vi.fn();
    syncCheckableHiddenInput(input, host, true, spreadProps, {
      name: "agree",
      checked: false,
    });

    expect(spreadProps).toHaveBeenCalledWith(input, { name: "agree" });
    expect(input.checked).toBe(true);
    expect(input.getAttribute("form")).toBe("f1");

    host.remove();
  });
});
