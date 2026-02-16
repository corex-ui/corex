import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { FloatingPanel } from "../components/floating-panel";
import type {
  Props,
  OpenChangeDetails,
  PositionChangeDetails,
  SizeChangeDetails,
  StageChangeDetails,
} from "@zag-js/floating-panel";
import { getString, getBoolean, getDir } from "../lib/util";

type FloatingPanelHookState = {
  floatingPanel?: FloatingPanel;
  handlers?: Array<CallbackRef>;
};

function parseSize(val: string | undefined): { width: number; height: number } | undefined {
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

function parsePoint(val: string | undefined): { x: number; y: number } | undefined {
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

const FloatingPanelHook: Hook<object & FloatingPanelHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & FloatingPanelHookState) {
    const el = this.el;
    const open = getBoolean(el, "open");
    const defaultOpen = getBoolean(el, "defaultOpen");
    const controlled = getBoolean(el, "controlled");
    const size = parseSize(el.dataset.size);
    const defaultSize = parseSize(el.dataset.defaultSize);
    const position = parsePoint(el.dataset.position);
    const defaultPosition = parsePoint(el.dataset.defaultPosition);
    const zag = new FloatingPanel(el, {
      id: el.id,
      ...(controlled ? { open } : { defaultOpen }),
      draggable: getBoolean(el, "draggable") !== false,
      resizable: getBoolean(el, "resizable") !== false,
      allowOverflow: getBoolean(el, "allowOverflow") !== false,
      closeOnEscape: getBoolean(el, "closeOnEscape") !== false,
      disabled: getBoolean(el, "disabled"),
      dir: getDir(el),
      size,
      defaultSize,
      position,
      defaultPosition,
      minSize: parseSize(el.dataset.minSize),
      maxSize: parseSize(el.dataset.maxSize),
      persistRect: getBoolean(el, "persistRect"),
      gridSize: Number(el.dataset.gridSize) || 1,
      onOpenChange: (details: OpenChangeDetails) => {
        const eventName = getString(el, "onOpenChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, { open: details.open, id: el.id });
        }
        const clientName = getString(el, "onOpenChangeClient");
        if (clientName) {
          el.dispatchEvent(
            new CustomEvent(clientName, {
              bubbles: true,
              detail: { value: details, id: el.id },
            })
          );
        }
      },
      onPositionChange: (details: PositionChangeDetails) => {
        const eventName = getString(el, "onPositionChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            position: details.position,
            id: el.id,
          });
        }
      },
      onSizeChange: (details: SizeChangeDetails) => {
        const eventName = getString(el, "onSizeChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            size: details.size,
            id: el.id,
          });
        }
      },
      onStageChange: (details: StageChangeDetails) => {
        const eventName = getString(el, "onStageChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            stage: details.stage,
            id: el.id,
          });
        }
      },
    } as Props);
    zag.init();
    this.floatingPanel = zag;
    this.handlers = [];
  },

  updated(this: object & HookInterface<HTMLElement> & FloatingPanelHookState) {
    const open = getBoolean(this.el, "open");
    const controlled = getBoolean(this.el, "controlled");
    this.floatingPanel?.updateProps({
      id: this.el.id,
      ...(controlled ? { open } : {}),
      disabled: getBoolean(this.el, "disabled"),
      dir: getDir(this.el),
    } as Partial<Props>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & FloatingPanelHookState) {
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.floatingPanel?.destroy();
  },
};

export { FloatingPanelHook as FloatingPanel };
