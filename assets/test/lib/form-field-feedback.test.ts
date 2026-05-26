import { describe, expect, it } from "vitest";
import {
  clearCorexFormFieldFeedback,
  isCorexFormField,
  setHostDataInvalid,
  setScopeErrorsVisible,
} from "../../lib/form-field-feedback";

describe("form-field-feedback", () => {
  it("isCorexFormField reads data-form-field", () => {
    const el = document.createElement("div");
    expect(isCorexFormField(el)).toBe(false);
    el.setAttribute("data-form-field", "true");
    expect(isCorexFormField(el)).toBe(true);
  });

  it("clearCorexFormFieldFeedback clears host invalid and hides errors", () => {
    const host = document.createElement("div");
    host.setAttribute("data-invalid", "");
    const error = document.createElement("div");
    error.setAttribute("data-scope", "radio-group");
    error.setAttribute("data-part", "error");
    error.textContent = "can't be blank";
    host.append(error);

    clearCorexFormFieldFeedback(host, "radio-group");

    expect(host.hasAttribute("data-invalid")).toBe(false);
    expect(error.hidden).toBe(true);
  });

  it("setHostDataInvalid sets empty data-invalid when true", () => {
    const host = document.createElement("div");
    setHostDataInvalid(host, true);
    expect(host.getAttribute("data-invalid")).toBe("");
    setHostDataInvalid(host, false);
    expect(host.hasAttribute("data-invalid")).toBe(false);
  });

  it("setScopeErrorsVisible toggles error parts", () => {
    const host = document.createElement("div");
    const error = document.createElement("div");
    error.setAttribute("data-scope", "radio-group");
    error.setAttribute("data-part", "error");
    host.append(error);

    setScopeErrorsVisible(host, "radio-group", false);
    expect(error.hidden).toBe(true);
    setScopeErrorsVisible(host, "radio-group", true);
    expect(error.hidden).toBe(false);
  });
});
