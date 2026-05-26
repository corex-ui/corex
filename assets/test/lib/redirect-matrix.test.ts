import { afterEach, describe, expect, it, vi } from "vitest";
import { performRedirect, readDomItemRedirect, type RedirectInput } from "../../lib/redirect";
import { mockLiveSocket } from "../helpers/mock-live-socket";
import { hasKey } from "../helpers/matrix";

describe.each([
  ["null element", null, undefined, null],
  ["fallback only", null, "fallback", "fallback"],
  ["redirect false", "false-dataset", undefined, null],
] as const)("readDomItemRedirect %s", (_label, kind, fallback, expectedTo) => {
  it("resolves redirect", () => {
    const element =
      kind === "false-dataset"
        ? (() => {
            const n = document.createElement("div");
            n.dataset.redirect = "false";
            return n;
          })()
        : null;
    const result = readDomItemRedirect(element, fallback);
    if (expectedTo === null) expect(result).toBeNull();
    else expect(result?.destination).toBe(expectedTo);
  });
});

describe("performRedirect", () => {
  const openSpy = vi.spyOn(window, "open").mockImplementation(() => null);

  afterEach(() => {
    openSpy.mockClear();
  });

  it.each([
    ["null", null, false],
    ["new tab", { destination: "/x", newTab: true }, true],
    ["patch", { destination: "/patch", mode: "patch" as const }, true],
    ["navigate", { destination: "/go", mode: "navigate" as const }, true],
  ] as const)("%s", (_label, input, expected) => {
    const { ctx, patch, navigate } = mockLiveSocket(true);
    expect(performRedirect(input, ctx)).toBe(expected);
    const redirect = input as RedirectInput | null;
    if (redirect && hasKey(redirect, "newTab") && redirect.newTab)
      expect(openSpy).toHaveBeenCalled();
    if (redirect?.mode === "patch") expect(patch).toHaveBeenCalled();
    if (redirect?.mode === "navigate") expect(navigate).toHaveBeenCalled();
  });
});
