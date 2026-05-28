import { describe, expect, it } from "vitest";
import * as datePicker from "@zag-js/date-picker";
import { DatePicker } from "../../components/date-picker";
import {
  applyServerIsoToZagIfNeeded,
  resolveCloseOnSelect,
  resolveIsoListForFormSync,
  valueToIsoString,
} from "../../hooks/date-picker";
import { el } from "../helpers/dom";

describe("valueToIsoString", () => {
  it("returns empty for null", () => {
    expect(valueToIsoString(null)).toBe("");
  });

  it("stringifies values", () => {
    expect(valueToIsoString("2024-01-01")).toBe("2024-01-01");
  });

  it("formats calendar date parts as ISO", () => {
    expect(valueToIsoString({ year: 2024, month: 6, day: 1 })).toBe("2024-06-01");
  });
});

describe("resolveCloseOnSelect", () => {
  it("reads closeOnSelect boolean", () => {
    expect(resolveCloseOnSelect(el({ closeOnSelect: true }))).toBe(true);
    expect(resolveCloseOnSelect(el({}))).toBe(false);
  });
});

describe("resolveIsoListForFormSync", () => {
  it("prefers explicit server values including empty", () => {
    const node = el({ formField: true, value: "1990-01-15" });
    expect(resolveIsoListForFormSync(node, undefined, [])).toEqual([]);
    expect(resolveIsoListForFormSync(node, undefined, ["1995-06-20"])).toEqual(["1995-06-20"]);
  });

  it("falls back to hidden input then data-value when api is empty", () => {
    const node = el({ formField: true, value: "1990-01-15" });
    node.innerHTML =
      '<input data-scope="date-picker" data-part="value-input" value="1990-01-15" />';

    expect(resolveIsoListForFormSync(node, [])).toEqual(["1990-01-15"]);
  });

  it("uses api values when present", () => {
    const node = el({ formField: true, value: "1990-01-15" });
    const parsed = datePicker.parse("1990-01-15");

    expect(resolveIsoListForFormSync(node, [parsed])).toEqual(["1990-01-15"]);
  });
});

describe("applyServerIsoToZagIfNeeded", () => {
  it("sets zag value from server iso when api is empty", () => {
    const host = document.createElement("div");
    host.id = "dp-form-field";
    host.innerHTML = `
      <div data-scope="date-picker" data-part="root"></div>
      <div data-scope="date-picker" data-part="control">
        <input data-scope="date-picker" data-part="input" />
        <input data-scope="date-picker" data-part="value-input" value="1990-01-15" />
      </div>
      <div data-scope="date-picker" data-part="positioner" hidden>
        <div data-scope="date-picker" data-part="content" hidden>
          <div data-part="day-view"><table><thead></thead><tbody></tbody></table></div>
        </div>
      </div>
    `;

    const instance = new DatePicker(host, {
      id: host.id,
      selectionMode: "single",
      defaultValue: [datePicker.parse("1990-01-15")],
    });
    instance.init();

    const synced = applyServerIsoToZagIfNeeded(instance, ["1990-01-15"]);
    expect(synced).toEqual(["1990-01-15"]);
    expect(instance.api.value.length).toBeGreaterThan(0);

    instance.destroy();
  });
});
