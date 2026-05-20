import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { FloatingPanel } from "../components/floating-panel";
import type { PositioningOptions } from "@zag-js/popper";
import type {
  Props,
  OpenChangeDetails,
  PositionChangeDetails,
  SizeChangeDetails,
  StageChangeDetails,
} from "@zag-js/floating-panel";
import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { readPositioningOptions } from "../lib/positioning";
import { idMatches, notifyChange, readPayloadId } from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";

type FloatingPanelHookState = {
  floatingPanel?: FloatingPanel;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
};

type PanelSize = { width: number; height: number };

type AnchorDetails = {
  triggerRect: DOMRect | null;
  boundaryRect: DOMRect | null;
};

function anchorPointFromPositioning(
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

export function parseSize(val: string | undefined): { width: number; height: number } | undefined {
  if (!val) return undefined;
  try {
    const parsed = JSON.parse(val) as { width?: number; height?: number };
    if (typeof parsed.width === "number" && typeof parsed.height === "number") {
      return { width: parsed.width, height: parsed.height };
    }
  } catch {
    //
  }
  return undefined;
}

export function parsePoint(val: string | undefined): { x: number; y: number } | undefined {
  if (!val) return undefined;
  try {
    const parsed = JSON.parse(val) as { x?: number; y?: number };
    if (typeof parsed.x === "number" && typeof parsed.y === "number") {
      return { x: parsed.x, y: parsed.y };
    }
  } catch {
    //
  }
  return undefined;
}

const FALLBACK_DEFAULT_SIZE = { width: 320, height: 240 };

export function buildAnchorProps(el: HTMLElement) {
  const defaultSize = parseSize(el.dataset.defaultSize) ?? FALLBACK_DEFAULT_SIZE;
  const defaultPosition = parsePoint(el.dataset.defaultPosition);
  const positioning = readPositioningOptions(el);
  const getAnchorPosition =
    defaultPosition == null && positioning
      ? (details: { triggerRect: DOMRect | null; boundaryRect: DOMRect | null }) =>
          anchorPointFromPositioning(positioning, details, defaultSize, getDir(el))
      : undefined;
  return { defaultPosition, getAnchorPosition } as const;
}

const FloatingPanelHook: Hook<
  object & HookInterface<HTMLElement> & FloatingPanelHookState,
  HTMLElement
> = {
  mounted(this: object & HookInterface<HTMLElement> & FloatingPanelHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const size = parseSize(el.dataset.size);
    const defaultSize = parseSize(el.dataset.defaultSize);
    const anchorProps = buildAnchorProps(el);
    const zag = new FloatingPanel(el, {
      id: el.id,
      defaultOpen: false,
      draggable: getBoolean(el, "draggable") !== false,
      resizable: getBoolean(el, "resizable") !== false,
      allowOverflow: getBoolean(el, "allowOverflow") !== false,
      closeOnEscape: getBoolean(el, "closeOnEscape") !== false,
      disabled: getBoolean(el, "disabled"),
      dir: getDir(el),
      size,
      defaultSize,
      defaultPosition: anchorProps.defaultPosition,
      getAnchorPosition: anchorProps.getAnchorPosition,
      minSize: parseSize(el.dataset.minSize),
      maxSize: parseSize(el.dataset.maxSize),
      persistRect: getBoolean(el, "persistRect"),
      gridSize: Number(el.dataset.gridSize) || 1,
      onOpenChange: (details: OpenChangeDetails) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: {
            id: el.id,
            open: details.open,
          } as Record<string, unknown>,
          serverEventName: getString(el, "onOpenChange"),
          clientEventName: getString(el, "onOpenChangeClient"),
        });
      },
      onPositionChange: (details: PositionChangeDetails) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id, position: details.position } as Record<string, unknown>,
          serverEventName: getString(el, "onPositionChange"),
          clientEventName: getString(el, "onPositionChangeClient"),
        });
      },
      onSizeChange: (details: SizeChangeDetails) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id, size: details.size } as Record<string, unknown>,
          serverEventName: getString(el, "onSizeChange"),
          clientEventName: getString(el, "onSizeChangeClient"),
        });
      },
      onStageChange: (details: StageChangeDetails) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id, stage: details.stage } as Record<string, unknown>,
          serverEventName: getString(el, "onStageChange"),
          clientEventName: getString(el, "onStageChangeClient"),
        });
      },
    } as Props);
    zag.init();
    this.floatingPanel = zag;

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add<CustomEvent<{ open: boolean }>>("corex:floating-panel:set-open", (event) => {
      const { open } = event.detail;
      zag.api.setOpen(open);
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add("floating_panel_set_open", (payload: unknown) => {
      if (!payload || typeof payload !== "object") return;
      const o = payload as { open?: boolean };
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (typeof o.open === "boolean") zag.api.setOpen(o.open);
    });
  },

  updated(this: object & HookInterface<HTMLElement> & FloatingPanelHookState) {
    const el = this.el;
    const anchorProps = buildAnchorProps(el);
    this.floatingPanel?.updateProps({
      id: el.id,
      disabled: getBoolean(el, "disabled"),
      dir: getDir(el),
      defaultPosition: anchorProps.defaultPosition,
      getAnchorPosition: anchorProps.getAnchorPosition,
    } as Partial<Props>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & FloatingPanelHookState) {
    this.domRegistry?.teardown();
    this.domRegistry = undefined;
    this.handleRegistry?.teardown();
    this.handleRegistry = undefined;
    this.floatingPanel?.destroy();
  },
};

export { FloatingPanelHook as FloatingPanel };
