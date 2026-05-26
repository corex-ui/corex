import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/marquee";
import { readMarqueeProps } from "../../hooks/marquee";
import { el } from "../helpers/dom";
import { expectHookModule } from "../helpers/expect-hook";

describe("marquee hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("readMarqueeProps", () => {
  it.each([
    [{ duration: 3000, side: "top", speed: 40, autoFill: true }, 3000, "top"],
    [{ duration: 1000, side: "bottom" }, 1000, "bottom"],
  ] as const)("%#", (dataset, duration, side) => {
    const node = el(dataset as Record<string, string | number | boolean>);
    node.id = "mq";
    const props = readMarqueeProps(node);
    expect(props.id).toBe("mq");
    expect(props.duration).toBe(duration);
    expect(props.side).toBe(side);
  });
});
