import type { PositioningOptions } from "@zag-js/popper";

type PanelSize = { width: number; height: number };

type AnchorDetails = {
  triggerRect: DOMRect | null;
  boundaryRect: DOMRect | null;
};

export function anchorPointFromPositioning(
  positioning: PositioningOptions,
  details: AnchorDetails,
  panelSize: PanelSize,
  dir: "ltr" | "rtl" | undefined
): { x: number; y: number } | undefined {
  const boundaryRect = details.boundaryRect;
  if (!boundaryRect) return undefined;

  const gutter = positioning.gutter ?? 8;
  const shift = positioning.shift ?? 0;
  const mainAxis = positioning.offset?.mainAxis ?? 0;
  const crossAxis = positioning.offset?.crossAxis ?? 0;
  const placement = positioning.placement ?? "bottom";
  const { width: pw, height: ph } = panelSize;
  const b = boundaryRect;
  const isRtl = dir === "rtl";

  const xInnerLeft = b.x + gutter;
  const xInnerRight = b.x + b.width - pw - gutter;
  const xCenter = b.x + (b.width - pw) / 2;

  const yInnerTop = b.y + gutter;
  const yInnerBottom = b.y + b.height - ph - gutter;
  const yCenter = b.y + (b.height - ph) / 2;

  const parts = placement.split("-") as [string, string?];
  const side = parts[0];
  const align = parts[1];

  const xForBottomTop = () => {
    if (align === "start") return isRtl ? xInnerRight : xInnerLeft;
    if (align === "end") return isRtl ? xInnerLeft : xInnerRight;
    return xCenter;
  };

  if (side === "bottom") {
    return {
      x: xForBottomTop() + shift + crossAxis,
      y: yInnerBottom - mainAxis,
    };
  }

  if (side === "top") {
    return {
      x: xForBottomTop() + shift + crossAxis,
      y: yInnerTop + mainAxis,
    };
  }

  if (side === "left") {
    const y = align === "start" ? yInnerTop : align === "end" ? yInnerBottom : yCenter;
    return {
      x: b.x + gutter + mainAxis,
      y: y + shift + crossAxis,
    };
  }

  if (side === "right") {
    const y = align === "start" ? yInnerTop : align === "end" ? yInnerBottom : yCenter;
    return {
      x: b.x + b.width - pw - gutter - mainAxis,
      y: y + shift + crossAxis,
    };
  }

  return {
    x: xCenter + crossAxis,
    y: yCenter + mainAxis,
  };
}
