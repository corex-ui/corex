import { describe, expect, it } from "vitest";
import { syncInputFormAssociation } from "../../lib/util";
import { el } from "../helpers/dom";

describe("syncInputFormAssociation", () => {
  it("removes form attribute when the hook is inside a form element", () => {
    const root = el({ form: "post-form" });
    const form = document.createElement("form");
    form.id = "post-form";
    const input = document.createElement("input");
    input.setAttribute("form", "post-form");
    form.appendChild(root);
    root.appendChild(input);
    document.body.appendChild(form);

    syncInputFormAssociation(input, root);

    expect(input.hasAttribute("form")).toBe(false);
    form.remove();
  });

  it("sets form attribute when the hook is outside a form element", () => {
    const root = el({ form: "post-form" });
    const input = document.createElement("input");
    root.appendChild(input);

    syncInputFormAssociation(input, root);

    expect(input.getAttribute("form")).toBe("post-form");
  });
});
